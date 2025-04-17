package com.uniquenotes.registration;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.google.gson.JsonObject;

@WebServlet("/NoteServlet")
public class NoteServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/uniquenotes?useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String noteIdStr = request.getParameter("id");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        
        System.out.println("doGet: action=" + action + ", noteIdStr=" + noteIdStr + ", email=" + email); // Debug log
        
        if (email == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            if ("get".equals(action)) {
                if (noteIdStr == null) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Note ID is missing");
                    return;
                }
                int noteId = Integer.parseInt(noteIdStr); // Convert to int
                PreparedStatement pst = con.prepareStatement(
                    "SELECT id, title, content FROM notes WHERE id = ? AND user_email = ?");
                pst.setInt(1, noteId); // Use setInt for integer id
                pst.setString(2, email);
                System.out.println("Executing query with noteId=" + noteId + ", user_email=" + email); // Debug log
                ResultSet rs = pst.executeQuery();
                
                if (rs.next()) {
                    JsonObject json = new JsonObject();
                    json.addProperty("id", rs.getInt("id")); // Use getInt for consistency
                    json.addProperty("title", rs.getString("title"));
                    json.addProperty("content", rs.getString("content"));
                    response.setContentType("application/json");
                    response.getWriter().write(json.toString());
                } else {
                    System.out.println("No note found for noteId=" + noteId + ", user_email=" + email); // Debug log
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Note not found");
                }
            }
            con.close();
        } catch (NumberFormatException e) {
            System.out.println("NumberFormatException: " + e.getMessage()); // Debug log
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid note ID format");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Exception: " + e.getMessage()); // Debug log
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected error");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        
        if (email == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            if ("create".equals(action)) {
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
                    response.sendRedirect("index.jsp?error=empty_fields");
                    return;
                }
                PreparedStatement pst = con.prepareStatement(
                    "INSERT INTO notes (user_email, title, content, created_at, updated_at) VALUES (?, ?, ?, NOW(), NOW())",
                    Statement.RETURN_GENERATED_KEYS);
                pst.setString(1, email);
                pst.setString(2, title);
                pst.setString(3, content);
                pst.executeUpdate();
                response.sendRedirect("index.jsp?status=note_created");
            } else if ("update".equals(action)) {
                String noteIdStr = request.getParameter("noteId");
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                if (noteIdStr == null || title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
                    response.sendRedirect("index.jsp?error=empty_fields");
                    return;
                }
                int noteId = Integer.parseInt(noteIdStr);
                PreparedStatement pst = con.prepareStatement(
                    "UPDATE notes SET title = ?, content = ?, updated_at = NOW() WHERE id = ? AND user_email = ?");
                pst.setString(1, title);
                pst.setString(2, content);
                pst.setInt(3, noteId);
                pst.setString(4, email);
                int rowsUpdated = pst.executeUpdate();
                if (rowsUpdated == 0) {
                    response.sendRedirect("index.jsp?error=note_not_found");
                    return;
                }
                response.sendRedirect("index.jsp?status=note_updated");
            } else if ("delete".equals(action)) {
                String noteIdStr = request.getParameter("id");
                if (noteIdStr == null) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Note ID missing");
                    return;
                }
                int noteId = Integer.parseInt(noteIdStr);
                PreparedStatement pst = con.prepareStatement(
                    "DELETE FROM notes WHERE id = ? AND user_email = ?");
                pst.setInt(1, noteId);
                pst.setString(2, email);
                int rowsDeleted = pst.executeUpdate();
                if (rowsDeleted == 0) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Note not found");
                    return;
                }
                JsonObject jsonResponse = new JsonObject();
                jsonResponse.addProperty("status", "success");
                response.setContentType("application/json");
                response.getWriter().write(jsonResponse.toString());
            }
            con.close();
        } catch (NumberFormatException e) {
            System.out.println("NumberFormatException: " + e.getMessage()); // Debug log
            response.sendRedirect("index.jsp?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Exception: " + e.getMessage()); // Debug log
            response.sendRedirect("index.jsp?error=database_error");
        }
    }
}