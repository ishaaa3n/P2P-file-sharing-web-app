<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Study Material Hub — Upload</title>
    <link rel="stylesheet" href="css/modern-style.css">
    <style>
        .upload-header {
            background:
                radial-gradient(800px 300px at 100% 0%, rgba(236, 72, 153, 0.18), transparent 60%),
                linear-gradient(135deg, #18182a 0%, #1e1e3a 100%);
            color: white;
            padding: var(--space-2xl) var(--space-lg);
            margin-bottom: var(--space-xl);
            border-radius: var(--radius-xl);
            position: relative;
            overflow: hidden;
        }

        .upload-header h1 {
            font-size: 1.75rem;
            margin-bottom: 0.4rem;
            color: white;
            letter-spacing: -0.03em;
        }

        .upload-header p {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.95rem;
        }

        .upload-form {
            background: var(--bg-primary);
            padding: var(--space-xl);
            border-radius: var(--radius-lg);
            border: 1px solid var(--border);
            max-width: 800px;
            margin: 0 auto;
        }

        .form-actions {
            display: flex;
            gap: var(--space-md);
            margin-top: var(--space-xl);
        }
        .form-actions .btn { flex: 1; }

        .file-preview {
            background: var(--bg-tertiary);
            padding: var(--space-md);
            border-radius: var(--radius-sm);
            margin-top: var(--space-sm);
            font-size: 0.85rem;
            color: var(--text-secondary);
            border-left: 3px solid var(--success);
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

    <div class="container-md">
        <div class="upload-header">
            <h1>Share Study Material</h1>
            <p>Upload notes, previous papers, lab manuals or other resources for your peers</p>
        </div>


        <c:if test="${not empty success}">
            <div class="alert alert-success">
                ✓ <strong>${success}</strong>
                <div class="file-preview">
                    <p><strong>File:</strong> ${fileName}</p>
                    <p><strong>Size:</strong> ${fileSize}</p>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error">⚠️ ${error}</div>
        </c:if>

        <div class="upload-form">
            <form action="upload" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="file">📎 Choose File</label>
                    <input type="file" name="file" id="file" required>
                    <p class="form-help">Max size: 100 MB. Supports PDF, images, documents, and archives</p>
                </div>

                <div class="form-group">
                    <label for="subject">📖 Subject Name</label>
                    <input type="text" id="subject" name="subject" placeholder="e.g., Operating Systems, Data Structures" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="branch">🏢 Branch</label>
                        <select id="branch" name="branch" required>
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
                        <label for="semester">📚 Semester</label>
                        <select id="semester" name="semester" required>
                            <option value="1">1st Semester</option>
                            <option value="2">2nd Semester</option>
                            <option value="3">3rd Semester</option>
                            <option value="4">4th Semester</option>
                            <option value="5">5th Semester</option>
                            <option value="6">6th Semester</option>
                            <option value="7">7th Semester</option>
                            <option value="8">8th Semester</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="materialType">🏷️ Material Type</label>
                        <select id="materialType" name="materialType" required>
                            <option value="notes">Class Notes</option>
                            <option value="pyq">Previous Year Paper</option>
                            <option value="lab">Lab Manual</option>
                            <option value="syllabus">Syllabus</option>
                            <option value="assignment">Assignment</option>
                            <option value="book">Book / Reference</option>
                            <option value="other">Other</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">📝 Description (Optional)</label>
                    <textarea name="description" id="description" placeholder="Describe what this material covers, any important notes, etc."></textarea>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary btn-lg">📤 Upload Material</button>
                    <a href="controller?action=dashboard" class="btn btn-secondary btn-lg">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
