<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Group 5's Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	// TODO: Get order id
	String orderId = request.getParameter("orderId");

	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
	String uid = "SA";
	String pw = "YourStrong@Passw0rd";

	String sql = "SELECT op.productId, op.quantity, pi.quantity as previousInventory, pi.quantity - op.quantity as newInventory, pi.warehouseId FROM ordersummary os\n" +
			"INNER JOIN orderproduct op on op.orderId = os.orderId\n" +
			"INNER JOIN productinventory pi on op.productId = pi.productId\n" +
			"WHERE os.orderId = ?";

	// TODO: Check if valid order id
	try(Connection c = DriverManager.getConnection(url, uid, pw)){

		PreparedStatement pstmt = c.prepareStatement(sql);

		if(orderId == null){
			out.println("<p>Error: No order id provided</p>");
			return;
		}else {
			try {
				pstmt.setInt(1, Integer.parseInt(orderId));
			} catch (NumberFormatException nfe) {
				out.println("<p>Error: Invalid order id provided.</p>");
				return;
			}
		}

		ResultSet rs = pstmt.executeQuery();
		if (!rs.isBeforeFirst() ) {
			out.println("<p>Error: Order does not exist.</p>");
			return;
		}

		//Turn off auto commit (start transaction)
		c.setAutoCommit(false);

		boolean rollback = false;

		while(rs.next()){
			int productId = rs.getInt(1);
			int quantity = rs.getInt(2);
			int currentInv = rs.getInt(3);
			int newInv = rs.getInt(4);
			int warehouseId = rs.getInt(5);

			//Add shipment record
			String insertSQL = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId)\n" +
					"VALUES (?, ?, ?)";

			java.sql.Date shipmentDate = new java.sql.Date(System.currentTimeMillis());
			String shipmentDesc = "ProductId: " + productId;

			PreparedStatement insertStatement = c.prepareStatement(insertSQL);
			insertStatement.setDate(1, shipmentDate);
			insertStatement.setString(2, shipmentDesc);
			insertStatement.setInt(3, warehouseId);

			insertStatement.executeUpdate();

			//Update inventory
			String updateSQL = "UPDATE productinventory SET quantity = ? WHERE productId = ?";
			PreparedStatement updateStatement = c.prepareStatement(updateSQL);

			updateStatement.setInt(1, newInv);
			updateStatement.setInt(2, productId);

			insertStatement.executeUpdate();

			if(newInv < 0){
				out.println("<h2>Shipment not done. Insufficient inventory for product id: " + productId + "</h2");
				rollback = true;
			}else {
				out.println("<h3>Ordered product: " + productId + " Qty: " + quantity + " Previous inventory: " + currentInv + " New Inventory: " + newInv);
			}


		}

		if(rollback){
			c.rollback();
		}else {
			c.commit();
		}

		//Turn auto commit back on
		c.setAutoCommit(true);

	}catch (SQLException e){
		out.println(e);
	}

%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
