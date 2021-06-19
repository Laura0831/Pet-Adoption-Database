<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<html>
	<head>
		<title>WIP Login</title>
	</head>

	<body>
		<%
		String email = request.getParameter("email");
		String t = "Data: ";	
		try {
			Class.forName("oracle.jdbc.OracleDriver");
			Connection conn = DriverManager.getConnection(
			"jdbc:oracle:thin:@aloe.cs.arizona.edu:1521:oracle",
			"kjbredenkamp",
			"OskarAndRussCute3397");

			Statement stmt = conn.createStatement();

			ResultSet rset = stmt.executeQuery("SELECT EmailAddress FROM Member"+
			" WHERE EmailAddress='"+email+"'");
			
			int size = 0;

			if(rset != null) {
			
				while(rset.next())
				{
					t = t + " "+rset.getRow()+":"+rset.getString(1);
					size++;
				}	
			}
			t = t + " Size: " + size;	
			String redirect="";
			if(size==0)
			{
				redirect = "index.html?error=";
			} else {
				redirect = "main.html?email="+email;
			}
			stmt.close();
			conn.close();
			response.sendRedirect(redirect);
		} catch(Exception e) {
			response.sendRedirect("index.html?error="+e.toString());	
		}
		%>
		<%=t%>
	</body>

</html>

