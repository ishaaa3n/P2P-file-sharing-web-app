<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>P2P File Sharing - Upload</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; min-height: 100vh; }

        .navbar {
            background: white; padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: flex; justify-content: space-between; align-items: center;
        }
        .navbar h1 { color: #667eea; font-size: 1.5rem; }
        .nav-links a {
            color: #333; text-decoration: none; margin-left: 1.5rem;
            padding: 0.5rem 1rem; border-radius: 5px; transition: all 0.3s;
        }
        .nav-links a:hover { background: #667eea; color: white; }

        .container { max-width: 700px; margin: 2rem auto; padding: 2rem; }

        .card {
            background: white; padding: 2rem; border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        .card h2 { color: #333; margin-bottom: 1.5rem; }

        .form-group { margin-bottom: 1.25rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; color: #555; font-weight: 500; }
        .form-group input[type="file"],
        .form-group textarea {
            width: 100%; padding: 0.75rem; border: 1px solid #ddd;
            border-radius: 5px; font-size: 1rem; font-family: inherit;
        }
        .form-group textarea { resize: vertical; min-height: 80px; }

        .btn {
            background: #667eea; color: white; padding: 0.75rem 1.5rem;
            border: none; border-radius: 5px; cursor: pointer;
            font-size: 1rem; transition: background 0.3s;
        }
        .btn:hover { background: #5568d3; }
        .btn-secondary { background: #888; margin-left: 0.5rem; }
        .btn-secondary:hover { background: #666; }

        .alert {
            padding: 0.85rem 1rem; border-radius: 5px; margin-bottom: 1rem;
        }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error   { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        .file-info { margin-top: 1rem; font-size: 0.9rem; color: #555; }
        .file-info p { margin: 0.25rem 0; }

        .max-size-note { font-size: 0.85rem; color: #888; margin-top: 0.25rem; }
    </style>
</head>
<body>
    <nav class="navbar">
        <h1>P2P File Sharing</h1>
        <div class="nav-links">
            <a href="controller?action=dashboard">Dashboard</a>
            <a href="upload">Upload</a>
            <a href="controller?action=files">Files</a>
            <a href="peer">Peers</a>
            <a href="controller?action=logout">Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="card">
            <h2>Upload a File</h2>

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <strong>${success}</strong>
                    <div class="file-info">
                        <p><strong>File:</strong> ${fileName}</p>
                        <p><strong>Size:</strong> ${fileSize}</p>
                        <p><strong>Chunks:</strong> ${chunkCount}</p>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>

            <form action="upload" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="file">Select file</label>
                    <input type="file" name="file" id="file" required>
                    <p class="max-size-note">Maximum file size: 100 MB</p>
                </div>
                <div class="form-group">
                    <label for="description">Description (optional)</label>
                    <textarea name="description" id="description" placeholder="Briefly describe this file..."></textarea>
                </div>
                <button type="submit" class="btn">Upload</button>
                <a href="controller?action=dashboard" class="btn btn-secondary" style="text-decoration:none;display:inline-block;">Cancel</a>
            </form>
        </div>
    </div>
</body>
</html>
