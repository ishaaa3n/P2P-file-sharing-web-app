<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Study Material Hub</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
            background: linear-gradient(135deg, #4f46e5 0%, #06b6d4 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }

        .error-container {
            background: white;
            padding: 3rem 2rem;
            border-radius: 16px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
            max-width: 560px;
            text-align: center;
            animation: slideUp 0.3s ease;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .error-code {
            font-size: 4rem;
            font-weight: 700;
            color: #4f46e5;
            line-height: 1;
            margin-bottom: 0.5rem;
        }

        h1 {
            color: #1f2937;
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            font-weight: 600;
        }

        p {
            color: #6b7280;
            margin-bottom: 1.5rem;
            line-height: 1.6;
            font-size: 0.95rem;
        }

        .actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-bottom: 1.5rem;
        }

        a {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
            font-size: 0.95rem;
        }

        .btn-primary {
            background: #4f46e5;
            color: white;
        }

        .btn-primary:hover {
            background: #4338ca;
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        .btn-secondary {
            background: #f3f4f6;
            color: #374151;
            border: 1px solid #e5e7eb;
        }

        .btn-secondary:hover {
            background: #e5e7eb;
        }

        .error-details {
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e5e7eb;
            text-align: left;
            background: #f9fafb;
            padding: 1rem;
            border-radius: 8px;
            font-size: 0.8rem;
            color: #6b7280;
            word-break: break-word;
            font-family: 'Monaco', 'Courier New', monospace;
            max-height: 150px;
            overflow-y: auto;
        }

        .logo {
            font-size: 2rem;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="logo">📚</div>
        <%
            Integer status = (Integer) request.getAttribute("javax.servlet.error.status_code");
            String msg = (String) request.getAttribute("javax.servlet.error.message");
            String uri = (String) request.getAttribute("javax.servlet.error.request_uri");
            Throwable exception = (Throwable) request.getAttribute("javax.servlet.error.exception");
            int code = status != null ? status : 0;
        %>

        <div class="error-code"><%= code != 0 ? code : "Error" %></div>
        <h1>
            <% if (code == 404) { %>
                Page Not Found
            <% } else if (code == 500) { %>
                Server Error
            <% } else if (code == 403) { %>
                Access Denied
            <% } else if (code == 401) { %>
                Not Authorized
            <% } else { %>
                Oops! Something Went Wrong
            <% } %>
        </h1>

        <p>
            <% if (code == 404) { %>
                The page you're looking for doesn't exist. Please check the URL and try again.
            <% } else if (code == 500) { %>
                We encountered an unexpected error. Our team has been notified and is working on a fix.
            <% } else if (code == 403) { %>
                You don't have permission to access this resource.
            <% } else if (code == 401) { %>
                Please log in to access this page.
            <% } else { %>
                We're sorry, but something went wrong. Please try again later.
            <% } %>
        </p>

        <div class="actions">
            <a href="controller?action=home" class="btn-primary">← Back to Home</a>
            <a href="controller?action=files" class="btn-secondary">Browse Materials</a>
        </div>

        <% if (exception != null || uri != null) { %>
            <div class="error-details">
                <strong>Details:</strong><br>
                <% if (uri != null) { %>
                    URI: <%= uri %><br>
                <% } %>
                <% if (msg != null) { %>
                    Message: <%= msg %>
                <% } %>
            </div>
        <% } %>
    </div>
</body>
</html>
