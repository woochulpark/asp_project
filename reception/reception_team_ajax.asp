<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%		
	sValue = request("sValue")
    code = request("code")    

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ
	
    SQL_C = "select 의전관 from 행사마스터 where 행사번호 = '"& code &"' "

    Set Rs = ConnAplus.execute(SQL_C)

    If Rs.EOF Then
		gCode = ""
	Else		
		gCode = Rs("의전관")
    End If    

	SQL = "select 코드, 직급 as 직책, 성함 as 성명, 연락처,  센터 "
	SQL = SQL & " from 행사의전팀장 (nolock) "	
	SQL = SQL & " where 계약여부 = '계약' "	
	if sValue <> "" then
		SQL = SQL & " and 성함 like '%" & sValue & "%' "
	end if
	SQL = SQL & " and ( 본부 like '%' + ( select 본부 from 행사의전팀장 (nolock) where 코드 = '"& gCode &"' ) + '%' "
	SQL = SQL & " or 센터 = (case when ( select 본부 from 행사의전팀장 (nolock) where 코드 = '"& gCode &"') = '외주' then '' else '꽃집' end) ) "
	SQL = SQL & " order by 센터 desc, 직급, 성함 "

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
		<input type="text" class="input_ty" placeholder="이름" name="sValue" id="sValue" value="<%= sValue %>">
		<a href="javascript:void(0);" class="btn_search" onclick="TeamList($('#sValue').val());">검색</a>
	</div><!--// def_search -->	

	<table class="list_ty">		
		<colgroup>
			<col span="2" class="list_w02"><col span="1" class="list_w00"><col span="1" class="list_w02">
		</colgroup>
		<thead>		
			<tr>
				<th scope="col">직책</th>
				<th scope="col">성명</th>
				<th scope="col">연락처</th>
				<th scope="col">선택</th>
			</tr>
		</thead>
		<tbody>
<%
	if rc = 0 then 
%>
			<tr><td colspan="4">일치하는 검색결과가 없습니다.</td></tr>
<%
	else
		for i=0 to UBound(arrObj,2)
			tcode	= arrObj(0,i)
			ttype	= arrObj(1,i)
			tname	= arrObj(2,i)			
			tphone	= arrObj(3,i)
			tcenter	= arrObj(4,i)			
%>
			<tr>						
				<td><%=ttype %></td>						
				<td><%=tname %></td>
				<td><%=tphone %></td>
				<td><a href="javascript:void(0);" class="btn_ty ty02" onclick="TeamAdd('<%=tcode %>', '<%=tname %>', '<%=tphone %>', '<%=tcenter%>');">배정</a></td>
			</tr>
<%
		next
	end if
%>
		</tbody>
	</table>

</div>
