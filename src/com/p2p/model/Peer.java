package com.p2p.model;

import java.sql.Timestamp;
import java.net.Socket;

/**
 * Peer Model class representing a peer node in the P2P network.
 * This is part of the MVC Model layer.
 */
public class Peer {
    
    private int peerId;
    private int userId;
    private String peerName;
    private String ipAddress;
    private int listeningPort;
    private int downloadPort;
    private boolean isOnline;
    private Timestamp lastSeen;
    private int uploadNeighborId;
    private int downloadNeighborId;
    private Socket socket;
    
    // Constructors
    public Peer() {
    }
    
    public Peer(int userId, String peerName, String ipAddress, int listeningPort) {
        this.userId = userId;
        this.peerName = peerName;
        this.ipAddress = ipAddress;
        this.listeningPort = listeningPort;
        this.isOnline = true;
    }
    
    public Peer(int peerId, int userId, String peerName, String ipAddress, int listeningPort, 
                boolean isOnline, Timestamp lastSeen) {
        this.peerId = peerId;
        this.userId = userId;
        this.peerName = peerName;
        this.ipAddress = ipAddress;
        this.listeningPort = listeningPort;
        this.isOnline = isOnline;
        this.lastSeen = lastSeen;
    }
    
    // Getters and Setters
    public int getPeerId() {
        return peerId;
    }
    
    public void setPeerId(int peerId) {
        this.peerId = peerId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getPeerName() {
        return peerName;
    }
    
    public void setPeerName(String peerName) {
        this.peerName = peerName;
    }
    
    public String getIpAddress() {
        return ipAddress;
    }
    
    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }
    
    public int getListeningPort() {
        return listeningPort;
    }
    
    public void setListeningPort(int listeningPort) {
        this.listeningPort = listeningPort;
    }
    
    public int getDownloadPort() {
        return downloadPort;
    }
    
    public void setDownloadPort(int downloadPort) {
        this.downloadPort = downloadPort;
    }
    
    public boolean isOnline() {
        return isOnline;
    }
    
    public void setOnline(boolean online) {
        isOnline = online;
    }
    
    public Timestamp getLastSeen() {
        return lastSeen;
    }
    
    public void setLastSeen(Timestamp lastSeen) {
        this.lastSeen = lastSeen;
    }
    
    public int getUploadNeighborId() {
        return uploadNeighborId;
    }
    
    public void setUploadNeighborId(int uploadNeighborId) {
        this.uploadNeighborId = uploadNeighborId;
    }
    
    public int getDownloadNeighborId() {
        return downloadNeighborId;
    }
    
    public void setDownloadNeighborId(int downloadNeighborId) {
        this.downloadNeighborId = downloadNeighborId;
    }
    
    public Socket getSocket() {
        return socket;
    }
    
    public void setSocket(Socket socket) {
        this.socket = socket;
    }
    
    public String getPeerAddress() {
        return ipAddress + ":" + listeningPort;
    }
    
    @Override
    public String toString() {
        return "Peer{" +
                "peerId=" + peerId +
                ", userId=" + userId +
                ", peerName='" + peerName + '\'' +
                ", ipAddress='" + ipAddress + '\'' +
                ", listeningPort=" + listeningPort +
                ", isOnline=" + isOnline +
                '}';
    }
}