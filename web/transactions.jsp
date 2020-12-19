<%-- 
    Document   : transactions
    Created on : Nov 29, 2020, 11:50:14 PM
    Author     : m
--%>
<%@page import="java.sql.Date"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.io.IOException"%>
<%@page import="java.sql.Connection"%>
<%!
    /*
     public ArrayList<Transaction> getTransactions(int AccID) throws ClassNotFoundException, IOException, SQLException{
     ArrayList<Transaction> result = new ArrayList<>() ;
     String url = "jdbc:mysql://localhost:3306/BankingSystem";
     String user = "root";
     String password = "";
     Connection Con = null;
     Class.forName("com.mysql.jdbc.Driver");
     Con = DriverManager.getConnection(url, user, password) ;
     String line = "SELECT BankTransactionID, BTFromAccount, BTToAccount, BTAmount, UNIX_TIMESTAMP(BTCreationDate) as ut FROM BankTransaction WHERE BTFromAccount = ?";
     PreparedStatement statement = Con.prepareStatement(line);
     statement.setString(1, AccID+"");
     ResultSet RS = statement.executeQuery();
     while(RS.next()){
     boolean isRemovable = true ;
     //Timestamp dt ;
     double timestamp = RS.getInt("ut"), currTimestamp = System.currentTimeMillis();
            
     if((currTimestamp - timestamp) >= 86400000 ){
     isRemovable = false ;
     }
     Transaction t = new Transaction(RS.getInt("BankTransactionID"), RS.getInt("BTFromAccount"), RS.getInt("BTToAccount"), RS.getDouble("BTAmount"), isRemovable);
     result.add(t);
     //result = RS.getInt("BankAccountID");
     }
     Con.close();
     return result;
     }
     */
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Transactions</title>
    </head>
    <body>
        <h1>Your transactions</h1>
        <%
            int AccID = (Integer) session.getAttribute("AccID");
            String url = "jdbc:mysql://localhost:3306/BankingSystem";
            String user = "root";
            String password = "";
            Connection Con = null;
            Class.forName("com.mysql.jdbc.Driver");
            Con = DriverManager.getConnection(url, user, password);
            String line = "SELECT BankTransactionID, BTFromAccount, BTToAccount, BTAmount, BTCreationDate as ut FROM BankTransaction WHERE BTFromAccount = ?";
            PreparedStatement statement = Con.prepareStatement(line);
            statement.setString(1, AccID + "");
            ResultSet RS = statement.executeQuery();
            boolean isFree = true ;
            while (RS.next()) {
                isFree = false ;
                //java.sql.Timestamp t ;
                boolean isRemovable = true;
                java.sql.Timestamp  d =  RS.getTimestamp("ut");
                double timestamp = d.getTime()/1000, currTimestamp = System.currentTimeMillis()/1000;
                
                
                if ((currTimestamp - timestamp) >= 86400) {
                    isRemovable = false;
                }
                        
                
        %>


                    <table border='1px' cellspacing='5px'>
                        <tr>
                            <th>
                                Transaction ID
                            </th>
                            <th>
                                From
                            </th>
                            <th>
                                To
                            </th>
                            <th>
                                Amount
                            </th>
                            <th>
                                Removable ?
                            </th>                  
                        </tr>
                        <tr>
                            <td><%= RS.getInt("BankTransactionID")%></td>
                            <td><%= RS.getInt("BTFromAccount")%></td>
                            <td><%= RS.getInt("BTToAccount")%></td>
                            <td><%= RS.getDouble("BTAmount")%></td>
                            <td>
                                <% if (isRemovable == true){ %>
                                
                                    <p>Yes</p>    
                                <%
                                } else { %>
                                    <p>No</p>
                                <%
                                }
                                %>
                            </td>
                        </tr>
                        
                    </table>
                <%
                }
                if(isFree) { %>
                    <p text-align="center">Sorry, You have no transactions yet</p>
                <%
                }
            
                Con.close();
                %>
        <h1>Transfer money to a user</h1>

    </body>
</html>
