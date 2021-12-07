<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

//Product list is empty, do nothing
if (productList == null) return;

// Remove product selected
// Get product information
String id = request.getParameter("id");

// If the item exists in the product list, remove it
if (productList.containsKey(id))
	productList.remove(id);

session.setAttribute("productList", productList);
%>
<jsp:forward page="showcart.jsp" />