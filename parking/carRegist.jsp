<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>AVS-Regist Car</title>
</head>
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
    
    form {
        width: 300px;
        padding: 20px;
        background-color: #f2f2f2;
        border-radius: 5px;
    }
    
    input[type="text"],
    select {
            width: 100%;
		    padding: 10px;
		    margin-bottom: 10px;
		    border: 1px solid #ccc;
		    border-radius: 3px;
		    box-sizing: border-box;
		    }
    
    #registSubmit {
        background-color: #4CAF50;
        color: #fff;
        padding: 10px 20px;
        cursor: pointer;
        border-radius: 3px;
        box-sizing: border-box;
        display: inline-block;
        width: 100%;
        text-align: center;
    }
    
    #registSubmit:hover {
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
</style>
<script>
function registFormCheck(){
	if(document.carRegistForm.carnum.value==""){
		alert("차량번호를 입력하세요.");
		document.carRegistForm.carnum.focus();
		return false;
	}
	
	document.carRegistForm.submit();
}
</script>
<body>
<div id="main">
		<form name="carRegistForm" action="carRegistConfirm.jsp">
			<p>차량번호 : <input type="text" name="carnum">
			<p>차종류 : <select name="type">
						<option value="0">일반차량</option>
						<option value="1">하이브리드</option>
						<option value="2">전기차</option>
					 </select>
			<div id="registSubmit" onclick="registFormCheck()">등록</div>
		</form>
</div>
</body>
</html>