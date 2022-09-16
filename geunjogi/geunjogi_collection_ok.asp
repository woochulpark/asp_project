<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/conf/dbmsConnect.asp"-->

<%
	
	input_code = Trim(request("code"))
	input_type = Trim(request("collType"))
	input_cName = Trim(request("collName"))
	input_cDate = Trim(request("collDate"))
	input_cHour = Trim(request("collHour"))
	input_cMin = Trim(request("collMin"))	

	input_date = input_cDate & " " & input_cHour & ":" & input_cMin

	if input_type = "a" then
		SQL = " INSERT INTO 근조기회수 (행사번호, 회수자, 회수일 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& input_code &"','"& input_cName &"','"& input_date &"' ) "
	elseif input_type = "b" then
		SQL = " UPDATE 근조기회수 SET 회수자 = '"& input_cName &"', 회수일 = '"& input_date &"' WHERE 행사번호 = '"& input_code &"' "
	else
		SQL = " DELETE FROM 근조기회수 WHERE 행사번호 = '"& input_code &"' "
	end if

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	response.End

%>