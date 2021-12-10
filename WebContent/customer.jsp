<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ include file="header.jsp" %>

<div style="padding-left: 60px">

<%

	Integer customerId = (Integer) session.getAttribute("authenticatedCustomerId");

	if(customerId == null){
		out.println("Please login to view customer info.");
		return;
	}

	String sql = "SELECT firstName + ' ' + lastName as name, email, phonenum, address, city + ', ' + state as location, postalCode, country FROM customer\n" +
		"WHERE customerId = ? ";

	try (
			Connection con = DriverManager.getConnection(url, uid, pw);
			PreparedStatement pstmt = con.prepareStatement(sql)
	) {

		pstmt.setInt(1, customerId);

		ResultSet rs = pstmt.executeQuery();
		while(rs.next()){
			out.println("<h2>Name: " + rs.getString(1) + "</h2>");
			out.println("<h3>Email: " + rs.getString(2) + "</h3>");
			out.println("<h3>Phone Number: " + rs.getString(3) + "</h3>");
			out.println("<h3>Address: " + rs.getString(4) + "</h3>");
			out.println("<h3>City: " + rs.getString(5) + "</h3>");
			out.println("<h3>Postal Code: " + rs.getString(6) + "</h3>");
			out.println("<h3>Country: " + rs.getString(7) + "</h3>");

		}

	} catch (SQLException e){
		out.println(e);
	}

%>
</div>
</body>
</html>

