<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
	
	code = Trim(request.Form("code"))
	input_mcode = Split(Trim(request.Form("input_mcode")),",")
	input_hname = Split(Trim(request.Form("input_hname")),",")
	input_htype = Split(Trim(request.Form("input_htype")),",")
	input_hday = Split(Trim(request.Form("input_hday")),",")
	input_hdate = Split(Trim(request.Form("input_hdate")),",")
	input_htime = Split(Trim(request.Form("input_htime"))	,",")	
	input_hhour = Split(Trim(request.Form("input_hhour")),",")
	input_hjobpay = Split(Trim(request.Form("input_hjobpay")),",")
	input_hworkpay = Split(Trim(request.Form("input_hworkpay")),",")
	input_hetcpay = Split(Trim(request.Form("input_hetcpay")),",")
	input_htotalpay = Split(Trim(request.Form("input_htotalpay")),",")
	input_htex = Split(Trim(request.Form("input_htex")),",")
	input_hpay = Split(Trim(request.Form("input_hpay")),",")
	input_htex2 = Split(Trim(request.Form("input_htex2")),",")
	input_htex3 = Split(Trim(request.Form("input_htex3")),",")

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	SQL_DELTE = " DELETE FROM 행사도우미 WHERE 행사번호 = '"& code &"' "
	
	Set Rs = ConnAplus.execute(SQL_DELTE)

	For i=0 To UBound(input_mcode)		

		SQL = " INSERT INTO 행사도우미 (행사번호, 라인번호, 구분, 사원코드, 사원명, 시작일자, 작업시간, 도우미단가, 작업수당, "
		SQL = SQL & " 시간외수당, 총액, 지급액, 세액, 일차, 시작시간, 변경세액, 소득세, 주민세, 등록자, 시스템일자 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& code &"', '"& i+1 &"', '"& input_htype(i) &"', '"& input_mcode(i) &"', '"& input_hname(i) &"', '"& input_hdate(i) &"', '"& input_hhour(i) &"', '"& input_hjobpay(i) &"', '"& input_hworkpay(i) &"', "
		SQL = SQL & " '"& input_hetcpay(i) &"', '"& input_htotalpay(i) &"', '"& input_hpay(i) &"', '"& input_htex(i) &"', '"& input_hday(i) &"', '"& input_htime(i) &"', '"& input_htex(i) &"', '"& input_htex2(i) &"', "		
		SQL = SQL & " '"& input_htex3(i) &"', '"& user_id &"', getdate() ) "		

		Set Rs = ConnAplus.execute(SQL)

    Next	

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	response.write "<script type='text/javascript'>"
	response.write "alert('등록되었습니다.');"
	response.write "location.replace('calculation_helper.asp?Code="& code &"');"
	response.write "</script>"

	response.End

%>
