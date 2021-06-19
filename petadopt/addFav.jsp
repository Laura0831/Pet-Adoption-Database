<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<html>

	<head>
		<title>PetAdopt Favorite Add</title>
	</head>

	<body>
		<center>	
			<h1>Message:</h1>
			<%
				String message="";	
				String email = request.getParameter("email");
				String name = request.getParameter("name");
				String bday = request.getParameter("bday");
				String pemail = request.getParameter("pemail");

				try {
					Class.forName("oracle.jdbc.OracleDriver");
					Connection conn = DriverManager.getConnection(
					"jdbc:oracle:thin:@aloe.cs.arizona.edu:1521:oracle",
					"kjbredenkamp",
					"OskarAndRussCute3397");
					conn.setAutoCommit(false);
					
					PreparedStatement stmt = conn.prepareStatement
					("INSERT INTO Favorite VALUES(?,?,?,TO_DATE(?,'YYYY-MM-DD'))");
					stmt.setString(1,email);
					stmt.setString(2,pemail);
					stmt.setString(3,name);
					stmt.setString(4,bday);

					stmt.executeUpdate();
					stmt.close();
				

					conn.commit();	
					conn.close();
					message = "Completed successfully";
					response.sendRedirect("pet.jsp?email="+email);	
				} catch (Exception e){
					response.sendRedirect("pet.jsp?email="+email);	
				}
			
					
			%>
			<h2><%=message%></h2><br>
		</center>
	</body>

</html>
