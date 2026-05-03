package com.p2p.model;

import java.sql.Timestamp;

/**
 * SharedFile Model class representing a file in the P2P network.
 * This is part of the MVC Model layer.
 */
public class SharedFile {
    
    private int fileId;
    private int userId;
    private String fileName;
    private String filePath;
    private long fileSize;
    private String fileType;
    private String fileHash;
    private int chunkCount;
    private int chunkSize;
    private boolean isAvailable;
    private Timestamp uploadDate;
    private int downloadCount;
    private String description;
    
    // Constructors
    public SharedFile() {
    }
    
    public SharedFile(int userId, String fileName, String filePath, long fileSize) {
        this.userId = userId;
        this.fileName = fileName;
        this.filePath = filePath;
        this.fileSize = fileSize;
        this.isAvailable = true;
        this.downloadCount = 0;
    }
    
    public SharedFile(int fileId, int userId, String fileName, long fileSize, String fileHash, 
                      int chunkCount, boolean isAvailable, Timestamp uploadDate) {
        this.fileId = fileId;
        this.userId = userId;
        this.fileName = fileName;
        this.fileSize = fileSize;
        this.fileHash = fileHash;
        this.chunkCount = chunkCount;
        this.isAvailable = isAvailable;
        this.uploadDate = uploadDate;
    }
    
    // Getters and Setters
    public int getFileId() {
        return fileId;
    }
    
    public void setFileId(int fileId) {
        this.fileId = fileId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getFileName() {
        return fileName;
    }
    
    public void setFileName(String fileName) {
        this.fileName = fileName;
    }
    
    public String getFilePath() {
        return filePath;
    }
    
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }
    
    public long getFileSize() {
        return fileSize;
    }
    
    public void setFileSize(long fileSize) {
        this.fileSize = fileSize;
    }
    
    public String getFileType() {
        return fileType;
    }
    
    public void setFileType(String fileType) {
        this.fileType = fileType;
    }
    
    public String getFileHash() {
        return fileHash;
    }
    
    public void setFileHash(String fileHash) {
        this.fileHash = fileHash;
    }
    
    public int getChunkCount() {
        return chunkCount;
    }
    
    public void setChunkCount(int chunkCount) {
        this.chunkCount = chunkCount;
    }
    
    public int getChunkSize() {
        return chunkSize;
    }
    
    public void setChunkSize(int chunkSize) {
        this.chunkSize = chunkSize;
    }
    
    public boolean isAvailable() {
        return isAvailable;
    }
    
    public void setAvailable(boolean available) {
        isAvailable = available;
    }
    
    public Timestamp getUploadDate() {
        return uploadDate;
    }
    
    public void setUploadDate(Timestamp uploadDate) {
        this.uploadDate = uploadDate;
    }
    
    public int getDownloadCount() {
        return downloadCount;
    }
    
    public void setDownloadCount(int downloadCount) {
        this.downloadCount = downloadCount;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getFormattedFileSize() {
        if (fileSize < 1024) {
            return fileSize + " B";
        } else if (fileSize < 1024 * 1024) {
            return String.format("%.2f KB", fileSize / 1024.0);
        } else if (fileSize < 1024 * 1024 * 1024) {
            return String.format("%.2f MB", fileSize / (1024.0 * 1024.0));
        } else {
            return String.format("%.2f GB", fileSize / (1024.0 * 1024.0 * 1024.0));
        }
    }
    
    @Override
    public String toString() {
        return "SharedFile{" +
                "fileId=" + fileId +
                ", userId=" + userId +
                ", fileName='" + fileName + '\'' +
                ", fileSize=" + fileSize +
                ", chunkCount=" + chunkCount +
                ", isAvailable=" + isAvailable +
                '}';
    }
}