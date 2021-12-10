<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<html>
<head>
<title>Group 5's Grocery - Product Information</title>
</head>
<body>

<%@ include file="header.jsp" %>

<div style="padding-left: 60px">
<%
// Get product name to search for
// TODO: Retrieve and display info for the product
String productId = request.getParameter("id");

String sql = "SELECT productName, productDesc, productPrice, productImageURL FROM product WHERE productId = ?";

try(Connection c = DriverManager.getConnection(url, uid, pw)){
    PreparedStatement pstmt = c.prepareStatement(sql);

    pstmt.setInt(1, Integer.parseInt(productId));

    ResultSet rs = pstmt.executeQuery();
    rs.next();

    String productName = rs.getString(1);
    String desc = rs.getString(2);
    String price = rs.getString(3);
    String imageURL = rs.getString(4);

    out.println("<h1>" + productName + "</h1>");
    if(imageURL != null)
        out.println("<img src=\"" + imageURL + "\" alt=\"Product Image\" width=\"400\" height=\"400\"/>");
    out.println("<p><b>Description:</b> " + desc + "</p>");
    out.println("<p><b>ID:</b> " + productId + "</p>");
    out.println("<p><b>Price:</b> " + price + "</p>");

    String addCartLink = new StringBuilder("addcart.jsp?id=")
            .append(productId)
            .append("&price=")
            .append(price)
            .append("&name=")
            .append(productName)
            .toString();

    out.println("<h1><a href=" + addCartLink + ">Add to cart</a></h1>");
    out.println("<h1><a href=listprod.jsp />Continue Shopping</h1>");


}catch (SQLException e){
    out.println(e);
}

%>
</div>

</body>
</html>

