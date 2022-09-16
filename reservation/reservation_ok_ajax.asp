<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/conf/dbmsConnect.asp"-->

<%
	rType = request("rType")
	rName = request("rName")
	rPhone = request("rPhone")

	SQL = "INSERT INTO 상담예약 (상담종류, 이름, 연락처) values "	
	SQL = SQL & " ('"& rType &"', '"& rName &"', '"& rPhone &"') "	

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	ConnAplus.execute(SQL)	

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	

	response.End

%>