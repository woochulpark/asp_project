<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	
	sValue = request("sValue")	
	sType = request("sType")
	jobtime = request("jobtime")
	jobdate = request("jobdate")	

	SQL = " select top 1 구분2 "
	SQL = SQL & " from 공용코드 a (nolock) "	
	SQL = SQL & " where 대표코드 = '00256' "	
	SQL = SQL & " and 상세명칭 = '"& sValue &"' "	
	SQL = SQL & " and 구분1 = '"& jobtime &"' "	
	SQL = SQL & " and 구분4 <= '"& jobdate &"' "			
	SQL = SQL & " order by 구분4 desc "	

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ		
		
	Set Rs = ConnAplus.execute(SQL)

	If Rs.EOF Then
		workpay = 0		
	Else
		workpay = rs("구분2")
	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	
%>
<script type="text/javascript">
	HelperWorkpay('<%=sType %>', '<%=workpay %>');	
</script>