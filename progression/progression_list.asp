<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%	
	menu = "진행"

	dim page, sPage, sType, sValue
	page = request("page")
	sPage = 10

	page = request("page")
	sDate = request("sDate")
	eDate = request("eDate")
	sValue = request("sValue")

	if page = "" then 
		page = 1
	end if

	mDate = DateAdd("m",-1*user_boardmax,date())

	if sDate = "" then
		sDate = DateAdd("d",-1*user_board,date())
	end if
	if eDate = "" then
		eDate = date()		
	end if

	eDate2 = DateAdd("d",1,eDate)

	SQL = " BEGIN "
	SQL = SQL & " with receptionListTBL as ( "
	SQL = SQL & " select Row_Number() OVER (ORDER BY a.시스템일자 desc) AS rowNum, "	
	SQL = SQL & " a.행사번호, c.성함, convert(varchar(16),a.시스템일자,120) as 행사시작일, b.단체명, d.장례식장, a.행사상태, isnull(e.상태,'') as 상태, a.일반단체구분 "
	SQL = SQL & " from 행사마스터 a "
	SQL = SQL & " left outer join 행사단체 b on a.행사단체 = b.단체코드 "
	SQL = SQL & " left outer join 행사의전팀장 c on a.진행팀장 = c.코드 "
	SQL = SQL & " left outer join 행사장례식장 d on a.장례식장 = d.코드 "	
	SQL = SQL & " left outer join 행사_승인요청 e on a.행사번호 = e.행사번호 "
	SQL = SQL & " where a.행사상태 in ('진행', '완료') "
	if sValue <> "" then
		SQL = SQL & " and c.성함 like '%"& sValue &"%' "
	end if
	SQL = SQL & " and a.시스템일자 between '"& sDate &"' and '"& eDate2 &"' "
	if user_boardmax > 0 then
		SQL = SQL & " and a.시스템일자 > '"& mDate &"' "
	end if
    if user_type = "b" then
        SQL = SQL & " and a.본부 = '"& user_bunbu &"' "
    end if 
	SQL = SQL & " ) "
	SQL = SQL & " select * from receptionListTBL "
	SQL = SQL & " where rowNum between (("& page &" - 1) * "& sPage &") + 1 and "& page &" * "& sPage &" "
	SQL = SQL & " END "
	
	SQL_CNT = " select count(*) as count "	
	SQL_CNT = SQL_CNT & " from 행사마스터 a "
	SQL_CNT = SQL_CNT & " left outer join 행사단체 b on a.행사단체 = b.단체코드 "
	SQL_CNT = SQL_CNT & " left outer join 행사의전팀장 c on a.진행팀장 = c.코드 "
	SQL_CNT = SQL_CNT & " left outer join 행사장례식장 d on a.장례식장 = d.코드 "	
	SQL_CNT = SQL_CNT & " where a.행사상태 in ('진행', '완료') "
	if sValue <> "" then
		SQL_CNT = SQL_CNT & " and c.성함 like '%"& sValue &"%' "
	end if
	SQL_CNT = SQL_CNT & " and a.시스템일자 between '"& sDate &"' and '"& eDate2 &"' "
	if user_boardmax > 0 then
		SQL_CNT = SQL_CNT & " and a.시스템일자 > '"& mDate &"' "
	end if
    if user_type = "b" then
        SQL_CNT = SQL_CNT & " and a.본부 = '"& user_bunbu &"' "
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
	<form name="frm" method="post" action="progression_list.asp">
	<input type="hidden" id="page" name="page" value="<%=page %>" />

	<div class="search_box">
		<ul class="sch_form">
			<li class="ty01">
				<span class="dp_box"><input type="text" id="sDate" name="sDate" value="<%=sDate %>" class="datepicker input_ty start-date w100" placeholder="접수일" readonly ></span> ~ 
				<span class="dp_box"><input type="text" id="eDate" name="eDate" value="<%=eDate %>" class="datepicker input_ty end-date w100" placeholder="접수일" readonly ></span>
			</li>
			<li>
				<input type="text" class="input_ty w100" name="sValue" value="<%= sValue %>" placeholder="의전팀장명">
			</li>
		</ul>
		<a href="javascript:search();" class="btn_search">검색</a>
	</div><!--// search_box -->

	</form>

	<p class="list_top_noti">*의전팀장명 클릭 시 상세내용을 보실 수 있습니다.</p>

	<table class="list_ty">
		<caption>접수 리스트</caption>
		<colgroup>
			<col span="1" class="list_w01"><col span="1" class="list_w02"><col span="2" class="list_w00"><col span="1" class="list_w03">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">의전<br class="m_br">팀장</th>
				<th scope="col">접수일</th>
				<th scope="col">일반/단체</th>
				<th scope="col">장례식장</th>
				<th scope="col">상태</th>
			</tr>
		</thead>
		<tbody>
<%
	if rc = 0 then 
%>
			<tr><td colspan="5">일치하는 검색결과가 없습니다.</td></tr>
<%
	else
		for i=0 to UBound(arrObj,2)
			Code		= arrObj(1,i)
			Name		= arrObj(2,i)
			StartDate	= arrObj(3,i)
			GroupName	= arrObj(4,i)
			JangName	= arrObj(5,i)
			Stat		= arrObj(6,i)
			Stat2		= arrObj(7,i)		
			ViewType	= arrObj(8,i)

            if Name = "" or isnull(Name) then
                Name = "배정전"
            end if

			if ViewType = "용품배송" or ViewType = "화환배송" or ViewType = "용품+화환배송" or ViewType = "근조화환배송" then
				ViewType_URL = "progression_sign_b.asp?Code=" & FnAesEncrypt(Code, AesEncryptPwd)
				ViewType = "b"
			else
				ViewType_URL = "progression_progress.asp?Code=" & Code
				ViewType = "a"
			end if

			StatBtn = ""
			Stat2Btn = ""
			if Stat = "진행" then
				StatBtn = "<span class='btn_stat ty04'>진행</span>"
			else
				StatBtn = "<span class='btn_stat ty05'>완료</span>"
			end if

			if Stat2 = "완료승인요청" then
				Stat2Btn = "<span class='btn_stat ty02'>승인요청중</span>"
			end if

			StartDate = replace(right(replace(StartDate, "-", "."),14), " ", "<br>")
			
%>
			<tr>
				<td><a href="<%=ViewType_URL %>"><%=Name %></a></td>
				<td><%=StartDate %></td>
				<td><%=GroupName %></td>
				<td><%=JangName %></td>
				<td><a href="<%=ViewType_URL %>"><%=StatBtn %><%=Stat2Btn %></a></td><!--// 클래스별로 ty04 : 진행/ ty02 : 승인요청중 / ty05 : 완료 -->
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
	function SendMMS(code) {
		confirm("문자발송하시겠습니까?");
	}	
</script>

<% if rc <> 0 then %>
<script language="javascript" type="text/javascript">
	GSGAdminPaging("<%=tCnt %>", "<%=sPage %>", "<%=page %>", "goPage")
</script>
<% end if %>