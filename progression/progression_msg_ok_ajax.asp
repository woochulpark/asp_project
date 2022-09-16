<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
	code = request("Code")
	msgno = request("msgno")

	code = request("Code")

	'SQL = "exec [p_문자발송_부고안내] '"& code &"', '"& user_id &"', '"& msgno &"' "
	SQL = "exec [p_문자발송_부고안내] '"& code &"', '"& user_id &"', '"& msgno &"', '"& FnAesEncrypt(code, AesEncryptPwd) &"' "
	SQL2 = "select * from ums_data (nolock) where etc2 = '행사_부고안내' and etc4 = '"& code &"' and dest_phone = '"& msgno &"' "
	SQL3 = "select * from ums_log (nolock) where etc2 = '행사_부고안내' and etc4 = '"& code &"' and dest_phone = '"& msgno &"' "
	

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ	

	Set Rs = ConnAplus.execute(SQL2)

	If Rs.EOF Then
		sign = "N"
	Else
		sign = "Y"
	End If

	if sign = "N" then

		Set Rs = ConnAplus.execute(SQL3)

		If Rs.EOF Then
			sign = "N"
		Else
			sign = "Y2"
		End If

	end if	

	if sign = "N" then
		Set Rs = ConnAplus.execute(SQL)
		sign = "S"
	end if

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	
	
	response.write sign	

	response.End

%>