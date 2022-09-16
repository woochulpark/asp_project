<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
	
	code = Trim(request.Form("code"))
	p11 = Trim(request.Form("p11"))	
	p15 = Trim(request.Form("p15"))
	p16 = Trim(request.Form("p16"))
	p17 = Trim(request.Form("p17"))
	p18 = Trim(request.Form("p18"))
	p19 = Trim(request.Form("p19"))
	p20 = Trim(request.Form("p20"))
	p21 = Trim(request.Form("p21"))
	p22 = Trim(request.Form("p22"))
	p23 = Trim(request.Form("p23"))
	p24 = Trim(request.Form("p24"))
	p25 = Trim(request.Form("p25"))
	p26 = Trim(request.Form("p26"))
	p27 = Trim(request.Form("p27"))
	p28 = Trim(request.Form("p28"))
	
	If p24 = "" Then
		p24 = "00"
	End if

	If p25 = "" Then
		p25 = "00"
	End If

	If p27 = "" Then
		p27 = "00"
	End If

	If p28 = "" Then
		p28 = "00"
	End If


	p23_t = p23 & " " & p24 & ":" & p25 & ":00"
	p26_t = p26 & " " & p27 & ":" & p28 & ":00"

	
	SQL = " update 행사_고인정보 set "
	SQL = SQL & " 장례형태 = '"& p11 &"', 호실 = '"& p15 &"', [1차장지] = '"& p16 &"', "
	SQL = SQL & " [1차장지코드] = '"& p17 &"', [2차장지] = '"& p18 &"', 버스사용여부 = '"& p19 &"', 버스장지 = '"& p20 &"', 리무진사용여부 = '"& p21 &"', 리무진장지 = '"& p22 &"' "
	if p23 <> "" then
		SQL = SQL & " , 입관일시 = '"& p23_t &"' "
	end if
	if p26 <> "" then
		SQL = SQL & " , 발인일시 = '"& p26_t &"' "
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
	response.write "location.replace('progression_goin.asp?Code="& code &"');"
	response.write "</script>"	


	response.End

%>