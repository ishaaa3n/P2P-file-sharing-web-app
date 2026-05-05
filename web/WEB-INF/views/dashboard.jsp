<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Study Material Hub — Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; min-height: 100vh; color: #2d2d2d; }

        .navbar { background: white; padding: 1rem 2rem; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08); display: flex; justify-content: space-between; align-items: center; }
        .navbar h1 { color: #667eea; font-size: 1.4rem; }
        .nav-links a { color: #333; text-decoration: none; margin-left: 1rem; padding: 0.5rem 0.85rem; border-radius: 5px; transition: all 0.3s; font-size: 0.95rem; }
        .nav-links a:hover { background: #667eea; color: white; }

        .container { max-width: 1200px; margin: 1.5rem auto; padding: 0 1rem; }

        .welcome {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; padding: 1.75rem 2rem; border-radius: 12px;
            margin-bottom: 1.5rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;
        }
        .welcome h2 { font-size: 1.5rem; margin-bottom: 0.25rem; }
        .welcome p { opacity: 0.9; font-size: 0.95rem; }
        .welcome .actions a {
            background: rgba(255,255,255,0.2); color: white; padding: 0.6rem 1.1rem;
            border-radius: 6px; text-decoration: none; margin-left: 0.5rem;
            transition: background 0.2s;
        }
        .welcome .actions a:hover { background: rgba(255,255,255,0.3); }
        .role-tag { background: rgba(255,255,255,0.25); padding: 0.15rem 0.55rem; border-radius: 12px; font-size: 0.75rem; margin-left: 0.5rem; }

        .stats-row { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 1rem; margin-bottom: 1.5rem; }
        .stat-card {
            background: white; padding: 1.25rem 1.5rem; border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        .stat-card .num { font-size: 2rem; font-weight: 700; color: #667eea; }
        .stat-card .label { color: #888; font-size: 0.85rem; margin-top: 0.25rem; }

        .row { display: grid; grid-template-columns: 1.4fr 1fr; gap: 1.25rem; }
        @media (max-width: 900px) { .row { grid-template-columns: 1fr; } }

        .panel {
            background: white; padding: 1.5rem; border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        .panel h3 { color: #444; font-size: 1.1rem; margin-bottom: 1rem; display: flex; justify-content: space-between; align-items: center; }
        .panel h3 a { font-size: 0.85rem; color: #667eea; text-decoration: none; font-weight: normal; }
        .panel h3 a:hover { text-decoration: underline; }

        .file-list { display: flex; flex-direction: column; gap: 0.6rem; }
        .file-item {
            display: flex; justify-content: space-between; align-items: center;
            padding: 0.65rem 0.85rem; background: #fafbff; border-radius: 6px;
            font-size: 0.92rem; border-left: 3px solid #667eea;
        }
        .file-item .file-info { flex: 1; min-width: 0; }
        .file-item .file-name { font-weight: 500; color: #333; word-break: break-word; }
        .file-item .file-meta { color: #888; font-size: 0.78rem; margin-top: 0.15rem; }
        .file-item .verified { background: #d4edda; color: #155724; padding: 0.1rem 0.4rem; border-radius: 4px; font-size: 0.7rem; font-weight: 600; margin-left: 0.4rem; }
        .file-item .actions { display: flex; gap: 0.35rem; }
        .file-item .btn-mini {
            padding: 0.3rem 0.65rem; border-radius: 4px; font-size: 0.75rem;
            text-decoration: none; border: none; cursor: pointer;
        }
        .btn-mini-primary { background: #667eea; color: white; }
        .btn-mini-danger { background: #f8d7da; color: #721c24; }

        .empty-state { color: #888; text-align: center; padding: 1.5rem 1rem; font-size: 0.9rem; }
        .empty-state a { color: #667eea; text-decoration: none; font-weight: 500; }
    </style>
</head>
<body>
    <nav class="navbar">
        <h1>📚 Study Material Hub</h1>
        <div class="nav-links">
            <a href="controller?action=dashboard">Dashboard</a>
            <a href="upload">Upload</a>
            <a href="controller?action=files">Browse</a>
            <a href="controller?action=logout">Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="welcome">
            <div>
                <h2>
                    Welcome, ${sessionScope.user.username}
                    <span class="role-tag">${sessionScope.user.role}</span>
                </h2>
                <p>
                    <c:if test="${not empty sessionScope.user.branch}">${sessionScope.user.branch}</c:if>
                    <c:if test="${sessionScope.user.semester > 0}"> · Sem ${sessionScope.user.semester}</c:if>
                </p>
            </div>
            <div class="actions">
                <a href="upload">📤 Upload material</a>
                <a href="controller?action=files">🔍 Browse all</a>
            </div>
        </div>

        <div class="stats-row">
            <div class="stat-card"><div class="num">${userFiles.size()}</div><div class="label">Your uploads</div></div>
            <div class="stat-card"><div class="num">${totalFiles}</div><div class="label">Total materials</div></div>
            <c:set var="totalDownloads" value="0"/>
            <c:set var="totalUpvotes" value="0"/>
            <c:forEach var="f" items="${userFiles}">
                <c:set var="totalDownloads" value="${totalDownloads + f.downloadCount}"/>
                <c:set var="totalUpvotes" value="${totalUpvotes + f.upvoteCount}"/>
            </c:forEach>
            <div class="stat-card"><div class="num">${totalDownloads}</div><div class="label">Downloads on your files</div></div>
            <div class="stat-card"><div class="num">${totalUpvotes}</div><div class="label">Upvotes received</div></div>
        </div>

        <div class="row">
            <div class="panel">
                <h3>Your uploads <a href="upload">+ upload new</a></h3>
                <c:choose>
                    <c:when test="${empty userFiles}">
                        <div class="empty-state">
                            You haven't shared any material yet.
                            <br><a href="upload">Upload your first one</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="file-list">
                            <c:forEach var="f" items="${userFiles}">
                                <div class="file-item">
                                    <div class="file-info">
                                        <div class="file-name">
                                            ${f.fileName}
                                            <c:if test="${f.verified}"><span class="verified">✓ verified</span></c:if>
                                        </div>
                                        <div class="file-meta">
                                            ${f.materialTypeLabel}
                                            <c:if test="${not empty f.subject}"> · ${f.subject}</c:if>
                                            <c:if test="${not empty f.branch}"> · ${f.branch}</c:if>
                                            <c:if test="${f.semester > 0}"> · Sem ${f.semester}</c:if>
                                            · ⬇ ${f.downloadCount} · ▲ ${f.upvoteCount}
                                        </div>
                                    </div>
                                    <div class="actions">
                                        <a class="btn-mini btn-mini-primary" href="download?id=${f.fileId}">Download</a>
                                        <a class="btn-mini btn-mini-danger" href="controller?action=delete&amp;id=${f.fileId}" onclick="return confirm('Delete this material?')">Delete</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="panel">
                <h3>🔥 Trending now <a href="controller?action=files&amp;sort=upvotes">view all</a></h3>
                <c:choose>
                    <c:when test="${empty trendingFiles}">
                        <div class="empty-state">No materials yet.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="file-list">
                            <c:forEach var="f" items="${trendingFiles}">
                                <div class="file-item">
                                    <div class="file-info">
                                        <div class="file-name">${f.fileName}</div>
                                        <div class="file-meta">
                                            <c:if test="${not empty f.subject}">${f.subject} · </c:if>
                                            ▲ ${f.upvoteCount} · ⬇ ${f.downloadCount}
                                        </div>
                                    </div>
                                    <div class="actions">
                                        <a class="btn-mini btn-mini-primary" href="download?id=${f.fileId}">Download</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>
