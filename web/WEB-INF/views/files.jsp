<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Materials - Study Material Hub</title>
    <link rel="stylesheet" href="css/modern-style.css">
    <style>
        .filter-section {
            background: var(--bg-primary);
            border: 1px solid var(--border);
            padding: var(--space-lg);
            border-radius: 12px;
            margin-bottom: var(--space-lg);
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: var(--space-md);
            margin-bottom: var(--space-md);
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: var(--space-sm);
        }

        .filter-group label {
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-secondary);
        }

        .filter-actions {
            display: flex;
            gap: var(--space-sm);
            flex-wrap: wrap;
        }

        .filter-actions button {
            flex: 1;
            min-width: 120px;
        }

        .clear-filters {
            color: var(--text-tertiary);
            font-size: 0.9rem;
            text-align: center;
            margin-top: var(--space-md);
        }

        .results-info {
            color: var(--text-secondary);
            margin-bottom: var(--space-lg);
            font-weight: 500;
        }

        .empty-message {
            text-align: center;
            padding: var(--space-2xl) var(--space-lg);
            background: var(--bg-primary);
            border-radius: 12px;
            border: 1px solid var(--border);
        }

        .empty-message h3 {
            margin-bottom: var(--space-md);
            color: var(--text-primary);
        }

        .pagination-nav {
            display: flex;
            justify-content: center;
            gap: var(--space-sm);
            margin: var(--space-2xl) 0;
            flex-wrap: wrap;
        }

        .pagination-nav a, .pagination-nav .current {
            padding: var(--space-sm) var(--space-md);
            border-radius: 6px;
            text-decoration: none;
            border: 1px solid var(--border);
            transition: all 0.2s ease;
        }

        .pagination-nav a {
            background: var(--bg-primary);
            color: var(--primary);
        }

        .pagination-nav a:hover {
            background: var(--bg-tertiary);
        }

        .pagination-nav .current {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
            font-weight: 600;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <h1>📚 Study Material Hub</h1>
        <div class="nav-links">
            <a href="controller?action=home">Home</a>
            <c:if test="${not empty sessionScope.user}">
                <a href="controller?action=dashboard">Dashboard</a>
                <a href="upload">Upload</a>
            </c:if>
            <a href="controller?action=files">Browse Files</a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}"><a href="controller?action=logout">Logout</a></c:when>
                <c:otherwise><a href="controller?action=login">Login</a></c:otherwise>
            </c:choose>
        </div>
    </nav>

    <div class="container">
        <!-- Search & Filters -->
        <div class="filter-section">
            <h3 style="margin-bottom: var(--space-lg);">🔍 Find Materials</h3>
            <form action="controller" method="get" class="filter-grid">
                <input type="hidden" name="action" value="files">
                
                <div class="filter-group" style="grid-column: span 2;">
                    <label>Search</label>
                    <input type="text" name="q" value="${q}" placeholder="File name, subject...">
                </div>
                
                <div class="filter-group">
                    <label>Branch</label>
                    <select name="branch">
                        <option value="">All Branches</option>
                        <option value="CSE" <c:if test="${branch == 'CSE'}">selected</c:if>>CSE</option>
                        <option value="IT" <c:if test="${branch == 'IT'}">selected</c:if>>IT</option>
                        <option value="ECE" <c:if test="${branch == 'ECE'}">selected</c:if>>ECE</option>
                        <option value="EEE" <c:if test="${branch == 'EEE'}">selected</c:if>>EEE</option>
                        <option value="MECH" <c:if test="${branch == 'MECH'}">selected</c:if>>MECH</option>
                        <option value="CIVIL" <c:if test="${branch == 'CIVIL'}">selected</c:if>>CIVIL</option>
                        <option value="AIDS" <c:if test="${branch == 'AIDS'}">selected</c:if>>AI & DS</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label>Semester</label>
                    <select name="semester">
                        <option value="">All</option>
                        <c:forEach var="i" begin="1" end="8">
                            <option value="${i}" <c:if test="${i == semester}">selected</c:if>>Sem ${i}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label>Type</label>
                    <select name="type">
                        <option value="">All Types</option>
                        <option value="notes" <c:if test="${type == 'notes'}">selected</c:if>>Notes</option>
                        <option value="pyq" <c:if test="${type == 'pyq'}">selected</c:if>>Previous Papers</option>
                        <option value="lab" <c:if test="${type == 'lab'}">selected</c:if>>Lab Manual</option>
                        <option value="syllabus" <c:if test="${type == 'syllabus'}">selected</c:if>>Syllabus</option>
                        <option value="assignment" <c:if test="${type == 'assignment'}">selected</c:if>>Assignment</option>
                        <option value="book" <c:if test="${type == 'book'}">selected</c:if>>Book</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label>Sort By</label>
                    <select name="sort">
                        <option value="">Newest</option>
                        <option value="upvotes" <c:if test="${sort == 'upvotes'}">selected</c:if>>Most Liked</option>
                        <option value="downloads" <c:if test="${sort == 'downloads'}">selected</c:if>>Most Downloaded</option>
                    </select>
                </div>
                
                <div style="display: flex; gap: var(--space-sm); grid-column: span 2;">
                    <button type="submit" class="btn btn-primary">Apply Filters</button>
                    <c:if test="${not empty q or not empty branch or (semester != null and semester > 0) or not empty type or not empty sort}">
                        <a href="controller?action=files" class="btn btn-secondary">Clear</a>
                    </c:if>
                </div>
            </form>
        </div>

        <!-- Results Summary -->
        <div class="results-info">
            <c:choose>
                <c:when test="${totalResults > 0}">
                    📊 Showing <strong>${files.size()}</strong> of <strong>${totalResults}</strong> material<c:if test="${totalResults != 1}">s</c:if>
                </c:when>
                <c:otherwise>
                    No materials found
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Files Grid -->
        <c:choose>
            <c:when test="${empty files}">
                <div class="empty-message">
                    <h3>No materials found</h3>
                    <p>
                        <c:if test="${not empty q or not empty branch or not empty type}">
                            Try adjusting your filters or search terms
                        </c:if>
                        <c:if test="${empty q and empty branch and empty type}">
                            <c:if test="${not empty sessionScope.user}">
                                <a href="upload">Be the first to upload!</a>
                            </c:if>
                            <c:if test="${empty sessionScope.user}">
                                <a href="controller?action=register">Sign up to start sharing</a>
                            </c:if>
                        </c:if>
                    </p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid grid-3">
                    <c:forEach var="f" items="${files}">
                        <div class="file-card">
                            <div class="file-header">
                                <span class="file-name">${f.fileName}</span>
                                <c:if test="${f.verified}"><span class="badge badge-success">✓</span></c:if>
                            </div>

                            <div class="file-meta">
                                <c:if test="${not empty f.subject}">${f.subject}</c:if>
                                <c:if test="${not empty f.subject and (not empty f.branch or f.semester > 0)}"> • </c:if>
                                <c:if test="${not empty f.branch}">${f.branch}</c:if>
                                <c:if test="${f.semester > 0}"> S${f.semester}</c:if>
                            </div>

                            <div class="file-tags">
                                <span class="tag badge-warning">${f.materialTypeLabel}</span>
                                <span class="tag badge-primary" title="File size">${f.formattedFileSize}</span>
                            </div>

                            <c:if test="${not empty f.description}">
                                <p style="font-size: 0.85rem; color: var(--text-secondary); margin: var(--space-sm) 0; line-height: 1.5;">
                                    ${f.description}
                                </p>
                            </c:if>

                            <div style="font-size: 0.8rem; color: var(--text-tertiary); display: flex; justify-content: space-between; margin: var(--space-md) 0;">
                                <span>by ${empty f.uploaderName ? 'unknown' : f.uploaderName}</span>
                                <span>📥 ${f.downloadCount} • 👍 ${f.upvoteCount}</span>
                            </div>

                            <div class="file-actions">
                                <a class="btn btn-sm btn-primary" href="download?id=${f.fileId}">📥 Download</a>
                                <c:if test="${not empty sessionScope.user}">
                                    <a class="btn btn-sm btn-outline" href="controller?action=upvote&amp;id=${f.fileId}&amp;back=controller%3Faction%3Dfiles">👍 Like</a>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination-nav">
                        <c:if test="${currentPage > 1}">
                            <a href="?action=files&amp;page=${currentPage - 1}&amp;q=${q}&amp;branch=${branch}&amp;semester=${semester}&amp;type=${type}&amp;sort=${sort}">← Previous</a>
                        </c:if>
                        <c:forEach var="p" begin="1" end="${totalPages}">
                            <c:choose>
                                <c:when test="${p == currentPage}"><span class="current">${p}</span></c:when>
                                <c:otherwise><a href="?action=files&amp;page=${p}&amp;q=${q}&amp;branch=${branch}&amp;semester=${semester}&amp;type=${type}&amp;sort=${sort}">${p}</a></c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <a href="?action=files&amp;page=${currentPage + 1}&amp;q=${q}&amp;branch=${branch}&amp;semester=${semester}&amp;type=${type}&amp;sort=${sort}">Next →</a>
                        </c:if>
                    </div>
                </c:if>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
