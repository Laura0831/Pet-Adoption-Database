<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<html>

	<head>
		<title>Member Profile:</title>
		<style>
			.grid-container {
			  display: grid;
			  grid-template-columns: 1fr 1fr 1fr 1fr;
			  grid-template-rows: 1fr 1fr 1fr;
			  gap: 0px 0px;
			  grid-template-areas:
			    ". User-Info User-Info ."
			    ". Favorite-Pets Owned-Pets ."
			    ". . . .";
			}

			.User-Info { grid-area: User-Info; }

			.Favorite-Pets { grid-area: Favorite-Pets; }

			.Owned-Pets { grid-area: Owned-Pets; }

		</style>
		<script>
			function home()
			{
				window.location.pathname='/petadopt/main.html';
			}
		</script>
	</head>

	<body>
		
		<%

			String petTemplate="<tr><td>%NAME%</td><td>%AGE%</td><td>%BREED%</td></tr>";
			String favtable="";
			String adopttable="";
			String info="<table ><tbody><tr><td>Name:</td><td>%NAME%</td><td>Email:</td><td>%EMAIL%</td></tr><tr><td>Birthday:</td><td>%BDAY%</td><td>Age:</td><td>%AGE%</td></tr><tr><td>Location:</td><td>%LOCATION%</td><td>Role:</td><td>%ROLE%</td></tr></tbody></table><table ><tbody><tr><td>Intro:</td><td>%INTRO%</td></tr><tr><td>Adopting Experience:</td><td>%EXPERIENCE%</td></tr></tbody></table>";
	
			String email = request.getParameter("email");
			try {
				Class.forName("oracle.jdbc.OracleDriver");
				Connection conn = DriverManager.getConnection(
				"jdbc:oracle:thin:@aloe.cs.arizona.edu:1521:oracle",
				"kjbredenkamp",
				"OskarAndRussCute3397");

				Statement stmt = conn.createStatement();

				ResultSet rset = stmt.executeQuery("SELECT * FROM Member"+
				" WHERE EmailAddress='"+email+"'");
			
				int size = 0;
				java.sql.Date curDate = new java.sql.Date(System.currentTimeMillis());
				if(rset != null) {
				
					while(rset.next())
					{
						size++;
						if(size==1)
						{
						
						boolean sender = rset.getString(7).equals("y");
						boolean adopter = rset.getString(6).equals("y");
						
						java.sql.Date birth= rset.getDate(5);
						
						long elapsed=curDate.getTime()-birth.getTime();
						elapsed=elapsed/1000;
						elapsed=elapsed/60;
						elapsed=elapsed/60;
						elapsed=elapsed/24;
						elapsed=elapsed/365;
						int years = (int) elapsed;
						String role;
						if(sender && adopter)
						{
							role = "Both";
						} else if (sender)
						{
							role = "Sender";
						} else if (adopter) {
							role= "Adopter";
						} else {
							role="IMPOSSIBLE";
						}
						info=info.replace("%NAME%",rset.getString(2));	
						info=info.replace("%EMAIL%",rset.getString(1));
						info=info.replace("%BDAY%",rset.getString(5).substring(0,10));
						info=info.replace("%AGE%",years+"y");
						info=info.replace("%LOCATION%",rset.getString(4));
						info=info.replace("%ROLE%",role);
						info=info.replace("%INTRO%",rset.getString(3));
						if(rset.getString(8) != null)	
						info=info.replace("%EXPERIENCE%",rset.getString(8));
						else
						info=info.replace("%EXPERIENCE%","N/A");
						}
					}	
				}
				String redirect="";
				if(size==0)
				{
					redirect = "index.html";
					response.sendRedirect(redirect);
				}
				
				stmt.close();
				
				stmt = conn.createStatement();
				rset = stmt.executeQuery("SELECT * FROM Pet"+
				" WHERE EmailAddress='"+email+"'");
				
				if(rset != null) {
				
					while(rset.next())
					{
						
						String cur = petTemplate;	
						java.sql.Date birth= rset.getDate(3);
						
						long elapsed=curDate.getTime()-birth.getTime();
						elapsed=elapsed/1000;
						elapsed=elapsed/60;
						elapsed=elapsed/60;
						elapsed=elapsed/24;
						elapsed=elapsed/365;
						int years = (int) elapsed;
						cur=cur.replace("%NAME%",rset.getString(2));	
						cur=cur.replace("%AGE%",years+"y");
						cur=cur.replace("%BREED%",rset.getString(5));
						adopttable=adopttable+cur;	
					}	
				}
				stmt.close();
				
				stmt = conn.createStatement();
				rset = stmt.executeQuery("SELECT * FROM Pet"+
				" WHERE EmailAddress IN (SELECT EmailAddressPet FROM Favorite WHERE EmailAddressMember='"+email+"')");
				size=0;	
				if(rset != null) {
				
					while(rset.next())
					{
						
						String cur = petTemplate;	
						java.sql.Date birth= rset.getDate(3);
						
						long elapsed=curDate.getTime()-birth.getTime();
						elapsed=elapsed/1000;
						elapsed=elapsed/60;
						elapsed=elapsed/60;
						elapsed=elapsed/24;
						elapsed=elapsed/365;
						int years = (int) elapsed;
						cur=cur.replace("%NAME%",rset.getString(2));	
						cur=cur.replace("%AGE%",years+"y");
						cur=cur.replace("%BREED%",rset.getString(5));
						favtable=favtable+cur;	
					}	
				}
				favtable=favtable;	
				stmt.close();	
				conn.close();
			} catch(Exception e) {
				info = info + "<br>" + e.getMessage() + "<br>";	
				for(StackTraceElement s:e.getStackTrace())
				{
					info = info + s.toString() + "<br>";
				}
			
			}
		%>
		<center>
			<h1>Member Area</h1>
			<div class="grid-container" style="width:70%;height:60%">
				<div class="User-Info">
				<h3>User Info:</h3>	
				<%=info%>	
				</div>
				<div class="Favorite-Pets">
				<h3>Favorite Pets:</h3>	
				<table >
					<tbody>
						<tr>
							<td><h4>Name</h4></td>
							<td><h4>Age</h4></td>
							<td><h4>Breed</h4></td>
						</tr>
						<%=favtable%>	
					</tbody>
				</table>

				</div>
				<div class="Owned-Pets">
				<h3>Up for adoption:</h3>	
				<table >
					<tbody>
						<tr>
							<td><h4>Name</h4></td>
							<td><h4>Age</h4></td>
							<td><h4>Breed</h4></td>
						</tr>
						<%=adopttable%>
					</tbody>
				</table>
				</div>
			</div>
			<input type="button" value="Home" onclick="home()">	
		</center>
	</body>

</html>
