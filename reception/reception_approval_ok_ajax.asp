<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
	code = request("Code")
	
	
	SQL = "select a.서명, isnull(b.상태,'') as 상태 "
	SQL = SQL & " from 행사_회사지원서명 a (nolock) "
	SQL = SQL & " left outer join 행사_승인요청 b (nolock) on a.행사번호 = b.행사번호 "	
	SQL = SQL & " where a.행사번호 = '" & code & "' "	
	
	SQL2 = " INSERT INTO 행사_승인요청 (행사번호, 상태) values ('"& code &"', '진행승인요청') "

	SQL3 = "select isnull(a.공급확인서, 'N') 공급확인서 "  
	SQL3 = SQL3 & " from 행사단체 a (nolock) "
	SQL3 = SQL3 & " 	inner join 행사마스터 b (nolock) on a.단체코드 = b.행사단체 "	
	SQL3 = SQL3 & " where 1=1 "
	SQL3 = SQL3 & " and b.행사번호 = '" & code & "' "	

	SQL4 = " DELETE 행사_승인요청 where 행사번호 = '"& code &"' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)

	ConnAplus.execute(SQL4)

	If Rs.EOF Then
		sign = "N"
	Else
		sign = "Y"
		stat = Rs("상태")
		if stat = "" then
			ConnAplus.execute(SQL2)
		end if
	End If

	Set Rs = Nothing

	if sign = "N" then

		Set Rs3 = ConnAplus.execute(SQL3)

		If Rs3.EOF Then
			sign = "Y"
			ConnAplus.execute(SQL2)

		Else
			if Rs3("공급확인서") = "N" then
				sign = "Y"
				ConnAplus.execute(SQL2)

			end if
			
		End If			
	end if

	Set Rs3 = Nothing

	ConnAplus.Close
	Set ConnAplus = Nothing

	
	
	if sign = "Y" then
		if stat = "" then 
			response.write "a"
		else
			response.write "b"
		end if
	else
		response.write "c"
	end if

	response.End

%>