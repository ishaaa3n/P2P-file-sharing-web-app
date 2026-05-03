<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>P2P File Sharing Network - Home</title>
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
            margin-left: 2rem;
            padding: 0.5rem 1rem;
            border-radius: 5px;
            transition: all 0.3s;
        }
        
        .nav-links a:hover {
            background: #667eea;
            color: white;
        }
        
        .nav-links a.btn-primary {
            background: #667eea;
            color: white;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .hero {
            text-align: center;
            color: white;
            padding: 4rem 2rem;
        }
        
        .hero h2 {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        
        .hero p {
            font-size: 1.2rem;
            opacity: 0.9;
            margin-bottom: 2rem;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin: 3rem 0;
        }
        
        .stat-card {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .stat-card h3 {
            color: #667eea;
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
        }
        
        .stat-card p {
            color: #666;
            font-size: 1rem;
        }
        
        .section {
            background: white;
            border-radius: 10px;
            padding: 2rem;
            margin: 2rem 0;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .section h3 {
            color: #333;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #667eea;
        }
        
        .file-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1rem;
        }
        
        .file-item {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
        
        .file-item h4 {
            color: #333;
            margin-bottom: 0.5rem;
        }
        
        .file-item p {
            color: #666;
            font-size: 0.9rem;
        }
        
        .peer-list {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .peer-badge {
            background: #28a745;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
        }
        
        .peer-badge.offline {
            background: #6c757d;
        }
        
        .btn {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-size: 1rem;
            transition: all 0.3s;
        }
        
        .btn:hover {
            background: #5a6fd6;
            transform: translateY(-2px);
        }
        
        .footer {
            text-align: center;
            color: white;
            padding: 2rem;
            margin-top: 3rem;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <h1>🔗 P2P File Sharing</h1>
        <div class="nav-links">
            <a href="controller?action=home">Home</a>
            <a href="controller?action=files">Files</a>
            <a href="controller?action=peers">Peers</a>
            <a href="controller?action=login" class="btn-primary">Login</a>
            <a href="controller?action=register" class="btn-primary">Register</a>
        </div>
    </nav>
    
    <div class="container">
        <div class="hero">
            <h2>Peer-to-Peer File Sharing Network</h2>
            <p>Share files directly with peers across the network. Fast, secure, and decentralized.</p>
            <a href="controller?action=register" class="btn">Get Started</a>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>${totalFiles}</h3>
                <p>Files Available</p>
            </div>
            <div class="stat-card">
                <h3>${totalPeers}</h3>
                <p>Total Peers</p>
            </div>
            <div class="stat-card">
                <h3>${onlinePeers}</h3>
                <p>Online Peers</p>
            </div>
        </div>
        
        <c:if test="${not empty recentFiles}">
        <div class="section">
            <h3>📁 Recent Files</h3>
            <div class="file-list">
                <c:forEach var="file" items="${recentFiles}" begin="0" end="5">
                    <div class="file-item">
                        <h4>${file.fileName}</h4>
                        <p>Size: ${file.formattedFileSize} | Chunks: ${file.chunkCount}</p>
                        <p>Downloads: ${file.downloadCount}</p>
                    </div>
                </c:forEach>
            </div>
            <br>
            <a href="controller?action=files" class="btn">View All Files</a>
        </div>
        </c:if>
        
        <c:if test="${not empty onlinePeersList}">
        <div class="section">
            <h3>🌐 Active Peers</h3>
            <div class="peer-list">
                <c:forEach var="peer" items="${onlinePeersList}" begin="0" end="9">
                    <span class="peer-badge">
                        ${peer.peerName} (${peer.ipAddress}:${peer.listeningPort})
                    </span>
                </c:forEach>
            </div>
            <br>
            <a href="controller?action=peers" class="btn">View All Peers</a>
        </div>
        </c:if>
    </div>
    
    <div class="footer">
        <p>&copy; 2024 P2P File Sharing Network | Built with Java Servlet, JSP, JDBC & MVC</p>
    </div>
</body>
</html>