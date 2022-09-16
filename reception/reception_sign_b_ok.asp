<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check2.asp"-->

<%	
	code = Trim(request.Form("code"))	
	SignImg = Trim(request.Form("SignImg"))	
	
	SQL = " INSERT INTO 행사_회사지원서명 (행사번호, 서명) values ('"& code &"', '"& SignImg &"') "	

	SQL2 = " INSERT INTO 행사_승인요청 (행사번호, 상태) values ('"& code &"', '진행승인요청') "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	ConnAplus.execute(SQL)
	ConnAplus.execute(SQL2)

	ConnAplus.Close
	Set ConnAplus = Nothing

	response.write "<script type='text/javascript'>"
	response.write "alert('저장되었습니다.');"
	response.write "location.replace('reception_sign_b.asp?Code="& FnAesEncrypt(code, AesEncryptPwd) &"');"
	response.write "</script>"

	response.End

%>