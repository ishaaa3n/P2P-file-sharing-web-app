<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>P2P File Sharing - Active Peers</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .navbar {
            background: rgba(255, 255, 255, 0.95);
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
        
        .page-header {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .page-header h2 {
            color: #333;
            margin-bottom: 0.5rem;
        }
        
        .stats {
            display: flex;
            gap: 2rem;
            margin-top: 1rem;
        }
        
        .stat-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .stat-item .number {
            font-size: 1.5rem;
            font-weight: bold;
            color: #667eea;
        }
        
        .stat-item .label {
            color: #666;
        }
        
        .section {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .section h3 {
            color: #333;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #667eea;
        }
        
        .peer-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .peer-table th,
        .peer-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .peer-table th {
            background: #f8f9fa;
            color: #333;
            font-weight: 600;
        }
        
        .peer-table tr:hover {
            background: #f8f9fa;
        }
        
        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        
        .status-badge.online {
            background: #d4edda;
            color: #155724;
        }
        
        .status-badge.offline {
            background: #f8d7da;
            color: #721c24;
        }
        
        .btn {
            display: inline-block;
            padding: 0.4rem 0.8rem;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-size: 0.85rem;
            transition: all 0.3s;
        }
        
        .btn:hover {
            background: #5a6fd6;
        }
        
        .btn-sm {
            padding: 0.3rem 0.6rem;
            font-size: 0.8rem;
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
        
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #666;
        }
        
        .actions {
            display: flex;
            gap: 0.5rem;
        }
        
        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <h1>🔗 P2P File Sharing</h1>
        <div class="nav-links">
            <a href="controller?action=home">Home</a>
            <a href="controller?action=files">Files</a>
            <a href="controller?action=peers" style="background: #667eea; color: white;">Peers</a>
            <c:if test="${not empty sessionScope.username}">
                <a href="controller?action=dashboard">Dashboard</a>
                <a href="controller?action=logout">Logout</a>
            </c:if>
            <c:if test="${empty sessionScope.username}">
                <a href="controller?action=login">Login</a>
            </c:if>
        </div>
    </nav>
    
    <div class="container">
        <div class="page-header">
            <h2>🌐 Active Peers</h2>
            <p style="color: #666;">View and manage peer connections in the network</p>
            <div class="stats">
                <div class="stat-item">
                    <span class="number">${onlineCount}</span>
                    <span class="label">Online</span>
                </div>
                <div class="stat-item">
                    <span class="number">${totalCount}</span>
                    <span class="label">Total Peers</span>
                </div>
            </div>
        </div>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        
        <c:if test="${not empty onlinePeers}">
        <div class="section">
            <h3>🟢 Online Peers</h3>
            <table class="peer-table">
                <thead>
                    <tr>
                        <th>Peer ID</th>
                        <th>Peer Name</th>
                        <th>IP Address</th>
                        <th>Listening Port</th>
                        <th>Download Port</th>
                        <th>Last Seen</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="peer" items="${onlinePeers}">
                        <tr>
                            <td>${peer.peerId}</td>
                            <td>${peer.peerName}</td>
                            <td>${peer.ipAddress}</td>
                            <td>${peer.listeningPort}</td>
                            <td>${peer.downloadPort}</td>
                            <td>${peer.lastSeen}</td>
                            <td>
                                <div class="actions">
                                    <span class="status-badge online">Online</span>
                                    <a href="peer?action=disconnect&id=${peer.peerId}" class="btn btn-sm btn-danger">Disconnect</a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        </c:if>
        
        <c:if test="${not empty allPeers}">
        <div class="section">
            <h3>📋 All Peers</h3>
            <table class="peer-table">
                <thead>
                    <tr>
                        <th>Peer ID</th>
                        <th>Peer Name</th>
                        <th>IP Address</th>
                        <th>Port</th>
                        <th>Status</th>
                        <th>Last Seen</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="peer" items="${allPeers}">
                        <tr>
                            <td>${peer.peerId}</td>
                            <td>${peer.peerName}</td>
                            <td>${peer.ipAddress}</td>
                            <td>${peer.listeningPort}</td>
                            <td>
                                <span class="status-badge ${peer.online ? 'online' : 'offline'}">
                                    ${peer.online ? 'Online' : 'Offline'}
                                </span>
                            </td>
                            <td>${peer.lastSeen}</td>
                            <td>
                                <div class="actions">
                                    <c:if test="${peer.online}">
                                        <a href="peer?action=disconnect&id=${peer.peerId}" class="btn btn-sm btn-danger">Disconnect</a>
                                    </c:if>
                                    <c:if test="${!peer.online}">
                                        <a href="peer?action=connect&id=${peer.peerId}" class="btn btn-sm btn-success">Connect</a>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        </c:if>
        
        <c:if test="${empty onlinePeers and empty allPeers}">
        <div class="section">
            <div class="empty-state">
                <h3>No peers registered yet</h3>
                <p>Register a peer to start participating in the P2P network</p>
                <br>
                <a href="peer?action=register" class="btn">Register New Peer</a>
            </div>
        </div>
        </c:if>
        
        <div class="section">
            <h3>➕ Register New Peer</h3>
            <p style="color: #666; margin-bottom: 1rem;">
                Register your peer to participate in the P2P network. You'll need to provide a unique peer name and port numbers.
            </p>
            <a href="peer?action=register" class="btn">Register Peer</a>
        </div>
    </div>
</body>
</html>