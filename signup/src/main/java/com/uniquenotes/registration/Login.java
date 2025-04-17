package com.uniquenotes.registration;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class Login extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String uemail = request.getParameter("username");
        String upwd = request.getParameter("password");
        HttpSession session = request.getSession();
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/uniquenotes?useSSL=false", 
                "root", 
                "");
            
            PreparedStatement pst = con.prepareStatement(
                "SELECT uname FROM users WHERE uemail = ? AND upwd = ?");
            pst.setString(1, uemail);
            pst.setString(2, upwd);
            
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                session.setAttribute("name", rs.getString("uname"));
                session.setAttribute("email", uemail);
                response.sendRedirect("index.jsp");
            } else {
                request.setAttribute("status", "failed");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("status", "error");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}