<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>AVS-MyPage</title>
<style>
	html, body {
	  height: 100%;
	}
	
	body {
	  font-family: Arial, sans-serif;
	  background-color: #f2f2f2;
	  color: #333333;
	  margin: 0;
	  padding: 0;
	  display: flex;
	  justify-content: center;
	  align-items: center;
	  height: 100vh;
	}
	
	#main {
	  display: flex;
	  flex-direction: column;
	  align-items: center;
	  padding: 50px;
	  background-color: #ffffff;
	  border-radius: 5px;
	  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	}
	
	#banner {
	  text-align: center;
	  margin-bottom: 30px;
	}
	
	h3 {
	  font-size: 24px;
	  color: #555555;
	}
	
	.button {
	  display: block;
	  width: 200px;
	  padding: 10px 20px;
	  background-color: #4CAF50;
	  color: white;
	  text-align: center;
	  text-decoration: none;
	  cursor: pointer;
	  margin-bottom: 10px;
	  border-radius: 4px;
	}
	
	.button:hover {
	  background-color: #45a049;
	}
</style>
</head>
<body>
<%
    String user = "";

    try{
         user = session.getAttribute("name").toString();
    }
    catch(Exception e){
        response.sendRedirect("./Index.jsp");
    }
%>
<div id="main">
    <div id="banner"><h3><%=user %>님의 정보</h3></div>
    <a href="./userCar.jsp" class="button">등록 차량</a>
    <a href="./userReservation.jsp" class="button">예약 기록</a>
    <a href="./userRecord.jsp" class="button">출입 기록</a>
</div>
</body>
</html>
