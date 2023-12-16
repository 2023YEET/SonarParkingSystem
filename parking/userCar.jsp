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
        margin-bottom: 10px;
    }
    
    .item h3 {
    	display: inline;
        margin: 0;
        font-size: 18px;
    }
    
    .item p {
        margin: 5px 0;
    }
    
    .button-container {
        display: inline;
        text-align: right;
        padding: 10px;
        float: right;
    }
    
    .button {
        display: inline-block;
        width: 80px;
        height: 30px;
        background-color: #4CAF50;
        color: white;
        border-radius: 4px;
        text-align: center;
        line-height: 30px;
        cursor: pointer;
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
<title>AVS-<%=name %>'s car</title>
</head>
<body>
<div id="main">
    <div id="banner"><h2>나의 등록 차량</h2></div>
    <div class="list-container">
<%
    try {
        MyConn = DriverManager.getConnection(sUrl, sUser, sPwd);
        String sql = "SELECT * FROM car WHERE useridx=?;";
        stmt = MyConn.prepareStatement(sql);
        stmt.setString(1, idx);
        ResultSet rs = stmt.executeQuery();
    
        while(rs.next()){
            String carNum = rs.getString("carnum");
            String carType = rs.getString("ctype");
            if(carType.equals("0")) carType = "일반차량";
            if(carType.equals("1")) carType = "하이브리드";
            if(carType.equals("2")) carType = "전기차";
%>
    <div class="item">
        <h3><%=carNum %></h3>
		<div class="button-container">
		<a href="./carCancel.jsp?carnum=<%=carNum%>&idx=<%=idx%>"><div class="button">등록 취소</div></a>
		</div>
        <p><%=carType %></p>
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
