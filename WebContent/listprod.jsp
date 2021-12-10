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

<jsp:include page="header.jsp"/>
<%@ include file="jdbc.jsp" %>

<div style="padding-left: 60px">
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
			"<table id=\"myTable\">" +
				"<tr>" +
					"<th></th>" +
					"<th onclick=\"sortTable(1)\">Product Name</th>" +
					"<th onclick=\"sortTable(2)\">Category</th>" +
					"<th onclick=\"sortTable(3)\">Price</th>" +
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
</div>

<!--Table ordering function from https://www.w3schools.com/howto/tryit.asp?filename=tryhow_js_sort_table_desc -->
<script>
	function sortTable(n) {
		var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
		table = document.getElementById("myTable");
		switching = true;
		//Set the sorting direction to ascending:
		dir = "asc";
		/*Make a loop that will continue until
        no switching has been done:*/
		while (switching) {
			//start by saying: no switching is done:
			switching = false;
			rows = table.rows;
			/*Loop through all table rows (except the
            first, which contains table headers):*/
			for (i = 1; i < (rows.length - 1); i++) {
				//start by saying there should be no switching:
				shouldSwitch = false;
				/*Get the two elements you want to compare,
                one from current row and one from the next:*/
				x = rows[i].getElementsByTagName("TD")[n];
				y = rows[i + 1].getElementsByTagName("TD")[n];
				/*check if the two rows should switch place,
                based on the direction, asc or desc:*/
				if (dir == "asc") {
					if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
						//if so, mark as a switch and break the loop:
						shouldSwitch= true;
						break;
					}
				} else if (dir == "desc") {
					if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
						//if so, mark as a switch and break the loop:
						shouldSwitch = true;
						break;
					}
				}
			}
			if (shouldSwitch) {
				/*If a switch has been marked, make the switch
                and mark that a switch has been done:*/
				rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
				switching = true;
				//Each time a switch is done, increase this count by 1:
				switchcount ++;
			} else {
				/*If no switching has been done AND the direction is "asc",
                set the direction to "desc" and run the while loop again.*/
				if (switchcount == 0 && dir == "asc") {
					dir = "desc";
					switching = true;
				}
			}
		}
	}
</script>

</body>
</html>