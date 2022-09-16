<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%	
	menu = "상품검색"
	
	page = request("page")
	sPage = 10

	page = request("page")
	sType = request("sType")
	sValue = request("sValue")	

	if page = "" then 
		page = 1
	end if

	if sType = "" then
		sType = "a"
	end if

	SQL = " BEGIN "
	SQL = SQL & " with boardListTBL as ( "
	if sType = "a" then
		SQL = SQL & " select Row_Number() OVER (ORDER BY b.단체명 desc) AS rowNum, "
	else
		SQL = SQL & " select Row_Number() OVER (ORDER BY a.상품명 desc) AS rowNum, "
	end if 
	SQL = SQL & " a.상품코드, a.상품명, replace(convert(varchar, convert(money, a.상품액), 1), '.00', '') as 상품액변환, a.단체구분, a.파일명, b.단체명 "
	SQL = SQL & " from 상품코드 a (nolock) "
	SQL = SQL & " left outer join 행사단체 b (nolock) on a.집계구분 = b.단체명 "

	if sType = "a" then
		if sValue <> "" then
			SQL = SQL & " where b.단체명 like '%"& sValue &"%' "
		end if
	else
		if sValue <> "" then
			SQL = SQL & " where a.상품명 like '%"& sValue &"%' "
		end if		
	end if 
	SQL = SQL & " and a.상품코드 not in (select 상품코드 from 상품코드 nolock where 단체구분 = '단체' and 판매종료일자 <> '99991231') "
	SQL = SQL & " ) "	
	SQL = SQL & " select * from boardListTBL "
	SQL = SQL & " where rowNum between (("& page &" - 1) * "& sPage &") + 1 and "& page &" * "& sPage &" "
	SQL = SQL & " END "		
	
	SQL_CNT = " select count(*) as count "
	SQL_CNT = SQL_CNT & " from 상품코드 a (nolock) "	
	SQL_CNT = SQL_CNT & " left outer join 행사단체 b (nolock) on a.집계구분 = b.단체명 "	

	if sType = "a" then
		if sValue <> "" then
			SQL_CNT = SQL_CNT & " where b.단체명 like '%"& sValue &"%' "
		end if
	else
		if sValue <> "" then
			SQL_CNT = SQL_CNT & " where a.상품명 like '%"& sValue &"%' "
		end if
	end if

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

	'response.Write SQL & "<br>" & SQL_CNT
%>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->
	<form name="frm" method="post" action="product_list.asp">
	<input type="hidden" id="page" name="page" value="<%=page %>" />

	<div class="search_box">
		<ul class="sch_form">
			<li class="ty02">
				<select name="sType" id="sType" class="select_ty">
					<option value="a">단체명</option>
					<option value="b">상품명</option>
				</select>
				<input type="text" name="sValue" value="<%= sValue %>" class="input_ty" placeholder="단체명 또는 상품명">
			</li>
		</ul>
		<a href="javascript:search();" class="btn_search">검색</a>
	</div><!--// search_box -->

	</form>

	<p class="list_top_noti">*상품명 클릭 시 상세내용을 보실 수 있습니다.</p>
	<table class="list_ty">
		<caption>상품검색 리스트</caption>
		<colgroup>
			<col span="1" class="list_w01"><col span="1" class="list_w00"><col span="1" class="list_w00"><col span="1" class="verti_w05">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">구분</th>
				<th scope="col">상품명</th>
				<th scope="col">단체명</th>
				<th scope="col">본인부담액</th>
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
			Code		= arrObj(1,i)
			Name		= arrObj(2,i)
			Price		= arrObj(3,i)
			Gubun		= arrObj(4,i)
			file		= arrObj(5,i)
			Danche		= arrObj(6,i)			
%>
			<tr>
				<td><%=Gubun %></td>
				<td><a href="javascript:void(0);" onclick="View('<%=file %>');" class="link"><%=Name %></a></td>				
				<td><%=Danche %></td>
				<td><%=Price %></td>
			</tr>		
<%
		next
	end if 
%>				
		</tbody>
	</table><!--// list_ty -->

	<div class="paging" id="Paging"></div>



	<!--// 해당 페이지 내, 팝업은 pdf만 호출하신다고 하셔서, 따로 퍼블할 게 없습니다. -->

</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->

<script type="text/javascript" language="javascript" src="/js/paging.js"></script>		
<script language="javascript" type="text/javascript">
	function search() {
		var frm = document.frm;
		frm.page.value = "1";
		frm.submit();
	}
	function goPage(page) {
		var frm = document.frm;
		frm.page.value = page;
		frm.submit();
	}
	function View(filename) {
		window.open('http://pdf.apluslife.co.kr/UTF/item_view.asp?spum_file=' + filename , '_blank');
	}
	document.getElementById("sType").value = "<%=sType %>";	
</script>
<% if rc <> 0 then %>
<script language="javascript" type="text/javascript">
<!--
	GSGAdminPaging("<%=tCnt %>", "<%=sPage %>", "<%=page %>", "goPage")
//-->
</script>
<% end if %>