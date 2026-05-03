-- =====================================================
-- P2P File Sharing Network - Database Schema
-- =====================================================
-- This script creates the database and tables for the
-- P2P File Sharing application using MySQL.
-- =====================================================

-- Create the database
CREATE DATABASE IF NOT EXISTS p2p_file_sharing;
USE p2p_file_sharing;

-- =====================================================
-- Table: users
-- Stores user account information
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    ip_address VARCHAR(45) DEFAULT NULL,
    port INT DEFAULT 0,
    is_online BOOLEAN DEFAULT FALSE,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL DEFAULT NULL,
    last_seen TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_online (is_online)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: shared_files
-- Stores information about files shared on the network
-- =====================================================
CREATE TABLE IF NOT EXISTS shared_files (
    file_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size BIGINT NOT NULL DEFAULT 0,
    file_type VARCHAR(50) DEFAULT NULL,
    file_hash VARCHAR(64) DEFAULT NULL,
    chunk_count INT NOT NULL DEFAULT 1,
    chunk_size INT NOT NULL DEFAULT 102400,
    is_available BOOLEAN DEFAULT TRUE,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    download_count INT DEFAULT 0,
    description TEXT DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_file_name (file_name),
    INDEX idx_available (is_available),
    INDEX idx_file_type (file_type),
    INDEX idx_upload_date (upload_date),
    FULLTEXT idx_search (file_name, description)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: peers
-- Stores peer node information for P2P connections
-- =====================================================
CREATE TABLE IF NOT EXISTS peers (
    peer_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    peer_name VARCHAR(100) NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    listening_port INT NOT NULL,
    download_port INT DEFAULT 0,
    is_online BOOLEAN DEFAULT FALSE,
    last_seen TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    upload_neighbor_id INT DEFAULT NULL,
    download_neighbor_id INT DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_peer_name (peer_name),
    INDEX idx_online (is_online),
    INDEX idx_ip_port (ip_address, listening_port)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: file_chunks
-- Stores information about file chunks for P2P distribution
-- =====================================================
CREATE TABLE IF NOT EXISTS file_chunks (
    chunk_id INT PRIMARY KEY AUTO_INCREMENT,
    file_id INT NOT NULL,
    chunk_index INT NOT NULL,
    chunk_hash VARCHAR(64) DEFAULT NULL,
    peer_id INT DEFAULT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (file_id) REFERENCES shared_files(file_id) ON DELETE CASCADE,
    FOREIGN KEY (peer_id) REFERENCES peers(peer_id) ON DELETE SET NULL,
    UNIQUE KEY unique_file_chunk (file_id, chunk_index, peer_id),
    INDEX idx_file_id (file_id),
    INDEX idx_peer_id (peer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: downloads
-- Tracks download history
-- =====================================================
CREATE TABLE IF NOT EXISTS downloads (
    download_id INT PRIMARY KEY AUTO_INCREMENT,
    file_id INT NOT NULL,
    user_id INT DEFAULT NULL,
    peer_id INT DEFAULT NULL,
    download_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    download_status ENUM('pending', 'in_progress', 'completed', 'failed') DEFAULT 'pending',
    FOREIGN KEY (file_id) REFERENCES shared_files(file_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (peer_id) REFERENCES peers(peer_id) ON DELETE SET NULL,
    INDEX idx_file_id (file_id),
    INDEX idx_user_id (user_id),
    INDEX idx_download_date (download_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Insert default admin user
-- =====================================================
-- Default credentials: admin / admin123
INSERT INTO users (username, password, email, ip_address, port, is_online) 
VALUES ('admin', 'admin123', 'admin@p2pnetwork.com', '127.0.0.1', 8080, TRUE)
ON DUPLICATE KEY UPDATE username = username;

-- =====================================================
-- Create views for common queries
-- =====================================================

-- View: Active files with user info
CREATE OR REPLACE VIEW v_active_files AS
SELECT 
    sf.file_id,
    sf.file_name,
    sf.file_size,
    sf.chunk_count,
    sf.download_count,
    sf.upload_date,
    u.username,
    u.email
FROM shared_files sf
JOIN users u ON sf.user_id = u.user_id
WHERE sf.is_available = TRUE
ORDER BY sf.upload_date DESC;

-- View: Online peers summary
CREATE OR REPLACE VIEW v_online_peers AS
SELECT 
    p.peer_id,
    p.peer_name,
    p.ip_address,
    p.listening_port,
    p.download_port,
    p.last_seen,
    u.username
FROM peers p
JOIN users u ON p.user_id = u.user_id
WHERE p.is_online = TRUE
ORDER BY p.last_seen DESC;

-- =====================================================
-- Sample data for testing (optional)
-- =====================================================

-- Insert sample users
INSERT INTO users (username, password, email, ip_address, port, is_online) VALUES
('alice', 'password123', 'alice@example.com', '192.168.1.10', 9001, TRUE),
('bob', 'password123', 'bob@example.com', '192.168.1.11', 9002, TRUE),
('charlie', 'password123', 'charlie@example.com', '192.168.1.12', 9003, FALSE)
ON DUPLICATE KEY UPDATE username = username;

-- Insert sample peers
INSERT INTO peers (user_id, peer_name, ip_address, listening_port, download_port, is_online) VALUES
(2, 'Alice-Peer', '192.168.1.10', 9001, 9004, TRUE),
(3, 'Bob-Peer', '192.168.1.11', 9002, 9005, TRUE),
(4, 'Charlie-Peer', '192.168.1.12', 9003, 9006, FALSE)
ON DUPLICATE KEY UPDATE peer_name = peer_name;

-- =====================================================
-- End of schema
-- =====================================================