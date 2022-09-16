<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check2.asp"-->

<%		
	code = request("Code")

	SQL = "select isnull([입금액계],'0') as 입금액계, isnull([실입금회차],'0') as 실입금회차 "
	SQL = SQL & " from LifeWeb.dbo.계약마스터V "	
	SQL = SQL & " where [계약코드] = '"& code &"' "	

	SQL2 = "select isnull(a.납입일자,'') as 수납일자, isnull(a.회차,'') as 회차, isnull(a.입금액,'0') as 입금액, "
	SQL2 = SQL2 & " (select top(1) 입금방법 from 수납마스터 where 수납일자 = a.납입일자 and 계약코드 = a.계약코드 order by 입금방법) as 방법 "	
	SQL2 = SQL2 & " from [LifeErp].[dbo].[수납일정표V] a "
	SQL2 = SQL2 & " where a.계약코드 = '"& code &"' "
	SQL2 = SQL2 & " and a.납입일자 <> '' "
	SQL2 = SQL2 & " and a.입금액 = a.납입예정금액 "
	SQL2 = SQL2 & " order by 회차 desc "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ		
		
	Set Rs = ConnAplus.execute(SQL)	

	If Rs.EOF Then
		total = 0
		totalcnt = 0
	Else		
		total = FormatNumber(Rs("입금액계"),0)
		totalcnt = Rs("실입금회차")
	End If

	Set Rs = ConnAplus.execute(SQL2)

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

	<table class="table_ty verti">
		<caption>납입내역</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="1" style="width:*%;">
		</colgroup>

			<tr>
				<th scope="row">총 납입횟수</th>
				<td><%=totalcnt %>회</td>
			</tr>
			<tr>
				<th scope="row">총 불입액</th>
				<td><%=total %>원</td>
			</tr>
	</table>

	<table class="table_ty mt">
		<caption>납입내역</caption>
		<colgroup>
			<col span="1" class="verti_w05"><col span="1" class="verti_w04"><col span="1" style="width:*%;"><col span="1" class="verti_w04">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">수납일자</th>
				<th scope="col">회차</th>
				<th scope="col">입금액</th>
				<th scope="col">방법</th>
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
			p1	= arrObj(0,i)
			p2	= arrObj(1,i)
			p3	= FormatNumber(arrObj(2,i),0)
			p4	= arrObj(3,i)

			p1 = left(p1,4) & "-" & mid(p1,5,2) & "-" & right(p1,2)
%>
			<tr>						
				<td><%=p1 %></td>						
				<td><%=p2 %></td>
				<td><%=p3 %></td>
				<td><%=p4 %></td>
			</tr>
<%
		next
	end if 
%>
		</tbody>
	</table>

</div>