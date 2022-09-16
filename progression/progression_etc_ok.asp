<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/conf/dbmsConnect.asp"-->

<%
	
	code = Trim(request.Form("code"))	
	p0 = Trim(request.Form("p0"))	
	p1 = Trim(request.Form("p1"))
	p2 = Trim(request.Form("p2"))
	p3 = Trim(request.Form("p3"))
	p4 = Trim(request.Form("p4"))
	p5 = Trim(request.Form("p5"))
	p6 = Trim(request.Form("p6"))
	p7 = Trim(request.Form("p7"))
	p8 = Trim(request.Form("p8"))
	p9 = Trim(request.Form("p9"))
	p10 = Trim(request.Form("p10"))
	p11 = Trim(request.Form("p11"))
	p12 = Trim(request.Form("p12"))
	p13 = Trim(request.Form("p13"))
	p14 = Trim(request.Form("p14"))
	p15 = Trim(request.Form("p15"))
	p16 = Trim(request.Form("p16"))
	p17 = Trim(request.Form("p17"))	

	p8_t = p8 & " " & p9 & ":" & p10 & ":00"
	p11_t = p11 & " " & p12 & ":" & p13 & ":00"
	p14_t = p14 & " " & p15 & ":" & p16 & ":00"
	
	SQL = " update 행사_기타정보 set 행사번호 = '"& code &"' "
	if p8 <> "" then
		SQL = SQL & " , 용품도착일 = '"& p8_t &"' "
	end if
	if p11 <> "" then
		SQL = SQL & " , 화환도착일 = '"& p11_t &"' "
	end if
	if p14 <> "" then
		SQL = SQL & " , 근조기설치일 = '"& p14_t &"' "
	end if		
	SQL = SQL & " where 행사번호 = '"& code &"' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	response.write "<script type='text/javascript'>"
	response.write "alert('저장되었습니다.');"
	response.write "location.replace('progression_etc.asp?Code="& code &"');"
	response.write "</script>"	

	response.End

%>