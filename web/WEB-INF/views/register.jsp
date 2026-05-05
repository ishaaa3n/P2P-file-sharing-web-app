<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Study Material Hub — Register</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh; display: flex; align-items: center; justify-content: center;
            padding: 2rem 1rem;
        }
        .register-container {
            background: white; padding: 2.5rem; border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            width: 100%; max-width: 480px;
        }
        h2 { text-align: center; color: #667eea; margin-bottom: 0.25rem; font-size: 1.75rem; }
        .subtitle { text-align: center; color: #888; margin-bottom: 1.5rem; font-size: 0.9rem; }
        .form-group { margin-bottom: 1rem; }
        .form-row { display: flex; gap: 0.75rem; }
        .form-row .form-group { flex: 1; }
        label { display: block; margin-bottom: 0.4rem; color: #555; font-size: 0.9rem; font-weight: 500; }
        input, select {
            width: 100%; padding: 0.7rem; border: 1px solid #ddd;
            border-radius: 6px; font-size: 0.95rem; font-family: inherit;
        }
        input:focus, select:focus { outline: none; border-color: #667eea; }
        .btn {
            width: 100%; background: #667eea; color: white;
            padding: 0.75rem; border: none; border-radius: 6px;
            font-size: 1rem; cursor: pointer; transition: background 0.3s;
            margin-top: 0.5rem;
        }
        .btn:hover { background: #5568d3; }
        .alert { padding: 0.75rem; border-radius: 6px; margin-bottom: 1rem; font-size: 0.9rem; }
        .alert-error { background: #f8d7da; color: #721c24; }
        .alert-success { background: #d4edda; color: #155724; }
        .switch { text-align: center; margin-top: 1.25rem; font-size: 0.9rem; color: #666; }
        .switch a { color: #667eea; text-decoration: none; font-weight: 500; }
        .switch a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="register-container">
        <h2>Create your account</h2>
        <p class="subtitle">Join the College Study Material Hub</p>

        <c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>
        <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>

        <form action="controller" method="post">
            <input type="hidden" name="action" value="register">

            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required>
            </div>

            <div class="form-group">
                <label for="email">College email</label>
                <input type="email" id="email" name="email" placeholder="you@college.edu" required>
            </div>

            <div class="form-group">
                <label for="role">I am a</label>
                <select id="role" name="role" required>
                    <option value="student">Student</option>
                    <option value="faculty">Faculty</option>
                </select>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="branch">Branch</label>
                    <select id="branch" name="branch">
                        <option value="">Select branch</option>
                        <option value="CSE">CSE</option>
                        <option value="IT">IT</option>
                        <option value="ECE">ECE</option>
                        <option value="EEE">EEE</option>
                        <option value="MECH">MECH</option>
                        <option value="CIVIL">CIVIL</option>
                        <option value="AIDS">AI &amp; DS</option>
                        <option value="OTHER">Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="semester">Semester</label>
                    <select id="semester" name="semester">
                        <option value="0">N/A</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                </div>
            </div>

            <button type="submit" class="btn">Create account</button>
        </form>

        <div class="switch">
            Already have an account? <a href="controller?action=login">Sign in</a>
        </div>
    </div>
</body>
</html>
