<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html>
<head>
    <title>Group 5's Grocery Warehouse</title>
</head>
<body>

<jsp:include page="header.jsp"/>
<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp" %>

<div style="padding-left: 60px">
    <h1>Warehouses List</h1>

    <%

        session = request.getSession(true);
        Integer customerId = (Integer) session.getAttribute("authenticatedCustomerId");
        if(customerId == null){
            out.println("<p>Please login to view the warehouse.</p>");
            return;
        }

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
        ){

            String sql = "SELECT w.warehouseId, w.warehouseName, p2.productId, p2.productName, p.quantity, p2.productPrice FROM warehouse w\n" +
                    "INNER JOIN productinventory p ON w.warehouseId = p.warehouseId\n" +
                    "INNER JOIN product p2 on p2.productId = p.productId";



            ResultSet rs = query.executeQuery(sql);
            out.println(
                "<table style='border: 1px solid black'>" +
                    "<tr>" +
                        "<th style='border: 1px solid black'>Warehouse Id</th>" +
                        "<th style='border: 1px solid black'>Warehouse Name</th>" +
                        "<th style='border: 1px solid black'>Product Id</th>" +
                        "<th style='border: 1px solid black'>Product Name</th>" +
                        "<th style='border: 1px solid black'>Quantity</th>" +
                        "<th style='border: 1px solid black'>Price</th>" +
                    "</tr>"
            );

            while(rs.next()){
                int warehouseId = rs.getInt(1);
                String warehouseName = rs.getString(2);
                int productId = rs.getInt(3);
                String productName = rs.getString(4);
                int quantity = rs.getInt(5);
                float price = rs.getFloat(6);

                out.println(
                    "<tr>" +
                        "<td style='border: 1px solid black'>" + warehouseId + "</td>" +
                        "<td style='border: 1px solid black'>" + warehouseName + "</td>" +
                        "<td style='border: 1px solid black'>" + productId + "</td>" +
                        "<td style='border: 1px solid black'>" + productName + "</td>" +
                        "<td style='border: 1px solid black'>" + quantity + "</td>" +
                        "<td style='border: 1px solid black'>" + currFormat.format(price) + "</td>" +
                    "</tr>"
                );
            }

            out.println("</table");


        }catch (SQLException e){
            out.println(e);
        }




    %>

</div>
</body>
</html>