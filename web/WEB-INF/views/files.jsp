<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>P2P File Sharing - Browse Files</title>
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
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .page-header h2 {
            color: #333;
        }
        
        .search-form {
            display: flex;
            gap: 0.5rem;
        }
        
        .search-form input {
            padding: 0.75rem 1rem;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            width: 250px;
        }
        
        .search-form input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .search-form button {
            padding: 0.75rem 1.5rem;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1rem;
        }
        
        .search-form button:hover {
            background: #5a6fd6;
        }
        
        .files-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .file-card {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
        }
        
        .file-card:hover {
            transform: translateY(-5px);
        }
        
        .file-card h3 {
            color: #333;
            margin-bottom: 0.75rem;
            word-break: break-all;
        }
        
        .file-card .file-meta {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }
        
        .file-card .file-meta span {
            margin-right: 1rem;
        }
        
        .file-card .file-desc {
            color: #888;
            font-size: 0.85rem;
            margin-bottom: 1rem;
            max-height: 40px;
            overflow: hidden;
        }
        
        .file-card .file-actions {
            display: flex;
            gap: 0.5rem;
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
            padding: 0.4rem 0.8rem;
            font-size: 0.85rem;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            gap: 0.5rem;
            margin-top: 2rem;
        }
        
        .pagination a {
            padding: 0.5rem 1rem;
            background: white;
            color: #667eea;
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s;
        }
        
        .pagination a:hover,
        .pagination a.active {
            background: #667eea;
            color: white;
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem;
            background: white;
            border-radius: 10px;
        }
        
        .empty-state h3 {
            color: #333;
            margin-bottom: 1rem;
        }
        
        .empty-state p {
            color: #666;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <h1>🔗 P2P File Sharing</h1>
        <div class="nav-links">
            <a href="controller?action=home">Home</a>
            <a href="controller?action=files" style="background: #667eea; color: white;">Files</a>
            <a href="controller?action=peers">Peers</a>
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
            <h2>📁 Browse Files</h2>
            <form action="controller" method="get" class="search-form">
                <input type="hidden" name="action" value="search">
                <input type="text" name="q" placeholder="Search files..." value="${searchQuery}">
                <button type="submit">Search</button>
            </form>
        </div>
        
        <c:if test="${not empty files}">
            <div class="files-grid">
                <c:forEach var="file" items="${files}">
                    <div class="file-card">
                        <h3>📄 ${file.fileName}</h3>
                        <div class="file-meta">
                            <span>📊 ${file.formattedFileSize}</span>
                            <span>🧩 ${file.chunkCount} chunks</span>
                        </div>
                        <div class="file-meta">
                            <span>⬇️ ${file.downloadCount} downloads</span>
                            <span>📅 ${file.uploadDate}</span>
                        </div>
                        <c:if test="${not empty file.description}">
                            <div class="file-desc">${file.description}</div>
                        </c:if>
                        <div class="file-actions">
                            <a href="download?id=${file.fileId}" class="btn btn-sm">Download</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="controller?action=files&page=${currentPage - 1}">← Previous</a>
                    </c:if>
                    
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <a href="controller?action=files&page=${i}" 
                           class="${currentPage == i ? 'active' : ''}">${i}</a>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages}">
                        <a href="controller?action=files&page=${currentPage + 1}">Next →</a>
                    </c:if>
                </div>
            </c:if>
        </c:if>
        
        <c:if test="${empty files}">
            <div class="empty-state">
                <h3>No files available</h3>
                <p>Be the first to upload a file to the network!</p>
                <br>
                <a href="upload" class="btn">Upload File</a>
            </div>
        </c:if>
    </div>
</body>
</html>