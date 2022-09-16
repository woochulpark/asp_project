<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%	
	menu = "근조기"
	
	page = request("page")
	sPage = 10

	page = request("page")
	sDate = request("sDate")
	eDate = request("eDate")
	sValue = request("sValue")
	sType = request("sType")

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
	SQL = SQL & " with geunjogiListTBL as ( "
	SQL = SQL & " select Row_Number() OVER (ORDER BY a.시스템일자 desc) AS rowNum, "	
	SQL = SQL & " a.행사번호, c.성함, convert(varchar(16),a.시스템일자,120) as 행사시작일, b.단체명, d.장례식장, isnull(e.회수자, '') as 회수자, isnull(convert(varchar(16),e.회수일,120), '') as 회수일, a.행사상태, a.일반단체구분 "
	SQL = SQL & " from 행사마스터 a "
	SQL = SQL & " left outer join 행사단체 b on a.행사단체 = b.단체코드 "
	SQL = SQL & " left outer join 행사의전팀장 c on a.진행팀장 = c.코드 "
	SQL = SQL & " left outer join 행사장례식장 d on a.장례식장 = d.코드 "
	SQL = SQL & " left outer join 근조기회수 e on a.행사번호 = e.행사번호 "
	SQL = SQL & " where a.근조기 = 'Y' "
	SQL = SQL & " and a.시스템일자 between '"& sDate &"' and '"& eDate2 &"' "

	If user_type = "b" Then
		SQL = SQL & " and a.본부 = '"& user_bunbu &"' "
	End if

	if sValue <> "" then
		SQL = SQL & " and c.성함 like '%"& sValue &"%' "
	end if
	if sType = "회수" then
		SQL = SQL & " and e.회수일 <> '' "
	end if
	if sType = "미회수" then
		SQL = SQL & " and e.회수일 is null "
	end if
	if user_boardmax > 0 then
		SQL = SQL & " and a.시스템일자 > '"& mDate &"' "
	end if
	SQL = SQL & " ) "
	SQL = SQL & " select * from geunjogiListTBL "
	SQL = SQL & " where rowNum between (("& page &" - 1) * "& sPage &") + 1 and "& page &" * "& sPage &" "
	SQL = SQL & " END "
	
	SQL_CNT = " select count(*) as count "	
	SQL_CNT = SQL_CNT & " from 행사마스터 a "
	SQL_CNT = SQL_CNT & " left outer join 행사단체 b on a.행사단체 = b.단체코드 "
	SQL_CNT = SQL_CNT & " left outer join 행사의전팀장 c on a.진행팀장 = c.코드 "
	SQL_CNT = SQL_CNT & " left outer join 행사장례식장 d on a.장례식장 = d.코드 "
	SQL_CNT = SQL_CNT & " left outer join 근조기회수 e on a.행사번호 = e.행사번호 "
	SQL_CNT = SQL_CNT & " where a.근조기 = 'Y' "	
	SQL_CNT = SQL_CNT & " and a.시스템일자 between '"& sDate &"' and '"& eDate2 &"' "

	If user_type = "b" Then
		SQL_CNT = SQL_CNT & " and a.본부 = '"& user_bunbu &"' "
	End if
	
	if sValue <> "" then
		SQL_CNT = SQL_CNT & " and c.성함 like '%"& sValue &"%' "
	end if
	if sType = "회수" then
		SQL_CNT = SQL_CNT & " and e.회수일 <> '' "
	end if
	if sType = "미회수" then
		SQL_CNT = SQL_CNT & " and e.회수일 is null "
	end if
	if user_boardmax > 0 then
		SQL_CNT = SQL_CNT & " and a.시스템일자 > '"& mDate &"' "
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

	<form name="frm" method="post" action="geunjogi_list.asp">
	<input type="hidden" id="page" name="page" value="<%=page %>" />

	<div class="search_box">
		<ul class="sch_form">
			<li class="ty01">
				<span class="dp_box"><input type="text" name="sDate" id="sDate" value="<%=sDate %>" class="datepicker input_ty start-date w100" placeholder="접수일" readonly ></span> ~ 
				<span class="dp_box"><input type="text" name="eDate" id="eDate" value="<%=eDate %>" class="datepicker input_ty end-date w100" placeholder="접수일" readonly ></span>
			</li>
			<li class="ty02">
				<select name="sType" id="sType" class="select_ty">
					<option value="">전체</option>
					<option value="회수">회수</option>
					<option value="미회수">미회수</option>
				</select>
				<input type="text" name="sValue" value="<%= sValue %>" class="input_ty" placeholder="의전팀장명">
			</li>
		</ul>		
		<a href="javascript:search();" class="btn_search">검색</a>
	</div><!--// search_box -->

	</form>

	<p class="list_top_noti">*의전팀장명 클릭 시 상세내용을 보실 수 있습니다.</p>

	<table class="list_ty">
		<caption>근조기 리스트</caption>
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
			CollName	= arrObj(6,i)
			CollDate	= arrObj(7,i)
			stat		= arrObj(8,i)
			ViewType	= arrObj(9,i)

			if Stat = "진행" then
				StatBtn = "<span class='btn_stat ty04'>진행</span>"
			elseif Stat = "완료" then
				StatBtn = "<span class='btn_stat ty05'>완료</span>"
			elseif Stat = "접수" then
				StatBtn = "<span class='btn_stat ty04'>접수</span>"
			else
				StatBtn = "<span class='btn_stat ty05'>접수취소</span>"
			end if
						
			Jang_Txt = JangName

			Date_Txt = Right(Replace(Split(StartDate, " ")(0), "-", "."), 8) & "<br>" & Split(StartDate, " ")(1)
			if CollDate = "" then
				Coll_Txt = "<span onclick=""ChangColl('"& Code &"');"" id='stat_"&Code&"' class='btn_stat ty06'>미회수</span>"
			else
				Coll_Txt = "<span onclick=""ChangColl('"& Code &"');"" id='stat_"&Code&"' class='btn_stat ty05'>회수</span>"
			end if

			if Stat = "진행" or Stat = "완료" then
				if ViewType = "용품배송" or ViewType = "화환배송" or ViewType = "용품+화환배송" or ViewType = "근조화환배송" then
					ViewType_URL = "/progression/progression_sign_b.asp?Code=" & FnAesEncrypt(Code, AesEncryptPwd)
					ViewType = "b"
				else
					ViewType_URL = "/progression/progression_progress.asp?Code=" & Code
					ViewType = "a"
				end if
			else
				if ViewType = "용품배송" or ViewType = "화환배송" or ViewType = "용품+화환배송" or ViewType = "근조화환배송" then
					ViewType_URL = "/reception/reception_info_b.asp?Code=" & FnAesEncrypt(Code, AesEncryptPwd)
					ViewType = "b"
				else
					ViewType_URL = "/reception/reception_info.asp?Code=" & Code
					ViewType = "a"
				end if
			end if
%>
			<tr>
				<td class="cur"><a href="<%=ViewType_URL %>"><%=Name %></a></td>
				<td class="fc-g"><%=Date_Txt %></td>
				<td><%=GroupName %></td>
				<td><%=Jang_Txt %></td>
				<td><%=Coll_Txt %><%=StatBtn %></td>
			</tr>
<%
		next
	end if 
%>						
		</tbody>
	</table><!--// list_ty -->

	<div class="paging" id="Paging"></div>

	<!--#include virtual="/common/layer_popup.asp"-->	

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
	function Save(type, code) {

		var cName = document.getElementById("cName").value;
		var cDate = document.getElementById("cDate").value;
		var cHour = document.getElementById("cHour").value;
		var cMin = document.getElementById("cMin").value;

		if (type == "a" || type == "b") {
			if (cName == "") {
				alert("회수자를 입력해 주세요.");
				return false;
			}
			if (cDate == "") {
				alert("회수일자를 입력해 주세요.");
				return false;
			}
		}
		if (!confirm("저장하시겠습니까?")) {
			return false;
		}
		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "geunjogi_collection_ok.asp", //요청을 보낼 서버의 URL
			data: { collType: type, code: code, collName: cName, collDate: cDate, collHour: cHour, collMin: cMin }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				//alert("저장되었습니다.");

				if (type == "c") {
					$("#stat_" + code).html("미회수");
					$("#stat_" + code).attr('class', 'btn_stat ty06');
				} else {
					$("#stat_" + code).html("회수");
					$("#stat_" + code).attr('class', 'btn_stat ty05');
				}
				alert('저장되었습니다.');
				Close();
			}
		});
	}
	function ChangColl(code) {		

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "geunjogi_collection.asp", //요청을 보낼 서버의 URL
			data: { code: code }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open('근조기회수');
			}
		});
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