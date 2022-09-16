<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%
	menu = "장례식장"

	searchtext = request("searchtext")
	area = request("area")
	area2 = request("area2")
	page = request("page")
	code = request("code")

	if code = "" then 
		response.End
	end if

	SQL = " select 코드,주소,장례식장,연락처, "
	SQL = SQL & " isnull(이용조건,'') as 이용조건 , isnull(이용관빈소,'') as 이용관빈소 , isnull(이용입관용품,'') as 이용입관용품, "
	SQL = SQL & " isnull(이용제단,'') as 이용제단 , isnull(이용버스,'') as 이용버스 , isnull(이용리무진,'') as 이용리무진 "
	SQL = SQL & " from 행사장례식장 "
	SQL = SQL & " where 코드 = '" & code & "' "

	SQL2 = " select b.코드,b.평수,b.빈소수, "
	SQL2 = SQL2 & " isnull(replace(convert(varchar, convert(money, b.일일빈소료), 1), '.00', ''),0) as 일일빈소료, "
	SQL2 = SQL2 & " isnull(replace(convert(varchar, convert(money, b.시간빈소료), 1), '.00', ''),0) as 시간빈소료 "
	SQL2 = SQL2 & " from "
	SQL2 = SQL2 & " 행사장례식장 a inner join 행사빈소시설 b on a.코드 = b.코드 "
	SQL2 = SQL2 & " where b.코드 = '"& code &"' and b.삭제여부 = 'N' "
	SQL2 = SQL2 & " order by b.평수 desc "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)	

	If Rs.EOF Then
		
	Else
		code		 = Rs("코드")
		addr		 = Rs("주소")
		jangname	 = Rs("장례식장")
		tel			 = Rs("연락처")
		jogun		 = Rs("이용조건")
		binso		 = Rs("이용관빈소")
		yong		 = Rs("이용입관용품")
		jeadan		 = Rs("이용제단")		
		bus			 = Rs("이용버스")
		rimujin		 = Rs("이용리무진")
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

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->

	<form name="frm" method="post" action="funeral_list.asp">
		<input type="hidden" id="page" name="page" value="<%=page %>" />
		<input type="hidden" id="area" name="area" value="<%=area %>" />
		<input type="hidden" id="area2" name="area2" value="<%=area2 %>" />
		<input type="hidden" id="searchtext" name="searchtext" value="<%=searchtext %>" />
		<input type="hidden" id="addr" name="addr" value="<%=addr %>"  />
		<input type="hidden" id="jangname" name="jangname" value="<%=jangname %>" />
	</form>

	<p class="fune_name"><%=jangname %></p>
	
	<p class="sub_tit mt">기본정보</p>
	<table class="table_ty verti">
		<caption>장례식장-상세-기본정보</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="1" style="width:*%;">
		</colgroup>

			<tr>
				<th scope="row" class="btnu">주소<a href="javascript:void();"  onclick="goMap();" class="btn_ico ico06">MAP 바로가기</a></th>
				<td><%=addr %></td>
			</tr>
			<tr>
				<th scope="row">연락처</th>
				<td><a href="tel:<%=tel %>"><%=tel %></a></td>
			</tr>
	</table>

	<p class="sub_tit mt">이용정보</p>
	<table class="table_ty verti">
		<caption>장례식장-상세-이용정보</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="1" style="width:*%;">
		</colgroup>

			<tr>
				<th scope="row">이용조건</th>
				<td><%=jogun %></td>
			</tr>
			<tr>
				<th scope="row">관/빈소용품</th>
				<td><%=binso %></td>
			</tr>
			<tr>
				<th scope="row">입관용품</th>
				<td><%=yong %></td>
			</tr>
			<tr>
				<th scope="row">제단</th>
				<td><%=jeadan %></td>
			</tr>
			<tr>
				<th scope="row">버스</th>
				<td><%=bus %></td>
			</tr>
			<tr>
				<th scope="row">리무진</th>
				<td><%=rimujin %></td>
			</tr>
	</table>

	<p class="sub_tit mt">빈소시설</p>
	<table class="table_ty">
		<caption>장례식장-상세-기본정보</caption>
		<colgroup>
			<col span="1" class="verti_w05"><col span="1" class="verti_w02"><col span="2" style="width:*%;">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">평수</th>
				<th scope="col">빈소수</th>
				<th scope="col">일일반소료</th>
				<th scope="col">시간빈소료</th>
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
			Meter		= arrObj(1,i)
			Binsosu		= arrObj(2,i)
			Priceday	= arrObj(3,i)
			Pricetime	= arrObj(4,i)
						
%>
			<tr>
				<td><%=Meter %></td>
				<td><%=Binsosu %></td>
				<td><%=Priceday %></td>
				<td><%=Pricetime %></td>
			</tr>		
<%
		next
	end if 
%>	
		</tbody>			
	</table>	

	<!--// 191203 추가 -->
	<div class="btm_btns">
		<a href="javascript:window.history.back();" class="btn_ty btn_b ty05">리스트</a>
	</div><!--// btm_btns -->

</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->

<script language="javascript" type="text/javascript">
	function List() {
		document.frm.action = 'funeral_list.asp';
		document.frm.target = '_self';
		document.frm.submit();
	}
	function goMap() {
		window.open('', 'map');
		document.frm.target = 'map';
		document.frm.action = '/map/map.asp';
		document.frm.submit();
	}
</script>