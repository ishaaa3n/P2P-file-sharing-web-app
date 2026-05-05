package com.p2p.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import javax.servlet.ServletContext;

/**
 * Database Connection Utility class for JDBC operations.
 * Uses H2 embedded database (file-based, no separate server install).
 */
public class DBConnection {

    private static final String DRIVER = "org.h2.Driver";
    private static final String DB_FILE =
        System.getProperty("user.home").replace("\\", "/") + "/.p2p_data/p2p_db";
    private static final String URL =
        "jdbc:h2:file:" + DB_FILE + ";MODE=MySQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1;AUTO_RECONNECT=TRUE";
    private static final String USER = "sa";
    private static final String PASSWORD = "";

    private static DBConnection instance;
    private Connection connection;

    private DBConnection() {
        try {
            Class.forName(DRIVER);
            this.connection = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    public DBConnection(ServletContext context) {
        try {
            String driver = context.getInitParameter("dbDriver");
            String url = context.getInitParameter("dbURL");
            String user = context.getInitParameter("dbUser");
            String password = context.getInitParameter("dbPassword");

            Class.forName(driver != null ? driver : DRIVER);
            this.connection = DriverManager.getConnection(
                url != null ? url : URL,
                user != null ? user : USER,
                password != null ? password : PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    public static synchronized DBConnection getInstance() {
        if (instance == null || !isValidConnection(instance.connection)) {
            instance = new DBConnection();
        }
        return instance;
    }

    public Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return connection;
    }

    private static boolean isValidConnection(Connection conn) {
        try {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }

    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static synchronized void resetInstance() {
        if (instance != null) {
            instance.closeConnection();
            instance = null;
        }
    }
}
