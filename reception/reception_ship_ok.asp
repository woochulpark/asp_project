<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check2.asp"-->

<%	
	code = Trim(request.Form("code"))	
	gubun = Trim(request.Form("gubun"))	
	check = Trim(request.Form("check"))	
	
	input34 = Trim(request.Form("input34"))	
	p1 = Trim(request.Form("p1"))	
	p2 = Trim(request.Form("p2"))	
	p3 = Trim(request.Form("p3"))	
	p4 = Trim(request.Form("p4"))
	
	p_1 = Replace(p2, ".", "") & p3 & p4 
	p_2 = Replace(p2, ".", "-") & " " & p3 & ":" & p4 & ":00"

		
	If check = "0" Then
		If gubun = "1" Then
			SQL = " UPDATE A SET 용품인수자 = '"& p1 &"', 용품도착일시 = '"& p_1 &"' from 행사마스터_세부추가 A where 행사번호 = '"& input34 &"' "
			SQL2 = " UPDATE A SET 용품도착일 = '"& p_2 &"' from 행사_기타정보 A where 행사번호 = '"& input34 &"' "					
		ElseIf gubun = "2" Then
			SQL = " UPDATE A SET 화환인수자 = '"& p1 &"', 화환도착일시 = '"& p_1 &"' from 행사마스터_세부추가 A where 행사번호 = '"& input34 &"' "
			SQL2 = " UPDATE A SET 화환도착일 = '"& p_2 &"' from 행사_기타정보 A where 행사번호 = '"& input34 &"' "	
		ElseIf gubun = "3" Then
			SQL = " UPDATE A SET 조기인수자 = '"& p1 &"', 근조기설치 = '"& p_1 &"' from 행사마스터_세부추가 A where 행사번호 = '"& input34 &"' "
			SQL2 = " UPDATE A SET 근조기설치일 = '"& p_2 &"' from 행사_기타정보 A where 행사번호 = '"& input34 &"' "	
		End if

	ElseIf check = "3" Then
		SQL = " UPDATE A SET 용품인수자 = '"& p1 &"', 용품도착일시 = '"& p_1 &"', 화환인수자 = '"& p1 &"', 화환도착일시 = '"& p_1 &"' from 행사마스터_세부추가 A where 행사번호 = '"& input34 &"' "
		SQL2 = " UPDATE A SET 용품도착일 = '"& p_1 &"', 화환도착일 = '"& p_2 &"' from 행사_기타정보 A where 행사번호 = '"& input34 &"' "					

	ElseIf check = "4" Then
			SQL = " UPDATE A SET 용품인수자 = '"& p1 &"', 용품도착일시 = '"& p_1 &"', 조기인수자 = '"& p1 &"', 근조기설치 = '"& p_1 &"' from 행사마스터_세부추가 A where 행사번호 = '"& input34 &"' "
			SQL2 = " UPDATE A SET 용품도착일 = '"& p_2 &"', 근조기설치일 = '"& p_2 &"' from 행사_기타정보 A where 행사번호 = '"& input34 &"' "		

	ElseIf check = "5" Then
			SQL = " UPDATE A SET 화환인수자 = '"& p1 &"', 화환도착일시 = '"& p_1 &"', 조기인수자 = '"& p1 &"', 근조기설치 = '"& p_1 &"' from 행사마스터_세부추가 A where 행사번호 = '"& input34 &"' "
			SQL2 = " UPDATE A SET 화환도착일 = '"& p_2 &"', 근조기설치일 = '"& p_2 &"' from 행사_기타정보 A where 행사번호 = '"& input34 &"' "

	ElseIf check = "6" Then
			SQL = " UPDATE A SET 용품인수자 = '"& p1 &"', 용품도착일시 = '"& p_1 &"', 화환인수자 = '"& p1 &"', 화환도착일시 = '"& p_1 &"', 조기인수자 = '"& p1 &"', 근조기설치 = '"& p_1 &"' from 행사마스터_세부추가 A where 행사번호 = '"& input34 &"' "
			SQL2 = " UPDATE A SET 용품도착일 = '"& p_2 &"', 화환도착일 = '"& p_2 &"', 근조기설치일 = '"& p_2 &"' from 행사_기타정보 A where 행사번호 = '"& input34 &"' "	

	End If

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	'Response.write SQL & "<br><br>"
	'Response.write SQL2 & "<br><br>"
	'Response.end
	
	ConnAplus.execute(SQL)
	ConnAplus.execute(SQL2)

	ConnAplus.Close
	Set ConnAplus = Nothing

	response.write "<script type='text/javascript'>"
	response.write "alert('저장되었습니다.');"
	response.write "location.replace('reception_ship.asp?Code="& code &"&gubun="& gubun &" ' );"
	response.write "</script>"

	response.End

%>