<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="javax.swing.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>AVS-login</title>
</head>
<body>
<%
	Connection MyConn = null;
	String sUrl = "jdbc:mariadb://localhost:3306/parking";
	String sUser = "yeetpi";
	String sPwd = "a123123123";
	Class.forName("org.mariadb.jdbc.Driver");	
	PreparedStatement stmt = null;
	
	request.setCharacterEncoding("utf-8");
	String rId = request.getParameter("id");
	String rPw = request.getParameter("pw");
	
	try {
		MyConn = DriverManager.getConnection(sUrl, sUser, sPwd);
	    String sql = "SELECT * FROM user WHERE id=? AND pw=?;";
	    stmt = MyConn.prepareStatement(sql);
        stmt.setString(1, rId);
        stmt.setString(2, rPw);
	    ResultSet rs = stmt.executeQuery();

	    while(rs.next()){
	        session.setAttribute("user", rId);
	        session.setAttribute("idx", rs.getString("useridx"));
	        session.setAttribute("name", rs.getString("name"));
	        System.out.println(rs.getString("useridx"));
	        response.sendRedirect("./userPage.jsp");
		}
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