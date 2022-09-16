<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%		
	sValue = request("sValue")	
	sValue_2 = request("sValue_2")

	SQL = "select 상품코드, 상품액, 상품명, 파일명 "
	SQL = SQL & " from 상품코드 "	
	SQL = SQL & " where 1=1 "
	SQL = SQL & " and convert(varchar(8), getdate(),112) between 판매시작일자 and 판매종료일자 "
	if sValue <> "" then
		SQL = SQL & " and 상품명 like '%" & sValue & "%' "
	end if	
	if sValue_2 <> "" And sValue_2 <> "일반" then
		SQL = SQL & " and 집계구분 = '" & sValue_2 & "' "
	end if

	SQL = SQL & " order by 판매시작일자 desc, 상품명, 상품코드 "
	'Response.write 	SQL

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
		<input type="text" class="input_ty" placeholder="이름" name="sValue" id="sValue" value="<%= sValue %>">
		<a href="javascript:void(0);" class="btn_search" onclick="ItemList($('#sValue').val());">검색</a>
	</div><!--// def_search -->

	<table class="list_ty">
		<caption>상품명 리스트</caption>
		<colgroup>
			<col span="1" class="list_w02"><col span="2" class="list_w00"><col span="1" class="list_w03">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">코드</th>
				<th scope="col">상품금액</th>
				<th scope="col">상품명</th>
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
			icode	= arrObj(0,i)
			ipay	= FormatNumber(arrObj(1,i),0)
			iname	= arrObj(2,i)
			file	= arrObj(3,i)
%>
					<tr>						
						<td><%=icode %></td>						
						<td><%=ipay %></td>
						<td><%=iname %></td>
						<td><a href="javascript:void(0);" onclick="ItemAdd('<%=icode %>', '<%=iname %>', '<%=file %>');" class="btn_ty ty02">등록</a></td>
					</tr>		
<%
		next
	end if 
%>
		</tbody>		

	</table>

</div>