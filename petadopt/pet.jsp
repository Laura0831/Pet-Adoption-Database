<%@ page import="java.io.*,java.util.*,java.sql.*" 
%>
<html>
    <head>
        
           <script>
           
	    function findGetParameter(parameterName)
	    {
                var result = null,
		tmp=[];
		location.search.substr(1).split('&').forEach(
                    function (item) {
                    tmp=item.split('=');
		    if(tmp[0]===parameterName) result = tmp[1];
		    }
		);
		return result;
	    }
            function Back()
            {
		var queryParams = new URLSearchParams();
		queryParams.set("email",findGetParameter('email'));
		history.replaceState(null,null,"?"+decodeURIComponent(queryParams.toString()));	
		window.location.pathname= '/petadopt/main.html';
            }
            function okay()
            {
                console.log("hello");
            }
          
	    function petClick(name,email,bday)
	    {
		var queryParams = new URLSearchParams(window.location.search);
		queryParams.set("pemail",email);
		queryParams.set("name",name);
		queryParams.set("bday",bday);
		history.replaceState(null,null,"?"+decodeURIComponent(queryParams.toString()));
		window.location.pathname='/petadopt/addFav.jsp';
            }
        </script>
        </head>
<body>


<%
    String row = "";
    
    int size = 0;
    String name = "";
    String email ="";
    String check="";
    String PetTemplate="<table ><tbody><tr></tr><td><b>Name:</b></td><td>%NAME%</td><td><b>Email:</b></td><td>%EMAIL%</td></tr>"+
       " <tr><td><b>Birthday:</b></td><td>%BDO%</td><td></td> <td><b>Breed:</b></td><td>%BREED%</td><td></td></tr>" +
       "<tr><td><b>Sterilized:</b></td><td>%STER%</td><td></td> <td><b>Aspect:</b></td><td>%ASPECT%</td><td></td></tr></tbody></table>";
   
   
       String button="<input type=\"button\" name=\"email\" value=\"Favorite\" onclick=\"petClick('%NAME%','%EMAIL%','%BDO%')\">";
    try {
        Class.forName("oracle.jdbc.OracleDriver");
        Connection conn = DriverManager.getConnection(
        "jdbc:oracle:thin:@aloe.cs.arizona.edu:1521:oracle",
        "kjbredenkamp",
        "OskarAndRussCute3397");
        
        Statement stmt = conn.createStatement();

        ResultSet rset = stmt.executeQuery("SELECT * FROM Pet");
        
        email = request.getParameter("Favorite");
        size = 0;
        while(rset.next())
        {
            String cur = PetTemplate;
	    String curButt=button;
            cur=cur.replace("%NAME%",rset.getString(2));	
            curButt=curButt.replace("%NAME%",rset.getString(2)); 
	    cur=cur.replace("%EMAIL%",rset.getString(1));
	    curButt=curButt.replace("%EMAIL%",rset.getString(1));
            cur=cur.replace("%BDO%",rset.getString(3));
	    curButt=curButt.replace("%BDO%",rset.getString(3).substring(0,10));
            cur=cur.replace("%BREED%",rset.getString(5));
            
            if(rset.getString(4).equals("y")){
                cur=cur.replace("%STER%","Yes");
            }
            else if(rset.getString(4).equals("n")){
                cur=cur.replace("%STER%","No");
            }
            check = rset.getString(5);

            if(check.equals("Dog")){
                cur=cur.replace("%ASPECT%",rset.getString(6)+" days of walking");
            }
            else if(check.equals("Rabbit")){
                if(rset.getString(7).equals("y")){
                    cur=cur.replace("%ASPECT%","Yes");
                }
                else if(rset.getString(7).equals("n")){
                    cur=cur.replace("%ASPECT%","No");
                }
                
            }
            else if(check.equals("Cat")){
                cur=cur.replace("%ASPECT%","None");
            }



            row=row +cur + curButt +"<br>";
            
            
        
            size++;

        }   
  
        if(size== 0){
            name = "No Pets found!";
            
        }
        

        stmt.close();
        conn.close();
        
    } 
    catch(Exception e) {
        
        String info = row + "<br>" + e.getMessage() + "<br>";	
        
    }
%>
<center>
    <h1> Pet List</h1>
    <div>
        <h3>All the Pets:</h3>	
        <%=row%>
        <%=name%>
       
        
    </div>

    
    <button onclick="Back()" style="width:100px; font-size: 15px; margin-top:70px;">Quit</button>
    
</center>



</body>

</html>

