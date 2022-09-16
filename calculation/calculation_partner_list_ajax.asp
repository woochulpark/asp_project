<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	dim sValue	
	sValue = request("sValue")	

	SQL = " select 거래처코드, 지역, 거래처명, 사업자번호, 대표자, 우편주소, 상세주소 "
	SQL = SQL & " from 의전거래처마스터 "
	SQL = SQL & " where 계약여부 = '계약' "
	SQL = SQL & " and 거래처명 not in ( 'N', '기타', '제외', '본부', '베어베터', '천마퀵' ) "
	if sValue <> "" then
		SQL = SQL & " and 거래처명 like '%" & sValue & "%' "
	end if
	SQL = SQL & " order by 거래처명 "

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

	<div class="def_search">		
		<input type="text" class="input_ty" placeholder="거래처명" name="sValue" id="sValue" value="<%= sValue %>">
		<a href="javascript:void(0);" class="btn_search" onclick="PartnerList2($('#sValue').val());">검색</a>
	</div><!--// def_search -->

	<table class="list_ty">
		<caption>협력업체</caption>
		<colgroup>
			<col span="1" class="verti_w05"><col span="1" style="width:*%;"><col span="1" class="list_w03">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">거래처명</th>
				<th scope="col">사업자우편주소</th>
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
			pcode		= arrObj(0,i)
			area		= arrObj(1,i)
			partner		= arrObj(2,i)
			pno			= arrObj(3,i)
			padmin		= arrObj(4,i)
			padress		= arrObj(5,i)
			padress2	= arrObj(6,i)
%>
			<tr>				
				<td><%=partner %></td>				
				<td><%=padmin %></td>
				<td>
					<a href="javascript:void(0);" class="btn_ty ty02" onclick="PartnerAdd('<%=pcode %>','<%=partner %>');">선택</a>
				</td>
			</tr>
<%
		next
	end if 
%>
		</tbody>
	</table><!--// list_ty -->
	
</div>