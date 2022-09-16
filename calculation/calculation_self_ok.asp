<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
	code = Trim(request.Form("code"))
	input_icode = Split(Trim(request.Form("input_icode")),",")
	input_item = Split(Trim(request.Form("input_item")),",")
	input_item2 = Split(Trim(request.Form("input_item2")),",")
	input_cnt = Split(Trim(request.Form("input_cnt")),",")
	input_price = Split(Trim(request.Form("input_price")),",")
	input_etc = Split(Trim(request.Form("input_etc")),"|")
	input_center = Split(Trim(request.Form("input_center")),",")
	input_bonbu = Split(Trim(request.Form("input_bonbu")),",")	

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	SQL_DELTE = " DELETE FROM 행사진행물품 WHERE 행사번호 = '"& code &"' AND 구분 = '자체' "
	
	Set Rs = ConnAplus.execute(SQL_DELTE)

	For i=0 To UBound(input_icode)	

		item = input_item(i) & "-" & input_item2(i)
		price = input_price(i) * input_cnt(i)

		input_etc_txt = ""
		input_bonbu_txt = ""
		input_center_txt = ""

		if request.Form("input_etc") <> "" then
			input_etc_txt = input_etc(i)
		end if
		if request.Form("input_bonbu") <> "" then				
			input_bonbu_txt = input_bonbu(i)
		end if
		if request.Form("input_center") <> "" then		
			input_center_txt = input_center(i)
		end if		

		SQL = " INSERT INTO 행사진행물품 (행사번호, 구분, 라인번호, 구매구분, 상품코드, 상품명, 수량, 지급액, 비고, 본부, 센터, 등록자, 시스템일자 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& code &"', '자체', '"& i+1 &"', 'Y', '"& input_icode(i) &"', '"& item &"', '"& input_cnt(i) &"', "
		SQL = SQL & " '"& price &"', '"& input_etc_txt &"', '"& input_bonbu_txt &"', '"& input_center_txt &"', '"& user_id &"', getdate() ) "

		Set Rs = ConnAplus.execute(SQL)

    Next	

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	response.write "<script type='text/javascript'>"
	response.write "alert('등록되었습니다.');"
	response.write "location.replace('calculation_self.asp?Code="& code &"');"
	response.write "</script>"

	response.End

%>
