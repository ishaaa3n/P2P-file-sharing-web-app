<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Active Peers - Study Material Hub</title>
    <link rel="stylesheet" href="css/modern-style.css">
    <style>
        .header-section {
            background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
            color: white;
            padding: var(--space-2xl) var(--space-lg);
            margin-bottom: var(--space-2xl);
            border-radius: 12px;
        }

        .header-section h1 {
            margin-bottom: var(--space-sm);
        }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: var(--space-lg);
            margin-top: var(--space-lg);
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            display: block;
            margin-bottom: var(--space-xs);
        }

        .stat-label {
            font-size: 0.9rem;
            opacity: 0.95;
        }

        .peers-table {
            background: var(--bg-primary);
            border: 1px solid var(--border);
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: var(--space-2xl);
        }

        .table-header {
            background: var(--bg-tertiary);
            padding: var(--space-lg);
            border-bottom: 1px solid var(--border);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: var(--space-md);
            text-align: left;
            border-bottom: 1px solid var(--border);
        }

        th {
            background: var(--bg-tertiary);
            font-weight: 600;
            color: var(--text-primary);
            font-size: 0.9rem;
        }

        tr:hover {
            background: var(--bg-tertiary);
        }

        tr:last-child td {
            border-bottom: none;
        }

        .status-online {
            background: #d1fae5;
            color: #065f46;
            padding: var(--space-xs) var(--space-sm);
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-block;
        }

        .status-offline {
            background: var(--danger-light);
            color: var(--danger-text);
            padding: var(--space-xs) var(--space-sm);
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-block;
        }

        .actions-cell {
            display: flex;
            gap: var(--space-sm);
            flex-wrap: wrap;
        }

        .empty-peers {
            text-align: center;
            padding: var(--space-2xl) var(--space-lg);
            background: var(--bg-primary);
            border-radius: 12px;
            border: 1px solid var(--border);
        }

        @media (max-width: 768px) {
            table {
                font-size: 0.85rem;
            }

            th, td {
                padding: var(--space-sm);
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <h1>📚 Study Material Hub</h1>
        <div class="nav-links">
            <a href="controller?action=home">Home</a>
            <a href="controller?action=files">Browse Files</a>
            <a href="controller?action=peers">Active Peers</a>
            <c:if test="${not empty sessionScope.user}">
                <a href="controller?action=dashboard">Dashboard</a>
                <a href="controller?action=logout">Logout</a>
            </c:if>
            <c:if test="${empty sessionScope.user}">
                <a href="controller?action=login">Login</a>
            </c:if>
        </div>
    </nav>

    <div class="container">
        <div class="header-section">
            <h1>🌐 Active Peers in Network</h1>
            <p>Monitor and manage peer connections in the P2P file sharing network</p>
            <div class="stats-row">
                <div class="stat-item">
                    <span class="stat-number">🟢 ${onlineCount}</span>
                    <span class="stat-label">Online Now</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">${totalCount}</span>
                    <span class="stat-label">Total Registered</span>
                </div>
            </div>
        </div>

        <c:if test="${not empty success}">
            <div class="alert alert-success">✓ ${success}</div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error">⚠️ ${error}</div>
        </c:if>

        <!-- Online Peers -->
        <c:if test="${not empty onlinePeers}">
            <div style="margin-bottom: var(--space-2xl);">
                <h3 style="margin-bottom: var(--space-lg);">🟢 Online Peers</h3>
                <div class="peers-table">
                    <table>
                        <thead>
                            <tr>
                                <th>Peer ID</th>
                                <th>Name</th>
                                <th>IP Address</th>
                                <th>Port</th>
                                <th>Status</th>
                                <th>Last Seen</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="peer" items="${onlinePeers}">
                                <tr>
                                    <td><code style="background: var(--bg-tertiary); padding: 2px 6px; border-radius: 4px; font-size: 0.85rem;">${peer.peerId}</code></td>
                                    <td>${peer.peerName}</td>
                                    <td>${peer.ipAddress}</td>
                                    <td>${peer.listeningPort}</td>
                                    <td><span class="status-online">● Online</span></td>
                                    <td style="font-size: 0.9rem; color: var(--text-secondary);">${peer.lastSeen}</td>
                                    <td>
                                        <a href="peer?action=disconnect&id=${peer.peerId}" class="btn btn-sm btn-danger" onclick="return confirm('Disconnect this peer?')">Disconnect</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <!-- All Peers -->
        <c:if test="${not empty allPeers}">
            <div style="margin-bottom: var(--space-2xl);">
                <h3 style="margin-bottom: var(--space-lg);">📋 All Peers</h3>
                <div class="peers-table">
                    <table>
                        <thead>
                            <tr>
                                <th>Peer ID</th>
                                <th>Name</th>
                                <th>IP Address</th>
                                <th>Port</th>
                                <th>Status</th>
                                <th>Last Seen</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="peer" items="${allPeers}">
                                <tr>
                                    <td><code style="background: var(--bg-tertiary); padding: 2px 6px; border-radius: 4px; font-size: 0.85rem;">${peer.peerId}</code></td>
                                    <td>${peer.peerName}</td>
                                    <td>${peer.ipAddress}</td>
                                    <td>${peer.listeningPort}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${peer.online}">
                                                <span class="status-online">● Online</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-offline">○ Offline</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="font-size: 0.9rem; color: var(--text-secondary);">${peer.lastSeen}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${peer.online}">
                                                <a href="peer?action=disconnect&id=${peer.peerId}" class="btn btn-sm btn-danger" onclick="return confirm('Disconnect this peer?')">Disconnect</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="peer?action=connect&id=${peer.peerId}" class="btn btn-sm btn-success">Connect</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <!-- Empty State -->
        <c:if test="${empty onlinePeers and empty allPeers}">
            <div class="empty-peers">
                <h3 style="margin-bottom: var(--space-md);">No peers registered yet</h3>
                <p style="color: var(--text-secondary); margin-bottom: var(--space-lg);">
                    Register your first peer to start participating in the P2P network
                </p>
                <a href="peer?action=register" class="btn btn-primary">Register New Peer</a>
            </div>
        </c:if>
    </div>
</body>
</html>
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