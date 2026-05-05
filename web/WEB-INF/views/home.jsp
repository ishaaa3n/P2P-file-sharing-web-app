<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>College Study Material Hub</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; min-height: 100vh; color: #2d2d2d; }

        .navbar { background: white; padding: 1rem 2rem; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08); display: flex; justify-content: space-between; align-items: center; }
        .navbar h1 { color: #667eea; font-size: 1.4rem; }
        .nav-links a { color: #333; text-decoration: none; margin-left: 1rem; padding: 0.5rem 0.85rem; border-radius: 5px; transition: all 0.3s; font-size: 0.95rem; }
        .nav-links a:hover { background: #667eea; color: white; }
        .nav-cta { background: #667eea; color: white !important; }

        .hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; padding: 4rem 2rem; text-align: center;
        }
        .hero h2 { font-size: 2.5rem; margin-bottom: 1rem; }
        .hero p { font-size: 1.1rem; opacity: 0.95; max-width: 640px; margin: 0 auto 1.75rem; }
        .hero .cta a {
            background: white; color: #667eea; padding: 0.85rem 1.75rem;
            border-radius: 8px; text-decoration: none; font-weight: 600;
            margin: 0 0.4rem; display: inline-block; transition: transform 0.15s;
        }
        .hero .cta a:hover { transform: translateY(-2px); }
        .hero .cta a.outline { background: transparent; color: white; border: 2px solid white; }

        .container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; }

        .stats {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 1rem; margin-bottom: 2rem;
        }
        .stat-card {
            background: white; padding: 1.5rem; border-radius: 10px; text-align: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        .stat-card .num { font-size: 2.2rem; font-weight: 700; color: #667eea; }
        .stat-card .label { color: #888; margin-top: 0.3rem; }

        .features { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 1rem; margin-bottom: 2rem; }
        .feature {
            background: white; padding: 1.5rem; border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        .feature .icon { font-size: 2rem; margin-bottom: 0.5rem; }
        .feature h4 { color: #333; margin-bottom: 0.4rem; }
        .feature p { color: #666; font-size: 0.9rem; line-height: 1.5; }

        .section-title { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; }
        .section-title h3 { color: #444; font-size: 1.25rem; }
        .section-title a { color: #667eea; text-decoration: none; font-size: 0.9rem; }

        .file-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 1rem; margin-bottom: 2.5rem; }
        .file-card {
            background: white; padding: 1.1rem; border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        .file-card .name { font-weight: 600; word-break: break-word; margin-bottom: 0.4rem; }
        .file-card .meta { color: #888; font-size: 0.8rem; margin-bottom: 0.6rem; }
        .file-card .tag { background: #eef0fa; color: #5568d3; padding: 0.1rem 0.5rem; border-radius: 12px; font-size: 0.7rem; margin-right: 0.25rem; }
        .file-card .actions { display: flex; gap: 0.4rem; margin-top: 0.5rem; }
        .btn-mini { padding: 0.4rem 0.75rem; border-radius: 5px; text-decoration: none; font-size: 0.8rem; background: #667eea; color: white; }
    </style>
</head>
<body>
    <nav class="navbar">
        <h1>📚 Study Material Hub</h1>
        <div class="nav-links">
            <a href="controller?action=home">Home</a>
            <a href="controller?action=files">Browse</a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="controller?action=dashboard">Dashboard</a>
                    <a href="upload">Upload</a>
                    <a href="controller?action=logout">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="controller?action=login">Login</a>
                    <a href="controller?action=register" class="nav-cta">Register</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <section class="hero">
        <h2>Your College Study Material, Organized</h2>
        <p>Find notes, previous year papers, lab manuals and syllabus shared by your peers and faculty — filterable by branch, semester, and subject.</p>
        <div class="cta">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="controller?action=files">Browse Materials</a>
                    <a href="upload" class="outline">Upload Yours</a>
                </c:when>
                <c:otherwise>
                    <a href="controller?action=register">Get Started</a>
                    <a href="controller?action=files" class="outline">Browse Without Account</a>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <div class="container">
        <div class="stats">
            <div class="stat-card"><div class="num">${totalFiles}</div><div class="label">Materials shared</div></div>
            <div class="stat-card"><div class="num">📚</div><div class="label">Notes · PYQs · Labs</div></div>
            <div class="stat-card"><div class="num">8</div><div class="label">Semesters covered</div></div>
            <div class="stat-card"><div class="num">⭐</div><div class="label">Faculty verified content</div></div>
        </div>

        <div class="features">
            <div class="feature"><div class="icon">🔍</div><h4>Smart filters</h4><p>Filter by branch, semester, subject, and material type. Find exactly what you need in seconds.</p></div>
            <div class="feature"><div class="icon">▲</div><h4>Upvote helpful materials</h4><p>The most useful notes float to the top. Vote for what helped you so others can find it too.</p></div>
            <div class="feature"><div class="icon">✓</div><h4>Faculty verified</h4><p>Materials reviewed by faculty get a verified badge — so you know what's reliable.</p></div>
            <div class="feature"><div class="icon">📤</div><h4>Share what you've got</h4><p>Got great notes? Upload them in one click. Help your juniors and earn upvotes.</p></div>
        </div>

        <c:if test="${not empty trendingFiles}">
            <div class="section-title"><h3>🔥 Trending materials</h3><a href="controller?action=files&amp;sort=upvotes">view all →</a></div>
            <div class="file-grid">
                <c:forEach var="f" items="${trendingFiles}">
                    <div class="file-card">
                        <div class="name">${f.fileName}</div>
                        <div class="meta">
                            <c:if test="${not empty f.subject}">${f.subject} · </c:if>
                            ▲ ${f.upvoteCount} · ⬇ ${f.downloadCount}
                        </div>
                        <div>
                            <c:if test="${not empty f.branch}"><span class="tag">${f.branch}</span></c:if>
                            <c:if test="${f.semester > 0}"><span class="tag">Sem ${f.semester}</span></c:if>
                            <span class="tag">${f.materialTypeLabel}</span>
                        </div>
                        <div class="actions">
                            <a class="btn-mini" href="download?id=${f.fileId}">Download</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${not empty recentFiles}">
            <div class="section-title"><h3>🆕 Recently added</h3><a href="controller?action=files">view all →</a></div>
            <div class="file-grid">
                <c:forEach var="f" items="${recentFiles}">
                    <div class="file-card">
                        <div class="name">${f.fileName}</div>
                        <div class="meta">
                            <c:if test="${not empty f.subject}">${f.subject} · </c:if>
                            ${f.formattedFileSize}
                        </div>
                        <div>
                            <c:if test="${not empty f.branch}"><span class="tag">${f.branch}</span></c:if>
                            <c:if test="${f.semester > 0}"><span class="tag">Sem ${f.semester}</span></c:if>
                            <span class="tag">${f.materialTypeLabel}</span>
                        </div>
                        <div class="actions">
                            <a class="btn-mini" href="download?id=${f.fileId}">Download</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
</body>
</html>
