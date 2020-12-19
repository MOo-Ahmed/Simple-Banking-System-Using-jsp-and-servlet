/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import javax.servlet.http.HttpSession;

/**
 *
 * @author m
 */
@WebServlet(urlPatterns = {"/Validate"})
public class Validate extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            int ID = Integer.parseInt(request.getParameter("ID"));
            String PASSWORD = request.getParameter("password");
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Validate</title>");            
            out.println("</head>");
            out.println("<body>");
                
            
            String url = "jdbc:mysql://localhost:3306/BankingSystem";
            String user = "root";
            String password = "";
            Connection Con = null;
            //Statement Stmt = null;
            Class.forName("com.mysql.jdbc.Driver");
            Con = DriverManager.getConnection(url, user, password) ; 
            //Stmt = Con.createStatement();
                /*
                String pname = request.getParameter("pname");
                String pnumber = request.getParameter("pnumber");
                String plocation = request.getParameter("plocation");
                String dnum = request.getParameter("dnum");
                */
                /*
                String line = "INSERT INTO Customer(CustomerID,CustomerName,CustomerAddress,CustomerMobile) VALUES("
                        + "'" + 12 + "',"
                        + "'" + "Mohamed" + "',"
                        + "'" + "Dokki" + "',"
                        + "'" + "1234" + "')";
                */
            String line = "SELECT * FROM Customer WHERE CustomerID = ? AND CustomerPassword = ?";
            PreparedStatement statement = Con.prepareStatement(line);
            statement.setString(1, ID+"");
            statement.setString(2, PASSWORD);
            ResultSet RS = statement.executeQuery();
            if(RS.next()){
                //out.println("<p>" + RS.getString("CustomerPassword") + "</p>");
                Con.close();
                HttpSession session = request.getSession();
                session.setAttribute("id", ID);
                response.sendRedirect("customerhome.jsp");
            } else {
                out.println("<p>Invalid user data !!</p>");
                out.println("<form action='index.html'>");
                out.println("<input type ='submit' value = 'Return to login'>");
                out.println("</form>");
               
                
            }
            out.println("</body>");
            out.println("</html>");
            Con.close();
        }
        catch(Exception e){
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
