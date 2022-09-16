<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
	
	code = Trim(request.Form("code"))	
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
	p29 = Trim(request.Form("p29"))	

	p1 = p1 & " " & p2 & ":" & p3 & ":00"
	p4 = p4 & " " & p5 & ":" & p6 & ":00"
	p23_t = p23 & " " & p24 & ":" & p25 & ":00"
	p26_t = p26 & " " & p27 & ":" & p28 & ":00"

	if p29 = "insert" then
		SQL = " INSERT INTO 행사_고인정보 (행사번호, 빈소도착, 별세일시, 고인명, 고인성별, 고인연령, 사망사유, 장례형태, 장례진행종교, 장례식장코드, 장례식장명,  "
		SQL = SQL & " 호실, [1차장지], [1차장지코드], [2차장지], 버스사용여부, 버스장지, 리무진사용여부, 리무진장지 "
		if p23 <> "" then
			SQL = SQL & " , 입관일시 "
		end if
		if p26 <> "" then
			SQL = SQL & " , 발인일시 "
		end if
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& code &"','"& p1 &"','"& p4 &"','"& p7 &"','"& p8 &"','"& p9 &"','"& p10 &"','"& p11 &"','"& p12 &"','"& p14 &"','"& p13 &"', "
		SQL = SQL & " '"& p15 &"','"& p16 &"','"& p17 &"','"& p18 &"','"& p19 &"','"& p20 &"','"& p21 &"','"& p22 &"' "
		if p23 <> "" then
			SQL = SQL & " ,'"& p23_t &"' "
		end if
		if p26 <> "" then
			SQL = SQL & " ,'"& p26_t &"' "
		end if
		SQL = SQL & " ) "
	else
		SQL = " update 행사_고인정보 set 빈소도착 = '"& p1 &"', 별세일시 = '"& p4 &"', 고인명 = '"& p7 &"', 고인성별 = '"& p8 &"', 고인연령 = '"& p9 &"', 사망사유 = '"& p10 &"', "
		SQL = SQL & " 장례형태 = '"& p11 &"', 장례진행종교 = '"& p12 &"', 장례식장코드 = '"& p14 &"', 장례식장명 = '"& p13 &"', 호실 = '"& p15 &"', [1차장지] = '"& p16 &"',  "
		SQL = SQL & " [1차장지코드] = '"& p17 &"', [2차장지] = '"& p18 &"', 버스사용여부 = '"& p19 &"', 버스장지 = '"& p20 &"', 리무진사용여부 = '"& p21 &"', 리무진장지 = '"& p22 &"' "
		if p23 <> "" then
			SQL = SQL & " , 입관일시 = '"& p23_t &"' "
		end if
		if p26 <> "" then
			SQL = SQL & " , 발인일시 = '"& p26_t &"' "
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
	response.write "location.replace('reception_goin.asp?Code="& code &"');"
	response.write "</script>"	


	response.End

%>