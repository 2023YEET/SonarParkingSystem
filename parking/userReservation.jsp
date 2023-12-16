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
        margin-bottom: 20px;
    }
    
    .item h3 {
        margin: 0;
        font-size: 18px;
    }
    
    .item p {
    	display: inline;
        margin: 5px 0;
    }
    
    .button-container {
        display: inline;
        padding-right: 20px;
        text-align: right;
        float: right;
    }
    
    .button {
        display: inline-block;
        width: 80px;
        height: 30px;
        padding: 10px;
        background-color: #4CAF50;
        color: white;
        border-radius: 4px;
        text-align: center;
        line-height: 30px;
        cursor: pointer;
    }
    
    h5 {
   		display: inline-block;
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
<title>AVS-<%=name %>'s Reservation</title>
</head>
<body>
<div id="main">
    <div id="banner"><h2>나의 예약 기록</h2></div>
    <div class="list-container">
<%
    try {
        MyConn = DriverManager.getConnection(sUrl, sUser, sPwd);
        String sql = "SELECT * FROM reservation WHERE useridx=? ORDER BY regdate DESC;";
        stmt = MyConn.prepareStatement(sql);
        stmt.setString(1, idx);
        ResultSet rs = stmt.executeQuery();
    
        while(rs.next()){
        	String reservNum = rs.getString("reserveidx");
            String carNum = rs.getString("carnum");
            String cellNum = rs.getString("cellnum");
            String reservTime = rs.getString("regdate");
			
%>
    <div class="item">
        <h3><%=cellNum %>번 주차공간</h3>
        <p>예약차량 : <%=carNum %>
        <div class="button-container">
		<a href="./reservationCancel.jsp?reserveNum=<%=reservNum %>&cellnum=<%=cellNum%>"><div class="button">예약 취소</div></a>
		</div>
        <p><h5>예약 시간 : <%=reservTime %></h5>
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
