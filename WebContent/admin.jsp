<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp" %>
<jsp:include page="header.jsp"/>

<div style="padding-left: 60px">
<h1>All Customers</h1>

<%

    //Note: Forces loading of SQL Server driver
    try
    {	// Load driver class
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    }
    catch (java.lang.ClassNotFoundException e)
    {
        System.err.println("ClassNotFoundException: " +e);
    }

    Locale locale = Locale.US;
    NumberFormat currFormat = NumberFormat.getCurrencyInstance(locale);

    // Make connection
    try (
            Connection con = DriverManager.getConnection(url, uid, pw);
            Statement query = con.createStatement();
    ) {

        String sql = "SELECT customerId, firstName + ' ' + lastName as name, userid, email FROM customer";

        ResultSet rs = query.executeQuery(sql);
        out.println(
            "<table style='border: 1px solid black'>" +
                "<tr>" +
                    "<th style='border: 1px solid black'>Id</th>" +
                    "<th style='border: 1px solid black'>Name</th>" +
                    "<th style='border: 1px solid black'>Username</th>" +
                    "<th style='border: 1px solid black'>Email</th>" +
                "</tr>"
        );

        while(rs.next()){
            int customerId = rs.getInt(1);
            String customerName = rs.getString(2);
            String customerUsername = rs.getString(3);
            String customerEmail = rs.getString(4);

            out.println(
                "<tr>" +
                    "<td style='border: 1px solid black'>" + customerId + "</td>" +
                    "<td style='border: 1px solid black'>" + customerName + "</td>" +
                    "<td style='border: 1px solid black'>" + customerUsername + "</td>" +
                    "<td style='border: 1px solid black'>" + customerEmail + "</td>" +
                "</tr>"
            );
        }

        out.println("</table><br/>");

        out.println("<h1>All Orders</h1>");

        String orderSql = "SELECT os.orderId, os.orderDate, c.customerId, c.firstName + ' ' + c.lastName as customerName, os.totalAmount" +
                " FROM ordersummary os" +
                " INNER JOIN customer c ON os.customerId = c.customerId";

        String orderProductSQL = " SELECT p.productId, productPrice, op.quantity" +
                " FROM product p" +
                " INNER JOIN orderproduct op ON op.productId = p.productId" +
                " INNER JOIN ordersummary os ON os.orderId = op.orderId" +
                " WHERE os.orderId = ? ";

        Statement statement = con.createStatement();
        PreparedStatement ptsmt = con.prepareStatement(orderProductSQL);

        ResultSet rs2 = statement.executeQuery(orderSql);
        out.println(
                "<table style='border: 1px solid black'>" +
                        "<tr>" +
                        "<th style='border: 1px solid black'>Order Id</th>" +
                        "<th style='border: 1px solid black'>Order Date</th>" +
                        "<th style='border: 1px solid black'>Customer Id</th>" +
                        "<th style='border: 1px solid black'>Customer Name</th>" +
                        "<th style='border: 1px solid black'>Total Amount</th>" +
                        "</tr>"
        );

        while(rs2.next()){
            int orderId = rs2.getInt(1);
            out.println(
                    "<tr>" +
                            "<td style='border: 1px solid black'>" + orderId + "</td>" +
                            "<td style='border: 1px solid black'>" + rs2.getTimestamp(2) + "</td>" +
                            "<td style='border: 1px solid black'>" + rs2.getInt(3) + "</td>" +
                            "<td style='border: 1px solid black'>" + rs2.getString(4) + "</td>" +
                            "<td style='border: 1px solid black'>" + currFormat.format(rs2.getDouble(5)) + "</td>" +
                            "</tr>" +
                            //Align the inner table to the right
                            "<tr align=\"right\">" +
                            "<td colspan=\"5\" style='border: 1px solid black'>" +
                            "<table style='border: 1px solid black; align: right'>" +
                            "<tr >" +
                            "<th style='border: 1px solid black'>Product Id</th>" +
                            "<th style='border: 1px solid black'>Quantity</th>" +
                            "<th style='border: 1px solid black'>Price</th>" +
                            "</tr>"
            );

            ptsmt.setInt(1, orderId);
            ResultSet rst2 = ptsmt.executeQuery();
            while (rst2.next()) {
                out.println(
                        "<tr>" +
                                "<td style='border: 1px solid black'>" + rst2.getInt(1) + "</td>" +
                                "<td style='border: 1px solid black'>" + rst2.getInt(3) + "</td>" +
                                "<td style='border: 1px solid black'>" + currFormat.format(rst2.getDouble(2)) + "</td>" +
                                "</tr>"
                );

            }

            out.println("</table></tr></td>");
        }

        out.println("</table><br/>");


    }catch (SQLException e){
        out.println(e);
    }

%>
<br/>
<h1><a href="loaddata.jsp">Database Restore</a></h1>
<br/>
</div>
</body>
</html>

