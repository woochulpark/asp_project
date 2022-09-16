<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/conf/dbmsConnect.asp"-->

<%	
	categoryb = request("categoryb")
	categoryc = request("categoryc")	

	if categoryb <> "" then

		SQL = " select 소분류 "
		SQL = SQL & " from 행사용품코드 "	
		SQL = SQL & " where 중분류 = '"& categoryb &"' "
		SQL = SQL & " group by 소분류 "

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

		category_list = "<option value=''>소분류</option>"

		if rc = 0 then
		else
			for i=0 to UBound(arrObj,2)			
				Catecory	= arrObj(0,i)
				category_list = category_list & "<option value='"& Catecory &"'>"& Catecory &"</option>"
			next
		end if	
	else 
		category_list = "<option value=''>소분류</option>"
	end if 
%>
<select name="sTypeC" id="sTypeC" class="mb10 mr2p w50p fl-l select"><%=category_list %></select>
<script language="javascript" type="text/javascript">
	document.getElementById("sTypeC").value = "<%=categoryc %>";
</script>