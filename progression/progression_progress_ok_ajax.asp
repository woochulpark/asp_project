<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
	code = request("Code")

	input0 = request.Form("input0")
	input1 = request.Form("input1")
	input2 = request.Form("input2")
	input3 = request.Form("input3")
	input4 = request.Form("input4")
	input5 = request.Form("input5")
	input6 = request.Form("input6")
	input7 = request.Form("input7")

	sdate = input2 & ":" & input3
	edate = input4 & ":" & input5

	SQL = "insert into 행사_장례진행 (행사번호, 일차, 근무일, 입실시간, 퇴실시간, 내용) "
	SQL = SQL & " values ('"& code &"', '"& input0 &"', '"& input1 &"', '"& sdate &"', '"& edate &"', '"& input6 &"') "	

	SQL2 = " update 행사_장례진행 set 근무일 = '"& input1 &"', 입실시간 = '"& sdate &"', 퇴실시간 = '"& edate &"', 내용 = '"& input6 &"' "
	SQL2 = SQL2 & " where 행사번호 = '"& code &"' and 일차 = '"& input0 &"' "

	SQL3 = " select 행사번호 from 행사_장례진행 where 행사번호 = '"& code &"' and 일차 = '"& input0 &"' "
	
	SQL4 = " select 행사번호 from 행사_장례진행 where 행사번호 = '"& code &"' and 일차 = '"& Cint(input0) - 1 &"' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL3)

	If Rs.EOF Then
		
		if Cint(input0) > 1 then
			Set Rs2 = ConnAplus.execute(SQL4)
			If Rs2.EOF Then
				stat = "error" '이전일 근무일지가 없을때
			Else
				stat = "insert" '이전일 근무일지가 있을때
			End If
			Set Rs2 = Nothing
		else
			stat = "insert" '1일차 근무일지 등록일때
		end if		
	Else
		stat = "update" '등록된 근무일지가 있을때		
	End If

	if stat = "insert" then
		ConnAplus.execute(SQL) '등록
	elseif stat = "update" then
		ConnAplus.execute(SQL2) '업데이트
	end if

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing
	
	response.write stat

	response.End

%>