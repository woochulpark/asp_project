<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
	
	code = Trim(request.Form("code"))
	input_icode = Split(Trim(request.Form("input_icode")),",")
	input_item0 = Split(Trim(request.Form("input_item0")),",")
	input_item = Split(Trim(request.Form("input_item")),",")
	input_pcode = Split(Trim(request.Form("input_pcode")),",")
	input_partner = Split(Trim(request.Form("input_partner")),",")
	input_cnt = Split(Trim(request.Form("input_cnt")),",")
	input_price = Split(Trim(request.Form("input_price")),",")
	input_pay = Split(Trim(request.Form("input_pay")),",")
	input_etc = Split(Trim(request.Form("input_etc")),"|")		

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	SQL_DELTE = " DELETE FROM 행사진행물품 WHERE 행사번호 = '"& code &"' AND 구분 = '구입' "
	
	Set Rs = ConnAplus.execute(SQL_DELTE)

	For i=0 To UBound(input_icode)

		if UBound(input_pcode) < 0 then
			input_pcode_v = ""
		else
			input_pcode_v = input_pcode(i)
		end if

		if UBound(input_partner) < 0 then
			input_partner_v = ""
		else
			input_partner_v = input_partner(i)
		end if

		if UBound(input_price) < 0 then
			input_price_v = 0
		else
			input_price_v = input_price(i)
			if input_price_v = "" then
				input_price_v = 0
			end if 
		end if

		if UBound(input_pay) < 0 then
			input_pay_v = ""
		else
			input_pay_v = input_pay(i)
		end if

		if UBound(input_etc) < 0 then
			input_etc_v = ""
		else
			input_etc_v = input_etc(i)
		end If
		
		if UBound(input_item) < 0 then
			input_item_v = ""
		else
			input_item_v = input_item0(i) & "(" &  input_item(i) & ")"
		end if

		SQL = " INSERT INTO 행사진행물품 (행사번호, 구분, 라인번호, 구매구분, 상품코드, 상품명, 거래처코드, 거래처명, 수량, 지급액, 결재방법, 비고, 본부, 센터, 등록자, 시스템일자 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& code &"', '구입', '"& i+1 &"', '', '"& input_icode(i) &"', '"& input_item_v &"', '"& input_pcode_v &"', '"& input_partner_v &"', '"& input_cnt(i) &"', "
		SQL = SQL & " '"& input_price_v &"', '"& input_pay_v &"', '"& input_etc_v &"', '', '', '"& user_id &"', getdate() ) "		

		Set Rs = ConnAplus.execute(SQL)

    Next
	
	SQL = "exec [P_행사보고서_카드합계] '"& code &"'"
	ConnAplus.execute(SQL)

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	

	response.write "<script type='text/javascript'>"
	response.write "alert('등록되었습니다.');"
	response.write "location.replace('calculation_buy.asp?Code="& code &"');"
	response.write "</script>"

	response.End

%>
