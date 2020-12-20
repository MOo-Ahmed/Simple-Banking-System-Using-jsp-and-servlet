<%-- 
    Document   : customerhome
    Created on : Nov 29, 2020, 7:43:57 PM
    Author     : m
--%>
<%@page import="java.io.IOException"%>
<%@page import="java.sql.*"%>
<%!
    public boolean checkIfBankAccExist(int ID) throws ClassNotFoundException, IOException, SQLException{
        String url = "jdbc:mysql://localhost:3306/BankingSystem";
        String user = "root";
        String password = "";
        Connection Con = null;
        Class.forName("com.mysql.jdbc.Driver");
        Con = DriverManager.getConnection(url, user, password) ;
        String line = "SELECT * FROM BankAccount WHERE CustomerID = ?";
        PreparedStatement statement = Con.prepareStatement(line);
        statement.setString(1, ID+"");
        ResultSet RS = statement.executeQuery();
        boolean result = RS.next()?true:false;
        Con.close();

        return result ;
    }
    
    public double getCustomerBalance(int ID) throws ClassNotFoundException, IOException, SQLException{
        
        double result = 0 ;
        String url = "jdbc:mysql://localhost:3306/BankingSystem";
        String user = "root";
        String password = "";
        Connection Con = null;
        Class.forName("com.mysql.jdbc.Driver");
        Con = DriverManager.getConnection(url, user, password) ;
        String line = "SELECT * FROM BankAccount WHERE CustomerID = ?";
        PreparedStatement statement = Con.prepareStatement(line);
        statement.setString(1, ID+"");
        ResultSet RS = statement.executeQuery();
        RS.next();
        result = RS.getDouble("BACurrentBalance");
        Con.close();
        return result;
    }
    
    public int getAccountNumber(int ID) throws ClassNotFoundException, IOException, SQLException{
        
        int result = 0 ;
        String url = "jdbc:mysql://localhost:3306/BankingSystem";
        String user = "root";
        String password = "";
        Connection Con = null;
        Class.forName("com.mysql.jdbc.Driver");
        Con = DriverManager.getConnection(url, user, password) ;
        String line = "SELECT * FROM BankAccount WHERE CustomerID = ?";
        PreparedStatement statement = Con.prepareStatement(line);
        statement.setString(1, ID+"");
        ResultSet RS = statement.executeQuery();
        RS.next();
        result = RS.getInt("BankAccountID");
        Con.close();
        return result;
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer Balance</title>
    </head>
    <body>
        <%
            
           int ID = (Integer) session.getAttribute("id") ;
           int bankAccNumber = getAccountNumber(ID);
           session.setAttribute("AccID", bankAccNumber);
           
        %>
        <h1>Account ID : <%=bankAccNumber%></h1>
        <%
            
           
           boolean isHavingBankAccount = checkIfBankAccExist(ID);
           if(isHavingBankAccount){ %>
                <p><b>Your Balance is :</b> <%=getCustomerBalance(ID) %> $</p>
           <%    
           }
           else{%>
                <form action="addAccount">
                    <input type="submit" value="Add bank account"> 
                </form>
           <%
           }
        %>
        <a href="transactions.jsp">View my transactions</a>
    </body>
</html>
