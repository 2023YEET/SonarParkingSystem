<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.DriverManager" %>
<html>
<head>
<meta charset="UTF-8">
<title>AVS-main</title>
<style>
/* CSS styles for centering content */
	html, body {
	  height: 100%;
	}
	
	body {
	  display: flex;
	  background-color: #f2f2f2;
	  flex-direction: column;
	  justify-content: center;
	  align-items: center;
	}
	
	/* CSS styles for banner */
	#banner {
	  text-align: center;
	  margin-bottom: 20px;
	}
	
	/* CSS styles for buttons */
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
	
	.carbutton {
      display: inline-block;
	  width: 40px;
	  padding: 10px 20px;
	  background-color: #4CAF50;
	  color: white;
	  text-align: center;
	  text-decoration: none;
	  cursor: pointer;
	  margin-bottom: 10px;
	  border-radius: 4px;
    }
    
    .carbutton:hover {
	  background-color: #45a049;
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

    .dropdown {
	  display: block;
	  width: 240px;
	  text-align: center;
	  line-height: 41px;
	  text-decoration: none;
	  cursor: pointer;
	  border-radius: 4px;
    }

    .dropdown-button {
    	display: block;
    	width: 240px;
    	height: 41px;
        background-color: #f9f9f9;
        border: 1px solid #ddd;
        text-align: center;
        line-height: 41px;
	  	text-decoration: none;
	 	cursor: pointer;
	 	margin-bottom: 10px;
	 	border-radius: 4px;
    }

    .dropdown-content {
   		display: block;
   		width: 240px;
        position: absolute;
        background-color: #f9f9f9;
        border: 1px solid #ddd;
        border-radius: 4px;
        display: none;
        z-index: 1;
        max-height: 150px;
        overflow-y: auto;
        cursor: pointer;
    }

    .dropdown-content::-webkit-scrollbar {
        width: 0;
    }

    .dropdown-content a {
        display: block;
        width: 230px;
        height: 41px;
        padding: 5px;
        text-align: center;
        border: 1px solid #ddd;
        line-height: 41px;
        cursor: pointer;
    }
</style>
</head>
<body>
<%	
	String user = session.getAttribute("name").toString();
	String idx = session.getAttribute("idx").toString();
%>
<div id="main">
  <div id="banner"><p><h2><%=user %>님 환영합니다.</h2></div>
  <a href="./carRegist.jsp" class="button"><div id="registCar">차량등록</div></a>
  <a href="./reservation.jsp" class="button"><div id="reservation">예약하기</div></a>
  <a href="./myPage.jsp" class="button"><div id="parkingStat">내 정보</div></a>
  <div class="dropdown">
  	<form>
  	 	<input type="hidden" name="carnum">
  	</form>
    <div class="dropdown-button" onclick="toggleDropdown()">차량선택</div>
		<div class="dropdown-content">
<%
	Connection MyConn = null;
	String sUrl = "jdbc:mariadb://localhost:3306/parking";
	String sUser = "yeetpi";
	String sPwd = "a123123123";
	Class.forName("org.mariadb.jdbc.Driver");	
	PreparedStatement stmt = null;
	
    try {
        MyConn = DriverManager.getConnection(sUrl, sUser, sPwd);
        String sql = "SELECT * FROM car WHERE useridx=?;";
        stmt = MyConn.prepareStatement(sql);
        stmt.setString(1, idx);
        ResultSet rs = stmt.executeQuery();
        
        while(rs.next()){
        	String carnum = rs.getString("carnum");
%>
        <a onclick="selectItem('<%=carnum%>')"><%=carnum%></a>
<%          
        };
     } catch (Exception e) {
        e.printStackTrace();
     };
%>
	</div>
  	</div>
  	<div class="iobuttons">
 		<a onclick="inCheck()" class="carbutton"><div id="in">입차</div></a>
  		<a onclick="outCheck()" class="carbutton"><div id="out">출차</div></a>  
	</div>
  <a href="./logout.jsp" class="button"><div id="logout">로그아웃</div></a>
  </div>
  <script>
    var dropdownContent = document.querySelector('.dropdown-content');
    var dropdownButton = document.querySelector('.dropdown-button');

    function toggleDropdown() {
        if (dropdownContent.style.display === 'none') {
            dropdownContent.style.display = 'block';
        } else {
            dropdownContent.style.display = 'none';
        }
    }

    function selectItem(item) {
        dropdownButton.textContent = item;
        dropdownContent.style.display = 'none';
    }

    document.addEventListener('click', function(e) {
        if (!dropdownButton.contains(e.target) && !dropdownContent.contains(e.target)) {
            dropdownContent.style.display = 'none';
        }
    });
    
	function inCheck(){
		location.href="./inConfirm.jsp?carnum="+dropdownButton.textContent;
	}
	
	function outCheck(){
		location.href="./outConfirm.jsp?carnum="+dropdownButton.textContent;
	}
</script>
</body>
</html>
