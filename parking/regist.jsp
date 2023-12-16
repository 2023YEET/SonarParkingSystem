<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>AVS-regist</title>
</head>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f2f2f2;
        margin: 0;
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }

    div {
        width: 400px;
        background-color: #fff;
        padding: 20px;
        border-radius: 5px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }

    form {
        display: flex;
        flex-direction: column;
    }

    label {
        margin-bottom: 10px;
        font-weight: bold;
    }

    input[type="text"],
    input[type="password"] {
        padding: 5px;
        margin-bottom: 10px;
        border: 1px solid #ccc;
        border-radius: 3px;
    }

    input[type="submit"],
    input[type="button"] {
        padding: 8px 20px;
        background-color: #4CAF50;
        color: #fff;
        border: none;
        border-radius: 3px;
        cursor: pointer;
    }

    #registSubmit {
        margin-top: 10px;
        text-align: center;
        background-color: #4CAF50;
        padding: 8px 0;
        border-radius: 3px;
        cursor: pointer;
    }

    #registSubmit:hover {
        background-color: #45a049;
    }

    select {
        margin-bottom: 10px;
        padding: 5px;
        border: 1px solid #ccc;
        border-radius: 3px;
    }

    p {
        margin-bottom: 5px;
    }
</style>

<script>
function registFormCheck(){
	if (document.registForm.name.value==""){
		alert("이름을 입력하세요.");
		document.registForm.name.focus();
		return false;
	}
	
	if (document.registForm.name.value.length > 10){
		alert("10자 이하로 입력하세요");
		document.userForm.name.focus();
		return false;
	}
	
	if (document.registForm.id.value==""){
		alert("아이디를 입력하세요.");
		document.registForm.id.focus();
		return false;
	}
	
	if (document.registForm.pw.value==""){
		alert("비밀번호를 입력하세요.");
		document.registForm.pw.focus();
		return false;
	}
	
	if (document.registForm.pwchk.value==""){
		alert("비밀번호 확인을 입력하세요.");
		document.registForm.pwchk.focus();
		return false;
	}
	
	let pw = document.registForm.pw.value;
	let pwchk = document.registForm.pwchk.value;
	
	if(!(pw === pwchk)){
		alert("입력한 비밀번호가 다릅니다!");
		document.registForm.pwchk.focus();
		return false;
	}
	
	if (document.registForm.name.value==""){
		alert("아이디를 입력하세요.");
		document.registForm.name.focus();
		return false;
	}
	
	if (document.registForm.phone.value==""){
		alert("연락처를 입력하세요.");
		document.registForm.phone.focus();
		return false;
	}
	
	let telcheck = /^[0-9]+$/;
	if(!telcheck.test(document.registForm.phone.value)){
		alert("숫자만 입력해주세요");
		document.registForm.phone.focus();
		return false;
	}
	
	if (document.registForm.phone.value.length != 11){
		alert("11자리 번호만 입력할 수 있습니다.");
		document.registForm.phone.focus();
		return false;
	}
	
	if (document.registForm.email.value==""){
		alert("이메일을 입력하세요.");
		document.registForm.email.focus();
		return false;
	}
	
	if (!(document.registForm.gender[0].checked||document.registForm.gender[1].checked)){
		alert("성별을 선택하세요.");
		document.userForm.gender[0].focus();
		return false;
	}

	document.registForm.submit();
	return true;
};
</script>
<body>
	<div>
		<form name="registForm" action="registConfirm.jsp">
			<p>성명 : <input type="text" name="name">
			<p>아이디 : <input type="text" name="id">
			<p>비밀번호 : <input type="password" name="pw">
			<p>비밀번호 확인 : <input type="password" name="pwchk">
			<p>연락처 : <input type="text" name="phone">
			<p>이메일 : <input type="text" name="email">
			<p>생년월일 : <select name="year">
			<%
			for(int i=1900; i<=2023; i++){
			%>
			<option value=<%=i %>><%=i %></option>
			<%
			}
			%>
			</select>
			<select name="month">
			<%
			for(int i=1; i<=12; i++){
			%>
			<option value=<%=i %>><%=i %></option>
			<%
			}
			%>
			</select>
			<select name="day">
			<%
			for(int i=1; i<=31; i++){
			%>
			<option value=<%=i %>><%=i %></option>
			<%
			}
			%>
			</select>
			<p>성별 : 남<input type="radio" name="gender" value="0">
				    여<input type="radio" name="gender" value="1">
			<div id="registSubmit" onclick="registFormCheck()">가입</div>
		</form>
	</div>
</body>
</html>
