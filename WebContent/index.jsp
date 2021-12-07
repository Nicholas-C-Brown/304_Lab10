<!DOCTYPE html>
<html>
<head>
        <title>Group 5's Grocery Main Page</title>
</head>
<body>
<h1 align="center">Welcome to Group 5's Grocery</h1>
<pre align="center">
Nicholas Brown - 81058851
Amelia Colquhoun - 54303649
Ishita Gupta - 99817512
Lakshay Karnwal - 37530722
</pre>



<%
        session = request.getSession(true);
        String userName = (String) session.getAttribute("authenticatedUser");

        if(userName != null) {
                out.println("<h1 align=center>Logged in as " + userName + "</h1>");
                out.println("<h2 align=center><a href=logout.jsp>Logout</a></h2>");
        }else {
                out.println("<h2 align=center><a href=login.jsp>Login</a></h2>");
        }

        out.println("<h2 align=\"center\"><a href=\"listprod.jsp\">Begin Shopping</a></h2>");
        out.println("<h2 align=\"center\"><a href=\"listorder.jsp\">List All Orders</a></h2>");
        out.println("<h2 align=\"center\"><a href=\"customer.jsp\">Customer Info</a></h2>");
        out.println("<h2 align=\"center\"><a href=\"admin.jsp\">Administrators</a></h2>");

%>
</body>
</html>


