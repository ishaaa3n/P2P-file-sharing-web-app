<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Study Material Hub — Browse</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; min-height: 100vh; color: #2d2d2d; }

        .navbar { background: white; padding: 1rem 2rem; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08); display: flex; justify-content: space-between; align-items: center; }
        .navbar h1 { color: #667eea; font-size: 1.4rem; }
        .nav-links a { color: #333; text-decoration: none; margin-left: 1rem; padding: 0.5rem 0.85rem; border-radius: 5px; transition: all 0.3s; font-size: 0.95rem; }
        .nav-links a:hover { background: #667eea; color: white; }

        .container { max-width: 1200px; margin: 1.5rem auto; padding: 0 1rem; }

        .filter-card {
            background: white; padding: 1.25rem 1.5rem; border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05); margin-bottom: 1.5rem;
        }
        .filter-card h3 { font-size: 1rem; color: #555; margin-bottom: 0.85rem; }
        .filter-grid {
            display: grid; grid-template-columns: 2fr 1fr 1fr 1fr 1fr 1fr auto;
            gap: 0.6rem; align-items: end;
        }
        .filter-grid label { display: block; font-size: 0.75rem; color: #888; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 0.25rem; }
        .filter-grid input, .filter-grid select {
            width: 100%; padding: 0.55rem; border: 1px solid #ddd; border-radius: 6px;
            font-size: 0.9rem; font-family: inherit; background: white;
        }
        .filter-grid button {
            background: #667eea; color: white; padding: 0.6rem 1.1rem;
            border: none; border-radius: 6px; cursor: pointer; font-size: 0.9rem; height: 38px;
        }
        .filter-grid button:hover { background: #5568d3; }
        .filter-clear { color: #888; font-size: 0.85rem; text-decoration: none; }
        .filter-clear:hover { color: #333; text-decoration: underline; }

        .results-summary { color: #666; font-size: 0.9rem; margin-bottom: 1rem; }

        .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 1rem; }
        .file-card {
            background: white; padding: 1.1rem; border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            display: flex; flex-direction: column; gap: 0.6rem;
            transition: transform 0.15s, box-shadow 0.15s;
        }
        .file-card:hover { transform: translateY(-2px); box-shadow: 0 4px 18px rgba(0, 0, 0, 0.08); }

        .file-header { display: flex; justify-content: space-between; align-items: flex-start; gap: 0.5rem; }
        .file-name { font-size: 1rem; font-weight: 600; color: #2d2d2d; word-break: break-word; line-height: 1.3; }
        .verified-badge {
            background: #d4edda; color: #155724; padding: 0.15rem 0.5rem;
            border-radius: 4px; font-size: 0.7rem; font-weight: 600; flex-shrink: 0;
        }

        .meta { display: flex; flex-wrap: wrap; gap: 0.35rem; }
        .tag {
            background: #eef0fa; color: #5568d3; padding: 0.15rem 0.55rem;
            border-radius: 12px; font-size: 0.75rem; font-weight: 500;
        }
        .tag-type { background: #fff3cd; color: #856404; }
        .tag-branch { background: #d1ecf1; color: #0c5460; }

        .desc { color: #777; font-size: 0.85rem; line-height: 1.4; min-height: 1.2em; }

        .file-footer {
            display: flex; justify-content: space-between; align-items: center;
            margin-top: auto; padding-top: 0.6rem; border-top: 1px solid #f0f0f0;
            font-size: 0.8rem; color: #888;
        }
        .uploader { font-style: italic; }
        .stats { display: flex; gap: 0.75rem; }

        .actions { display: flex; gap: 0.4rem; flex-wrap: wrap; }
        .btn-sm {
            padding: 0.4rem 0.75rem; border: none; border-radius: 5px;
            font-size: 0.8rem; cursor: pointer; text-decoration: none;
            display: inline-flex; align-items: center; gap: 0.25rem;
        }
        .btn-download { background: #667eea; color: white; }
        .btn-download:hover { background: #5568d3; }
        .btn-upvote { background: #f5f5f5; color: #555; border: 1px solid #e0e0e0; }
        .btn-upvote:hover { background: #ffe5e5; color: #c82333; border-color: #c82333; }
        .btn-verify { background: #d4edda; color: #155724; }
        .btn-verify:hover { background: #c3e6cb; }

        .empty {
            text-align: center; padding: 3rem 1rem; color: #888;
            background: white; border-radius: 10px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        .empty h3 { color: #555; margin-bottom: 0.5rem; }

        .pagination { display: flex; justify-content: center; gap: 0.4rem; margin-top: 1.5rem; flex-wrap: wrap; }
        .pagination a, .pagination .current {
            padding: 0.5rem 0.85rem; border-radius: 5px; text-decoration: none;
            background: white; color: #667eea; box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
        }
        .pagination .current { background: #667eea; color: white; }
        .pagination a:hover { background: #eef0fa; }

        @media (max-width: 900px) { .filter-grid { grid-template-columns: 1fr 1fr; } }
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
            <a href="controller?action=files">Browse</a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}"><a href="controller?action=logout">Logout</a></c:when>
                <c:otherwise><a href="controller?action=login">Login</a></c:otherwise>
            </c:choose>
        </div>
    </nav>

    <div class="container">
        <div class="filter-card">
            <h3>Find materials</h3>
            <form action="controller" method="get" class="filter-grid">
                <input type="hidden" name="action" value="files">
                <div>
                    <label>Search</label>
                    <input type="text" name="q" value="${q}" placeholder="Name, subject or description...">
                </div>
                <div>
                    <label>Branch</label>
                    <select name="branch">
                        <option value="">All</option>
                        <option value="CSE"   <c:if test="${branch == 'CSE'}">selected</c:if>>CSE</option>
                        <option value="IT"    <c:if test="${branch == 'IT'}">selected</c:if>>IT</option>
                        <option value="ECE"   <c:if test="${branch == 'ECE'}">selected</c:if>>ECE</option>
                        <option value="EEE"   <c:if test="${branch == 'EEE'}">selected</c:if>>EEE</option>
                        <option value="MECH"  <c:if test="${branch == 'MECH'}">selected</c:if>>MECH</option>
                        <option value="CIVIL" <c:if test="${branch == 'CIVIL'}">selected</c:if>>CIVIL</option>
                        <option value="AIDS"  <c:if test="${branch == 'AIDS'}">selected</c:if>>AI &amp; DS</option>
                        <option value="OTHER" <c:if test="${branch == 'OTHER'}">selected</c:if>>Other</option>
                    </select>
                </div>
                <div>
                    <label>Semester</label>
                    <select name="semester">
                        <option value="">All</option>
                        <c:forEach var="i" begin="1" end="8">
                            <option value="${i}" <c:if test="${i == semester}">selected</c:if>>Sem ${i}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label>Subject</label>
                    <input type="text" name="subject" value="${subject}" placeholder="e.g. OS">
                </div>
                <div>
                    <label>Type</label>
                    <select name="type">
                        <option value="">All</option>
                        <option value="notes"      <c:if test="${type == 'notes'}">selected</c:if>>Notes</option>
                        <option value="pyq"        <c:if test="${type == 'pyq'}">selected</c:if>>PYQ</option>
                        <option value="lab"        <c:if test="${type == 'lab'}">selected</c:if>>Lab</option>
                        <option value="syllabus"   <c:if test="${type == 'syllabus'}">selected</c:if>>Syllabus</option>
                        <option value="assignment" <c:if test="${type == 'assignment'}">selected</c:if>>Assignment</option>
                        <option value="book"       <c:if test="${type == 'book'}">selected</c:if>>Book</option>
                    </select>
                </div>
                <div>
                    <label>Sort</label>
                    <select name="sort">
                        <option value="">Newest</option>
                        <option value="upvotes"   <c:if test="${sort == 'upvotes'}">selected</c:if>>Most upvoted</option>
                        <option value="downloads" <c:if test="${sort == 'downloads'}">selected</c:if>>Most downloaded</option>
                    </select>
                </div>
                <div>
                    <button type="submit">Apply</button>
                </div>
            </form>
            <c:if test="${not empty q or not empty branch or (semester != null and semester > 0) or not empty subject or not empty type or not empty sort}">
                <div style="margin-top: 0.6rem;"><a href="controller?action=files" class="filter-clear">× clear filters</a></div>
            </c:if>
        </div>

        <div class="results-summary">
            <c:choose>
                <c:when test="${totalResults > 0}">Showing ${files.size()} of <strong>${totalResults}</strong> material<c:if test="${totalResults != 1}">s</c:if></c:when>
                <c:otherwise>No materials found</c:otherwise>
            </c:choose>
        </div>

        <c:choose>
            <c:when test="${empty files}">
                <div class="empty">
                    <h3>Nothing here yet</h3>
                    <p>Try adjusting your filters, or
                        <c:if test="${not empty sessionScope.user}"><a href="upload">upload the first material</a>.</c:if>
                        <c:if test="${empty sessionScope.user}"><a href="controller?action=register">sign up to share materials</a>.</c:if>
                    </p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid">
                    <c:forEach var="f" items="${files}">
                        <div class="file-card">
                            <div class="file-header">
                                <div class="file-name">${f.fileName}</div>
                                <c:if test="${f.verified}"><span class="verified-badge">✓ verified</span></c:if>
                            </div>

                            <div class="meta">
                                <c:if test="${not empty f.subject}"><span class="tag">${f.subject}</span></c:if>
                                <c:if test="${not empty f.branch}"><span class="tag tag-branch">${f.branch}</span></c:if>
                                <c:if test="${f.semester > 0}"><span class="tag tag-branch">Sem ${f.semester}</span></c:if>
                                <span class="tag tag-type">${f.materialTypeLabel}</span>
                            </div>

                            <c:if test="${not empty f.description}"><div class="desc">${f.description}</div></c:if>

                            <div class="file-footer">
                                <div class="uploader">by ${empty f.uploaderName ? 'unknown' : f.uploaderName}</div>
                                <div class="stats">
                                    <span title="Size">${f.formattedFileSize}</span>
                                    <span title="Downloads">⬇ ${f.downloadCount}</span>
                                    <span title="Upvotes">▲ ${f.upvoteCount}</span>
                                </div>
                            </div>

                            <div class="actions">
                                <a class="btn-sm btn-download" href="download?id=${f.fileId}">Download</a>
                                <c:if test="${not empty sessionScope.user}">
                                    <a class="btn-sm btn-upvote" href="controller?action=upvote&amp;id=${f.fileId}&amp;back=controller%3Faction%3Dfiles">▲ Upvote</a>
                                    <c:if test="${sessionScope.isFaculty}">
                                        <a class="btn-sm btn-verify" href="controller?action=verify&amp;id=${f.fileId}&amp;set=${!f.verified}&amp;back=controller%3Faction%3Dfiles">
                                            <c:choose>
                                                <c:when test="${f.verified}">Unverify</c:when>
                                                <c:otherwise>✓ Verify</c:otherwise>
                                            </c:choose>
                                        </a>
                                    </c:if>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <c:if test="${currentPage > 1}">
                            <a href="?action=files&amp;page=${currentPage - 1}&amp;q=${q}&amp;branch=${branch}&amp;semester=${semester}&amp;subject=${subject}&amp;type=${type}&amp;sort=${sort}">‹ Prev</a>
                        </c:if>
                        <c:forEach var="p" begin="1" end="${totalPages}">
                            <c:choose>
                                <c:when test="${p == currentPage}"><span class="current">${p}</span></c:when>
                                <c:otherwise><a href="?action=files&amp;page=${p}&amp;q=${q}&amp;branch=${branch}&amp;semester=${semester}&amp;subject=${subject}&amp;type=${type}&amp;sort=${sort}">${p}</a></c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <a href="?action=files&amp;page=${currentPage + 1}&amp;q=${q}&amp;branch=${branch}&amp;semester=${semester}&amp;subject=${subject}&amp;type=${type}&amp;sort=${sort}">Next ›</a>
                        </c:if>
                    </div>
                </c:if>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
