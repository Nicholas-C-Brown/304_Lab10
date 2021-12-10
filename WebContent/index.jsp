<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<!DOCTYPE html>
<html>
<head>
        <title>Group 5's Grocery Main Page</title>
</head>
<body>

<jsp:include page="header.jsp"/>
<%@ include file="jdbc.jsp" %>

<h1 align="center">Welcome to Group 5's Grocery</h1>
<pre align="center">
Nicholas Brown - 81058851
Amelia Colquhoun - 54303649
Ishita Gupta - 99817512
Lakshay Karnwal - 37530722
</pre>



<%

        //Note: Forces loading of SQL Server driver
        try
        {	// Load driver class
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        }
        catch (java.lang.ClassNotFoundException e)
        {
                out.println("ClassNotFoundException: " +e);
        }

        //Check if DB is loaded, if not, load it.
        try(Connection con = DriverManager.getConnection(url, uid, pw)){

                Statement s = con.createStatement();
                s.executeQuery("SELECT * FROM customer");

        }catch (SQLException e){
                response.sendRedirect("loaddata.jsp");
        }


        session = request.getSession(true);
        String userName = (String) session.getAttribute("authenticatedUser");

        if(userName != null) {
                out.println("<h1 align=center>Logged in as " + userName + "</h1>");
                out.println("<h2 align=center><a href=logout.jsp>Logout</a></h2>");
                out.println("<h2 align=\"center\"><a href=\"listprod.jsp\">Begin Shopping</a></h2>");
                out.println("<h2 align=\"center\"><a href=\"listorder.jsp\">List All Orders</a></h2>");
                out.println("<h2 align=\"center\"><a href=\"customer.jsp\">Customer Info</a></h2>");
                out.println("<h2 align=\"center\"><a href=\"warehouse.jsp\">Warehouse</a></h2>");
                out.println("<h2 align=\"center\"><a href=\"admin.jsp\">Admin</a></h2>");

        }else {
                out.println("<h2 align=center><a href=login.jsp>Login</a></h2>");
                out.println("<h2 align=\"center\"><a href=\"listprod.jsp\">Begin Shopping</a></h2>");
        }


%>
</body>
</html>


