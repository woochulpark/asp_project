<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
	
	code = Trim(request.Form("code"))
	input2 = Split(Trim(request.Form("input2")),",")
	input3 = Split(Trim(request.Form("input3")),",")
	input4 = Split(Trim(request.Form("input4")),",")
	input5 = Split(Trim(request.Form("input5")),",")
	input6 = Split(Trim(request.Form("input6")),",")
	input7 = Split(Trim(request.Form("input7")),",")
	input8 = Split(Trim(request.Form("input8")),",")
	input9 = Split(Trim(request.Form("input9")),",")

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	SQL_DELTE = " DELETE FROM 행사_회사지원 WHERE 행사번호 = '"& code &"' "
	
	Set Rs = ConnAplus.execute(SQL_DELTE)

	For i=0 To UBound(input2)

		SQL = " INSERT INTO 행사_회사지원 (행사번호, 순번, 사원코드, 사원명, 접수일, 일차, 출동일시, 종료일시 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& code &"', '"& i+1 &"', '"& input2(i) &"', '"& input3(i) &"', '"& input4(i) &"', '"& input5(i) &"', '"& input6(i) &":"& input7(i) &"', '"& input8(i) &":"& input9(i) &"' ) "
		'response.write SQL
		'response.End
		Set Rs = ConnAplus.execute(SQL)

    	Next	

	if request.Form("input3") <> "" and UBound(input3) = 0 then
		SQL = " INSERT INTO 행사_회사지원 (행사번호, 순번, 사원코드, 사원명, 접수일, 일차, 출동일시, 종료일시 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& code &"', '1', '"& request.Form("input2") &"', '"& request.Form("input3") &"', '"& request.Form("input4") &"', '"& request.Form("input5") &"', '"& request.Form("input6") &":"& request.Form("input7") &"', '"& request.Form("input8") &":"& request.Form("input9") &"' ) "
		'response.write SQL
		'response.End
		Set Rs = ConnAplus.execute(SQL)
	end if

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	response.write "<script type='text/javascript'>"
	'response.write "alert("&  request.Form("input3") &");"
	'response.write "alert("&  UBound(input3) &");"
	response.write "alert('등록되었습니다.');"
	response.write "location.replace('progression_sign.asp?Code="& code &"');"
	response.write "</script>"

	response.End

%>
