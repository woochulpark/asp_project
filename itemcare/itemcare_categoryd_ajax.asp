<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/conf/dbmsConnect.asp"-->

<%
	categoryd = request("categoryd")

	SQL = " select 상세명칭 as 본부 "
	SQL = SQL & " from 공용코드 "	
	SQL = SQL & " where 대표코드 = '00301' and 구분5 = 'Y' "
	SQL = SQL & " order by 구분2 "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ	
		
	Set Rs = ConnAplus.execute(SQL)		

	If Rs.EOF Then
		rc = 0
	Else
		rc = Rs.RecordCount
		arrObj = Rs.GetRows(rc)
	End If	

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	category_list = "<option value=''>본부선택</option>"

	if rc = 0 then
	else
		for i=0 to UBound(arrObj,2)			
			Catecory	= arrObj(0,i)
			category_list = category_list & "<option value='"& Catecory &"'>"& Catecory &"</option>"
		next
	end if
%>
<select name="sTypeD" id="sTypeD" class="select_ty"><%=category_list %></select>