<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
	code = request("Code")


	'SQL = "exec [p_문자발송_설문조사] '"& code &"', '"& user_id &"', '"& FnAesEncrypt(code, AesEncryptPwd) &"' "	
	'SQL2 = "select * from ums_data (nolock) where etc2 = '행사_설문조사' and dest_phone not in ('01033001620', '01036828963') and etc4 = '"& code &"' "
	'SQL3 = "select * from ums_log (nolock) where etc2 = '행사_설문조사' and dest_phone not in ('01033001620', '01036828963') and etc4 = '"& code &"' "

	SQL = "exec [P_문자전송_알림톡_행사_발송_템플릿] '"& code &"', 'aplus_98_001_02', '만족도평가_의전팀장' "
	
	SQL2 = "select * from MZSENDLOG (nolock) where SUBJECT = '[A+라이프 효담 상조] 만족도 평가' "
	SQL2 = SQL2 & " and PHONE_NUM not in ('01033001620', '01036828963') and isnull(SMS_RCPT_MSG, '') in ('전송성공', '') and right(sn,13) = '"& code &"' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL2)

	If Rs.EOF Then
		sign = "N"
	Else
		sign = "Y2"
	End If

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