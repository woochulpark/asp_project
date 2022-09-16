<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	categorya = request("categorya")

	SQL = " select 대분류 "
	SQL = SQL & " from 행사용품코드 (nolock) "	
	SQL = SQL & " group by 대분류 "
	SQL = SQL & " order by 대분류 "

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

	category_list = "<option value=''>대분류</option>"

	if rc = 0 then
	else
		for i=0 to UBound(arrObj,2)			
			Catecory	= arrObj(0,i)
			category_list = category_list & "<option value='"& Catecory &"'>"& Catecory &"</option>"
		next
	end if	
%>
<select name="sTypeA" id="sTypeA" onchange="CategoryChange('b', this.value, '', '');" class="select_ty"><%=category_list %></select>