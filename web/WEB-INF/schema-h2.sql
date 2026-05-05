-- College Study Material Hub schema (H2)
-- Auto-loaded on first startup by DBInitializer
-- Uses CREATE / ALTER ... IF NOT EXISTS so re-runs are safe

CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) DEFAULT 'student',
    branch VARCHAR(50) DEFAULT NULL,
    semester INT DEFAULT 0,
    ip_address VARCHAR(45) DEFAULT NULL,
    port INT DEFAULT 0,
    is_online BOOLEAN DEFAULT FALSE,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL DEFAULT NULL,
    last_seen TIMESTAMP NULL DEFAULT NULL
);

ALTER TABLE users ADD COLUMN IF NOT EXISTS role VARCHAR(20) DEFAULT 'student';
ALTER TABLE users ADD COLUMN IF NOT EXISTS branch VARCHAR(50) DEFAULT NULL;
ALTER TABLE users ADD COLUMN IF NOT EXISTS semester INT DEFAULT 0;

CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);

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
    subject VARCHAR(100) DEFAULT NULL,
    branch VARCHAR(50) DEFAULT NULL,
    semester INT DEFAULT 0,
    material_type VARCHAR(30) DEFAULT 'notes',
    is_verified BOOLEAN DEFAULT FALSE,
    upvote_count INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

ALTER TABLE shared_files ADD COLUMN IF NOT EXISTS subject VARCHAR(100) DEFAULT NULL;
ALTER TABLE shared_files ADD COLUMN IF NOT EXISTS branch VARCHAR(50) DEFAULT NULL;
ALTER TABLE shared_files ADD COLUMN IF NOT EXISTS semester INT DEFAULT 0;
ALTER TABLE shared_files ADD COLUMN IF NOT EXISTS material_type VARCHAR(30) DEFAULT 'notes';
ALTER TABLE shared_files ADD COLUMN IF NOT EXISTS is_verified BOOLEAN DEFAULT FALSE;
ALTER TABLE shared_files ADD COLUMN IF NOT EXISTS upvote_count INT DEFAULT 0;

CREATE INDEX IF NOT EXISTS idx_files_subject ON shared_files(subject);
CREATE INDEX IF NOT EXISTS idx_files_branch ON shared_files(branch);
CREATE INDEX IF NOT EXISTS idx_files_semester ON shared_files(semester);
CREATE INDEX IF NOT EXISTS idx_files_material_type ON shared_files(material_type);
CREATE INDEX IF NOT EXISTS idx_files_upload_date ON shared_files(upload_date);

CREATE TABLE IF NOT EXISTS material_ratings (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    file_id INT NOT NULL,
    user_id INT NOT NULL,
    rating_value INT NOT NULL DEFAULT 1,
    rated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (file_id, user_id),
    FOREIGN KEY (file_id) REFERENCES shared_files(file_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_ratings_file ON material_ratings(file_id);
CREATE INDEX IF NOT EXISTS idx_ratings_user ON material_ratings(user_id);

-- Legacy tables kept for backwards compatibility (peer concept retained but not surfaced)
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

CREATE TABLE IF NOT EXISTS downloads (
    download_id INT PRIMARY KEY AUTO_INCREMENT,
    file_id INT NOT NULL,
    user_id INT DEFAULT NULL,
    peer_id INT DEFAULT NULL,
    download_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    download_status VARCHAR(20) DEFAULT 'pending',
    FOREIGN KEY (file_id) REFERENCES shared_files(file_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- Default admin (faculty role)
MERGE INTO users (username, password, email, role, branch, semester)
KEY(username)
VALUES ('admin', 'admin123', 'admin@college.edu', 'faculty', 'CSE', 0);

-- Sample student
MERGE INTO users (username, password, email, role, branch, semester)
KEY(username)
VALUES ('student1', 'student123', 'student1@college.edu', 'student', 'CSE', 5);
