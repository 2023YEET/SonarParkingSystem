<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>AVS</title>
<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f1f1f1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

#banner {
    margin-bottom: 20px;
    text-align: center;
}

h1 {
    color: #333;
    text-align: center;
    margin: 0;
}

form {
    width: 300px;
    padding: 20px;
    margin-top: 20px;
    background-color: #fff;
    border: 1px solid #ccc;
    border-radius: 5px;
}

input[type="text"],
input[type="password"] {
    width: 100%;
    padding: 10px;
    margin-bottom: 10px;
    border: 1px solid #ccc;
    border-radius: 3px;
    box-sizing: border-box;
}

label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
}

#loginButton,
#registButton {
    display: inline-block;
    padding: 10px 20px;
    background-color: #333;
    color: #fff;
    text-decoration: none;
    border-radius: 3px;
    text-align: center;
    cursor: pointer;
}

#loginButton:hover,
#registButton:hover {
    background-color: #555;
}

#loginButton {
    margin-right: 10px;
}

#registButton {
    background-color: #888;
}

</style>
</head>
<script>
function loginForm(){
    if(document.userForm.id.value==""){
        alert("아이디를 입력하세요.");
        return false;
    }
    if(document.userForm.pw.value==""){
        alert("비밀번호를 입력하세요.");
        return false;
    }
    document.userForm.submit();
    return true;
}
</script>
<body>
<div id="banner">
    <h1>Auto Vallet System</h1>
</div>
<%
    if(session.getAttribute("name")!=null){
        response.sendRedirect("./userPage.jsp");
    }
%>
<form name="userForm" action="./login.jsp">
    <div>
        <label for="id">아이디:</label>
        <input type="text" name="id" id="id">
    </div>
    <div>
        <label for="pw">비밀번호:</label>
        <input type="password" name="pw" id="pw">
    </div>
    <div>
        <button id="loginButton" onclick="loginForm()">로그인</button>
        <a href="./regist.jsp" id="registButton">회원가입</a>
    </div>
</form>
</body>
</html>
