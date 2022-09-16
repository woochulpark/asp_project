<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	dim sValue
	sValue = request("sValue")	
	sType = request("sType")

	SQL = " select top 100 a.사원코드, a.사원명, a.사원구분, left(a.주민번호,6), replace(a.휴대폰,' ',''), isnull(a.지역,''), isnull(b.은행명,''), a.계좌번호, a.예금주명, isnull(a.메모, ''), isnull(c.결과코드, '2') as 결과코드, "
	'SQL = SQL & " isnull((select 구분1 from 공용코드 where 대표코드 = '00255' and 대표명칭 = a.사원구분), 0) as 단가 "	
	SQL = SQL & " 0 as 단가 "	
	SQL = SQL & " from 행사사원마스터 a left outer join 은행코드 b on a.은행코드 = b.은행코드 "	
	SQL = SQL & " left outer join (select 이름,주민번호, 결과코드 from 개인실명확인이력 (nolock) where 결과코드 <> '2') c on a.사원명 = c.이름 and a.주민번호 = c.주민번호"	
	SQL = SQL & " where a.주민번호 is not null and 활성='Y' "
	if sValue <> "" then
		SQL = SQL & " and a.사원명 like '%" & sValue & "%' "
		SQL = SQL & " OR LEFT(a.주민번호,6) ='" & sValue & "' "
	end if
	SQL = SQL & " order by 사원명 asc "	

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
		<input type="text" name="sValue" id="sValue" value="<%= sValue %>" class="input_ty" placeholder="이름 또는 생년월일">
		<a href="javascript:void(0);" onclick="HelperList3('<%=sType %>', $('#sValue').val());" class="btn_search">검색</a>
	</div><!--// def_search -->
	<a href="javascript:void(0);" onclick="HelperWrite('<%=sType %>', '<%=sValue %>');" class="btn_ty btn_b btn_add ty03 w100">신규등록</a>
	<p class="list_top_noti mt">* 도우미명 클릭 시 수정가능합니다.</p>

	<table class="table_ty">
		<caption>도우미 리스트</caption>
		<colgroup>
			<col span="1" class="list_w02"><col span="2" class="list_w00"><col span="1" class="list_w02">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">도우미명</th>
				<th scope="col">주민번호</th>
				<th scope="col">휴대폰</th>
				<th scope="col">메모</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="ht02">은행명</td>
				<td class="ht02">계좌번호</td>
				<td class="ht02">예금주</td>
				<td></td>
			</tr>
		</tbody>
	</table>

	<table class="list_ty verti mt">
		<caption>도우미 리스트</caption>
		<colgroup>
			<col span="1" class="list_w02"><col span="2" class="list_w00"><col span="1" class="list_w05" width="19%">
		</colgroup>
		<tbody>
<%
	if rc = 0 then 
%>
			<tr><td colspan="4">일치하는 검색결과가 없습니다.</td></tr>
<%
	else
		for i=0 to UBound(arrObj,2)
			mcode		= arrObj(0,i)
			mname		= arrObj(1,i)
			mtype		= arrObj(2,i)
			mjumin		= arrObj(3,i)
			mphone		= arrObj(4,i)
			marea		= arrObj(5,i)
			mbank		= arrObj(6,i)
			mbankno		= arrObj(7,i)
			mbankuser	= arrObj(8,i)
			memo		= arrObj(9,i)
			mrescode	= arrObj(10,i)
			mpay		= arrObj(11,i)
			If Len(memo) > 3 Then 
				memo = Left(memo, 4) & "..."
			End If 
%>
			<tr>
				<td class="ty01"><a href="javascript:void(0);" onclick="HelperView('<%=sType %>', '<%=sValue %>', '<%=mcode %>');"><%=mname %></a></td>
				<td class="ty01"><%=mjumin %></td>
				<td class="ty01"><%=mphone %></td>
				<td class="ty01" maxlength="4" style="word-wrap:normal;"><%=memo %></td>
			</tr>
			<tr>
				<td><%=mbank %></td>
				<td><%=mbankno %></td>
				<td><%=mbankuser %></td>
				<% If mrescode <> "2" Then %>
					<td>
						<a href="javascript:void(0);" onclick="HelperAdd('<%=sType %>', '<%=mcode %>', '<%=mname %>', '<%=mtype %>', '<%=mpay %>');" 
							class="btn_ty ty02">
							선택
						</a>
					</td>
				<% Else %>
					<td>실명인증필요</td>
				<%End If %>

			</tr>					
<%
		next
	end if 
%>
		</tbody>
	</table>

</div>