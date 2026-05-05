-- H2-compatible schema for P2P File Sharing
-- Auto-loaded on first startup by DBInitializer

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
    last_seen TIMESTAMP NULL DEFAULT NULL
);

CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_online ON users(is_online);

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
    description CLOB DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_files_user_id ON shared_files(user_id);
CREATE INDEX IF NOT EXISTS idx_files_name ON shared_files(file_name);
CREATE INDEX IF NOT EXISTS idx_files_available ON shared_files(is_available);
CREATE INDEX IF NOT EXISTS idx_files_type ON shared_files(file_type);
CREATE INDEX IF NOT EXISTS idx_files_upload_date ON shared_files(upload_date);

CREATE TABLE IF NOT EXISTS peers (
    peer_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    peer_name VARCHAR(100) NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    listening_port INT NOT NULL,
    download_port INT DEFAULT 0,
    is_online BOOLEAN DEFAULT FALSE,
    last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    upload_neighbor_id INT DEFAULT NULL,
    download_neighbor_id INT DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_peers_user_id ON peers(user_id);
CREATE INDEX IF NOT EXISTS idx_peers_name ON peers(peer_name);
CREATE INDEX IF NOT EXISTS idx_peers_online ON peers(is_online);

CREATE TABLE IF NOT EXISTS file_chunks (
    chunk_id INT PRIMARY KEY AUTO_INCREMENT,
    file_id INT NOT NULL,
    chunk_index INT NOT NULL,
    chunk_hash VARCHAR(64) DEFAULT NULL,
    peer_id INT DEFAULT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (file_id) REFERENCES shared_files(file_id) ON DELETE CASCADE,
    FOREIGN KEY (peer_id) REFERENCES peers(peer_id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_chunks_file_id ON file_chunks(file_id);
CREATE INDEX IF NOT EXISTS idx_chunks_peer_id ON file_chunks(peer_id);

CREATE TABLE IF NOT EXISTS downloads (
    download_id INT PRIMARY KEY AUTO_INCREMENT,
    file_id INT NOT NULL,
    user_id INT DEFAULT NULL,
    peer_id INT DEFAULT NULL,
    download_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    download_status VARCHAR(20) DEFAULT 'pending',
    FOREIGN KEY (file_id) REFERENCES shared_files(file_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (peer_id) REFERENCES peers(peer_id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_downloads_file_id ON downloads(file_id);
CREATE INDEX IF NOT EXISTS idx_downloads_user_id ON downloads(user_id);
CREATE INDEX IF NOT EXISTS idx_downloads_date ON downloads(download_date);

MERGE INTO users (username, password, email, ip_address, port, is_online)
KEY(username)
VALUES ('admin', 'admin123', 'admin@p2pnetwork.com', '127.0.0.1', 8080, TRUE);

MERGE INTO users (username, password, email, ip_address, port, is_online)
KEY(username)
VALUES ('alice', 'password123', 'alice@example.com', '192.168.1.10', 9001, TRUE);

MERGE INTO users (username, password, email, ip_address, port, is_online)
KEY(username)
VALUES ('bob', 'password123', 'bob@example.com', '192.168.1.11', 9002, TRUE);

MERGE INTO users (username, password, email, ip_address, port, is_online)
KEY(username)
VALUES ('charlie', 'password123', 'charlie@example.com', '192.168.1.12', 9003, FALSE);
