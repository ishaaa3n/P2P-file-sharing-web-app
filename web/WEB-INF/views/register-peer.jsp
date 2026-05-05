<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>P2P File Sharing - Register Peer</title>
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
        .form-group input {
            width: 100%; padding: 0.75rem; border: 1px solid #ddd;
            border-radius: 5px; font-size: 1rem; font-family: inherit;
        }
        .form-row { display: flex; gap: 1rem; }
        .form-row .form-group { flex: 1; }

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

        .help { font-size: 0.85rem; color: #888; margin-top: 0.25rem; }
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
            <h2>Register a Peer</h2>

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <strong>${success}</strong>
                    <c:if test="${not empty peerName}">
                        <p>Peer "<strong>${peerName}</strong>" registered (ID: ${peerId})</p>
                    </c:if>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>

            <form action="peer" method="post">
                <input type="hidden" name="action" value="register">

                <div class="form-group">
                    <label for="peerName">Peer name</label>
                    <input type="text" id="peerName" name="peerName" placeholder="My-Peer-01" required>
                    <p class="help">A friendly name to identify this peer node.</p>
                </div>

                <div class="form-group">
                    <label for="ipAddress">IP address</label>
                    <input type="text" id="ipAddress" name="ipAddress" value="127.0.0.1" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="listeningPort">Listening port</label>
                        <input type="number" id="listeningPort" name="listeningPort" value="9001" min="1" max="65535" required>
                    </div>
                    <div class="form-group">
                        <label for="downloadPort">Download port</label>
                        <input type="number" id="downloadPort" name="downloadPort" value="9002" min="1" max="65535" required>
                    </div>
                </div>

                <button type="submit" class="btn">Register Peer</button>
                <a href="peer" class="btn btn-secondary" style="text-decoration:none;display:inline-block;">Cancel</a>
            </form>
        </div>
    </div>
</body>
</html>
