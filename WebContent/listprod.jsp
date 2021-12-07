<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.net.URL" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Group 5 Grocery</title>
</head>
<body>

<div style="display: flex; flex-direction: row; align-items: center; background-color: pink; justify-content: space-between; padding: 2px 10px">
	<div style="display: flex; flex-direction: row; align-items: center;">
		<h1 style="padding-right: 10px">Group 5 Grocery</h1>
		<h3 style="padding-right: 10px"><a href="shop.html">Home</a></h3>
		<h3 style="padding-right: 10px"><a href="showcart.jsp">View Cart</a></h3>
		<h3 style="padding-right: 10px"><a href="listorder.jsp">View Orders</a></h3>
	</div>
	<div>
		<h3>Logged in as Bob</h3>
	</div>
</div>


<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

// Make the connection
	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
	String uid = "SA";
	String pw = "YourStrong@Passw0rd";

	Locale locale = Locale.US;
	NumberFormat currFormat = NumberFormat.getCurrencyInstance(locale);

	String sql = "SELECT p.productId, p.productName, p.productPrice, c.categoryName FROM product p\n" +
			"INNER JOIN category c ON c.categoryId = p.categoryId\n" +
			"WHERE p.productName LIKE ? OR c.categoryName LIKE ?";

	try (
		Connection con = DriverManager.getConnection(url, uid, pw);
		PreparedStatement pstmt = con.prepareStatement(sql);
	)
	{
		if(name == null || name.equalsIgnoreCase("")) {
			pstmt.setString(1, "%%");
			pstmt.setString(2, "%%");
			out.println("<h2>All products:</h2>");

		}
		else {
			pstmt.setString(1, "%" + name + "%");
			pstmt.setString(2, "%" + name + "%");
			out.println("<h2>Products containing: '" + name + "'</h2>");
		}

		out.println(
			"<table>" +
				"<tr>" +
					"<th></th>" +
					"<th>Product Name</th>" +
					"<th>Category</th>" +
					"<th>Price</th>" +
				"</tr>"
		);

		ResultSet rs = pstmt.executeQuery();
		while(rs.next()){
			int productId = rs.getInt(1);
			String productName = rs.getString(2);
			double price = rs.getDouble(3);
			String categoryName= rs.getString(4);
			String addCartLink ="addcart.jsp?id=" + productId + "&price=" + price + "&name=" + productName;

			String productLink = new StringBuilder("product.jsp?id=")
					.append(productId)
					.toString();

			out.println(
					"<tr>" +
						"<td><a href=" + addCartLink + ">Add to cart</a></td>" +
						"<td><a href=" + productLink + ">" + productName + "</a></td>" +
						"<td>" + categoryName + "</td>" +
						"<td>" + currFormat.format(price) + "</td>" +
					"</tr>");
		}

	out.println("</table");


	}catch(SQLException e){
		out.println(e);
	}
%>

</body>
</html>