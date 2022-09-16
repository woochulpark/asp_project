<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check2.asp"-->

<%
	b_type1 = Trim(request("b_type1"))
	b_type2 = Trim(request("b_type2"))
	b_idx = Trim(request("b_idx"))

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	SQL = " select 파일명, 파일경로 "
	SQL = SQL & " from 파일저장 "
	SQL = SQL & " where 게시판종류 = '"& b_type1 &"' and 게시판종류2 = '"& b_type2 &"' and 게시판인덱스 = '"& b_idx &"' "
	SQL = SQL & " order by 인덱스 asc "
	
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
%>

<div class="filebox preview-image">
<%
	if rc = 0 then
	else
		for i=0 to UBound(arrObj,2)
			filename		= arrObj(0,i)
			filepath		= arrObj(1,i)
%>	
		<div class="upload-display"><img src="<%=filepath&filename %>" onclick="FileView('<%=filepath&filename %>');" class="upload-thumb"></div>
<%
		next
	end if 	
%>
</div>