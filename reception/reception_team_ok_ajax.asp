<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	code = Trim(request("Code"))
	tcode = Trim(request("tcode"))
    tcenter = Trim(request("tcenter"))    

	SQL = "update 행사마스터 set 진행팀장 = '"& tcode &"', 센터 = '"& tcenter &"' where 행사번호 = '"& code &"' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ		
    
    ConnAplus.execute(SQL)

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	

	response.End
%>
