<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Group 5 Grocery Order Processing</title>
</head>
<body>

<%@include file="header.jsp"%>
<div style="padding-left: 60px">
<%
    /**
     *  The product list HashMap wasn't returning some of the prices correctly for us.
     *  Therefore, our total order amount value is incorrect.
      */


// Get customer id
String username = request.getParameter("username");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");


    Locale locale = Locale.US;
    NumberFormat currFormat = NumberFormat.getCurrencyInstance(locale);

    String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
    String uid = "SA";
    String pw = "YourStrong@Passw0rd";

    String sql = "SELECT customerId, firstName + ' ' + lastName AS customerName FROM customer WHERE userid = ?";

// Make connection
    try (
            Connection con = DriverManager.getConnection(url, uid, pw);
            PreparedStatement pstmt = con.prepareStatement(sql);
    ){


        if(username == null){
            out.println("<h1>Error: No username provided</h1>");
            return;
        }

        else {
            pstmt.setString(1, username);
        }

        ResultSet rs = pstmt.executeQuery();
        if (!rs.isBeforeFirst() ) {
            out.println("<h1>Error: Customer does not exist or an invalid password was given.</h1>");
            return;
        }

        rs.next();
        int customerId = rs.getInt(1);
        String customerName = rs.getString(2);

        //Table header
        out.println("<h1>Your Order Summary</h1>");
        out.println(
            "<table>" +
                "<tr>" +
                    "<th>Product Id</th>" +
                    "<th>Product Name</th>" +
                    "<th>Quantity</th>" +
                    "<th>Price</th>" +
                    "<th>Subtotal</th>" +
                "</tr>"
        );

        //Get next order id
        Statement stmt = con.createStatement();
        ResultSet rsOrderId = stmt.executeQuery("SELECT MAX(orderId) FROM orderproduct");
        rsOrderId.next();
        int orderId = rsOrderId.getInt(1) + 1;

        //Insert the ordersummary row
        String sqlInsertOrderSummary = "INSERT INTO ordersummary (orderDate, totalAmount, customerId) VALUES (?,?,?)";
        java.sql.Date today = new java.sql.Date(System.currentTimeMillis());

        try( PreparedStatement pstmt3 = con.prepareStatement(sqlInsertOrderSummary) ) {
            pstmt3.setDate(1, today);
            pstmt3.setDouble(2, 0);
            pstmt3.setInt(3, customerId);

            pstmt3.executeUpdate();
        } catch (SQLException e){
            out.println("<p>" + e + "</p>");
        }


        String sqlInsertOrderProduct = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?,?,?,?)";

        double total = 0;
        Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
        while (iterator.hasNext()) {
            Map.Entry<String, ArrayList<Object>> entry = iterator.next();
            ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
            String productId = (String) product.get(0);
            String productName = (String) product.get(1);
            String price = (String) product.get(2);
            double pr = 0;
            //Some prices were showing up as null
            if (price != null)
                pr = Double.parseDouble(price);

            int qty = ((Integer) product.get(3)).intValue();
            double subtotal = pr * qty;
            total += subtotal;

            //Insert the order product
            try (PreparedStatement pstmt2 = con.prepareStatement(sqlInsertOrderProduct)) {
                pstmt2.setInt(1, orderId);
                pstmt2.setInt(2, Integer.parseInt(productId));
                pstmt2.setInt(3, qty);
                pstmt2.setDouble(4, pr);

                pstmt2.executeUpdate();
            } catch (SQLException e) {
                out.println("<p>" + e + "</p>");
            }

            //Add the order to the HTML Table
            out.println(
                "<tr>" +
                    "<td>" + productId + "</td>" +
                    "<td>" + productName + "</td>" +
                    "<td align=\"center\">" + qty + "</td>" +
                    "<td align=\"right\">" + currFormat.format(pr) + "</td>" +
                    "<td align=\"right\">" + currFormat.format(subtotal) + "</td>" +
                "</tr>"
            );
        }

        //Update the ordersummary total
        String sql4 = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
        try( PreparedStatement pstmt4 = con.prepareStatement(sql4) ) {
            pstmt4.setDouble(1, total);
            pstmt4.setInt(2, orderId);

            pstmt4.executeUpdate();
        } catch (SQLException e){
            out.println("<p>" + e + "</p>");
        }

        //Add the order total to the HTML Table
        out.println(
                "<tr>" +
                    "<td colspan=\"5\" align=\"right\"><b>Order total</b> " + currFormat.format(total) + "</td>" +
                "</tr>" +
            "</table>"
        );

        out.println("<h1>Order completed. Will be shipped soon...");
        out.println("<h1>Your order reference number is: " + orderId + "</h1>");
        out.println("<h1>Shipping to customer: " + customerId + " Name: " + customerName + "</h1>");
        out.println("<h1><a href=\"index.jsp\">Return to Shopping</a></h1>");

        //Clear product list from session
        productList = new HashMap<>();
        session.setAttribute("productList", productList);

        String sqlClearCart = "DELETE FROM incart WHERE orderId = ?";
        try( PreparedStatement pstmt5 = con.prepareStatement(sqlClearCart) ) {
            pstmt5.setInt(1, orderId);
            pstmt5.executeUpdate();
        } catch (SQLException e){
            out.println("<p>" + e + "</p>");
        }

    }catch (SQLException e){
        out.println("<p>" + e + "</p>");
    }

%>
</div>
</BODY>
</HTML>

