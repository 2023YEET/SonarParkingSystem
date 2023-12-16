<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.DriverManager" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
    body {
        font-family: Arial, sans-serif;
        display: flex;
        background-color: #f2f2f2;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
    }
    
    #main {
        width: 400px;
        padding: 20px;
        background-color: #f2f2f2;
        border-radius: 5px;
    }
    
    #banner {
        text-align: center;
        margin-bottom: 20px;
    }
    
    .list-container {
        max-height: 300px;
        overflow-y: auto;
    }
        
    .list-container::-webkit-scrollbar {
        width: 0.5em;
    }
    
    .list-container::-webkit-scrollbar-track {
        background-color: transparent;
    }
    
    .list-container::-webkit-scrollbar-thumb {
        background-color: transparent;
    }
    
    .item {
        background-color: #fff;
        padding: 10px;
        margin-bottom: 10px;
    }
    
    .item h3 {
        margin: 0;
        font-size: 18px;
    }
    
    .item p {
        margin: 5px 0;
    }
</style>
<%
    String name = "";
    String idx = "";
    try{
        name = session.getAttribute("name").toString();
        idx = session.getAttribute("idx").toString();
    } catch(Exception e){
        response.sendRedirect("./Index.jsp");
    }
    
    Connection MyConn = null;
    String sUrl = "jdbc:mariadb://localhost:3306/parking";
    String sUser = "yeetpi";
    String sPwd = "a123123123";
    Class.forName("org.mariadb.jdbc.Driver");    
    PreparedStatement stmt = null;
%>
<title>AVS-<%=name %>'s Record</title>
</head>
<body>
<div id="main">
    <div id="banner"><h2>나의 출입 기록</h2></div>
    <div class="list-container">
<%
    try {
        MyConn = DriverManager.getConnection(sUrl, sUser, sPwd);
        String sql = "SELECT t.* FROM time t JOIN car c WHERE t.carnum=c.carnum AND c.useridx=?;";
        stmt = MyConn.prepareStatement(sql);
        stmt.setString(1, idx);
        ResultSet rs = stmt.executeQuery();
    
        while(rs.next()){
        	String timeidx = rs.getString("inoutnum");
        	String carNum = rs.getString("carnum");
            String inTime = rs.getString("intime");
            String outTime = rs.getString("outtime");
			
%>
    <div class="item">
    	<h5>No. <%=timeidx %></h5>
        <h2><%=carNum %></h2>
        <p><h4>입차 시간 : <%=inTime %></h4>
        <p><h4>출차 시간 : <%=outTime %></h4>
    </div>
<%          
        }
     } catch (Exception e) {
        e.printStackTrace();
     }
%>
    </div>
</div>
</body>
</html>
