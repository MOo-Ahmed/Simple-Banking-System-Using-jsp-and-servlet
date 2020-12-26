<%-- 
    Document   : transactions
    Created on : Nov 29, 2020, 11:50:14 PM
    Author     : m
--%>
<%@page import="java.sql.Date"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.io.IOException"%>
<%@page import="java.sql.Connection"%>
<%!
    public String validateTransfer(String id1, String id2, String _amount) throws ClassNotFoundException, IOException, SQLException {
        int AccID = Integer.parseInt(id1);
        int AccID2 = Integer.parseInt(id2);
        double Amount = Double.parseDouble(_amount);
        String result = "";
        String url = "jdbc:mysql://localhost:3306/BankingSystem";
        String user = "root";
        String password = "";
        Connection Con = null;
        Class.forName("com.mysql.jdbc.Driver");
        Con = DriverManager.getConnection(url, user, password);

        String line = "SELECT BACurrentBalance FROM BankAccount WHERE BankAccountID = ?";
        PreparedStatement statement = Con.prepareStatement(line);
        statement.setString(1, AccID + "");
        ResultSet RS = statement.executeQuery();
        boolean isFree = true;
        if (RS.next()) {
            double balance = RS.getDouble("BACurrentBalance");
            if (Amount > balance) {
                result = "Failed .. Your balance can't satisfy the transfer";
            } else if (Amount <= 0.0) {
                result = "Failed .. invalid amount";
            } else {
                line = "SELECT * FROM BankAccount WHERE BankAccountID = ?";
                statement = Con.prepareStatement(line);
                statement.setString(1, AccID2 + "");
                RS = statement.executeQuery();
                if (RS.next() && RS.getInt("BankAccountID") == AccID2) {
                    // This is the only case the transaction can proceed
                    double balance2 = RS.getDouble("BACurrentBalance") + Amount;
                    line = "UPDATE BankAccount SET BACurrentBalance = ? WHERE BankAccountID = ?";
                    statement = Con.prepareStatement(line);
                    statement.setDouble(1, balance2);
                    statement.setInt(2, AccID2);
                    int s = statement.executeUpdate();

                    balance -= Amount;
                    line = "UPDATE BankAccount SET BACurrentBalance = ? WHERE BankAccountID = ?";
                    statement = Con.prepareStatement(line);
                    statement.setDouble(1, balance);
                    statement.setInt(2, AccID);
                    int s2 = statement.executeUpdate();

                    if (s2 > 0 && s > 0) {
                        result = "Successfully transferred";
                        line = "INSERT INTO BankTransaction (BTAmount, BTFromAccount, BTToAccount) VALUES (?,?,?)";
                        statement = Con.prepareStatement(line);
                        statement.setDouble(1, Amount);
                        statement.setInt(2, AccID);
                        statement.setInt(3, AccID2);
                        statement.executeUpdate();

                    } else {
                        result = "Something went wrong";
                    }
                }
            }

        }
        Con.close();
        return result;
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Transactions</title>
        <style>
            td,th {
                padding : 5px 10px;
            }
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
            table {
                text-align: center;
                font-family: Arial, Helvetica, sans-serif;
                border-collapse: collapse;
                width: 80%;
            }

            table td, table th {
                border: 1px solid #ddd;
                padding: 8px;
            }

            table tr:nth-child(even){background-color: #f2f2f2;}

            table tr:hover {background-color: #ddd;}

            table th {
                padding-top: 12px;
                padding-bottom: 12px;
                background-color: #000000;
                color: white;
            }
            input[type=text], input[type=password] {
                padding: 12px 20px;
                margin: 8px 0;
                border: none;
                border-bottom: 2px solid red;
            }
        </style>
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
            String line = "SELECT BankTransactionID, BTFromAccount, BTToAccount, BTAmount, BTCreationDate as ut FROM BankTransaction WHERE BTFromAccount = ? OR BTToAccount = ? ORDER BY BTCreationDate Desc";
            PreparedStatement statement = Con.prepareStatement(line);
            statement.setString(1, AccID + "");
            statement.setString(2, AccID + "");
            ResultSet RS = statement.executeQuery();
            boolean isFree = true; %>
        <table style="text-align:center; background-color: #ccccff; margin:auto" border='1px' cellspacing='5px'>
            <tr>
                <th> Transaction ID </th>
                <th> From </th>
                <th> To </th>
                <th> Amount </th>
                <th> Removable ? </th>                  
            </tr>
            <%
                while (RS.next()) {
                    isFree = false;
                    //java.sql.Timestamp t ;
                    boolean isRemovable = true;
                    java.sql.Timestamp d = RS.getTimestamp("ut");
                    double timestamp = d.getTime() / 1000, currTimestamp = System.currentTimeMillis() / 1000;
                    int btfrom = RS.getInt("BTFromAccount");
                    int btto = RS.getInt("BTToAccount");

                    if ((currTimestamp - timestamp) >= 86400 || btfrom != AccID) {
                        isRemovable = false;
                    }


            %>
            <tr>
                <td><%= RS.getInt("BankTransactionID")%></td>
                <td><%= btfrom%></td>
                <td><%= btto%></td>
                <td><%= RS.getDouble("BTAmount")%></td>
                <td>
                    <% if (isRemovable == true) {%>

                    <form method="get" action="ProcessTransferCancelling">
                        <input type='hidden' name="TrID" value=<%= RS.getInt("BankTransactionID")%>>
                        <input type='hidden' name="AccID" value=<%= RS.getInt("BTFromAccount")%>>
                        <input type='hidden' name="AccID2" value=<%= RS.getInt("BTToAccount")%>>
                        <input type='hidden' name="Amount" value=<%= RS.getInt("BTAmount")%>>
                        <input type="submit" value="Cancel" class="button">
                    </form>    
                    <%
                    } else { %>
                    <p>No</p>
                    <%
                        }
                    %>
                </td>
            </tr>                    
            <%
                }
            %>
        </table>
        <%
            if (isFree) { %>
        <p text-align="center">Sorry, You have no transactions yet</p>
        <%
            }

            Con.close();
        %>
        <h1>Transfer money to a user</h1>
        <form name= "TransferForm" method="get" action="ProcessTransfer">
            User account number :  <input type="text" name="AccID2">
            <br><br><br>
            Amount to transfer  :  <input type="text" name="amount"> 
            <input type="hidden" name="AccID" value=<%=AccID%>>
            <input type="submit" value="Transfer now" class="button" >
        </form>



        <br><br><br>
        <a href="customerhome.jsp" class="button">Back to home</a>

    </body>
</html>
