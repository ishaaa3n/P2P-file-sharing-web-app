# P2P File Sharing Network - Web Application

A complete Peer-to-Peer File Sharing Network built with **Java Servlet, JSP, JDBC, and MVC Architecture**.

## 📋 Project Overview

This project demonstrates a web-based P2P file sharing system where users can:
- Register and login to the system
- Upload files to share with the network
- Browse and download files from other peers
- Register and manage peer connections
- Track file downloads and peer activity

## 🏗️ Architecture

### MVC Pattern Implementation

```
┌─────────────────────────────────────────────────────────────────┐
│                         MVC Architecture                         │
├─────────────────────────────────────────────────────────────────┤
│  MODEL          │  VIEW           │  CONTROLLER                  │
│ ────────────────│─────────────────│────────────────────────────  │
│ • User          │ • home.jsp      │ • MainControllerServlet     │
│ • SharedFile    │ • login.jsp     │ • UserServlet               │
│ • Peer          │ • register.jsp  │ • FileUploadServlet         │
│ • UserDAO       │ • dashboard.jsp │ • FileDownloadServlet       │
│ • FileDAO       │ • files.jsp     │ • PeerServlet               │
│ • PeerDAO       │ • peers.jsp     │                             │
│ • DBConnection  │                 │                             │
└─────────────────────────────────────────────────────────────────┘
```

### Technology Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | JSP (JavaServer Pages), HTML5, CSS3, JavaScript |
| **Controller** | Java Servlets (javax.servlet) |
| **Model** | Java Beans (POJO) |
| **Data Access** | JDBC (java.sql) |
| **Database** | MySQL |
| **Server** | Apache Tomcat 9+ |
| **Build** | IntelliJ IDEA / Eclipse |

## 📁 Project Structure

```
P2P-File-Sharing-Web/
├── src/
│   └── com/p2p/
│       ├── controller/
│       │   ├── MainControllerServlet.java    # Front Controller
│       │   ├── FileUploadServlet.java        # File upload handling
│       │   ├── FileDownloadServlet.java      # File download handling
│       │   └── PeerServlet.java              # Peer management
│       ├── model/
│       │   ├── User.java                     # User entity
│       │   ├── SharedFile.java               # File entity
│       │   └── Peer.java                     # Peer entity
│       ├── dao/
│       │   ├── UserDAO.java                  # User data access
│       │   ├── FileDAO.java                  # File data access
│       │   └── PeerDAO.java                  # Peer data access
│       └── util/
│           └── DBConnection.java             # JDBC connection utility
├── web/
│   ├── WEB-INF/
│   │   ├── web.xml                           # Servlet configuration
│   │   └── views/
│   │       ├── home.jsp                      # Home page
│   │       ├── login.jsp                     # Login page
│   │       ├── register.jsp                  # Registration page
│   │       ├── dashboard.jsp                 # User dashboard
│   │       ├── files.jsp                     # File browser
│   │       └── peers.jsp                     # Peer management
│   └── index.jsp                             # Entry point
├── database/
│   └── schema.sql                            # MySQL database schema
└── README.md
```

## 🚀 Setup Instructions

### Prerequisites

1. **Java Development Kit (JDK)** 8 or higher
2. **Apache Tomcat** 9.0 or higher
3. **MySQL Server** 5.7 or higher
4. **MySQL JDBC Driver** (mysql-connector-java)

### Step 1: Database Setup

1. Start your MySQL server
2. Run the database schema script:

```bash
mysql -u root -p < database/schema.sql
```

Or manually execute the SQL in `database/schema.sql` using MySQL Workbench or phpMyAdmin.

### Step 2: Configure Database Connection

Update the database credentials in `web/WEB-INF/web.xml`:

```xml
<context-param>
    <param-name>dbURL</param-name>
    <param-value>jdbc:mysql://localhost:3306/p2p_file_sharing</param-value>
</context-param>
<context-param>
    <param-name>dbUser</param-name>
    <param-value>root</param-value>
</context-param>
<context-param>
    <param-name>dbPassword</param-name>
    <param-value>your_password</param-value>
</context-param>
```

### Step 3: Deploy to Tomcat

1. Copy the project to Tomcat's `webapps` directory
2. Or use IntelliJ IDEA / Eclipse to deploy directly

### Step 4: Start the Application

1. Start Apache Tomcat
2. Access the application at: `http://localhost:8080/P2P-File-Sharing-Web/`

## 📖 Usage Guide

### Default Credentials

| Username | Password |
|----------|----------|
| admin | admin123 |

### User Registration

1. Click "Register" on the home page
2. Fill in username, email, and password
3. Account will be created and you can login

### Uploading Files

1. Login to your account
2. Go to Dashboard or click "Upload"
3. Select a file and add description (optional)
4. Click "Upload" to share the file

### Browsing Files

1. Click "Files" in the navigation
2. Browse all available files
3. Use search to find specific files
4. Click "Download" to download a file

### Managing Peers

1. Click "Peers" in the navigation
2. View online and offline peers
3. Register a new peer with your account
4. Connect/disconnect peers as needed

## 🗄️ Database Schema

### Tables

| Table | Description |
|-------|-------------|
| `users` | User accounts and authentication |
| `shared_files` | Files available for sharing |
| `peers` | Peer node information |
| `file_chunks` | File chunk metadata for P2P distribution |
| `downloads` | Download history tracking |

### Key Relationships

```
users (1) ─── (many) shared_files
users (1) ─── (many) peers
shared_files (1) ─── (many) file_chunks
peers (1) ─── (many) file_chunks
shared_files (1) ─── (many) downloads
users (1) ─── (many) downloads
peers (1) ─── (many) downloads
```

## 🔧 Features

### Implemented Features

- ✅ **MVC Architecture** - Clean separation of Model, View, Controller
- ✅ **Servlet-based Controllers** - Front Controller pattern implementation
- ✅ **JSP Views** - Dynamic page rendering with JSTL
- ✅ **JDBC Data Access** - Full CRUD operations with DAO pattern
- ✅ **User Authentication** - Login/Registration system
- ✅ **File Upload/Download** - Multipart file handling
- ✅ **Peer Management** - Register, connect, disconnect peers
- ✅ **File Search** - Search files by name
- ✅ **Pagination** - Browse files with pagination
- ✅ **Session Management** - HTTP session handling
- ✅ **Responsive UI** - Modern CSS styling

### P2P Features

- ✅ **Chunk-based File Distribution** - Files split into 100KB chunks
- ✅ **Peer Discovery** - View active peers in the network
- ✅ **Neighbor Assignment** - Upload/Download neighbor tracking
- ✅ **Download Tracking** - Track download counts

## 🛠️ Development

### Building from Source

1. Open the project in IntelliJ IDEA or Eclipse
2. Configure Tomcat server
3. Add MySQL JDBC driver to classpath
4. Build and deploy

### Adding MySQL Connector

Download MySQL Connector/J from [MySQL Downloads](https://dev.mysql.com/downloads/connector/j/)

Place the JAR file in:
- `web/WEB-INF/lib/` directory, or
- Tomcat's `lib/` directory

## 📝 API Reference

### Servlet Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/controller?action=home` | GET | Home page |
| `/controller?action=login` | GET/POST | Login page/processing |
| `/controller?action=register` | GET/POST | Registration page/processing |
| `/controller?action=dashboard` | GET | User dashboard |
| `/controller?action=files` | GET | Browse files |
| `/controller?action=peers` | GET | View peers |
| `/controller?action=search&q=...` | GET | Search files |
| `/upload` | GET/POST | File upload page/processing |
| `/download?id=...` | GET | Download file |
| `/peer?action=register` | GET/POST | Register peer |
| `/peer?action=connect&id=...` | GET | Connect peer |
| `/peer?action=disconnect&id=...` | GET | Disconnect peer |

## 🔒 Security Notes

- Passwords are stored in plain text in this demo (for educational purposes)
- In production, use password hashing (BCrypt, SHA-256)
- Implement CSRF protection
- Add input validation and sanitization
- Use HTTPS for secure connections

## 📄 License

This project is created for educational purposes as a college project demonstrating Servlet, JSP, JDBC, and MVC patterns.

## 👨‍💻 Author

College Java Project - P2P File Sharing Network

---

**Technologies Used:** Java Servlet | JSP | JDBC | MVC | MySQL | Tomcat