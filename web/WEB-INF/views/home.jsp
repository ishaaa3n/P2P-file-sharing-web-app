<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Study Material Hub - Find & Share College Notes</title>
    <link rel="stylesheet" href="css/modern-style.css">
    <style>
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: var(--space-lg);
            margin: var(--space-2xl) 0;
        }

        .feature {
            text-align: center;
            padding: var(--space-lg);
        }

        .feature-icon {
            font-size: 3rem;
            margin-bottom: var(--space-md);
        }

        .feature h4 {
            color: var(--text-primary);
            margin-bottom: var(--space-sm);
        }

        .feature p {
            color: var(--text-secondary);
            font-size: 0.9rem;
            line-height: 1.6;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: var(--space-2xl) 0 var(--space-lg);
        }

        .section-header h3 {
            font-size: 1.5rem;
        }

        .section-header a {
            font-weight: 600;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <h1>📚 Study Material Hub</h1>
        <div class="nav-links">
            <a href="controller?action=home">Home</a>
            <a href="controller?action=files">Browse Files</a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="controller?action=dashboard">Dashboard</a>
                    <a href="upload">Upload</a>
                    <a href="controller?action=logout">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="controller?action=login">Login</a>
                    <a href="controller?action=register" class="cta">Register</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <section class="hero">
        <h2>Your College Study Materials, Organized</h2>
        <p>Discover notes, previous year exams, lab manuals, and syllabi shared by your peers and faculty — searchable by branch, semester, and subject.</p>
        <div class="cta">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="controller?action=files" class="btn btn-lg">Browse Materials</a>
                    <a href="upload" class="btn btn-lg btn-outline">Share Your Notes</a>
                </c:when>
                <c:otherwise>
                    <a href="controller?action=register" class="btn btn-lg">Get Started Free</a>
                    <a href="controller?action=files" class="btn btn-lg btn-outline">Browse Files</a>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <div class="container">
        <!-- Stats Section -->
        <div class="grid grid-4" style="margin: var(--space-2xl) 0;">
            <div class="stat-card">
                <div class="stat-number">${totalFiles > 0 ? totalFiles : '100+'}</div>
                <div class="stat-label">Materials Shared</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">📚</div>
                <div class="stat-label">Notes, PYQs & More</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">8</div>
                <div class="stat-label">Semesters Covered</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">⭐</div>
                <div class="stat-label">Verified Content</div>
            </div>
        </div>

        <!-- Features Section -->
        <div class="features">
            <div class="feature">
                <div class="feature-icon">🔍</div>
                <h4>Smart Search & Filters</h4>
                <p>Filter by branch, semester, subject, and type. Find exactly what you need instantly.</p>
            </div>
            <div class="feature">
                <div class="feature-icon">👍</div>
                <h4>Community Rated</h4>
                <p>See ratings and reviews from other students. Know which materials are most helpful.</p>
            </div>
            <div class="feature">
                <div class="feature-icon">✓</div>
                <h4>Faculty Verified</h4>
                <p>Content reviewed by faculty gets a verified badge for added reliability.</p>
            </div>
            <div class="feature">
                <div class="feature-icon">📤</div>
                <h4>Easy to Share</h4>
                <p>Upload your notes with just a few clicks and help your entire college community.</p>
            </div>
        </div>

        <!-- Trending Materials -->
        <c:if test="${not empty trendingFiles}">
            <div class="section-header">
                <h3>🔥 Trending Materials</h3>
                <a href="controller?action=files&amp;sort=upvotes">View All →</a>
            </div>
            <div class="grid grid-3">
                <c:forEach var="f" items="${trendingFiles}">
                    <div class="file-card">
                        <div class="file-header">
                            <div class="file-name">${f.fileName}</div>
                        </div>
                        <div class="file-meta">
                            <c:if test="${not empty f.subject}">${f.subject}</c:if>
                            <c:if test="${not empty f.subject and not empty f.uploaderName}"> • </c:if>
                            <c:if test="${not empty f.uploaderName}">by ${f.uploaderName}</c:if>
                        </div>
                        <div class="file-tags">
                            <c:if test="${not empty f.branch}"><span class="tag badge-primary">${f.branch}</span></c:if>
                            <c:if test="${f.semester > 0}"><span class="tag badge-primary">Sem ${f.semester}</span></c:if>
                            <span class="tag badge-warning">${f.materialTypeLabel}</span>
                        </div>
                        <div class="file-actions" style="margin-top: auto;">
                            <a class="btn btn-sm btn-primary" href="download?id=${f.fileId}">📥 Download</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <!-- Recently Added -->
        <c:if test="${not empty recentFiles}">
            <div class="section-header" style="margin-top: var(--space-2xl);">
                <h3>🆕 Recently Added</h3>
                <a href="controller?action=files">View All →</a>
            </div>
            <div class="grid grid-3">
                <c:forEach var="f" items="${recentFiles}">
                    <div class="file-card">
                        <div class="file-header">
                            <div class="file-name">${f.fileName}</div>
                        </div>
                        <div class="file-meta">
                            <c:if test="${not empty f.subject}">${f.subject}</c:if>
                            <c:if test="${not empty f.subject && f.formattedFileSize ne null}"> • </c:if>
                            <c:if test="${f.formattedFileSize ne null}">${f.formattedFileSize}</c:if>
                        </div>
                        <div class="file-tags">
                            <c:if test="${not empty f.branch}"><span class="tag badge-primary">${f.branch}</span></c:if>
                            <c:if test="${f.semester > 0}"><span class="tag badge-primary">Sem ${f.semester}</span></c:if>
                            <span class="tag badge-warning">${f.materialTypeLabel}</span>
                        </div>
                        <div class="file-actions" style="margin-top: auto;">
                            <a class="btn btn-sm btn-primary" href="download?id=${f.fileId}">📥 Download</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
</body>
</html>
