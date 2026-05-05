<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Study Material Hub — Register</title>
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

        .register-container {
            background: var(--bg-primary);
            padding: var(--space-2xl);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-xl);
            width: 100%;
            max-width: 520px;
            border: 1px solid var(--border);
            animation: fadeIn 0.3s var(--ease-out);
        }

        .register-header { text-align: center; margin-bottom: var(--space-xl); }
        .register-header h1 {
            color: var(--text-primary);
            font-size: 1.5rem;
            margin-bottom: 0.4rem;
            letter-spacing: -0.02em;
        }
        .register-header p { color: var(--text-tertiary); font-size: 0.9rem; }

        .register-footer {
            text-align: center;
            margin-top: var(--space-xl);
            padding-top: var(--space-lg);
            border-top: 1px solid var(--border);
            font-size: 0.9rem;
            color: var(--text-tertiary);
        }
        .register-footer a { font-weight: 600; color: var(--text-primary); }
        .register-footer a:hover { color: var(--primary); }

        button[type="submit"] { width: 100%; }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h1>📚 Study Material Hub</h1>
            <p>Create your account and join the community</p>
        </div>

        <c:if test="${not empty error}"><div class="alert alert-error">⚠️ ${error}</div></c:if>
        <c:if test="${not empty success}"><div class="alert alert-success">✓ ${success}</div></c:if>

        <form action="controller" method="post">
            <input type="hidden" name="action" value="register">

            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required>
            </div>

            <div class="form-group">
                <label for="email">College Email</label>
                <input type="email" id="email" name="email" placeholder="your@college.edu" required>
            </div>

            <div class="form-group">
                <label for="role">I am a</label>
                <select id="role" name="role" required>
                    <option value="">Select role</option>
                    <option value="student">Student</option>
                    <option value="faculty">Faculty</option>
                </select>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="branch">Branch</label>
                    <select id="branch" name="branch">
                        <option value="">Select branch</option>
                        <option value="CSE">Computer Science</option>
                        <option value="IT">Information Technology</option>
                        <option value="ECE">Electronics & Comm</option>
                        <option value="EEE">Electrical Engineering</option>
                        <option value="MECH">Mechanical</option>
                        <option value="CIVIL">Civil</option>
                        <option value="AIDS">AI & Data Science</option>
                        <option value="OTHER">Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="semester">Semester</label>
                    <select id="semester" name="semester">
                        <option value="0">Not applicable</option>
                        <option value="1">1st</option>
                        <option value="2">2nd</option>
                        <option value="3">3rd</option>
                        <option value="4">4th</option>
                        <option value="5">5th</option>
                        <option value="6">6th</option>
                        <option value="7">7th</option>
                        <option value="8">8th</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                    <p class="form-help">At least 6 characters</p>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-lg">Create Account</button>
        </form>

        <div class="register-footer">
            Already have an account? <a href="controller?action=login">Sign in here</a>
        </div>
    </div>
</body>
</html>
