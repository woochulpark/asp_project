<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check2.asp"-->

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
	
	If p8 = "" Then
		
	End If
	
	If p11 = "" Then
	
	End If
	
	If p14 = "" Then
	
	End if


	if p0 = "insert" then
		SQL = " INSERT INTO 행사_기타정보 (행사번호, 상주명, 연락처, 관계, 변경행사구분, 변경상품코드, 변경상품명, 지원서비스, 용품도착일, 화환도착일, 근조기설치일 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& code &"','"& p1 &"','"& p2 &"','"& p3 &"','"& p4 &"','"& p5 &"','"& p6 &"','"& p7 &"' "
		if p8 <> "" then
			SQL = SQL & " ,'"& p8_t &"' "
		Else
			SQL = SQL & " , NULL "
		end if
		if p11 <> "" then
			SQL = SQL & " ,'"& p11_t &"' "
		Else
			SQL = SQL & " , NULL "
		end if
		if p14 <> "" then
			SQL = SQL & " ,'"& p14_t &"' "
		Else
			SQL = SQL & " , NULL "
		end if
		SQL = SQL & " ) "
	else
		SQL = " update 행사_기타정보 set 상주명 = '"& p1 &"', 연락처 = '"& p2 &"', 관계 = '"& p3 &"', 변경행사구분 = '"& p4 &"', 변경상품코드 = '"& p5 &"', 변경상품명 = '"& p6 &"', 지원서비스 = '"& p7 &"' "
		if p8 <> "" then
			SQL = SQL & " , 용품도착일 = '"& p8_t &"' "
		Else
			SQL = SQL & " , 용품도착일 = NULL "
		end if
		if p11 <> "" then
			SQL = SQL & " , 화환도착일 = '"& p11_t &"' "
		Else
			SQL = SQL & " , 화환도착일 = NULL "
		end if
		if p14 <> "" then
			SQL = SQL & " , 근조기설치일 = '"& p14_t &"' "
		Else
			SQL = SQL & " , 근조기설치일 = NULL "
		end if		
		SQL = SQL & " where 행사번호 = '"& code &"' "
	end if

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	

	response.write "<script type='text/javascript'>"
	response.write "alert('저장되었습니다.');"
	response.write "location.replace('reception_etc_b.asp?Code="& FnAesEncrypt(code, AesEncryptPwd) &"');"
	response.write "</script>"	

	response.End

%>