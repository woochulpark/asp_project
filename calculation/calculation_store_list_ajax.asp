<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	dim sValue	
	sType = request("sType")
	sType2 = request("sType2")
	sValue = request("sValue")	

	SQL = " select 행사용품코드, 대분류, 중분류, 소분류, 단위수량, 단위, 단가, 판매가, 업체명 "
	SQL = SQL & " from 행사용품코드 "
	SQL = SQL & " where 판매여부 = 'Y' "
	if sType <> "" then 
		SQL = SQL & " and 대분류 = '"& sType &"' "
	end if
	if sType2 <> "" then 
		SQL = SQL & " and 중분류 = '"& sType2 &"' "
	end if
	if sValue <> "" then 
		SQL = SQL & " and 중분류 like '%" & sValue & "%' "
	end if
	SQL = SQL & " and convert(varchar(8), getdate(), 112) between 판매시작일 and 판매종료일 "	
	SQL = SQL & " order by 행사용품코드 "

	SQL_P = "  select distinct 대분류 "
	SQL_P = SQL_P & " from 행사용품코드 "	
	SQL_P = SQL_P & " where 판매여부 = 'Y' "
	SQL_P = SQL_P & " order by 대분류 asc "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ		
		
	Set Rs = ConnAplus.execute(SQL)

	If Rs.EOF Then
		rc = 0		
	Else
		rc = Rs.RecordCount
		arrObj = Rs.GetRows(rc)
	End If

	Set Rs = ConnAplus.execute(SQL_P)	

	If Rs.EOF Then
		rc2 = 0		
	Else
		rc2 = Rs.RecordCount
		arrObj2 = Rs.GetRows(rc2)
	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	

	category_list = "<option value=''>대분류</option>"

	if rc2 <> 0 then	
		for i=0 to UBound(arrObj2,2)
			catecory	= arrObj2(0,i)
			if catecory = sType then
				category_list = category_list & "<option value='"& catecory &"' selected>"& catecory &"</option>"
			else
				category_list = category_list & "<option value='"& catecory &"'>"& catecory &"</option>"
			end if
		next
	end if	
%>
<div class="lypB">
	
	<div class="search_box">
		<ul class="sch_form">
			<li class="ty02">
				<select id="category1" name="category1" onchange="CategoryChange(this.value);" class="select_ty">
					<%=category_list %>
				</select>
				<span id="category2_span">
					<select id="category2" name="category2" class="select_ty"><option value=''>중분류</option></select>
				</span>				
			</li>
			<li>
				<input type="text" name="sValue" id="sValue" value="<%= sValue %>" class="input_ty w100" placeholder="물품명">
			</li>
		</ul>
		<a href="javascript:void();" onclick="ItemList($('#category1').val(), $('#category2').val(), $('#sValue').val());" class="btn_search">검색</a>
	</div><!--// search_box -->	

	<table class="list_ty verti">
		<caption>용품명세서</caption>
		<colgroup>
			<col span="1" class="verti_w03"><col span="3" style="width:*%;">
		</colgroup>
		<tbody>
			<tr>
				<th scope="col" rowspan="2">선택</th>
				<th scope="col">대분류</th>
				<th scope="col">중분류</th>
				<th scope="col">소분류</th>
			</tr>
			<tr>
				<td class="ht01">행사품목코드</td>
				<td class="ht01">수량</td>
				<td class="ht01">단위</td>
			</tr>
		</tbody>
	</table>

	<table id="ItemList" class="list_ty verti mt">
		<caption>용품명세서</caption>
		<colgroup>
			<col span="1" class="verti_w03"><col span="3" style="width:*%;">
		</colgroup>
		<tbody>
<%
	if rc = 0 then 
%>
			<tr><td colspan="4">일치하는 검색결과가 없습니다.</td></tr>
<%
	else
		for i=0 to UBound(arrObj,2)
			itemcode	= arrObj(0,i)
			itemtype1	= arrObj(1,i)
			itemtype2	= arrObj(2,i)
			itemtype3	= arrObj(3,i)
			itemcnt		= arrObj(4,i)
			itemgroup	= arrObj(5,i)
			itemprice	= arrObj(6,i)
			itemsel		= arrObj(7,i)
%>
			<tr>
				<td rowspan="2">
					<p class="checks al"><span>
						<input type="checkbox" id="chk_<%=i %>" value="<%=itemcode %>,<%=itemtype2 %>,<%=itemtype3 %>,<%=itemprice %>">
						<label for="chk_<%=i %>">선택</label>
					</span></p>
				</td>
				<td class="ty01"><%=itemtype1 %></td>
				<td class="ty01"><%=itemtype2 %></td>
				<td class="ty01"><%=itemtype3 %></td>
			</tr>
			<tr>
				<td><%=itemcode %></td>
				<td><%=itemcnt %></td>
				<td><%=itemgroup %></td>
			</tr>					
<%
		next
	end if 
%>
		</tbody>			
	</table><!--// list_ty -->	

</div>

<div class="btm_btns">
	<a href="javascript:void();" onclick="ItemAdd();" class="btn_ty btn_b">선택완료</a>
</div><!--// btm_btns -->

<%	if sType <> "" then %>
<script>
	CategoryChange('<%=sType %>', '<%=sType2 %>');
</script>
<%	end if %>