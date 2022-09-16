<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	code = Trim(request("Code")) '행사번호
	mname = Trim(request("mname")) '변경계약자명
	mphone = Trim(request("mphone")) '변경휴대폰
	mname_o = Trim(request("mname_o")) '이전계약자명
	mname_o2 = Trim(request("mname_o2")) '이전회원명
	gcode = Trim(request("gcode")) '계약코드
	mcode = Trim(request("mcode")) '회원코드	

	'SQL = "update 행사계약마스터 set 계약자명 = '"& mname &"', 계약자휴대폰 = '"& mphone &"' where 행사번호 = '"& code &"' "

	'효담 DB에는 프로시져 호출
	SQL = "exec p_행사등록_회원명변경 '"& code &"', '"& mcode &"', '"& gcode &"', '"& mname &"', '"& mphone &"', '"& mname_o &"', '"& mname_o2 &"', '"& user_id &"'"

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ		
    
    ConnAplus.execute(SQL)

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	
	
	response.End
%>
