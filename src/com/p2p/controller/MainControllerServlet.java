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
 * Main Controller Servlet - Front Controller pattern implementation.
 * This servlet handles all requests and dispatches to appropriate JSP views.
 * This is the Controller component of the MVC pattern.
 */
@WebServlet(name = "MainController", urlPatterns = {"/controller"})
public class MainControllerServlet extends HttpServlet {
    
    private UserDAO userDAO;
    private FileDAO fileDAO;
    private PeerDAO peerDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        fileDAO = new FileDAO();
        peerDAO = new PeerDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "home";
        }
        
        switch (action) {
            case "home":
                showHomePage(request, response);
                break;
            case "login":
                showLoginPage(request, response);
                break;
            case "register":
                showRegisterPage(request, response);
                break;
            case "dashboard":
                showDashboard(request, response);
                break;
            case "files":
                showFilesPage(request, response);
                break;
            case "peers":
                showPeersPage(request, response);
                break;
            case "logout":
                logout(request, response);
                break;
            case "search":
                searchFiles(request, response);
                break;
            default:
                showHomePage(request, response);
                break;
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
            case "login":
                processLogin(request, response);
                break;
            case "register":
                processRegistration(request, response);
                break;
            case "logout":
                logout(request, response);
                break;
            default:
                response.sendRedirect("controller");
                break;
        }
    }
    
    // ==================== View Methods ====================
    
    private void showHomePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get statistics for home page
        request.setAttribute("totalFiles", fileDAO.getTotalFileCount());
        request.setAttribute("totalPeers", peerDAO.getPeerCount());
        request.setAttribute("onlinePeers", peerDAO.getOnlinePeerCount());
        
        // Get recent files
        List<SharedFile> recentFiles = fileDAO.getFilesWithPagination(0, 10);
        request.setAttribute("recentFiles", recentFiles);
        
        // Get online peers
        List<Peer> onlinePeers = peerDAO.getOnlinePeers();
        request.setAttribute("onlinePeersList", onlinePeers);
        
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
        
        // Get user's files
        List<SharedFile> userFiles = fileDAO.findFilesByUserId(user.getUserId());
        request.setAttribute("userFiles", userFiles);
        
        // Get user's peer info
        Peer userPeer = peerDAO.findPeerByUserId(user.getUserId());
        request.setAttribute("userPeer", userPeer);
        
        // Get statistics
        request.setAttribute("totalFiles", fileDAO.getTotalFileCount());
        request.setAttribute("onlinePeers", peerDAO.getOnlinePeerCount());
        
        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }
    
    private void showFilesPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pageStr = request.getParameter("page");
        int page = pageStr != null ? Integer.parseInt(pageStr) : 1;
        int limit = 12;
        int offset = (page - 1) * limit;
        
        // Get files with pagination
        List<SharedFile> files = fileDAO.getFilesWithPagination(offset, limit);
        int totalFiles = fileDAO.getTotalFileCount();
        int totalPages = (int) Math.ceil((double) totalFiles / limit);
        
        request.setAttribute("files", files);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("/WEB-INF/views/files.jsp").forward(request, response);
    }
    
    private void showPeersPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Peer> onlinePeers = peerDAO.getOnlinePeers();
        request.setAttribute("onlinePeers", onlinePeers);
        
        request.getRequestDispatcher("/WEB-INF/views/peers.jsp").forward(request, response);
    }
    
    private void searchFiles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String query = request.getParameter("q");
        if (query != null && !query.trim().isEmpty()) {
            List<SharedFile> files = fileDAO.searchFilesByName(query.trim());
            request.setAttribute("files", files);
            request.setAttribute("searchQuery", query);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/search.jsp").forward(request, response);
    }
    
    // ==================== Action Methods ====================
    
    private void processLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        if (username == null || password == null || 
            username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required");
            showLoginPage(request, response);
            return;
        }
        
        User user = userDAO.validateUser(username, password);
        
        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            
            // Update user status
            userDAO.updateUserOnlineStatus(user.getUserId(), true);
            
            // Redirect to dashboard
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
        
        // Validation
        if (username == null || password == null || email == null ||
            username.trim().isEmpty() || password.trim().isEmpty() || email.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required");
            showRegisterPage(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            showRegisterPage(request, response);
            return;
        }
        
        if (userDAO.usernameExists(username)) {
            request.setAttribute("error", "Username already exists");
            showRegisterPage(request, response);
            return;
        }
        
        // Create new user
        User newUser = new User(username, password, email);
        newUser.setIpAddress(request.getRemoteAddr());
        newUser.setPort(0); // Default port
        
        if (userDAO.createUser(newUser)) {
            request.setAttribute("success", "Registration successful! Please login.");
            showLoginPage(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            showRegisterPage(request, response);
        }
    }
    
    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId != null) {
                userDAO.updateUserOnlineStatus(userId, false);
            }
            session.invalidate();
        }
        
        response.sendRedirect("controller?action=home");
    }
}