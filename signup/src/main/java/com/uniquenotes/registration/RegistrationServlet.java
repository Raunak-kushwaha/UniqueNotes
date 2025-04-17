package com.uniquenotes.registration;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLIntegrityConstraintViolationException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegistrationServlet")
public class RegistrationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String uname = request.getParameter("name");
        String uemail = request.getParameter("email");
        String upwd = request.getParameter("pass");
        String reUpwd = request.getParameter("re_pass");
        String umobile = request.getParameter("contact");
        
        if (!upwd.equals(reUpwd)) {
            request.setAttribute("status", "password_mismatch");
            request.getRequestDispatcher("registration.jsp").forward(request, response);
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/uniquenotes?useSSL=false", 
                "root", 
                "");

            PreparedStatement pst = con.prepareStatement(
                "INSERT INTO users (uemail, uname, upwd, umobile) VALUES (?, ?, ?, ?)");
            pst.setString(1, uemail);
            pst.setString(2, uname);
            pst.setString(3, upwd);
            pst.setString(4, umobile);

            int rowCount = pst.executeUpdate();
            con.close();
            
            if (rowCount > 0) {
                response.sendRedirect("login.jsp?status=success");
            } else {
                response.sendRedirect("login.jsp?status=failed");
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            response.sendRedirect("registration.jsp?status=email_exists");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("registration.jsp?status=error");
        }
    }
}