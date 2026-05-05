<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Study Material Hub — Upload</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; min-height: 100vh; }

        .navbar { background: white; padding: 1rem 2rem; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); display: flex; justify-content: space-between; align-items: center; }
        .navbar h1 { color: #667eea; font-size: 1.4rem; }
        .nav-links a { color: #333; text-decoration: none; margin-left: 1.25rem; padding: 0.5rem 0.9rem; border-radius: 5px; transition: all 0.3s; font-size: 0.95rem; }
        .nav-links a:hover { background: #667eea; color: white; }

        .container { max-width: 760px; margin: 2rem auto; padding: 0 1rem; }
        .card { background: white; padding: 2rem; border-radius: 10px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05); }
        .card h2 { color: #333; margin-bottom: 0.25rem; }
        .card .subtitle { color: #888; font-size: 0.9rem; margin-bottom: 1.5rem; }

        .form-group { margin-bottom: 1.1rem; }
        .form-row { display: flex; gap: 1rem; }
        .form-row .form-group { flex: 1; }
        label { display: block; margin-bottom: 0.4rem; color: #555; font-weight: 500; font-size: 0.9rem; }
        input, select, textarea {
            width: 100%; padding: 0.7rem; border: 1px solid #ddd;
            border-radius: 6px; font-size: 0.95rem; font-family: inherit;
        }
        textarea { resize: vertical; min-height: 80px; }
        input:focus, select:focus, textarea:focus { outline: none; border-color: #667eea; }
        .help { font-size: 0.8rem; color: #888; margin-top: 0.25rem; }

        .btn { background: #667eea; color: white; padding: 0.75rem 1.5rem; border: none; border-radius: 6px; cursor: pointer; font-size: 1rem; transition: background 0.3s; }
        .btn:hover { background: #5568d3; }
        .btn-secondary { background: #888; margin-left: 0.5rem; text-decoration: none; display: inline-block; }
        .btn-secondary:hover { background: #666; }

        .alert { padding: 0.85rem 1rem; border-radius: 6px; margin-bottom: 1rem; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error   { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .file-info { margin-top: 0.5rem; font-size: 0.9rem; color: #555; }
        .file-info p { margin: 0.2rem 0; }
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
        <div class="card">
            <h2>Upload study material</h2>
            <p class="subtitle">Share notes, previous year papers, lab manuals or syllabus with your peers.</p>

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <strong>${success}</strong>
                    <div class="file-info">
                        <p><strong>File:</strong> ${fileName}</p>
                        <p><strong>Size:</strong> ${fileSize}</p>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>

            <form action="upload" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="file">Choose file</label>
                    <input type="file" name="file" id="file" required>
                    <p class="help">Max size: 100 MB. PDFs, images, docs and zips are all supported.</p>
                </div>

                <div class="form-group">
                    <label for="subject">Subject</label>
                    <input type="text" id="subject" name="subject" placeholder="e.g. Operating Systems" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="branch">Branch</label>
                        <select id="branch" name="branch" required>
                            <option value="">Select</option>
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
                        <select id="semester" name="semester" required>
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
                    <div class="form-group">
                        <label for="materialType">Type</label>
                        <select id="materialType" name="materialType" required>
                            <option value="notes">Notes</option>
                            <option value="pyq">Previous Year Paper</option>
                            <option value="lab">Lab Manual</option>
                            <option value="syllabus">Syllabus</option>
                            <option value="assignment">Assignment</option>
                            <option value="book">Book / Reference</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">Description (optional)</label>
                    <textarea name="description" id="description" placeholder="Briefly describe what this material covers..."></textarea>
                </div>

                <button type="submit" class="btn">Upload</button>
                <a href="controller?action=dashboard" class="btn btn-secondary">Cancel</a>
            </form>
        </div>
    </div>
</body>
</html>
