<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	dim sValue
	sValue = request("sValue")	
	sType = request("sType")
	code = request("code")

	SQL = " select a.idx, a.사원코드, a.은행코드, b.은행명, a.계좌번호, a.예금주명, a.검증, a.검증예금주명, a.등록자, a.시스템일자 "
	SQL = SQL & " from 행사사원계좌변경이력 a left outer join 은행코드 b on a.은행코드 = b.은행코드"	
	SQL = SQL & " where a.사원코드 = '" & code & "'"
	SQL = SQL & " order by a.시스템일자 desc "

	'Response.write SQL

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
<div>
	<table class="list_ty">
		<caption>도우미 리스트</caption>
		<colgroup>
			<col span="1" class="list_w05"><col span="1" class="list_w00"><col span="1" class="list_w02"><col span="1" class="list_w02">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">은행명</th>
				<th scope="col">계좌번호</th>
				<th scope="col">예금주명</th>
				<th scope="col"></th>
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
			idx					= arrObj(0,i)
			sCode				= arrObj(1,i)
			bankCode			= arrObj(2,i)
			bankName			= arrObj(3,i)
			accountNums			= arrObj(4,i)
			accountName			= arrObj(5,i)
			accountValid		= arrObj(6,i)
			accountValidName	= arrObj(7,i)
			modifiedBy			= arrObj(8,i)
			modifiedDate		= arrObj(9,i)
%>
			<tr>
				<td><%=bankName %></td>
				<td><%=accountNums %></td>
				<td><%=accountName %></td>
				<td><a href="javascript:void(0);" onclick="bankChange('<%=bankCode %>', '<%=accountNums %>', '<%=accountValid %>', '<%=accountValidName %>');" class="btn_ty ty02">변경</a></td>
			</tr>
<%
		next
	end if 
%>
		</tbody>
	</table>
</div>