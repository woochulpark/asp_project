<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check2.asp"-->

<%
	
	code = Trim(request.Form("code"))

	If Right(code,2) = "==" Then
		DB_ENC = "Y"
		code_enc = code
	Else
		DB_ENC = "N"	
		code_enc = FnAesEncrypt(code, AesEncryptPwd)
	End If
	
	qna1 = Trim(request.Form("qna1"))
	qna2 = Trim(request.Form("qna2"))
	qna3 = Trim(request.Form("qna3"))
	qna4 = Trim(request.Form("qna4"))
	qna5 = Trim(request.Form("qna5"))
	qna6 = Trim(request.Form("qna6"))
	qna7 = Trim(request.Form("qna7"))
	qna8 = Trim(request.Form("qna8"))

	st = Trim(request.Form("st"))
	dt = Trim(request.Form("dt"))
	tcode = Trim(request.Form("tcode"))
	gcode = Trim(request.Form("gcode"))
	hcode = Trim(request.Form("hcode"))

	gubun = Trim(request.Form("gubun"))

	If gubun = "일반" Or gubun = "단체" Or gubun = "저가형상향" Then
		f_url = "qna_write.asp"
	Else
		f_url = "qna_write_02.asp"
	End if
	
	total = CInt(qna1) + CInt(qna2) + CInt(qna3) + CInt(qna4) + CInt(qna5) + CInt(qna6)

	SQL = "Exec p_행사모니터링 'I', '"& code &"', '"& gcode &"', '"& tcode &"', '"& st &"', '"& dt &"', '"& qna1 &"', '"& qna2 &"', '"& qna3 &"', '"& qna4 &"', '"& qna5 &"', '"& qna6 &"', '"& total &"', '"& qna7 &"', '', '"& qna8 &"' "
	
	SQL1 = "Exec P_상담결과등록 '회원상담', '', '', '', '', '일반상담', NULL, '"& hcode &"', '"& gcode &"', '아웃콜', '행사모니터링', '통화완료', '고객 만족도 평가 등록', '상담완료', '', 'system', 'system'  "

	'response.Write SQL & "<BR><BR>"
	'response.Write f_url
	'response.End

	'SQL = " INSERT INTO LifeWeb..m_qna (hangsano, qna1, qna2, qna3, qna4, qna5, qna6, qna7, qna8, regdate "
	'SQL = SQL & " ) values ( "
	'SQL = SQL & " '"& code &"','"& qna1 &"','"& qna2 &"','"& qna3 &"','"& qna4 &"','"& qna5 &"','"& qna6 &"','"& qna7 &"','"& qna8 &"', getdate() ) "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)

	Set Rs1 = ConnAplus.execute(SQL1)

	Set Rs = Nothing
	Set Rs1 = Nothing

	ConnAplus.Close
	Set ConnAplus = Nothing

	response.write "<script type='text/javascript'>"
	response.write "alert('등록 되었습니다.');"
	response.write "location.replace('"& f_url &"?code="& code_enc &"');"
	response.write "</script>"	


	response.End

%>