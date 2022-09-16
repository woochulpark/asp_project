<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
	code = request("Code")

	SQL = "select a.일차, isnull(b.상태,'') as 상태 "
	SQL = SQL & " from 행사_장례진행 a "	
	SQL = SQL & " left outer join 행사_승인요청 b on a.행사번호 = b.행사번호 "	
	SQL = SQL & " where a.행사번호 = '" & code & "' and a.일차 = 1 "
	
	SQL2 = "UPDATE 행사_승인요청 SET 상태 = '완료승인요청', 등록일 = getdate() where 행사번호 = '"& code &"'"

	SQL3 = "insert into 행사_승인요청 (행사번호, 상태, 등록일) values ( '"& code &"', '완료승인요청', getdate() ) "

	SQL4 = "select DATEDIFF(DAY, LEFT(행사시작일시, 8), LEFT(isnull(행사종료일시, 행사시작일시), 8)) + 1 as 일차, 일반단체구분 "
	SQL4 = SQL4 & "from 행사마스터 (nolock) "
	SQL4 = SQL4 & "where 행사번호 = '" & code & "'"

	SQL5 = "SELECT ISNULL(COUNT(*), 0) AS 개수 "
	SQL5 = SQL5 & "FROM 행사_장례진행 NOLCOK "
	SQL5 = SQL5 & "WHERE 행사번호 = '" & code & "' and LEN(REPLACE(ISNULL(CONVERT(varchar(MAX), 내용), ''), ' ', '')) > 4 "
	SQL5 = SQL5 & "GROUP BY 행사번호 "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL4)
	workday =  rs("일차")
	division = rs("일반단체구분")

	Set Rs = ConnAplus.execute(SQL5)
	
	If Rs.eof Then
		cnt = 0
	Else 
		cnt = Rs("개수")
	End If

	If workday > 3 Then 
		workday = 3
	End If

	If division = "저가형" Then
		workday = 1
	End If

	'Response.write workday & " " & cnt & " "
	'일반단체구분 : 저가형인 경우 근무일지가 1개여도 가능하다.
	'근무일지와 일수는 같아야 한다. 3일이하만 확인 (근무일지가 부득이하게 3개지만 일자가 4일인 경우가 있어서)
	If  cnt < workday Then
		stattype = "z"
	Else 
		Set Rs = ConnAplus.execute(SQL)

		If Rs.EOF Then
			stattype = "c"
		Else		
			stattype = "d"
			stat = Rs("상태")

			if stat = "" then
				ConnAplus.execute(SQL3)
				stattype = "a"
			Elseif stat = "진행승인확인" then
				ConnAplus.execute(SQL2)
				stattype = "a"
			elseif stat = "완료승인요청" then
				stattype = "b"	
			end if
		End If
	End If

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing
	
	response.Write stattype

	response.End

%>