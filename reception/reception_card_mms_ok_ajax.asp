<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
    cno = Trim(request("cno"))
	receipt_hp = Trim(request("receipt_hp"))
	product_amt = Trim(request("product_amt"))
	install_period = Trim(request("install_period"))	
	card_gubun = Trim(request("card_gubun"))	
	card_result = Trim(request("card_result"))
	user_id = Trim(request("user_id"))

	If install_period = "0" Then
		install_period_nm = "일시납"
	Else			
		install_period_nm = install_period & "개월"
	End If

	
	SQL = "exec [P_문자전송_알림톡_카드현금_영수증] 'aplus_97_001_01', '"& receipt_hp &"', '1688-8890', '"& cno &"', '"& card_gubun &"', '"& card_result &"', '"& product_amt&"', '"& life_sawon_id &"', 'A', '"& install_period_nm &"', '재전송' "


	'response.end

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

		ConnAplus.execute(SQL)
	
	ConnAplus.Close
	Set ConnAplus = Nothing	
	
	response.write "S"	

	response.End

%>