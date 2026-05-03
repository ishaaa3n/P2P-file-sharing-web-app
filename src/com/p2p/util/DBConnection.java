package com.p2p.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import javax.servlet.ServletContext;

/**
 * Database Connection Utility class for JDBC operations.
 * This class manages database connections using the singleton pattern.
 */
public class DBConnection {
    
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/p2p_file_sharing";
    private static final String USER = "root";
    private static final String PASSWORD = "password";
    
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
    
    /**
     * Creates a DBConnection with custom parameters from ServletContext
     */
    public DBConnection(ServletContext context) {
        try {
            String driver = context.getInitParameter("dbDriver");
            String url = context.getInitParameter("dbURL");
            String user = context.getInitParameter("dbUser");
            String password = context.getInitParameter("dbPassword");
            
            Class.forName(driver);
            this.connection = DriverManager.getConnection(url, user, password);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Gets the singleton instance of DBConnection
     * @return DBConnection instance
     */
    public static synchronized DBConnection getInstance() {
        if (instance == null || !isValidConnection(instance.connection)) {
            instance = new DBConnection();
        }
        return instance;
    }
    
    /**
     * Gets the database connection
     * @return Connection object
     */
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
    
    /**
     * Checks if the connection is valid
     * @param conn Connection to check
     * @return true if connection is valid, false otherwise
     */
    private static boolean isValidConnection(Connection conn) {
        try {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }
    
    /**
     * Closes the database connection
     */
    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Resets the singleton instance (useful for testing)
     */
    public static synchronized void resetInstance() {
        if (instance != null) {
            instance.closeConnection();
            instance = null;
        }
    }
}