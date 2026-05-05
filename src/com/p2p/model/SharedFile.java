package com.p2p.model;

import java.sql.Timestamp;

/**
 * SharedFile Model — represents a study material in the College Material Hub.
 */
public class SharedFile {

    public static final String TYPE_NOTES = "notes";
    public static final String TYPE_PYQ = "pyq";
    public static final String TYPE_LAB = "lab";
    public static final String TYPE_SYLLABUS = "syllabus";
    public static final String TYPE_ASSIGNMENT = "assignment";
    public static final String TYPE_BOOK = "book";

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

    private String subject;
    private String branch;
    private int semester;
    private String materialType;
    private boolean isVerified;
    private int upvoteCount;

    private String uploaderName;

    public SharedFile() {
        this.materialType = TYPE_NOTES;
    }

    public SharedFile(int userId, String fileName, String filePath, long fileSize) {
        this.userId = userId;
        this.fileName = fileName;
        this.filePath = filePath;
        this.fileSize = fileSize;
        this.isAvailable = true;
        this.downloadCount = 0;
        this.materialType = TYPE_NOTES;
    }

    public int getFileId() { return fileId; }
    public void setFileId(int fileId) { this.fileId = fileId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }

    public long getFileSize() { return fileSize; }
    public void setFileSize(long fileSize) { this.fileSize = fileSize; }

    public String getFileType() { return fileType; }
    public void setFileType(String fileType) { this.fileType = fileType; }

    public String getFileHash() { return fileHash; }
    public void setFileHash(String fileHash) { this.fileHash = fileHash; }

    public int getChunkCount() { return chunkCount; }
    public void setChunkCount(int chunkCount) { this.chunkCount = chunkCount; }

    public int getChunkSize() { return chunkSize; }
    public void setChunkSize(int chunkSize) { this.chunkSize = chunkSize; }

    public boolean isAvailable() { return isAvailable; }
    public void setAvailable(boolean available) { isAvailable = available; }

    public Timestamp getUploadDate() { return uploadDate; }
    public void setUploadDate(Timestamp uploadDate) { this.uploadDate = uploadDate; }

    public int getDownloadCount() { return downloadCount; }
    public void setDownloadCount(int downloadCount) { this.downloadCount = downloadCount; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getBranch() { return branch; }
    public void setBranch(String branch) { this.branch = branch; }

    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }

    public String getMaterialType() { return materialType; }
    public void setMaterialType(String materialType) { this.materialType = materialType; }

    public boolean isVerified() { return isVerified; }
    public void setVerified(boolean verified) { isVerified = verified; }

    public int getUpvoteCount() { return upvoteCount; }
    public void setUpvoteCount(int upvoteCount) { this.upvoteCount = upvoteCount; }

    public String getUploaderName() { return uploaderName; }
    public void setUploaderName(String uploaderName) { this.uploaderName = uploaderName; }

    public String getFormattedFileSize() {
        if (fileSize < 1024) return fileSize + " B";
        if (fileSize < 1024 * 1024) return String.format("%.2f KB", fileSize / 1024.0);
        if (fileSize < 1024 * 1024 * 1024) return String.format("%.2f MB", fileSize / (1024.0 * 1024.0));
        return String.format("%.2f GB", fileSize / (1024.0 * 1024.0 * 1024.0));
    }

    public String getMaterialTypeLabel() {
        if (materialType == null) return "Notes";
        switch (materialType.toLowerCase()) {
            case TYPE_NOTES: return "Notes";
            case TYPE_PYQ: return "Previous Year Paper";
            case TYPE_LAB: return "Lab Manual";
            case TYPE_SYLLABUS: return "Syllabus";
            case TYPE_ASSIGNMENT: return "Assignment";
            case TYPE_BOOK: return "Book / Reference";
            default: return materialType;
        }
    }
}
