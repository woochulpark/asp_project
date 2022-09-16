<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%	
	menu = "상담신청확인"
	
	page = request("page")
	sPage = 10

	if page = "" then 
		page = 1
	end if	

	SQL = " BEGIN "
	SQL = SQL & " with boardListTBL as ( "
	SQL = SQL & " select Row_Number() OVER (ORDER BY 인덱스 desc) AS rowNum, "	
	SQL = SQL & " 이름, 연락처, 상담종류, CONVERT(varchar(16), 등록일, 120) as 신청일 "
	SQL = SQL & " from 상담예약 (nolock) "
	SQL = SQL & " ) "	
	SQL = SQL & " select * from boardListTBL "
	SQL = SQL & " where rowNum between (("& page &" - 1) * "& sPage &") + 1 and "& page &" * "& sPage &" "
	SQL = SQL & " END "

	SQL_CNT = " select count(*) as count "
	SQL_CNT = SQL_CNT & " from 상담예약 (nolock) "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ	

	Set Rs = ConnAplus.execute(SQL_CNT)

	tCnt = Rs("count")	
		
	Set Rs = ConnAplus.execute(SQL)		

	If Rs.EOF Then
		rc = 0		
	Else
		rc = Rs.RecordCount
		arrObj = Rs.GetRows(sPage)		
	End If	

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing
%>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->
	<form name="frm" method="post" action="reservation_list.asp">
		<input type="hidden" id="page" name="page" value="<%=page %>" />
	</form>

	<table class="list_ty">
		<caption>상품검색 리스트</caption>
		<colgroup>
			<col span="1" class="list_w01"><col span="1" class="list_w00"><col span="2" class="list_w02">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">이름</th>
				<th scope="col">연락처</th>
				<th scope="col">구분</th>
				<th scope="col">신청일</th>
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
			Name		= arrObj(1,i)
			PhoneNo		= arrObj(2,i)
			Gubun		= arrObj(3,i)
			Regdate		= arrObj(4,i)				
%>
			<tr>
				<td><%=Name %></td>
				<td><%=PhoneNo %></td>
				<td><%=Gubun %></td>
				<td><%=Regdate %></td>
			</tr>
<%
		next
	end if 
%>				
		</tbody>
	</table><!--// list_ty -->

	<div class="paging" id="Paging"></div>	

</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->

<script type="text/javascript" language="javascript" src="/js/paging.js"></script>		
<script language="javascript" type="text/javascript">	
	function goPage(page) {
		var frm = document.frm;
		frm.page.value = page;
		frm.submit();
	}
</script>
<% if rc <> 0 then %>
<script language="javascript" type="text/javascript">
<!--
	GSGAdminPaging("<%=tCnt %>", "<%=sPage %>", "<%=page %>", "goPage")
//-->
</script>
<% end if %>