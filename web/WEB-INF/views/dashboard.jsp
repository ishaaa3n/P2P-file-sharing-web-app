<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Study Material Hub</title>
    <link rel="stylesheet" href="css/modern-style.css">
    <style>
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: var(--space-lg);
            margin-bottom: var(--space-xl);
        }

        .dashboard-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: var(--space-lg);
        }

        @media (max-width: 1000px) {
            .dashboard-row { grid-template-columns: 1fr; }
        }
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
        <div class="dashboard-welcome">
            <div>
                <h2>
                    👋 Welcome, ${sessionScope.user.username}
                    <span class="role-tag">${sessionScope.user.role}</span>
                </h2>
                <p style="margin: var(--space-sm) 0 0;">
                    <c:if test="${not empty sessionScope.user.branch}">${sessionScope.user.branch}</c:if>
                    <c:if test="${sessionScope.user.semester > 0}"> • Sem ${sessionScope.user.semester}</c:if>
                </p>
            </div>
            <div class="dashboard-actions">
                <a href="upload">📤 Upload Material</a>
                <a href="controller?action=files">🔍 Browse Files</a>
            </div>
        </div>

        <!-- Stats -->
        <div class="dashboard-grid">
            <div class="stat-card">
                <div class="stat-number">${userFiles.size()}</div>
                <div class="stat-label">Your Uploads</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${totalFiles}</div>
                <div class="stat-label">Total Materials</div>
            </div>
            <c:set var="totalDownloads" value="0"/>
            <c:set var="totalUpvotes" value="0"/>
            <c:forEach var="f" items="${userFiles}">
                <c:set var="totalDownloads" value="${totalDownloads + f.downloadCount}"/>
                <c:set var="totalUpvotes" value="${totalUpvotes + f.upvoteCount}"/>
            </c:forEach>
            <div class="stat-card">
                <div class="stat-number">${totalDownloads}</div>
                <div class="stat-label">Downloads</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${totalUpvotes}</div>
                <div class="stat-label">Upvotes</div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="dashboard-row">
            <div class="card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-lg);">
                    <h3>📤 Your Uploads</h3>
                    <a href="upload" class="btn btn-sm btn-primary">+ Upload</a>
                </div>

                <c:choose>
                    <c:when test="${empty userFiles}">
                        <div class="empty-state">
                            <p>No materials shared yet</p>
                            <a href="upload" class="btn btn-primary" style="margin-top: var(--space-md);">Upload Your First Material</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="list">
                            <c:forEach var="f" items="${userFiles}">
                                <div class="file-item">
                                    <div class="file-details">
                                        <div class="file-title">
                                            ${f.fileName}
                                            <c:if test="${f.verified}"><span class="badge badge-success">✓ Verified</span></c:if>
                                        </div>
                                        <div class="file-stats">
                                            <span>${f.materialTypeLabel}</span>
                                            <c:if test="${not empty f.subject}"><span>${f.subject}</span></c:if>
                                            <span>📥 ${f.downloadCount}</span>
                                            <span>👍 ${f.upvoteCount}</span>
                                        </div>
                                    </div>
                                    <div class="file-actions">
                                        <a class="btn btn-sm btn-primary" href="download?id=${f.fileId}">Download</a>
                                        <a class="btn btn-sm btn-danger" href="controller?action=delete&amp;id=${f.fileId}" onclick="return confirm('Delete this material?')">Delete</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="card">
                <h3>🔥 Trending Materials</h3>
                <c:choose>
                    <c:when test="${empty trendingFiles}">
                        <div class="empty-state">
                            <p>No materials yet</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="list">
                            <c:forEach var="f" items="${trendingFiles}" varStatus="loop">
                                <c:if test="${loop.count <= 5}">
                                    <div class="file-item" style="border-left-color: var(--accent);">
                                        <div class="file-details">
                                            <div class="file-title">${f.fileName}</div>
                                            <div class="file-stats">
                                                <span>${f.materialTypeLabel}</span>
                                                <span>👍 ${f.upvoteCount}</span>
                                                <span>📥 ${f.downloadCount}</span>
                                            </div>
                                        </div>
                                        <a class="btn btn-sm btn-primary" href="download?id=${f.fileId}">Get</a>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                        <a href="controller?action=files&amp;sort=upvotes" style="display: block; text-align: center; margin-top: var(--space-lg); font-weight: 600;">View All →</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>
