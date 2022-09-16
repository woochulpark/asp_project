<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/conf/dbmsConnect.asp"-->

<%	
	code = Trim(request.Form("code"))	
	SignImg = Trim(request.Form("SignImg"))	
	SignP1 = Trim(request.Form("SignP1"))	
	
	SQL = " INSERT INTO 행사_회사지원서명 (행사번호, 서명) values ('"& code &"', '"& SignImg &"') "	

	SQL_2 = " UPDATE A SET 인수자 = '"& SignP1 &"' from 행사마스터_세부추가 A where 행사번호 = '"& code &"' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)
	Set Rs = ConnAplus.execute(SQL_2)

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	response.write "<script type='text/javascript'>"
	response.write "alert('저장되었습니다.');"
	response.write "location.replace('reception_sign.asp?Code="& code &"');"
	response.write "</script>"

	response.End

%>