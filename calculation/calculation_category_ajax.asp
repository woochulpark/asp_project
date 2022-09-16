<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/conf/dbmsConnect.asp"-->

<%	
	category = request("sValue")
	category2 = request("sValue2")

	SQL = "  select distinct 센터 "
	SQL = SQL & " from 행사의전팀장 "
	SQL = SQL & " where 본부 = '"& category &"' "
	SQL = SQL & " and 계약여부 = '계약' "
	SQL = SQL & " order by 센터 asc "

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

	category_list = "<option value=''>--선택--</option>"

	if rc <> 0 then	
		for i=0 to UBound(arrObj,2)
			catecory	= arrObj(0,i)
			if catecory = category2 then
				category_list = category_list & "<option value='"& catecory &"' selected>"& catecory &"</option>"
			else
				category_list = category_list & "<option value='"& catecory &"'>"& catecory &"</option>"
			end if
			
		next
	end if	
	
%>
<select class="select_ty tc w100"><%=category_list %></select>