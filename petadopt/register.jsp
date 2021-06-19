<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<html>

	<head>
		<title>PetAdopt Registration</title>
	</head>

	<body>
		<center>	
			<h1>Message:</h1>
			<%
				String message="";
				String form="<form action=\"$$$\"><input type=\"submit\" value=\"&&&\"></form>";
				String email = request.getParameter("email");
				String name = request.getParameter("name");
				String bday = request.getParameter("bday");
				String intro = request.getParameter("intro");
				String location = request.getParameter("location");
				String exp = request.getParameter("exp");
				String pname = request.getParameter("pname");
				String pbday = request.getParameter("pbday");
				String sterile = request.getParameter("sterile");
				String breed = request.getParameter("breed");
				String walk = request.getParameter("walk");
				String bites = request.getParameter("bites");
				String role = request.getParameter("role");

				String lbreed = "Cat";	
				
				String a="n";
				String s="n";

				if(role.equals("a"))
				{
					a="y";
				} else if (role.equals("s")) {
					s="y";
				} else {
					a="y";
					s="y";
				}
				
				if(!role.equals("a"))
				{
					if(breed.equals("r")){
						lbreed="Rabbit";
					} else if(breed.equals("d")) {
						lbreed="Dog";
					}
				}		
				try {
					Class.forName("oracle.jdbc.OracleDriver");
					Connection conn = DriverManager.getConnection(
					"jdbc:oracle:thin:@aloe.cs.arizona.edu:1521:oracle",
					"kjbredenkamp",
					"OskarAndRussCute3397");
					conn.setAutoCommit(false);
					PreparedStatement stmt = conn.prepareStatement
					("INSERT INTO Member VALUES(?,?,?,?,TO_DATE(?,'YYYY-MM-DD'),?,?,?)");
					stmt.setString(1,email);
					stmt.setString(2,name);
					stmt.setString(3,intro);
					stmt.setString(4,location);
					stmt.setString(5,bday);
					stmt.setString(6,a);
					stmt.setString(7,s);
					stmt.setString(8,exp);

					stmt.executeUpdate();
					stmt.close();
				

					if(!role.equals("a")){	
					message = "User OK, Pet not aborting:<br>";	
					stmt = conn.prepareStatement(
					"INSERT INTO Pet VALUES(?,?,TO_DATE(?,'YYYY-MM-DD'),?,?,?,?)");
					stmt.setString(1,email);
					stmt.setString(2,pname);
					stmt.setString(3,pbday);
					stmt.setString(4,sterile);	
					stmt.setString(5,lbreed);
					stmt.setString(6,walk);
					stmt.setString(7,bites);

					stmt.executeUpdate();
					stmt.close();	
					}	
					conn.commit();	
					conn.close();
					message = "Completed successfully";
					form = form.replace("$$$", "index.html");
					form = form.replace("&&&", "Go Home");
				} catch (Exception e){
					message="User or Pet could not be created.<br>"+e.getMessage();
					form = form.replace("$$$", "register.html");
					form = form.replace("&&&", "Try Again");
				}
			
			%>
			<h2><%=message%></h2><br>
			<%=form%>	
		</center>
	</body>

</html>
