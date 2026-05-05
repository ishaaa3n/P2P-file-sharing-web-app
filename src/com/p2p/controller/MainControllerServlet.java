package com.p2p.controller;

import com.p2p.dao.*;
import com.p2p.model.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Main Controller Servlet for College Study Material Hub.
 * Front Controller pattern — dispatches to JSP views based on `action` param.
 */
@WebServlet(name = "MainController", urlPatterns = {"/controller"})
public class MainControllerServlet extends HttpServlet {

    private UserDAO userDAO;
    private FileDAO fileDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        fileDAO = new FileDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "home";

        switch (action) {
            case "home":      showHomePage(request, response); break;
            case "login":     showLoginPage(request, response); break;
            case "register":  showRegisterPage(request, response); break;
            case "dashboard": showDashboard(request, response); break;
            case "files":     showFilesPage(request, response); break;
            case "logout":    logout(request, response); break;
            case "upvote":    toggleUpvote(request, response); break;
            case "verify":    verifyMaterial(request, response); break;
            case "delete":    deleteMaterial(request, response); break;
            default:          showHomePage(request, response); break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("controller");
            return;
        }
        switch (action) {
            case "login":    processLogin(request, response); break;
            case "register": processRegistration(request, response); break;
            case "logout":   logout(request, response); break;
            default:         response.sendRedirect("controller"); break;
        }
    }

    // ==================== View Methods ====================

    private void showHomePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("totalFiles", fileDAO.getTotalFileCount());
        request.setAttribute("recentFiles", fileDAO.getRecentMaterials(6));
        request.setAttribute("trendingFiles", fileDAO.getTrendingMaterials(6));
        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }

    private void showLoginPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    private void showRegisterPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("controller?action=login");
            return;
        }
        User user = (User) session.getAttribute("user");

        request.setAttribute("userFiles", fileDAO.findFilesByUserId(user.getUserId()));
        request.setAttribute("totalFiles", fileDAO.getTotalFileCount());
        request.setAttribute("trendingFiles", fileDAO.getTrendingMaterials(5));
        request.setAttribute("recentFiles", fileDAO.getRecentMaterials(5));

        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }

    private void showFilesPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("q");
        String branch = request.getParameter("branch");
        String semStr = request.getParameter("semester");
        String subject = request.getParameter("subject");
        String type = request.getParameter("type");
        String sort = request.getParameter("sort");
        Integer semester = parseIntSafe(semStr);

        String pageStr = request.getParameter("page");
        int page = parseIntSafe(pageStr) != null && parseIntSafe(pageStr) > 0 ? Integer.parseInt(pageStr) : 1;
        int limit = 12;
        int offset = (page - 1) * limit;

        List<SharedFile> files = fileDAO.searchMaterials(keyword, branch, semester, subject, type, sort, offset, limit);
        int total = fileDAO.countMaterials(keyword, branch, semester, subject, type);
        int totalPages = (int) Math.ceil(total / (double) limit);
        if (totalPages == 0) totalPages = 1;

        request.setAttribute("files", files);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalResults", total);
        request.setAttribute("q", keyword);
        request.setAttribute("branch", branch);
        request.setAttribute("semester", semester);
        request.setAttribute("subject", subject);
        request.setAttribute("type", type);
        request.setAttribute("sort", sort);

        request.getRequestDispatcher("/WEB-INF/views/files.jsp").forward(request, response);
    }

    // ==================== Action Methods ====================

    private void processLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (isBlank(username) || isBlank(password)) {
            request.setAttribute("error", "Username and password are required");
            showLoginPage(request, response);
            return;
        }

        User user = userDAO.validateUser(username.trim(), password);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("isFaculty", user.isFaculty());
            userDAO.updateUserOnlineStatus(user.getUserId(), true);
            response.sendRedirect("controller?action=dashboard");
        } else {
            request.setAttribute("error", "Invalid username or password");
            showLoginPage(request, response);
        }
    }

    private void processRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String branch = request.getParameter("branch");
        String semStr = request.getParameter("semester");

        if (isBlank(username) || isBlank(password) || isBlank(email) || isBlank(role)) {
            request.setAttribute("error", "Username, email, password, and role are required");
            showRegisterPage(request, response);
            return;
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            showRegisterPage(request, response);
            return;
        }
        if (userDAO.usernameExists(username.trim())) {
            request.setAttribute("error", "Username already exists");
            showRegisterPage(request, response);
            return;
        }

        User newUser = new User(username.trim(), password, email.trim());
        newUser.setRole(User.ROLE_FACULTY.equalsIgnoreCase(role) ? User.ROLE_FACULTY : User.ROLE_STUDENT);
        newUser.setBranch(branch);
        Integer sem = parseIntSafe(semStr);
        newUser.setSemester(sem != null ? sem : 0);
        newUser.setIpAddress(request.getRemoteAddr());

        if (userDAO.createUser(newUser)) {
            request.setAttribute("success", "Registration successful! Please login.");
            showLoginPage(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            showRegisterPage(request, response);
        }
    }

    private void toggleUpvote(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("controller?action=login");
            return;
        }
        Integer userId = (Integer) session.getAttribute("userId");
        String idStr = request.getParameter("id");
        Integer fileId = parseIntSafe(idStr);
        if (fileId != null) fileDAO.toggleUpvote(fileId, userId);

        String back = request.getParameter("back");
        response.sendRedirect(back != null && !back.isEmpty() ? back : "controller?action=files");
    }

    private void verifyMaterial(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("controller?action=login"); return;
        }
        User user = (User) session.getAttribute("user");
        if (!user.isFaculty()) {
            response.sendRedirect("controller?action=files"); return;
        }
        Integer fileId = parseIntSafe(request.getParameter("id"));
        String setStr = request.getParameter("set");
        boolean newState = !"false".equalsIgnoreCase(setStr);
        if (fileId != null) fileDAO.setVerified(fileId, newState);

        String back = request.getParameter("back");
        response.sendRedirect(back != null && !back.isEmpty() ? back : "controller?action=files");
    }

    private void deleteMaterial(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("controller?action=login"); return;
        }
        User user = (User) session.getAttribute("user");
        Integer fileId = parseIntSafe(request.getParameter("id"));
        if (fileId != null) {
            SharedFile target = fileDAO.findFileById(fileId);
            if (target != null && (target.getUserId() == user.getUserId() || user.isFaculty())) {
                fileDAO.deleteFile(fileId);
            }
        }
        response.sendRedirect("controller?action=dashboard");
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId != null) userDAO.updateUserOnlineStatus(userId, false);
            session.invalidate();
        }
        response.sendRedirect("controller?action=home");
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private static Integer parseIntSafe(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        try { return Integer.parseInt(s.trim()); } catch (NumberFormatException e) { return null; }
    }
}
