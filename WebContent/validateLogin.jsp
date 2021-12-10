<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful login
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0))
				return null;

		String sql = new StringBuilder()
				.append("SELECT userid, customerId FROM customer ")
				.append("WHERE userid = ? AND")
				.append(" password = ?")
				.toString();

		int customerId = -1;

		try
		(
			Connection con = DriverManager.getConnection(url, uid, pw);
			PreparedStatement pstmt = con.prepareStatement(sql);
		)
		{
			pstmt.setString(1, username);
			pstmt.setString(2, password);

			ResultSet rs = pstmt.executeQuery();
			retStr = "";
			while(rs.next()){
				retStr = rs.getString(1);
				customerId = rs.getInt(2);
			}

		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
			session.setAttribute("authenticatedCustomerId",customerId);
		}
		else
			session.setAttribute("loginMessage","An account with that username and password doesn't exist.");
		return retStr;
	}
%>

