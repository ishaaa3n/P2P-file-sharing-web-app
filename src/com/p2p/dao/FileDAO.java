package com.p2p.dao;

import com.p2p.model.SharedFile;
import com.p2p.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FileDAO {

    private static final int DEFAULT_CHUNK_SIZE = 102400;

    public boolean createFile(SharedFile file) {
        String sql = "INSERT INTO shared_files (user_id, file_name, file_path, file_size, " +
                     "file_type, file_hash, chunk_count, chunk_size, description, " +
                     "subject, branch, semester, material_type) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, file.getUserId());
            ps.setString(2, file.getFileName());
            ps.setString(3, file.getFilePath());
            ps.setLong(4, file.getFileSize());
            ps.setString(5, file.getFileType());
            ps.setString(6, file.getFileHash());
            ps.setInt(7, file.getChunkCount());
            ps.setInt(8, file.getChunkSize());
            ps.setString(9, file.getDescription());
            ps.setString(10, file.getSubject());
            ps.setString(11, file.getBranch());
            ps.setInt(12, file.getSemester());
            ps.setString(13, file.getMaterialType() != null ? file.getMaterialType() : SharedFile.TYPE_NOTES);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) file.setFileId(rs.getInt(1));
                return true;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public SharedFile findFileById(int fileId) {
        String sql = "SELECT f.*, u.username AS uploader FROM shared_files f " +
                     "LEFT JOIN users u ON f.user_id = u.user_id WHERE f.file_id = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fileId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extractFileFromResultSet(rs, true);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<SharedFile> findFilesByUserId(int userId) {
        List<SharedFile> files = new ArrayList<>();
        String sql = "SELECT f.*, u.username AS uploader FROM shared_files f " +
                     "LEFT JOIN users u ON f.user_id = u.user_id " +
                     "WHERE f.user_id = ? ORDER BY f.upload_date DESC";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) files.add(extractFileFromResultSet(rs, true));
        } catch (SQLException e) { e.printStackTrace(); }
        return files;
    }

    /**
     * Multi-criteria search. Any null/empty/zero param is ignored.
     */
    public List<SharedFile> searchMaterials(String keyword, String branch, Integer semester,
                                            String subject, String materialType,
                                            String sortBy, int offset, int limit) {
        StringBuilder sql = new StringBuilder(
            "SELECT f.*, u.username AS uploader FROM shared_files f " +
            "LEFT JOIN users u ON f.user_id = u.user_id WHERE f.is_available = true ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(f.file_name) LIKE ? OR LOWER(f.subject) LIKE ? OR LOWER(f.description) LIKE ?) ");
            String like = "%" + keyword.trim().toLowerCase() + "%";
            params.add(like); params.add(like); params.add(like);
        }
        if (branch != null && !branch.trim().isEmpty()) {
            sql.append("AND LOWER(f.branch) = ? ");
            params.add(branch.trim().toLowerCase());
        }
        if (semester != null && semester > 0) {
            sql.append("AND f.semester = ? ");
            params.add(semester);
        }
        if (subject != null && !subject.trim().isEmpty()) {
            sql.append("AND LOWER(f.subject) LIKE ? ");
            params.add("%" + subject.trim().toLowerCase() + "%");
        }
        if (materialType != null && !materialType.trim().isEmpty()) {
            sql.append("AND f.material_type = ? ");
            params.add(materialType.trim().toLowerCase());
        }

        if ("upvotes".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY f.upvote_count DESC, f.upload_date DESC ");
        } else if ("downloads".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY f.download_count DESC, f.upload_date DESC ");
        } else {
            sql.append("ORDER BY f.upload_date DESC ");
        }

        sql.append("LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        List<SharedFile> files = new ArrayList<>();
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) files.add(extractFileFromResultSet(rs, true));
        } catch (SQLException e) { e.printStackTrace(); }
        return files;
    }

    public int countMaterials(String keyword, String branch, Integer semester, String subject, String materialType) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM shared_files f WHERE f.is_available = true ");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(f.file_name) LIKE ? OR LOWER(f.subject) LIKE ? OR LOWER(f.description) LIKE ?) ");
            String like = "%" + keyword.trim().toLowerCase() + "%";
            params.add(like); params.add(like); params.add(like);
        }
        if (branch != null && !branch.trim().isEmpty()) {
            sql.append("AND LOWER(f.branch) = ? ");
            params.add(branch.trim().toLowerCase());
        }
        if (semester != null && semester > 0) {
            sql.append("AND f.semester = ? ");
            params.add(semester);
        }
        if (subject != null && !subject.trim().isEmpty()) {
            sql.append("AND LOWER(f.subject) LIKE ? ");
            params.add("%" + subject.trim().toLowerCase() + "%");
        }
        if (materialType != null && !materialType.trim().isEmpty()) {
            sql.append("AND f.material_type = ? ");
            params.add(materialType.trim().toLowerCase());
        }
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<SharedFile> getTrendingMaterials(int limit) {
        List<SharedFile> files = new ArrayList<>();
        String sql = "SELECT f.*, u.username AS uploader FROM shared_files f " +
                     "LEFT JOIN users u ON f.user_id = u.user_id " +
                     "WHERE f.is_available = true " +
                     "ORDER BY (f.upvote_count * 2 + f.download_count) DESC, f.upload_date DESC LIMIT ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) files.add(extractFileFromResultSet(rs, true));
        } catch (SQLException e) { e.printStackTrace(); }
        return files;
    }

    public List<SharedFile> getRecentMaterials(int limit) {
        return searchMaterials(null, null, null, null, null, null, 0, limit);
    }

    public boolean incrementDownloadCount(int fileId) {
        String sql = "UPDATE shared_files SET download_count = download_count + 1 WHERE file_id = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fileId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /**
     * Toggles a user's upvote on a file. Returns the new total upvote count, or -1 on failure.
     */
    public int toggleUpvote(int fileId, int userId) {
        try (Connection conn = DBConnection.getInstance().getConnection()) {
            // Check whether user already upvoted
            try (PreparedStatement check = conn.prepareStatement(
                    "SELECT rating_id FROM material_ratings WHERE file_id = ? AND user_id = ?")) {
                check.setInt(1, fileId);
                check.setInt(2, userId);
                ResultSet rs = check.executeQuery();
                if (rs.next()) {
                    // Already upvoted -> remove
                    int ratingId = rs.getInt("rating_id");
                    try (PreparedStatement del = conn.prepareStatement("DELETE FROM material_ratings WHERE rating_id = ?")) {
                        del.setInt(1, ratingId);
                        del.executeUpdate();
                    }
                    try (PreparedStatement upd = conn.prepareStatement(
                            "UPDATE shared_files SET upvote_count = GREATEST(upvote_count - 1, 0) WHERE file_id = ?")) {
                        upd.setInt(1, fileId);
                        upd.executeUpdate();
                    }
                } else {
                    try (PreparedStatement ins = conn.prepareStatement(
                            "INSERT INTO material_ratings (file_id, user_id, rating_value) VALUES (?, ?, 1)")) {
                        ins.setInt(1, fileId);
                        ins.setInt(2, userId);
                        ins.executeUpdate();
                    }
                    try (PreparedStatement upd = conn.prepareStatement(
                            "UPDATE shared_files SET upvote_count = upvote_count + 1 WHERE file_id = ?")) {
                        upd.setInt(1, fileId);
                        upd.executeUpdate();
                    }
                }
            }
            try (PreparedStatement get = conn.prepareStatement(
                    "SELECT upvote_count FROM shared_files WHERE file_id = ?")) {
                get.setInt(1, fileId);
                ResultSet rs = get.executeQuery();
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean hasUserUpvoted(int fileId, int userId) {
        String sql = "SELECT 1 FROM material_ratings WHERE file_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fileId);
            ps.setInt(2, userId);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean setVerified(int fileId, boolean verified) {
        String sql = "UPDATE shared_files SET is_verified = ? WHERE file_id = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, verified);
            ps.setInt(2, fileId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteFile(int fileId) {
        String sql = "DELETE FROM shared_files WHERE file_id = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fileId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int getTotalFileCount() {
        String sql = "SELECT COUNT(*) FROM shared_files WHERE is_available = true";
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<String> getDistinctBranches() {
        List<String> branches = new ArrayList<>();
        String sql = "SELECT DISTINCT branch FROM shared_files WHERE branch IS NOT NULL AND branch <> '' ORDER BY branch";
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) branches.add(rs.getString(1));
        } catch (SQLException e) { e.printStackTrace(); }
        return branches;
    }

    private SharedFile extractFileFromResultSet(ResultSet rs, boolean withUploader) throws SQLException {
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
        file.setSubject(rs.getString("subject"));
        file.setBranch(rs.getString("branch"));
        file.setSemester(rs.getInt("semester"));
        file.setMaterialType(rs.getString("material_type"));
        file.setVerified(rs.getBoolean("is_verified"));
        file.setUpvoteCount(rs.getInt("upvote_count"));
        if (withUploader) {
            try { file.setUploaderName(rs.getString("uploader")); } catch (SQLException ignore) {}
        }
        return file;
    }

    public static int calculateChunkCount(long fileSize) {
        return (int) Math.ceil((double) fileSize / DEFAULT_CHUNK_SIZE);
    }
}
