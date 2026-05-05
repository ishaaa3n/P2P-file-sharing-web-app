package com.p2p.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.Statement;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

/**
 * Runs schema-h2.sql on application startup so tables exist on first run.
 * Idempotent — uses CREATE TABLE IF NOT EXISTS / MERGE.
 */
@WebListener
public class DBInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        try (InputStream in = ctx.getResourceAsStream("/WEB-INF/schema-h2.sql")) {
            if (in == null) {
                ctx.log("schema-h2.sql not found in WEB-INF — skipping DB init");
                return;
            }

            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(in, StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String trimmed = line.trim();
                    if (trimmed.isEmpty() || trimmed.startsWith("--")) continue;
                    sb.append(line).append('\n');
                }
            }

            try (Connection conn = DBConnection.getInstance().getConnection();
                 Statement stmt = conn.createStatement()) {
                for (String sql : sb.toString().split(";")) {
                    String s = sql.trim();
                    if (!s.isEmpty()) {
                        stmt.execute(s);
                    }
                }
                ctx.log("Database initialized successfully (H2)");
            }
        } catch (Exception e) {
            sce.getServletContext().log("DB init failed: " + e.getMessage(), e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        DBConnection.resetInstance();
    }
}
