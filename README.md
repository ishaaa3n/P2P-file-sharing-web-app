# College Study Material Hub

A web application where students and faculty share study materials — notes, previous year papers, lab manuals, syllabi, assignments, and reference books — organized by **branch**, **semester**, **subject**, and **material type**.

Built with **Java Servlets, JSP, JDBC, and an embedded H2 database** following the **MVC architecture**.

---

## Features

### Authentication & Roles
- User registration with role selection (**Student** or **Faculty**)
- Profile fields for **Branch** (CSE, IT, ECE, EEE, MECH, CIVIL, AI&DS, Other) and **Semester** (1–8)
- Session-based login / logout
- Default seeded users for quick demo:
  - `admin` / `admin123` (Faculty)
  - `student1` / `student123` (Student, CSE Sem 5)

### Material Management
- Upload files up to **100 MB** (multipart upload)
- Capture metadata on upload: **subject, branch, semester, material type, description**
- Material types: **Notes, Previous Year Paper (PYQ), Lab Manual, Syllabus, Assignment, Book / Reference**
- File details persisted: original name, size, MIME type, MD5 hash, upload date, uploader, download count, upvote count

### Browse & Search
- Full-text search across **file name**, **subject**, and **description**
- Filter by **branch**, **semester**, **subject** (substring match), and **material type**
- Sort by: **Newest**, **Most upvoted**, **Most downloaded**
- Pagination (12 items per page)
- Combined-criteria search (any filter is optional and composes with others)

### Engagement
- **Upvote system** — each user can upvote a material once (toggleable). Upvote count is denormalized on the material row for fast sorting.
- **Faculty verification** — faculty users can mark materials as "verified" and unverify. Verified materials show a green badge.
- **Owner / faculty deletion** — uploaders can delete their own materials; faculty can delete any material.

### Dashboard
- Personalized welcome with role and branch / semester
- Personal stats: **Your Uploads**, **Total Materials**, **Downloads on your files**, **Upvotes received**
- List of your uploads with quick download / delete actions
- Sidebar showing **Trending materials** (weighted by upvotes + downloads)

### Public Home
- Hero section with featured CTAs (different for logged-in vs visitor)
- Aggregate stats across the platform
- **Trending Materials** carousel (top 6 by score)
- **Recently Added** carousel (latest 6 uploads)

### UI / UX
- Modern responsive design system (custom CSS)
- **Inter** + **Plus Jakarta Sans** typography
- Sticky glass-blur navbar
- Refined card components, soft multi-layer shadows, smooth `cubic-bezier` transitions
- Tasteful dark-gradient hero with subtle noise texture and pink/indigo glow
- Mobile-friendly layout with grid breakpoints

### Robustness
- Custom error page (404 / 500) styled to match the rest of the app
- Auto-creates the database schema on first startup via a `ServletContextListener`
- Schema migrations are idempotent (`CREATE / ALTER ... IF NOT EXISTS`)
- Foreign-key cascades — deleting a user removes their materials and ratings cleanly
- DB connection guarded by a singleton with auto-reconnect

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | JSP + JSTL, HTML5, CSS3 (custom design system) |
| **Backend** | Java 17, Servlet 4.0 (`javax.servlet`) |
| **Data Access** | JDBC, DAO pattern |
| **Database** | H2 embedded (single file, ~2.5 MB jar — no separate install) |
| **Web Server** | Apache Tomcat 9 |
| **Architecture** | MVC + Front Controller |

### Why H2 instead of MySQL
The project ships with an embedded H2 database. The DB is a single file at `~/.p2p_data/p2p_db.mv.db` and is created automatically on first startup. **No MySQL install or configuration required.** H2 runs in MySQL compatibility mode, so all SQL written in DAOs is portable to MySQL if you need it later.

---

## Project Structure

```
P2P-File-Sharing-Web/
├── src/com/p2p/
│   ├── controller/
│   │   ├── MainControllerServlet.java   # Front controller (home/login/register/dashboard/files/upvote/verify/delete)
│   │   ├── FileUploadServlet.java       # Multipart upload handling
│   │   ├── FileDownloadServlet.java     # File streaming + download counting
│   │   └── PeerServlet.java             # Legacy (kept for back-compat)
│   ├── model/
│   │   ├── User.java                    # role / branch / semester
│   │   ├── SharedFile.java              # subject / branch / semester / materialType / upvote
│   │   └── Peer.java                    # Legacy
│   ├── dao/
│   │   ├── UserDAO.java
│   │   ├── FileDAO.java                 # search, filters, upvote, verify, trending
│   │   └── PeerDAO.java                 # Legacy
│   └── util/
│       ├── DBConnection.java            # Singleton JDBC + H2 driver
│       └── DBInitializer.java           # @WebListener — runs schema-h2.sql on startup
├── web/
│   ├── WEB-INF/
│   │   ├── web.xml                      # Servlet mappings, error pages, context params
│   │   ├── schema-h2.sql                # Schema + sample users (auto-loaded)
│   │   ├── lib/                         # javax.servlet-api, h2, jstl jars
│   │   └── views/
│   │       ├── home.jsp                 # Public landing
│   │       ├── login.jsp                # Login form
│   │       ├── register.jsp             # Registration with role/branch/sem
│   │       ├── dashboard.jsp            # Logged-in dashboard
│   │       ├── files.jsp                # Browse + filter + paginate
│   │       └── upload.jsp               # Upload form with metadata
│   ├── css/
│   │   └── modern-style.css             # Design system
│   ├── index.jsp                        # → redirects to /controller?action=home
│   └── error.jsp                        # 404 / 500 friendly page
├── database/
│   └── schema.sql                       # Original MySQL schema (for reference; H2 schema lives in WEB-INF)
└── README.md
```

---

## Getting Started

### Prerequisites
- **JDK 17** or higher
- **Apache Tomcat 9.x** (must be 9, not 10 — this app uses `javax.servlet`)

### Setup (Windows / PowerShell)

1. **Install Tomcat 9** to `C:\tomcat9` (or update paths below).

2. **Set Tomcat env vars** (one-time, persistent):
   ```powershell
   [System.Environment]::SetEnvironmentVariable('CATALINA_HOME', 'C:\tomcat9', 'User')
   [System.Environment]::SetEnvironmentVariable('CATALINA_BASE', 'C:\tomcat9', 'User')
   ```
   Then close and reopen PowerShell.

3. **Build & deploy** (run from project root):
   ```powershell
   New-Item -ItemType Directory -Force "C:\tomcat9\webapps\p2p"
   Copy-Item -Recurse -Force ".\web\*" "C:\tomcat9\webapps\p2p\"
   New-Item -ItemType Directory -Force "C:\tomcat9\webapps\p2p\WEB-INF\classes"
   javac -d "C:\tomcat9\webapps\p2p\WEB-INF\classes" -cp ".\web\WEB-INF\lib\*" (Get-ChildItem -Recurse -Filter *.java .\src).FullName
   ```

4. **Start Tomcat**:
   ```powershell
   C:\tomcat9\bin\startup.bat
   ```

5. **Open** http://localhost:8080/p2p/

### Default Logins
| Username | Password | Role |
|----------|----------|------|
| `admin` | `admin123` | Faculty |
| `student1` | `student123` | Student |

---

## URL Endpoints

| URL | Method | Purpose |
|-----|--------|---------|
| `/` | GET | Redirects to home |
| `/controller?action=home` | GET | Public landing page |
| `/controller?action=login` | GET / POST | Login form / submit |
| `/controller?action=register` | GET / POST | Registration form / submit |
| `/controller?action=dashboard` | GET | Logged-in dashboard |
| `/controller?action=files` | GET | Browse with filters (`q`, `branch`, `semester`, `subject`, `type`, `sort`, `page`) |
| `/controller?action=upvote&id=X` | GET | Toggle upvote (auth required) |
| `/controller?action=verify&id=X&set=true` | GET | Toggle verified flag (faculty only) |
| `/controller?action=delete&id=X` | GET | Delete material (uploader or faculty) |
| `/controller?action=logout` | GET | End session |
| `/upload` | GET / POST | Upload form / multipart upload |
| `/download?id=X` | GET | Stream file + increment download counter |

---

## Database Schema

| Table | Purpose |
|-------|---------|
| `users` | Accounts, role, branch, semester |
| `shared_files` | Materials with metadata, hash, counts |
| `material_ratings` | Upvotes (one row per user-file pair) |
| `peers`, `file_chunks`, `downloads` | Legacy tables (kept for back-compat, not used in current UI) |

The schema is defined in [`web/WEB-INF/schema-h2.sql`](web/WEB-INF/schema-h2.sql) and loaded automatically by `DBInitializer` on application startup.

---

## Architecture Notes

- **MVC**: clean separation between Models (`com.p2p.model`), Views (`/WEB-INF/views/*.jsp`), and Controllers (`com.p2p.controller`).
- **Front Controller**: `MainControllerServlet` dispatches all `/controller` requests by `action` parameter.
- **DAO pattern**: every entity has a dedicated DAO; controllers never write SQL.
- **Singleton JDBC connection** with reconnection logic.
- **Auto schema bootstrap** via `ServletContextListener` — no manual database setup step.
- **Idempotent schema** — uses `CREATE TABLE IF NOT EXISTS` and `ALTER TABLE … ADD COLUMN IF NOT EXISTS` so re-runs are safe.

---

## Possible Extensions

Features that fit naturally on top of the current architecture:

- Password hashing (currently stored in plaintext for academic simplicity)
- File preview for PDFs and images
- Comments / discussion thread per material
- Subject-wise leaderboards
- "Saved / bookmarked" materials list
- Email notifications when verified
- Real chunked downloads with HTTP `Range` headers (the schema already models chunks)
- Admin panel with user management and reports

---

## License

Educational project. Created as a college mini-project to demonstrate **Servlet / JSP / JDBC / MVC** patterns in a realistic application.
