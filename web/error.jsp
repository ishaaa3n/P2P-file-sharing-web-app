<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Oops - Something went wrong</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex; align-items: center; justify-content: center;
            padding: 2rem;
        }
        .card {
            background: white; padding: 3rem; border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
            max-width: 540px; text-align: center;
        }
        .code { font-size: 5rem; font-weight: 700; color: #667eea; line-height: 1; }
        h2 { color: #333; margin: 0.5rem 0 0.75rem; }
        p { color: #666; margin-bottom: 1.5rem; }
        .actions a {
            display: inline-block; background: #667eea; color: white;
            padding: 0.75rem 1.5rem; border-radius: 5px;
            text-decoration: none; transition: background 0.3s;
            margin: 0.25rem;
        }
        .actions a:hover { background: #5568d3; }
        .actions .secondary { background: #888; }
        .actions .secondary:hover { background: #666; }
        .details {
            margin-top: 2rem; padding: 1rem; background: #f5f5f5;
            border-radius: 5px; text-align: left; font-size: 0.85rem;
            color: #555; word-break: break-word;
        }
    </style>
</head>
<body>
    <div class="card">
        <%
            Integer status = (Integer) request.getAttribute("javax.servlet.error.status_code");
            String msg = (String) request.getAttribute("javax.servlet.error.message");
            String uri = (String) request.getAttribute("javax.servlet.error.request_uri");
            int code = status != null ? status : 0;
        %>
        <div class="code"><%= code != 0 ? code : "Error" %></div>
        <h2>
            <% if (code == 404) { %>Page not found
            <% } else if (code == 500) { %>Server error
            <% } else { %>Something went wrong<% } %>
        </h2>
        <p>
            <% if (code == 404) { %>
                The page you were looking for doesn't exist.
            <% } else if (code == 500) { %>
                The server hit an unexpected error while handling your request.
            <% } else { %>
                An unexpected error occurred.
            <% } %>
        </p>
        <div class="actions">
            <a href="<%= request.getContextPath() %>/controller?action=home">Home</a>
            <a href="javascript:history.back()" class="secondary">Go back</a>
        </div>
        <% if (msg != null && !msg.isEmpty() || uri != null) { %>
            <div class="details">
                <% if (uri != null) { %><div><strong>URL:</strong> <%= uri %></div><% } %>
                <% if (msg != null && !msg.isEmpty()) { %><div><strong>Message:</strong> <%= msg %></div><% } %>
            </div>
        <% } %>
    </div>
</body>
</html>
