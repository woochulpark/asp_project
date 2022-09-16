<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	code = Trim(request("code"))
	
	g_1 = Replace(Trim(request("g_1")), ",", "")
	g_2 = Replace(Trim(request("g_2")), ",", "")
	g_3 = Replace(Trim(request("g_3")), ",", "")
	g_4 = Replace(Trim(request("g_4")), ",", "")
	g_5 = Replace(Trim(request("g_5")), ",", "")
	g_6 = Replace(Trim(request("g_6")), ",", "")
	g_8 = Replace(Trim(request("g_8")), ",", "")
	g_9 = Replace(Trim(request("g_9")), ",", "")
	g_10 = Replace(Trim(request("g_10")), ",", "")
	g_11 = Replace(Trim(request("g_11")), "-", "")
	g_12 = Replace(Trim(request("g_12")), ",", "")
	g_13 = Trim(request("g_13"))
	g_15 = Replace(Trim(request("g_15")), ",", "")
	g_14 = Trim(request("g_14"))
	g_16 = Trim(request("g_16"))
	g_18 = Trim(request("g_18"))
	g_19 = Trim(request("g_19"))
	g_20 = Trim(request("g_20"))
	g_21 = Trim(request("g_21"))
	g_22 = Replace(Trim(request("g_22")), ",", "")
	g_23 = Replace(Trim(request("g_23")), "-", "")
	g_24 = Trim(request("g_24"))
	g_25 = Trim(request("g_25"))
	g_26 = Trim(request("g_26"))    

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	SQL_DELTE = " DELETE FROM 행사입금 WHERE 행사번호 = '"& code &"' "
	
	Set Rs = ConnAplus.execute(SQL_DELTE)
	
	SQL = " INSERT INTO 행사입금 (행사번호,진행상품금액,추가금액,할인상주공제,매출,부금,카드수입총액,현장지출, "
	SQL = SQL & " 회사입금액,현금정산액,현금정산일자,영수증,카드사,카드결제액,자체용품금액, "
	SQL = SQL & " 총지출경비,지출비율,현금영수증구분,현금영수증성명,현금영수증번호,팀장입금액, "
	SQL = SQL & " 팀장입금일자,상품권사용여부,현금영수증승인번호,등록자,청구금액 "
	SQL = SQL & " ) values ( "
	SQL = SQL & " '"& code &"', '"& g_1 &"', '"& g_2 &"', '"& g_3 &"', '"& g_4 &"', '"& g_5 &"', '"& g_6 &"', '"& g_8 &"', "
	SQL = SQL & " '"& g_9 &"', '"& g_10 &"', '"& g_11 &"', '"& g_12 &"', '"& g_13 &"', '"& g_15 &"', '"& g_14 &"', "
	SQL = SQL & " '"& g_16 &"', '"& g_18 &"', '"& g_19 &"', '"& g_20 &"', '"& g_21 &"', '"& g_22 &"', "
	SQL = SQL & " '"& g_23 &"', '"& g_25 &"', '"& g_24 &"', '"& user_id &"', '"& g_26 &"' "
	SQL = SQL & " ) "

	Set Rs = ConnAplus.execute(SQL)    

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	response.write "<script type='text/javascript'>"
	response.write "alert('등록되었습니다.');"
	response.write "location.replace('calculation_total.asp?Code="& code &"');"
	response.write "</script>"

	response.End

%>
