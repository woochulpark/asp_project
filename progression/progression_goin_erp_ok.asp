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

	If p2 = "" Then
		p2 = "00"
	End If

	If p3 = "" Then
		p3 = "00"
	End If
	
	If p5 = "" Then
		p5 = "00"
	End If

	If p6 = "" Then
		p6 = "00"
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
	
	p1_s = Replace(p1 & p2 & p3, "-", "")
	p4_s = Replace(p4 & p5 & p6, "-", "")
	p23_s = Replace(p23 & p24 & p25, "-", "")
	p26_s = Replace(p26 & p27 & p28, "-", "")

	SQL2 = " update 행사마스터 set 도착일시 = '"& p1_s &"', 별세일 = '"& p4_s &"', 고인성명 = '"& p7 &"', 고인성별 = '"& p8 &"', 연령 = '"& p9 &"', 부고사유 = '"& p10 &"', "
	SQL2 = SQL2 & " 장례형태 = '"& p11 &"', 종교 = '"& p12 &"', 장례식장 = '"& p14 &"', 빈소 = '"& p15 &"', 장지 = '"& p16 &"',  "
	SQL2 = SQL2 & " 장지2 = '"& p18 &"', 버스사용 = '"& p19 &"', 버스방향 = '"& p20 &"', 리무진사용 = '"& p21 &"', 리무진방향 = '"& p22 &"', "
	SQL2 = SQL2 & " 입관일시 = '"& p23_s &"', 발인일시 = '"& p26_s &"' "
	SQL2 = SQL2 & " where 행사번호 = '"& code &"' "		

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	ConnAplus.execute(SQL)
	ConnAplus.execute(SQL2)
	
	ConnAplus.Close
	Set ConnAplus = Nothing

	response.write "<script type='text/javascript'>"
	response.write "alert('저장되었습니다.');"
	response.write "location.replace('progression_goin.asp?Code="& code &"');"
	response.write "</script>"	


	response.End

%>