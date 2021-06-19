<%@ page import="java.io.*,java.util.*,java.sql.*" 
%>
<html>
    <head>
        
           <script>
            
            function Back()
            {
                window.location.pathname= '/petadopt/main.html';
            }
           
        </script>
        </head>
<body>


<%
    String row = "";
    
    int size = 0;
    String name = "";
   
    String UserTemplate="<table ><tbody><tr></tr><td><b>Name:</b></td><td>%NAME%</td><td><b>Email:</b></td><td>%EMAIL%</td></tr><tr><td><b>Self Introduction:</b></td><td>%INTRO%</td><td><b>Adoption Experience:</b></td><td>%EXPERIENCE%</td></tr></tbody></table>";

    try {
        Class.forName("oracle.jdbc.OracleDriver");
        Connection conn = DriverManager.getConnection(
        "jdbc:oracle:thin:@aloe.cs.arizona.edu:1521:oracle",
        "kjbredenkamp",
        "OskarAndRussCute3397");
        
        Statement stmt = conn.createStatement();

        ResultSet rset = stmt.executeQuery("SELECT * FROM Member where IsAdopter = 'y'");
        
        
        size = 0;
        while(rset.next())
        {
            String cur = UserTemplate;
            cur=cur.replace("%NAME%",rset.getString(2));	
            cur=cur.replace("%EMAIL%",rset.getString(1));
            cur=cur.replace("%INTRO%",rset.getString(3));
            cur=cur.replace("%EXPERIENCE%",rset.getString(8));
            row=row +cur +"<br>";
           
        
            size++;

        }   
  
        if(size== 0){
            name = "No Adopters found!";
            
        }
        
     
        
    

        stmt.close();
        conn.close();
        
    } 
    catch(Exception e) {
        
        String info = row + "<br>" + e.getMessage() + "<br>";	
        
    }
%>
<center>
    <h1> Adopters List</h1>
    <div>
        <h3>All the Adopters:</h3>	
        <%=row%>
        <%=name%>
        	
    </div>

    
    <button onclick="Back()" style="width:100px; font-size: 15px; margin-top:70px;">Quit</button>
    
</center>



</body>

</html>

