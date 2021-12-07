<link href="css/style.css" rel="stylesheet">
<div style="display: flex; flex-direction: row; align-items: center; background-color: pink; justify-content: space-between; padding: 10px 60px">
    <div style="display: flex; flex-direction: row; align-items: center;">
        <h1 style="padding-right: 30px; margin: 0">Group 5 Grocery</h1>
        <h3 style="padding-right: 10px"><a href="index.jsp">Home</a></h3>
        <h3 style="padding-right: 10px"><a href="listprod.jsp">Begin Shopping</a></h3>
        <h3 style="padding-right: 10px"><a href="listorder.jsp">List Orders</a></h3>
        <h3 style="padding-right: 10px"><a href="customer.jsp">Customer Info</a></h3>
    </div>
    <div>
    <%@ page language="java" import="java.io.*,java.sql.*"%>
    <%@ include file="jdbc.jsp" %>
    <%

        session = request.getSession(true);
        Boolean b = (Boolean) session.getAttribute("dataLoaded");
        if(b == null || !b) {
            response.sendRedirect("loaddata.jsp");
        }


        String userName = (String) session.getAttribute("authenticatedUser");

        if(userName != null) {
            out.println("<h3 style=\"margin: 0\">Logged in as " + userName + "</h3>");
            out.println("<h4 align=center style=\"margin: 0\"><a href=logout.jsp>Logout</a></h4>");
        }else {
            out.println("<h3 style=\"margin: 0\">Not logged in</h3>");
            out.println("<h4 align=center style=\"margin: 0\"><a href=login.jsp>Login</a></h4>");
        }


    %>
    </div>
</div>
