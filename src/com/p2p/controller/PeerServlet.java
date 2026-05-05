package com.p2p.controller;

import com.p2p.dao.PeerDAO;
import com.p2p.dao.UserDAO;
import com.p2p.model.Peer;
import com.p2p.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Peer Servlet - Handles peer-related operations in the P2P network.
 * This servlet manages peer registration, connection, and neighbor assignments.
 */
@WebServlet(name = "PeerServlet", urlPatterns = {"/peer"})
public class PeerServlet extends HttpServlet {
    
    private PeerDAO peerDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        peerDAO = new PeerDAO();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listPeers(request, response);
                break;
            case "register":
                showRegisterPeerPage(request, response);
                break;
            case "connect":
                connectPeer(request, response);
                break;
            case "disconnect":
                disconnectPeer(request, response);
                break;
            case "status":
                getPeerStatus(request, response);
                break;
            default:
                listPeers(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("peer");
            return;
        }
        
        switch (action) {
            case "register":
                processPeerRegistration(request, response);
                break;
            case "connect":
                processPeerConnection(request, response);
                break;
            case "disconnect":
                processPeerDisconnection(request, response);
                break;
            default:
                response.sendRedirect("peer");
                break;
        }
    }
    
    // ==================== View Methods ====================
    
    private void listPeers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Peer> onlinePeers = peerDAO.getOnlinePeers();
        List<Peer> allPeers = peerDAO.getAllPeers();
        
        request.setAttribute("onlinePeers", onlinePeers);
        request.setAttribute("allPeers", allPeers);
        request.setAttribute("onlineCount", peerDAO.getOnlinePeerCount());
        request.setAttribute("totalCount", peerDAO.getPeerCount());
        
        request.getRequestDispatcher("/WEB-INF/views/peers.jsp").forward(request, response);
    }
    
    private void showRegisterPeerPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("controller?action=login");
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/views/register-peer.jsp").forward(request, response);
    }
    
    // ==================== Action Methods ====================
    
    private void processPeerRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("controller?action=login");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        String peerName = request.getParameter("peerName");
        String ipAddress = request.getParameter("ipAddress");
        int listeningPort = Integer.parseInt(request.getParameter("listeningPort"));
        int downloadPort = Integer.parseInt(request.getParameter("downloadPort"));
        
        // Validate
        if (peerName == null || peerName.trim().isEmpty()) {
            request.setAttribute("error", "Peer name is required");
            showRegisterPeerPage(request, response);
            return;
        }
        
        // Create peer
        Peer peer = new Peer(userId, peerName, ipAddress, listeningPort);
        peer.setDownloadPort(downloadPort);
        
        if (peerDAO.createPeer(peer)) {
            request.setAttribute("success", "Peer registered successfully!");
            request.setAttribute("peerId", peer.getPeerId());
            request.setAttribute("peerName", peerName);
            
            // Also update user's port
            User user = userDAO.findUserById(userId);
            if (user != null) {
                user.setPort(listeningPort);
                userDAO.updateUser(user);
            }
            
            request.getRequestDispatcher("/WEB-INF/views/register-peer.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Failed to register peer");
            showRegisterPeerPage(request, response);
        }
    }
    
    private void connectPeer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String peerIdStr = request.getParameter("id");
        
        if (peerIdStr == null) {
            response.sendRedirect("peer");
            return;
        }
        
        try {
            int peerId = Integer.parseInt(peerIdStr);
            if (peerDAO.updatePeerOnlineStatus(peerId, true)) {
                request.setAttribute("success", "Peer connected successfully");
            } else {
                request.setAttribute("error", "Failed to connect peer");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid peer ID");
        }
        
        listPeers(request, response);
    }
    
    private void disconnectPeer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String peerIdStr = request.getParameter("id");
        
        if (peerIdStr == null) {
            response.sendRedirect("peer");
            return;
        }
        
        try {
            int peerId = Integer.parseInt(peerIdStr);
            if (peerDAO.updatePeerOnlineStatus(peerId, false)) {
                request.setAttribute("success", "Peer disconnected successfully");
            } else {
                request.setAttribute("error", "Failed to disconnect peer");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid peer ID");
        }
        
        listPeers(request, response);
    }
    
    private void processPeerConnection(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("controller?action=login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        Peer peer = peerDAO.findPeerByUserId(userId);

        if (peer != null) {
            peerDAO.updatePeerOnlineStatus(peer.getPeerId(), true);
            request.setAttribute("success", "Peer connected successfully");
        } else {
            request.setAttribute("error", "No peer found for this user. Please register a peer first.");
        }

        listPeers(request, response);
    }

    private void processPeerDisconnection(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("controller?action=login");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        Peer peer = peerDAO.findPeerByUserId(userId);
        
        if (peer != null) {
            peerDAO.updatePeerOnlineStatus(peer.getPeerId(), false);
            request.setAttribute("success", "Peer disconnected successfully");
        } else {
            request.setAttribute("error", "No peer found for this user");
        }
        
        listPeers(request, response);
    }
    
    private void getPeerStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String peerIdStr = request.getParameter("id");
        
        if (peerIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Peer ID is required");
            return;
        }
        
        try {
            int peerId = Integer.parseInt(peerIdStr);
            Peer peer = peerDAO.findPeerById(peerId);
            
            if (peer != null) {
                response.setContentType("application/json");
                response.getWriter().write("{");
                response.getWriter().write("\"peerId\": " + peer.getPeerId() + ",");
                response.getWriter().write("\"peerName\": \"" + peer.getPeerName() + "\",");
                response.getWriter().write("\"ipAddress\": \"" + peer.getIpAddress() + "\",");
                response.getWriter().write("\"listeningPort\": " + peer.getListeningPort() + ",");
                response.getWriter().write("\"isOnline\": " + peer.isOnline() + ",");
                response.getWriter().write("\"lastSeen\": \"" + peer.getLastSeen() + "\"");
                response.getWriter().write("}");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Peer not found");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid peer ID");
        }
    }
}