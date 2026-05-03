package com.p2p.controller;

import com.p2p.dao.FileDAO;
import com.p2p.model.SharedFile;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;

/**
 * File Download Servlet - Handles file downloads in the P2P network.
 * This servlet streams files to clients and tracks download counts.
 */
@WebServlet(name = "FileDownloadServlet", urlPatterns = {"/download"})
public class FileDownloadServlet extends HttpServlet {
    
    private static final int BUFFER_SIZE = 1024 * 1024; // 1MB buffer
    private FileDAO fileDAO;
    
    @Override
    public void init() throws ServletException {
        fileDAO = new FileDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fileIdStr = request.getParameter("id");
        
        if (fileIdStr == null || fileIdStr.trim().isEmpty()) {
            response.sendRedirect("controller?action=files");
            return;
        }
        
        try {
            int fileId = Integer.parseInt(fileIdStr);
            SharedFile file = fileDAO.findFileById(fileId);
            
            if (file == null || !file.isAvailable()) {
                response.sendRedirect("controller?action=files&error=fileNotFound");
                return;
            }
            
            // Get the real path to uploads directory
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File fileOnDisk = new File(getServletContext().getRealPath("") + File.separator + file.getFilePath());
            
            if (!fileOnDisk.exists()) {
                response.sendRedirect("controller?action=files&error=fileNotFound");
                return;
            }
            
            // Set response headers
            response.setContentType(getServletContext().getMimeType(file.getFileName()));
            response.setContentLengthLong((int) file.getFileSize());
            response.setHeader("Content-Disposition", 
                "attachment; filename=\"" + file.getFileName() + "\"");
            
            // Stream file to client
            try (BufferedInputStream input = new BufferedInputStream(new FileInputStream(fileOnDisk));
                 BufferedOutputStream output = new BufferedOutputStream(response.getOutputStream())) {
                
                byte[] buffer = new byte[BUFFER_SIZE];
                int bytesRead;
                
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
                
                output.flush();
            }
            
            // Increment download count
            fileDAO.incrementDownloadCount(fileId);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("controller?action=files&error=invalidId");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("controller?action=files&error=downloadFailed");
        }
    }
}