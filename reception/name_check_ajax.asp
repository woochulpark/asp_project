<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	name = request("name")
	jumin = request("jumin")

	SQL = "SELECT * FROM 개인실명확인이력 WHERE 이름='" & name & "' AND 주민번호='"& jumin & "' and 결과코드 in ('1', '3') "

	'Response.write SQL
	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ	

    Set rs = ConnAplus.execute(SQL)    

	If rs.bof Or rs.eof Then        
		nameCheck = "false"
    Else
	    nameCheck = "true"
	End If

	Set rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	

	Response.write nameCheck
	response.End	
%>
