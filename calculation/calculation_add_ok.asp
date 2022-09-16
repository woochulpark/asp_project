<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
	
	code = Trim(request.Form("code"))
	input_icode = Split(Trim(request.Form("input_icode")),",")
	input_item0 = Split(Trim(request.Form("input_item0")),",")
	input_item = Split(Trim(request.Form("input_item")),",")
	input_type = Split(Trim(request.Form("input_type")),",")	
	input_cnt = Split(Trim(request.Form("input_cnt")),",")
	input_price = Split(Trim(request.Form("input_price")),",")	
	input_etc = Split(Trim(request.Form("input_etc"))	,"|")

	total_add = 0
	total_sale = 0

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	SQL_DELTE = " DELETE FROM 행사진행물품 WHERE 행사번호 = '"& code &"' AND 구분 in ('추가','공제','할인','상향','추가상향') "
	
	Set Rs = ConnAplus.execute(SQL_DELTE)

	For i=0 To UBound(input_icode)        

        if UBound(input_price) < 0 then
			input_price_v = 0
		else
			input_price_v = input_price(i)

			if input_price_v = "" then
				input_price_v = 0
			end if 
		end if

		if UBound(input_etc) < 0 then
			input_etc_v = ""
		else
			input_etc_v = input_etc(i)
		end if

		if UBound(input_item) < 0 then
			input_item_v = ""
		else
			input_item_v = input_item0(i) & "(" &  input_item(i) & ")"
		end if

		SQL = " INSERT INTO 행사진행물품 (행사번호, 구분, 라인번호, 구매구분, 상품코드, 상품명, 거래처코드, 거래처명, 수량, 지급액, 결재방법, 비고, 본부, 센터, 등록자, 시스템일자 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& code &"', '"& input_type(i) &"', '"& i+1 &"', 'Y', '"& input_icode(i) &"', '"& input_item_v &"', '', '', '"& input_cnt(i) &"', "
		SQL = SQL & " '"& input_price_v &"', '', '"& input_etc_v &"', '', '', '"& user_id &"', getdate() ) "

		Set Rs = ConnAplus.execute(SQL)

		'if input_type(i) = "추가" or input_type(i) = "상향" or input_type(i) = "추가상향" then
		'	total_add = total_add + Cint(input_price(i))
		'else
		'	total_sale = total_sale + Cint(input_price(i))
		'end if
    Next	

	SQL = "exec [P_행사보고서_카드합계] '"& code &"'"
	ConnAplus.execute(SQL)

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	response.write "<script type='text/javascript'>"
	response.write "alert('등록되었습니다.');"
	response.write "location.replace('calculation_add.asp?Code="& code &"');"
	response.write "</script>"

	response.End

%>
