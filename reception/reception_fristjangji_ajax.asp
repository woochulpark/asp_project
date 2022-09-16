<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%		
	sValue = request("sValue")		

	SQL = "select 상세코드, 대표명칭 "
	SQL = SQL & " from 공용코드 a (nolock) "	
	SQL = SQL & " where 1=1 "
	SQL = SQL & " and 대표코드  = '00502' "	
	if sValue <> "" then
		SQL = SQL & " and 대표명칭  like '%" & sValue & "%' "
	end if	
	SQL = SQL & " order by 상세코드 asc "

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
%>
<div class="lypB">
	<div class="def_search">
		<input type="text" name="sValue" id="sValue" value="<%= sValue %>" class="input_ty" placeholder="1차장지">
		<a href="javascript:void(0);" class="btn_search" onclick="FirstJangJi($('#sValue').val());">검색</a>
	</div><!--// def_search -->

	<table class="list_ty">
		<caption>장례식장 리스트</caption>
		<colgroup>
			<col span="1" class="list_w02"><col span="1" class="list_w00"><col span="1" class="list_w03">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">코드</th>
				<th scope="col">1차장지</th>
				<th scope="col">선택</th>
			</tr>
		</thead>
		<tbody>
<%
	if rc = 0 then 
%>
			<tr><td colspan="3">일치하는 검색결과가 없습니다.</td></tr>
<%
	else
		for i=0 to UBound(arrObj,2)
			fcode	= arrObj(0,i)
			fname	= arrObj(1,i)
%>
			<tr>						
				<td><%=fcode %></td>						
				<td><%=fname %></td>						
				<td><a href="javascript:void(0);" onclick="FristJangJiAdd('<%=fcode %>', '<%=fname %>');" class="btn_ty ty02">등록</a></td>
			</tr>		
<%
		next
	end if 
%>
		</tbody>
	</table>
</div>			