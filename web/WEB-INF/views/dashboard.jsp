<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>P2P File Sharing - Dashboard</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            min-height: 100vh;
        }
        
        .navbar {
            background: white;
            padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .navbar h1 {
            color: #667eea;
            font-size: 1.5rem;
        }
        
        .nav-links a {
            color: #333;
            text-decoration: none;
            margin-left: 1.5rem;
            padding: 0.5rem 1rem;
            border-radius: 5px;
            transition: all 0.3s;
        }
        
        .nav-links a:hover {
            background: #667eea;
            color: white;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .welcome-banner {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 10px;
            margin-bottom: 2rem;
        }
        
        .welcome-banner h2 {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .stat-card h3 {
            color: #667eea;
            font-size: 2rem;
            margin-bottom: 0.25rem;
        }
        
        .stat-card p {
            color: #666;
            font-size: 0.9rem;
        }
        
        .section {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .section h3 {
            color: #333;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #667eea;
        }
        
        .file-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .file-table th,
        .file-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .file-table th {
            background: #f8f9fa;
            color: #333;
            font-weight: 600;
        }
        
        .file-table tr:hover {
            background: #f8f9fa;
        }
        
        .btn {
            display: inline-block;
            padding: 0.5rem 1rem;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s;
        }
        
        .btn:hover {
            background: #5a6fd6;
        }
        
        .btn-sm {
            padding: 0.25rem 0.75rem;
            font-size: 0.85rem;
        }
        
        .btn-success {
            background: #28a745;
        }
        
        .btn-success:hover {
            background: #218838;
        }
        
        .btn-danger {
            background: #dc3545;
        }
        
        .btn-danger:hover {
            background: #c82333;
        }
        
        .peer-info {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 8px;
            margin-top: 1rem;
        }
        
        .peer-info p {
            margin: 0.25rem 0;
            color: #666;
        }
        
        .peer-info strong {
            color: #333;
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #666;
        }
        
        .empty-state p {
            margin: 1rem 0;
        }
        
        .actions {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <h1>🔗 P2P Dashboard</h1>
        <div class="nav-links">
            <a href="controller?action=home">Home</a>
            <a href="controller?action=files">Files</a>
            <a href="controller?action=peers">Peers</a>
            <a href="upload">Upload</a>
            <a href="controller?action=logout" class="btn btn-danger">Logout</a>
        </div>
    </nav>
    
    <div class="container">
        <div class="welcome-banner">
            <h2>Welcome back, ${username}!</h2>
            <p>Manage your files and peer connections</p>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>${totalFiles}</h3>
                <p>Total Files</p>
            </div>
            <div class="stat-card">
                <h3>${onlinePeers}</h3>
                <p>Online Peers</p>
            </div>
            <div class="stat-card">
                <h3>${not empty userFiles ? userFiles.size() : 0}</h3>
                <p>Your Files</p>
            </div>
        </div>
        
        <div class="actions">
            <a href="upload" class="btn btn-success">📤 Upload File</a>
            <a href="peer?action=register" class="btn">🔗 Register Peer</a>
        </div>
        
        <div class="section">
            <h3>📁 Your Files</h3>
            <c:if test="${not empty userFiles}">
                <table class="file-table">
                    <thead>
                        <tr>
                            <th>File Name</th>
                            <th>Size</th>
                            <th>Chunks</th>
                            <th>Downloads</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="file" items="${userFiles}">
                            <tr>
                                <td>${file.fileName}</td>
                                <td>${file.formattedFileSize}</td>
                                <td>${file.chunkCount}</td>
                                <td>${file.downloadCount}</td>
                                <td>
                                    <a href="download?id=${file.fileId}" class="btn btn-sm">Download</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <c:if test="${empty userFiles}">
                <div class="empty-state">
                    <p>You haven't uploaded any files yet.</p>
                    <a href="upload" class="btn">Upload your first file</a>
                </div>
            </c:if>
        </div>
        
        <c:if test="${not empty userPeer}">
        <div class="section">
            <h3>🌐 Your Peer Status</h3>
            <div class="peer-info">
                <p><strong>Peer Name:</strong> ${userPeer.peerName}</p>
                <p><strong>IP Address:</strong> ${userPeer.ipAddress}</p>
                <p><strong>Listening Port:</strong> ${userPeer.listeningPort}</p>
                <p><strong>Download Port:</strong> ${userPeer.downloadPort}</p>
                <p><strong>Status:</strong> 
                    <span style="color: ${userPeer.online ? '#28a745' : '#dc3545'}">
                        ${userPeer.online ? 'Online' : 'Offline'}
                    </span>
                </p>
            </div>
            <br>
            <c:if test="${userPeer.online}">
                <a href="peer?action=disconnect&id=${userPeer.peerId}" class="btn btn-danger">Disconnect Peer</a>
            </c:if>
            <c:if test="${!userPeer.online}">
                <a href="peer?action=connect&id=${userPeer.peerId}" class="btn btn-success">Connect Peer</a>
            </c:if>
        </div>
        </c:if>
    </div>
</body>
</html>