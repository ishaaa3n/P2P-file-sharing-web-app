package com.p2p.controller;

import com.p2p.dao.FileDAO;
import com.p2p.model.SharedFile;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.*;
import java.nio.file.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.io.IOException;

/**
 * File Upload Servlet - Handles file uploads in the P2P network.
 * This servlet processes multipart requests and stores files.
 */
@WebServlet(name = "FileUploadServlet", urlPatterns = {"/upload"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 100, // 100 MB
    maxRequestSize = 1024 * 1024 * 100 // 100 MB
)
public class FileUploadServlet extends HttpServlet {
    
    private static final String UPLOAD_DIR = "uploads";
    private FileDAO fileDAO;
    
    @Override
    public void init() throws ServletException {
        fileDAO = new FileDAO();
        
        // Create uploads directory if it doesn't exist
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("controller?action=login");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        
        try {
            Part filePart = request.getPart("file");
            String description = request.getParameter("description");
            String subject = request.getParameter("subject");
            String branch = request.getParameter("branch");
            String semStr = request.getParameter("semester");
            String materialType = request.getParameter("materialType");

            int semester = 0;
            if (semStr != null && !semStr.trim().isEmpty()) {
                try { semester = Integer.parseInt(semStr.trim()); } catch (NumberFormatException ignored) {}
            }

            if (filePart == null || filePart.getSize() == 0) {
                request.setAttribute("error", "Please select a file to upload");
                request.getRequestDispatcher("/WEB-INF/views/upload.jsp").forward(request, response);
                return;
            }
            
            // Get file name
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            
            // Get file size
            long fileSize = filePart.getSize();
            
            // Get file type
            String fileType = getFileExtension(fileName);
            
            // Generate file hash (MD5)
            String fileHash = generateFileHash(filePart);
            
            // Calculate chunks
            int chunkSize = 102400; // 100KB per chunk
            int chunkCount = FileDAO.calculateChunkCount(fileSize);
            
            // Create unique file path
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            Path filePath = Paths.get(uploadPath, uniqueFileName);
            
            // Save file
            try (InputStream input = filePart.getInputStream();
                 FileOutputStream output = new FileOutputStream(filePath.toFile())) {
                
                byte[] buffer = new byte[1024 * 1024]; // 1MB buffer
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
            }
            
            // Create SharedFile object
            SharedFile sharedFile = new SharedFile();
            sharedFile.setUserId(userId);
            sharedFile.setFileName(fileName);
            sharedFile.setFilePath(UPLOAD_DIR + "/" + uniqueFileName);
            sharedFile.setFileSize(fileSize);
            sharedFile.setFileType(fileType);
            sharedFile.setFileHash(fileHash);
            sharedFile.setChunkCount(chunkCount);
            sharedFile.setChunkSize(chunkSize);
            sharedFile.setDescription(description != null ? description : "");
            sharedFile.setSubject(subject != null ? subject.trim() : "");
            sharedFile.setBranch(branch != null ? branch.trim() : "");
            sharedFile.setSemester(semester);
            sharedFile.setMaterialType(materialType != null && !materialType.trim().isEmpty()
                ? materialType.trim().toLowerCase() : SharedFile.TYPE_NOTES);
            sharedFile.setAvailable(true);
            
            // Save to database
            if (fileDAO.createFile(sharedFile)) {
                request.setAttribute("success", "File uploaded successfully!");
                request.setAttribute("fileId", sharedFile.getFileId());
                request.setAttribute("fileName", fileName);
                request.setAttribute("fileSize", sharedFile.getFormattedFileSize());
                request.setAttribute("chunkCount", chunkCount);
            } else {
                request.setAttribute("error", "Failed to save file to database");
            }
            
            request.getRequestDispatcher("/WEB-INF/views/upload.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error uploading file: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/upload.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("controller?action=login");
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/views/upload.jsp").forward(request, response);
    }
    
    /**
     * Gets file extension from filename
     */
    private String getFileExtension(String fileName) {
        if (fileName.lastIndexOf(".") > 0) {
            return fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
        }
        return "unknown";
    }
    
    /**
     * Generates MD5 hash of file content
     */
    private String generateFileHash(Part filePart) throws IOException, NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("MD5");
        
        try (InputStream input = filePart.getInputStream()) {
            byte[] buffer = new byte[1024 * 1024];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) {
                md.update(buffer, 0, bytesRead);
            }
        }
        
        byte[] hashBytes = md.digest();
        StringBuilder sb = new StringBuilder();
        for (byte b : hashBytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}