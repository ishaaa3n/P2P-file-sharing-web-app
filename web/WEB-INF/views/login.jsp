<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Study Material Hub — Login</title>
    <link rel="stylesheet" href="css/modern-style.css">
    <style>
        body {
            background:
                radial-gradient(900px 500px at 80% -10%, rgba(236, 72, 153, 0.10), transparent 60%),
                radial-gradient(700px 400px at 0% 100%, rgba(99, 102, 241, 0.10), transparent 60%),
                #fafafa;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: var(--space-xl) var(--space-md);
        }

        .login-container {
            background: var(--bg-primary);
            padding: var(--space-2xl);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-xl);
            width: 100%;
            max-width: 420px;
            border: 1px solid var(--border);
            animation: fadeIn 0.3s var(--ease-out);
        }

        .login-header { text-align: center; margin-bottom: var(--space-xl); }
        .login-header h1 {
            color: var(--text-primary);
            font-size: 1.5rem;
            margin-bottom: 0.4rem;
            letter-spacing: -0.02em;
        }
        .login-header p { color: var(--text-tertiary); font-size: 0.9rem; }

        .home-link { text-align: center; margin-top: var(--space-lg); }
        .home-link a { color: var(--text-tertiary); font-size: 0.85rem; }
        .home-link a:hover { color: var(--text-primary); }

        .login-footer {
            text-align: center;
            margin-top: var(--space-xl);
            padding-top: var(--space-lg);
            border-top: 1px solid var(--border);
            font-size: 0.9rem;
            color: var(--text-tertiary);
        }
        .login-footer a { font-weight: 600; color: var(--text-primary); }
        .login-footer a:hover { color: var(--primary); }

        button[type="submit"] { width: 100%; }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1>📚 Study Material Hub</h1>
            <p>Sign in to continue</p>
        </div>

        <c:if test="${not empty error}"><div class="alert alert-error">⚠️ ${error}</div></c:if>
        <c:if test="${not empty success}"><div class="alert alert-success">✓ ${success}</div></c:if>

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
            
            <button type="submit" class="btn btn-primary btn-lg">Sign in</button>
        </form>

        <div class="login-footer">
            New here? <a href="controller?action=register">Create an account</a>
        </div>
        
        <div class="home-link">
            <a href="controller?action=home">← Back to home</a>
        </div>
    </div>
</body>
</html>
