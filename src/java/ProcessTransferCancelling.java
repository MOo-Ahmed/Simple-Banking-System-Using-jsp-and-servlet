
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/ProcessTransferCancelling"})
public class ProcessTransferCancelling extends HttpServlet {
    public String Cancel(String tid, String id1, String id2, String _amount)throws ClassNotFoundException, IOException, SQLException{
        int AccID = Integer.parseInt(id1);
        int AccID2 = Integer.parseInt(id2);
        int TrID = Integer.parseInt(tid);
        double Amount = Double.parseDouble(_amount);
        String result = "";
        String url = "jdbc:mysql://localhost:3306/BankingSystem";
        String user = "root";
        String password = "";
        Connection Con = null;
        Class.forName("com.mysql.jdbc.Driver");
        Con = DriverManager.getConnection(url, user, password);
        /*
            - Get balance 1 -> increase it
            - Get balance 2 -> decrease it
            - Remove the transaction
        
        */

        String line = "SELECT BACurrentBalance FROM BankAccount WHERE BankAccountID = ?";
        PreparedStatement statement = Con.prepareStatement(line);
        statement.setString(1, AccID + "");
        ResultSet RS = statement.executeQuery();
        boolean isFree = true;
        RS.next();
        double balance = RS.getDouble("BACurrentBalance") + Amount;
        line = "SELECT * FROM BankAccount WHERE BankAccountID = ?";
        statement = Con.prepareStatement(line);
        statement.setString(1, AccID2 + "");
        RS = statement.executeQuery();
        RS.next();
        double balance2 = RS.getDouble("BACurrentBalance") - Amount;
        line = "UPDATE BankAccount SET BACurrentBalance = ? WHERE BankAccountID = ?";
        statement = Con.prepareStatement(line);
        statement.setDouble(1, balance);
        statement.setInt(2, AccID);
        int s = statement.executeUpdate();
        line = "UPDATE BankAccount SET BACurrentBalance = ? WHERE BankAccountID = ?";
        statement = Con.prepareStatement(line);
        statement.setDouble(1, balance2);
        statement.setInt(2, AccID2);
        int s2 = statement.executeUpdate();

        if (s2 > 0 && s > 0) {
            result = "Successfully cancelled";
            line = "DELETE FROM BankTransaction WHERE BankTransactionID = ?";
            statement = Con.prepareStatement(line);
            statement.setInt(1, TrID);
            statement.executeUpdate();
                        
        } else {
            result = "Something went wrong";
        }
                
        Con.close();    
        return result;
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ClassNotFoundException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            String x = null, y = null, z = null , i = null;
            String r = "";
            
            x = request.getParameter("AccID");
            y = request.getParameter("AccID2");
            z = request.getParameter("Amount");
            i =  request.getParameter("TrID");
            r = Cancel(i, x, y, z);
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Processing</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<br><br><p> " + r + "</p><br><br><br>");
            out.println("<a href='transactions.jsp' style='border-radius: 5px; background-color: #ffcc00; padding: 4px; text-decoration: none; margin:5px; '>Back to transactions</a>");

            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ProcessTransferCancelling.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(ProcessTransferCancelling.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ProcessTransferCancelling.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(ProcessTransferCancelling.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
