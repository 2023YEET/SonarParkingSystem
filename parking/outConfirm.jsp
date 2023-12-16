<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.DriverManager" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>AVS-Out</title>
</head>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f2f2f2;
        margin: 0;
        padding: 0;
    }

    #confirmCard {
        width: 400px;
        margin: 50px auto;
        background-color: #fff;
        padding: 20px;
        border-radius: 5px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        text-align: center;
    }

    h2 {
        margin-bottom: 20px;
    }

    a {
        text-decoration: none;
        color: #4CAF50;
        font-weight: bold;
    }

    a:hover {
        text-decoration: underline;
    }

    div {
        margin-top: 10px;
    }
</style>
<body>
	<%
	request.setCharacterEncoding("utf-8");
	String rCarnum = request.getParameter("carnum");
	String idx = session.getAttribute("idx").toString();
	
	Connection MyConn = null;
	String sUrl = "jdbc:mariadb://localhost:3306/parking";
	String sUser = "yeetpi";
	String sPwd = "a123123123";
	Class.forName("org.mariadb.jdbc.Driver");	
	PreparedStatement stmt = null;
	//reservnum cellnum carnum useridx
	try {
		MyConn = DriverManager.getConnection(sUrl, sUser, sPwd);
	    String sql = "UPDATE time t INNER JOIN car c ON t.carnum = c.carnum SET t.outtime=now() WHERE c.useridx = ? AND t.carnum = ? AND t.outtime is null;";
	    stmt = MyConn.prepareStatement(sql);
	
        stmt.setString(1, idx);
        stmt.setString(2, rCarnum);
        stmt.executeUpdate();
        
        sql = "SELECT cellnum FROM pavailable WHERE carnum = ?;";
	    stmt = MyConn.prepareStatement(sql);
	
        stmt.setString(1, rCarnum);
        ResultSet rs = stmt.executeQuery();
        String targetCellnum = "";
        
        while(rs.next()){
        	targetCellnum = rs.getString("cellnum");
        }
        
        sql = "UPDATE pavailable SET carnum = null, occupied = 0 WHERE cellnum = ?;";
	    stmt = MyConn.prepareStatement(sql);
	
        stmt.setString(1, targetCellnum);
        stmt.executeUpdate();
        
        sql = "DELETE FROM reservation WHERE useridx=?;";
	    stmt = MyConn.prepareStatement(sql);
	
        stmt.setString(1, idx);
        stmt.executeUpdate();      
%>
<div id="confirmCard">
<h2>출차 확인되었습니다.</h2>
<a href="./Index.jsp"><div id="button">확인</div></a>
</div>
<%
        
	 } catch (Exception e) {
		    e.printStackTrace();
%>
<div id="confirmCard">
<h2>문제가 발생했습니다. 다시 시도하여 주십시오.</h2>
<a href="./Index.jsp"><div id="button">돌아가기</div></a>
</div>
<%
	 } finally {
	    if (stmt != null) { try { stmt.close(); } catch (SQLException e2) { e2.printStackTrace();}
	    }
	    if (MyConn != null) { try { MyConn.close(); } catch (SQLException e2) { e2.printStackTrace();}
	    }
	 }
%>
</body>
</html>