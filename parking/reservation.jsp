<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.DriverManager" %>
<!DOCTYPE html>
<html>
<head>
    <title>AVS-Reservation</title>
    <style>
        body {
            display: flex;
            background-color: #f2f2f2;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        
        #main {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 50px;
            background-color: #ffffff;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        #parkinglot {
            width: 100%;
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .parking-spot {
            width: 60px;
            height: 80px;
            background-color: grey;
            margin: 5px;
            display: flex;
            align-items: center;
            border-radius: 5px;
            justify-content: center;
            text-align: center;
            cursor: pointer;
        }
        
        #reservationButton {
            width: 150px;
            height: 40px;
            background-color: #4CAF50;
            border-radius: 4px;
            float: center;
            color: white;
            text-align: center;
            line-height: 40px;
            margin-top: 10px;
            justify-content: center;
            cursor: pointer;
        }

        #input { 	
            margin-top: 20px;
        }
    </style>
    <script>
        var selected = null;
        var originalColor = "#B5E61D";
        var selectedNum = " ";

        function handleClick(parkingSpot) {
            if (selected !== null) {
                selected.style.backgroundColor = originalColor;
                selectedNum = " ";
            }
            if (selected !== parkingSpot) {
                originalColor = parkingSpot.style.backgroundColor;
                parkingSpot.style.backgroundColor = "#4CAF50";
                selected = parkingSpot;
                selectedNum = parkingSpot.getAttribute("value");
                changeCellValue("cellnum", selectedNum);
            } else {
                selected = null;
            }
        }
        
        function reservation(){
            if(selectedNum == 0){
                alert("주차 공간을 선택하세요!");
            }
            else{
                document.reservationForm.submit();
            }
        }
        
        function changeCellValue(name, newValue) {
            var divElements = document.getElementsByName(name);
            for (var i = 0; i < divElements.length; i++) {
                var divElement = divElements[i];
                divElement.setAttribute("value", newValue);
            }
        }
    </script>
</head>
<body>
<div id="main">
<div id="parkinglot">
<%
    if(session.getAttribute("idx")==null){
        response.sendRedirect("./Index.jsp");
    }
    
    Connection MyConn = null;
    String sUrl = "jdbc:mariadb://localhost:3306/parking";
    String sUser = "yeetpi";
    String sPwd = "a123123123";
    Class.forName("org.mariadb.jdbc.Driver");    
    PreparedStatement stmt = null;
    
    try {
        MyConn = DriverManager.getConnection(sUrl, sUser, sPwd);
        String sql = "SELECT * FROM pavailable;";
        stmt = MyConn.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();
    
        while(rs.next()){
            int num = rs.getInt("cellnum");
            if(rs.getInt("occupied")==1){
%>
    <div class="parking-spot" value=<%=num %>><%=num %>번 칸</div>
<%          
            }
            if(rs.getInt("occupied")==0){
%>
    <div class="parking-spot" onclick="handleClick(this)" value=<%=num %> style="background:#B5E61D"><%=num %>번 칸</div>
<%  
            }
        }
     } catch (Exception e) {
        e.printStackTrace();
     }
%>
	</div>
    <div id="input">
    <form name="reservationForm" action="./reservationConfirm.jsp">
        <div>예약할 차량 : <select name="carnum">
<%
    try {
        MyConn = DriverManager.getConnection(sUrl, sUser, sPwd);
        String sql = "SELECT * FROM car WHERE useridx=?;";
        stmt = MyConn.prepareStatement(sql);
        try {
            String idx = session.getAttribute("idx").toString();
            stmt.setString(1, idx);
            ResultSet rs = stmt.executeQuery();
            System.out.println(idx);
        
            while(rs.next()){
                String carnum = rs.getString("carnum");
%>
        <option value=<%=carnum %>><%=carnum %></option>
<%
            }
        } catch (Exception e2){
            response.sendRedirect("./Index.jsp");
        }
     } catch (Exception e) {
        e.printStackTrace();
     } finally {
        if (stmt != null) { try { stmt.close(); } catch (SQLException e2) { e2.printStackTrace();}
        }
        if (MyConn != null) { try { MyConn.close(); } catch (SQLException e2) { e2.printStackTrace();}
        }
     }
%>
        </select></div>
        <input type="hidden" name="cellnum" value="">
        <div id="reservationButton" onclick="reservation()">예약하기</div>
    </form>
    </div>
</div>
</body>
</html>
