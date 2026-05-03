package com.p2p.dao;

import com.p2p.model.Peer;
import com.p2p.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Peer Data Access Object (DAO) for database operations.
 * This class handles all CRUD operations for Peer entities.
 */
public class PeerDAO {
    
    /**
     * Creates a new peer entry in the database
     * @param peer Peer object to create
     * @return true if successful, false otherwise
     */
    public boolean createPeer(Peer peer) {
        String sql = "INSERT INTO peers (user_id, peer_name, ip_address, listening_port, download_port) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, peer.getUserId());
            pstmt.setString(2, peer.getPeerName());
            pstmt.setString(3, peer.getIpAddress());
            pstmt.setInt(4, peer.getListeningPort());
            pstmt.setInt(5, peer.getDownloadPort());
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    peer.setPeerId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Finds a peer by ID
     * @param peerId Peer ID
     * @return Peer object or null if not found
     */
    public Peer findPeerById(int peerId) {
        String sql = "SELECT * FROM peers WHERE peer_id = ?";
        Peer peer = null;
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, peerId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                peer = extractPeerFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return peer;
    }
    
    /**
     * Finds a peer by user ID
     * @param userId User ID
     * @return Peer object or null if not found
     */
    public Peer findPeerByUserId(int userId) {
        String sql = "SELECT * FROM peers WHERE user_id = ? ORDER BY last_seen DESC LIMIT 1";
        Peer peer = null;
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                peer = extractPeerFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return peer;
    }
    
    /**
     * Finds a peer by IP address and port
     * @param ipAddress IP address
     * @param port Port number
     * @return Peer object or null if not found
     */
    public Peer findPeerByAddress(String ipAddress, int port) {
        String sql = "SELECT * FROM peers WHERE ip_address = ? AND listening_port = ?";
        Peer peer = null;
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, ipAddress);
            pstmt.setInt(2, port);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                peer = extractPeerFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return peer;
    }
    
    /**
     * Gets all online peers
     * @return List of online Peer objects
     */
    public List<Peer> getOnlinePeers() {
        List<Peer> peers = new ArrayList<>();
        String sql = "SELECT * FROM peers WHERE is_online = true ORDER BY peer_id";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                peers.add(extractPeerFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return peers;
    }
    
    /**
     * Gets all peers
     * @return List of all Peer objects
     */
    public List<Peer> getAllPeers() {
        List<Peer> peers = new ArrayList<>();
        String sql = "SELECT * FROM peers ORDER BY peer_id";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                peers.add(extractPeerFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return peers;
    }
    
    /**
     * Updates peer online status
     * @param peerId Peer ID
     * @param isOnline Online status
     * @return true if successful, false otherwise
     */
    public boolean updatePeerOnlineStatus(int peerId, boolean isOnline) {
        String sql = "UPDATE peers SET is_online = ?, last_seen = CURRENT_TIMESTAMP WHERE peer_id = ?";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setBoolean(1, isOnline);
            pstmt.setInt(2, peerId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Updates peer neighbor assignments
     * @param peerId Peer ID
     * @param uploadNeighborId Upload neighbor ID
     * @param downloadNeighborId Download neighbor ID
     * @return true if successful, false otherwise
     */
    public boolean updatePeerNeighbors(int peerId, int uploadNeighborId, int downloadNeighborId) {
        String sql = "UPDATE peers SET upload_neighbor_id = ?, download_neighbor_id = ? WHERE peer_id = ?";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, uploadNeighborId);
            pstmt.setInt(2, downloadNeighborId);
            pstmt.setInt(3, peerId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Marks all peers as offline
     * @return Number of peers marked offline
     */
    public int markAllPeersOffline() {
        String sql = "UPDATE peers SET is_online = false";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement()) {
            
            return stmt.executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Gets peer count
     * @return Total number of peers
     */
    public int getPeerCount() {
        String sql = "SELECT COUNT(*) FROM peers";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Gets online peer count
     * @return Number of online peers
     */
    public int getOnlinePeerCount() {
        String sql = "SELECT COUNT(*) FROM peers WHERE is_online = true";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Gets peer list as a map (peer_id -> port)
     * @return Map of peer IDs to ports
     */
    public Map<Integer, Integer> getPeerListAsMap() {
        Map<Integer, Integer> peerList = new HashMap<>();
        String sql = "SELECT peer_id, listening_port FROM peers WHERE is_online = true";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                peerList.put(rs.getInt("peer_id"), rs.getInt("listening_port"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return peerList;
    }
    
    /**
     * Deletes a peer by ID
     * @param peerId Peer ID
     * @return true if successful, false otherwise
     */
    public boolean deletePeer(int peerId) {
        String sql = "DELETE FROM peers WHERE peer_id = ?";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, peerId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Helper method to extract Peer from ResultSet
     */
    private Peer extractPeerFromResultSet(ResultSet rs) throws SQLException {
        Peer peer = new Peer();
        peer.setPeerId(rs.getInt("peer_id"));
        peer.setUserId(rs.getInt("user_id"));
        peer.setPeerName(rs.getString("peer_name"));
        peer.setIpAddress(rs.getString("ip_address"));
        peer.setListeningPort(rs.getInt("listening_port"));
        peer.setDownloadPort(rs.getInt("download_port"));
        peer.setOnline(rs.getBoolean("is_online"));
        peer.setLastSeen(rs.getTimestamp("last_seen"));
        peer.setUploadNeighborId(rs.getInt("upload_neighbor_id"));
        peer.setDownloadNeighborId(rs.getInt("download_neighbor_id"));
        return peer;
    }
}