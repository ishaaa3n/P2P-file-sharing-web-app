<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Study Material Hub — Login</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh; display: flex; align-items: center; justify-content: center;
            padding: 2rem 1rem;
        }
        .login-container {
            background: white; padding: 3rem; border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            width: 100%; max-width: 420px;
        }
        h2 { text-align: center; color: #667eea; margin-bottom: 0.25rem; font-size: 1.75rem; }
        .subtitle { text-align: center; color: #888; margin-bottom: 1.75rem; font-size: 0.9rem; }
        .form-group { margin-bottom: 1rem; }
        label { display: block; margin-bottom: 0.4rem; color: #555; font-size: 0.9rem; font-weight: 500; }
        input {
            width: 100%; padding: 0.75rem; border: 1px solid #ddd;
            border-radius: 6px; font-size: 0.95rem; font-family: inherit;
        }
        input:focus { outline: none; border-color: #667eea; }
        .btn {
            width: 100%; background: #667eea; color: white;
            padding: 0.85rem; border: none; border-radius: 6px;
            font-size: 1rem; cursor: pointer; transition: background 0.3s;
            margin-top: 0.5rem;
        }
        .btn:hover { background: #5568d3; }
        .alert { padding: 0.75rem; border-radius: 6px; margin-bottom: 1rem; font-size: 0.9rem; }
        .alert-error   { background: #f8d7da; color: #721c24; }
        .alert-success { background: #d4edda; color: #155724; }
        .switch { text-align: center; margin-top: 1.5rem; font-size: 0.9rem; color: #666; }
        .switch a { color: #667eea; text-decoration: none; font-weight: 500; }
        .switch a:hover { text-decoration: underline; }
        .home-link { display: block; text-align: center; margin-top: 1rem; color: #aaa; font-size: 0.85rem; text-decoration: none; }
        .home-link:hover { color: #667eea; }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>📚 Study Material Hub</h2>
        <p class="subtitle">Sign in to continue</p>

        <c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>
        <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>

        <form action="controller" method="post">
            <input type="hidden" name="action" value="login">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required autofocus>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit" class="btn">Sign in</button>
        </form>

        <div class="switch">
            New here? <a href="controller?action=register">Create an account</a>
        </div>
        <a class="home-link" href="controller?action=home">← Back to home</a>
    </div>
</body>
</html>
