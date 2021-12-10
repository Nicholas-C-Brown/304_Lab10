<html>
<head>
<title>Ray's Grocery</title>
</head>
<body>

<%@include file="header.jsp"%>

<div style="padding-left: 60px">

<%

    if(userName != null){
        response.sendRedirect("order.jsp?username=" + userName);
    }else {
        out.println("<h1>Please login before checking out.</h1>");
    }


%>
</div>
</body>
</html>

