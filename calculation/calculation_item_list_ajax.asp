<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	dim sValue	
	sType = request("sType")
	sValue = request("sValue")

	if sType = "buy" then
		sType = "기본제공"
	else
		sType = "추가비용"
	end if

	SQL = " select 행사품목코드, 품목구분, 품목분류, 품목명 "
	SQL = SQL & " from 행사품목코드 "
	SQL = SQL & " where 사용여부 = 'Y' "	
	SQL = SQL & " and 품목구분 in ('"& sType &"', '기본제공+추가비용') "
	if sValue <> "" then
		SQL = SQL & " and 품목분류 like '%" & sValue & "%' "
	end if
	SQL = SQL & " order by 행사품목코드 "	

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
		<input type="text" class="input_ty" placeholder="품목분류" name="sValue" id="sValue" value="<%= sValue %>">
		<a href="javascript:void(0);" class="btn_search" onclick="ItemList($('#sValue').val());">검색</a>
	</div><!--// def_search -->
	
	<table class="list_ty" id="ItemList">
		<caption>기본제공비용</caption>
		<colgroup>
			<col span="1" class="verti_w03"><col span="1" class="verti_w05"><col span="2" style="width:*%;">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">선택</th>
				<th scope="col">행사품목코드</th>
				<th scope="col">품목분류</th>
				<th scope="col">품목명</th>
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
			itemcode	= arrObj(0,i)
			itemtype	= arrObj(2,i)
			item		= arrObj(3,i)
%>
			<tr>
				<td>
					<p class="checks al"><span>
						<input type="checkbox" id="Checkbox_<%=i %>" value="<%=itemcode %>,<%=itemtype %>,<%=item %>">
						<label for="Checkbox_<%=i %>">선택</label>
					</span></p>				
				<td><%=itemcode %></td>						
				<td><%=itemtype %></td>
				<td><%=item %></td>
			</tr>		
<%
		next
	end if 
%>				
		</tbody>
	</table><!--// list_ty -->	
	
</div>
<div class="btm_btns">
	<a href="javascript:void(0);" onclick="ItemAdd();" class="btn_ty btn_b">선택완료</a>
</div><!--// btm_btns -->