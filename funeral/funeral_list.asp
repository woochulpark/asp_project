<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%	
	menu = "장례식장"
	
	page = request("page")
	sPage = 10

	searchtext = request("searchtext")
	area = request("area")
	area2 = request("area2")

	if area2 = "" then
		area2 = "구군별"
	end if

	if page = "" then 
		page = 1
	end if 	

	SQL = " BEGIN "
	SQL = SQL & " with jangsaList as ( "
	SQL = SQL & " select Row_Number() OVER (ORDER BY 시도 asc , 군구 asc ) AS rowNum, "
	SQL = SQL & " * "		
	SQL = SQL & " from "
	SQL = SQL & " 행사장례식장 "	
	SQL = SQL & " where 영업여부 ='영업' "

	if area = "" then
		
	elseif area2 = "구군별" then
		SQL = SQL & " and 시도 = '"& area &"' "
	else		
		SQL = SQL & " and 시도 = '"& area &"' and 군구 = '"& area2 &"' "
	end if	

	if searchtext <> "" then 
		SQL = SQL & " and 장례식장 like '%"& searchtext &"%' "
	end if 

	SQL = SQL & " ) "
	SQL = SQL & " select * from jangsaList "
	SQL = SQL & " where rowNum between (("& page &" - 1) * "& sPage &") + 1 and "& page &" * "& sPage &" "
	SQL = SQL & " end "	
	
	SQL_CNT = " select count(*) as count from 행사장례식장 where 영업여부 ='영업' "

	if area = "" then
		
	elseif area2 = "구군별" then		
		SQL_CNT = SQL_CNT & " and 시도 = '"& area &"' "		
	else		
		SQL_CNT = SQL_CNT & " and 시도 = '"& area &"' and 군구 = '"& area2 &"' "
	end if	

	if searchtext <> "" then 
		SQL_CNT = SQL_CNT & " and 장례식장 like '%"& searchtext &"%' "
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
%>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->

	<form name="frm" method="post" action="funeral_list.asp">
	<input type="hidden" id="page" name="page" value="<%=page %>" />
	<input type="hidden" id="code" name="code" />

	<div class="search_box">
		<ul class="sch_form">
			<li class="ty02">
				<select name="area" id="area" onchange="itemChange(this.form);" class="select_ty"></select>
				<select name="area2" id="area2" class="select_ty"></select>
			</li>
			<li>
				<input type="text" name="searchtext" value="<%= searchtext %>" class="input_ty w100" placeholder="장례식장명">
			</li>
		</ul>
		<a href="javascript:search();" class="btn_search">검색</a>
	</div><!--// search_box -->

	</form>

	<p class="list_top_count">총 <span><%= tCnt %></span>개가 검색되었습니다.</p>

	<p class="list_top_noti">*장례식장명 클릭 시 상세내용을 보실 수 있습니다.</p>
	<table class="list_ty">
		<caption>장례식장 리스트</caption>
		<colgroup>
			<col span="2" class="list_w02"><col span="2" class="list_w00">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">지역</th>
				<th scope="col">구군</th>
				<th scope="col">장례식장명</th>
				<th scope="col">연락처</th>
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
			Jangname	= arrObj(2,i)
			Tel			= arrObj(3,i)
			Sido		= arrObj(5,i)
			Gungu		= arrObj(6,i)

			if Tel = "" then
				Tel_Txt = ""
			else
				Tel_Txt = "<a href='tel:"& Tel &"' class='btn_ty ty02'>"& Tel &"</a>"
			end if
						
%>
			<tr>
				<td><%=Sido %></td>
				<td><%=Gungu %></td>
				<td><a href="javascript:void();" onclick="View('<%=Code %>')"><%=Jangname %></a></td>
				<td><%=Tel_Txt %></td>
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
<script type="text/javascript" language="javascript" src="/js/addr.js"></script>
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
	function View(code) {
		var frm = document.frm;
		frm.code.value = code;
		frm.action = "funeral_view.asp"
		frm.submit();
	}

	init(this.frm);
	document.getElementById("area").value = "<%=area %>";
	itemChange(this.frm);
	document.getElementById("area2").value = "<%=area2 %>";
</script>
<% if rc <> 0 then %>
<script language="javascript" type="text/javascript">
<!--
	GSGAdminPaging("<%=tCnt %>", "<%=sPage %>", "<%=page %>", "goPage")
//-->
</script>
<% end if %>