<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
	code = Trim(request.Form("code"))
	jedan = Trim(request.Form("jedan"))
	jedanpay = Replace(Trim(request.Form("jedanpay")), ",", "")
	sale = Trim(request.Form("sale"))
	salepay = Replace(Trim(request.Form("salepay")), ",", "")
	'indate = Replace(Trim(request.Form("indate")), "-", "")
	jangjietc = Trim(request.Form("jangjietc"))
	goinetc = Trim(request.Form("goinetc"))
	'hangsaetc = Trim(request.Form("hangsaetc"))

	'response.write code & "<br>"
	'response.write jedan & "<br>"
	'response.write jedanpay & "<br>"
	'response.write sale & "<br>"
	'response.write salepay & "<br>"
	'response.write indate & "<br>"
	'response.write jangjietc & "<br>"
	'response.write goinetc & "<br>"
	'response.write hangsaetc & "<br>"

	'response.End

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	'SQL_DELTE = " DELETE FROM 행사특이사항 WHERE 행사번호 = '"& code &"' "
	'Set Rs = ConnAplus.execute(SQL_DELTE)
	
	'SQL2 에 들어가있음
	SQL = " INSERT INTO 행사특이사항 (행사번호, 제단, 관, 차량, 고인특이사항, 유족특이사항, 의전관행사의견, 단체장례정산, 제단금액, 제단할인율, 제단할인금액, 장지특이사항, 등록자, 시스템일자 " '입금일자, 
	SQL = SQL & " ) values ( "
	SQL = SQL & " '"& code &"', '"& jedan &"', '', '', '"& goinetc &"', '', '', '', '"& jedanpay &"', '"& sale &"', '"& salepay &"', '"& jangjietc &"', '"& user_id &"', getdate() ) " ', '"& indate &"'


	SQL2 = "IF EXISTS(SELECT * FROM 행사특이사항 WHERE 행사번호 = '" & code & "')"
	SQL2 = SQL2 & " BEGIN UPDATE 행사특이사항 set 제단='" & jedan & "', 제단금액='" & jedanpay & "', 제단할인율='" & sale & "', 제단할인금액='" & salepay
	SQL2 = SQL2 &  "', 고인특이사항='" & goinetc & "', 장지특이사항='" & jangjietc & "',  시스템일자=getdate() where 행사번호 = '" & code & "'"
	SQL2 = SQL2 & " END ELSE BEGIN" & SQL & "END" ', 입금일자='" & indate & "'

	Set Rs = ConnAplus.execute(SQL2)    

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	response.write "<script type='text/javascript'>"
	response.write "alert('등록되었습니다.');"
	response.write "location.replace('calculation_etc.asp?Code="& code &"');"
	response.write "</script>"

	response.End

%>
