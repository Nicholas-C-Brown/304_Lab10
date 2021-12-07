<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Group 5 Grocery Order List</title>
</head>
<body>

<h1>Order List</h1>

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

String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";


// Make connection
try (
	Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();
)
{
	Locale locale = Locale.US;
	NumberFormat currFormat = NumberFormat.getCurrencyInstance(locale);

	String sql = "SELECT os.orderId, os.orderDate, c.customerId, c.firstName + ' ' + c.lastName as customerName, os.totalAmount" +
			" FROM ordersummary os" +
			" INNER JOIN customer c ON os.customerId = c.customerId ";

	String sql2 = " SELECT p.productId, productPrice, op.quantity" +
			" FROM product p" +
			" INNER JOIN orderproduct op ON op.productId = p.productId" +
			" INNER JOIN ordersummary os ON os.orderId = op.orderId" +
			" WHERE os.orderId = ? ";

	try (PreparedStatement pstmt = con.prepareStatement(sql2)) {

		ResultSet rst = stmt.executeQuery(sql);
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
		while (rst.next()) {
			int orderId = rst.getInt(1);
			out.println(
				"<tr>" +
					"<td style='border: 1px solid black'>" + orderId + "</td>" +
					"<td style='border: 1px solid black'>" + rst.getTimestamp(2) + "</td>" +
					"<td style='border: 1px solid black'>" + rst.getInt(3) + "</td>" +
					"<td style='border: 1px solid black'>" + rst.getString(4) + "</td>" +
					"<td style='border: 1px solid black'>" + currFormat.format(rst.getDouble(5)) + "</td>" +
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

			pstmt.setInt(1, orderId);
			ResultSet rst2 = pstmt.executeQuery();
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
		out.println("</table>");
	}

} catch (SQLException e){
	out.println(e);
}

%>

</body>
</html>

