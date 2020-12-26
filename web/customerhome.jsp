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
        if(RS.next()){
            result = RS.getInt("BankAccountID");
        }
        else result = -1 ;
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
        <style>
            .button {
                background-color: #f44336;
                padding: 12px 28px;
                font-size: 16px;
                border: none;
                color: white;
                padding: 15px 32px;
                text-align: center;
                text-decoration: none;
                transition-duration: 0.4s;
            }

            .button:hover {
              background-color: #ffcc00; 
              color: white;
            }
        </style>        
    </head>
    <body>
        <%
            
           int ID = (Integer) session.getAttribute("id") ;
           int bankAccNumber = getAccountNumber(ID);
           if(bankAccNumber != -1){
            session.setAttribute("AccID", bankAccNumber);
           }
           String accountID = "" ;
           if(bankAccNumber == -1){
               accountID = "---" ;
           }
           
        %>
        <h1>Account ID : <%=accountID%></h1>
        <%
            
           
           boolean isHavingBankAccount = checkIfBankAccExist(ID);
           if(isHavingBankAccount){ %>
                <p><b>Your Balance is :</b> <%=getCustomerBalance(ID) %> $</p>
           <%    
           }
           else{%>
                <form action="addAccount">
                    <input name = "ID" type="hidden" value="<%=ID%>">
                    <input type="submit" value="Add bank account" class="button"> 
                </form>
           <%
           }
           if(isHavingBankAccount == true){
        %>
        <br><br><a href="transactions.jsp" class="button">View my transactions</a>
        <%}%>
    </body>
</html>
