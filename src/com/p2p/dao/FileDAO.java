package com.p2p.dao;

import com.p2p.model.SharedFile;
import com.p2p.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * File Data Access Object (DAO) for database operations.
 * This class handles all CRUD operations for SharedFile entities.
 */
public class FileDAO {
    
    private static final int DEFAULT_CHUNK_SIZE = 102400; // 100KB chunks
    
    /**
     * Creates a new file entry in the database
     * @param file SharedFile object to create
     * @return true if successful, false otherwise
     */
    public boolean createFile(SharedFile file) {
        String sql = "INSERT INTO shared_files (user_id, file_name, file_path, file_size, " +
                     "file_type, file_hash, chunk_count, chunk_size, description) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, file.getUserId());
            pstmt.setString(2, file.getFileName());
            pstmt.setString(3, file.getFilePath());
            pstmt.setLong(4, file.getFileSize());
            pstmt.setString(5, file.getFileType());
            pstmt.setString(6, file.getFileHash());
            pstmt.setInt(7, file.getChunkCount());
            pstmt.setInt(8, file.getChunkSize());
            pstmt.setString(9, file.getDescription());
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    file.setFileId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Finds a file by ID
     * @param fileId File ID
     * @return SharedFile object or null if not found
     */
    public SharedFile findFileById(int fileId) {
        String sql = "SELECT * FROM shared_files WHERE file_id = ?";
        SharedFile file = null;
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, fileId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                file = extractFileFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return file;
    }
    
    /**
     * Finds files by user ID
     * @param userId User ID
     * @return List of SharedFile objects
     */
    public List<SharedFile> findFilesByUserId(int userId) {
        List<SharedFile> files = new ArrayList<>();
        String sql = "SELECT * FROM shared_files WHERE user_id = ? ORDER BY upload_date DESC";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                files.add(extractFileFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return files;
    }
    
    /**
     * Searches files by name
     * @param fileName File name or partial name
     * @return List of matching SharedFile objects
     */
    public List<SharedFile> searchFilesByName(String fileName) {
        List<SharedFile> files = new ArrayList<>();
        String sql = "SELECT * FROM shared_files WHERE file_name LIKE ? AND is_available = true " +
                     "ORDER BY upload_date DESC";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, "%" + fileName + "%");
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                files.add(extractFileFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return files;
    }
    
    /**
     * Gets all available files
     * @return List of available SharedFile objects
     */
    public List<SharedFile> getAllAvailableFiles() {
        List<SharedFile> files = new ArrayList<>();
        String sql = "SELECT * FROM shared_files WHERE is_available = true ORDER BY upload_date DESC";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                files.add(extractFileFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return files;
    }
    
    /**
     * Gets all files with pagination
     * @param offset Starting position
     * @param limit Maximum number of results
     * @return List of SharedFile objects
     */
    public List<SharedFile> getFilesWithPagination(int offset, int limit) {
        List<SharedFile> files = new ArrayList<>();
        String sql = "SELECT * FROM shared_files WHERE is_available = true " +
                     "ORDER BY upload_date DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, limit);
            pstmt.setInt(2, offset);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                files.add(extractFileFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return files;
    }
    
    /**
     * Updates file information
     * @param file SharedFile object with updated information
     * @return true if successful, false otherwise
     */
    public boolean updateFile(SharedFile file) {
        String sql = "UPDATE shared_files SET file_name = ?, file_path = ?, file_size = ?, " +
                     "file_type = ?, file_hash = ?, chunk_count = ?, chunk_size = ?, " +
                     "description = ?, is_available = ? WHERE file_id = ?";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, file.getFileName());
            pstmt.setString(2, file.getFilePath());
            pstmt.setLong(3, file.getFileSize());
            pstmt.setString(4, file.getFileType());
            pstmt.setString(5, file.getFileHash());
            pstmt.setInt(6, file.getChunkCount());
            pstmt.setInt(7, file.getChunkSize());
            pstmt.setString(8, file.getDescription());
            pstmt.setBoolean(9, file.isAvailable());
            pstmt.setInt(10, file.getFileId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Increments download count for a file
     * @param fileId File ID
     * @return true if successful, false otherwise
     */
    public boolean incrementDownloadCount(int fileId) {
        String sql = "UPDATE shared_files SET download_count = download_count + 1 WHERE file_id = ?";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, fileId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Sets file availability status
     * @param fileId File ID
     * @param available Availability status
     * @return true if successful, false otherwise
     */
    public boolean setFileAvailability(int fileId, boolean available) {
        String sql = "UPDATE shared_files SET is_available = ? WHERE file_id = ?";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setBoolean(1, available);
            pstmt.setInt(2, fileId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Deletes a file by ID
     * @param fileId File ID
     * @return true if successful, false otherwise
     */
    public boolean deleteFile(int fileId) {
        String sql = "DELETE FROM shared_files WHERE file_id = ?";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, fileId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Gets total count of available files
     * @return Total count
     */
    public int getTotalFileCount() {
        String sql = "SELECT COUNT(*) FROM shared_files WHERE is_available = true";
        
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
     * Gets files by file type
     * @param fileType File type/extension
     * @return List of SharedFile objects
     */
    public List<SharedFile> getFilesByType(String fileType) {
        List<SharedFile> files = new ArrayList<>();
        String sql = "SELECT * FROM shared_files WHERE file_type = ? AND is_available = true " +
                     "ORDER BY upload_date DESC";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, fileType);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                files.add(extractFileFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return files;
    }
    
    /**
     * Helper method to extract SharedFile from ResultSet
     */
    private SharedFile extractFileFromResultSet(ResultSet rs) throws SQLException {
        SharedFile file = new SharedFile();
        file.setFileId(rs.getInt("file_id"));
        file.setUserId(rs.getInt("user_id"));
        file.setFileName(rs.getString("file_name"));
        file.setFilePath(rs.getString("file_path"));
        file.setFileSize(rs.getLong("file_size"));
        file.setFileType(rs.getString("file_type"));
        file.setFileHash(rs.getString("file_hash"));
        file.setChunkCount(rs.getInt("chunk_count"));
        file.setChunkSize(rs.getInt("chunk_size"));
        file.setAvailable(rs.getBoolean("is_available"));
        file.setUploadDate(rs.getTimestamp("upload_date"));
        file.setDownloadCount(rs.getInt("download_count"));
        file.setDescription(rs.getString("description"));
        return file;
    }
    
    /**
     * Calculates chunk count based on file size
     * @param fileSize File size in bytes
     * @return Number of chunks
     */
    public static int calculateChunkCount(long fileSize) {
        return (int) Math.ceil((double) fileSize / DEFAULT_CHUNK_SIZE);
    }
}