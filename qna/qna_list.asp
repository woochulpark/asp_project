<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%		
	menu = "만족도평가"
	
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

	if sDate = "" then
		sDate = DateAdd("d",-15,date())
	end if
	if eDate = "" then
		eDate = date()
	end if

	eDate2 = DateAdd("d",0,eDate)

	SQL = " BEGIN "
	SQL = SQL & " with qnaListTBL as ( "
	SQL = SQL & " select Row_Number() OVER (ORDER BY left(a.행사시작일시,8) desc, a.행사번호 desc) AS rowNum "	
	SQL = SQL & " , a.행사번호, c.성함, convert(varchar(16),a.시스템일자,120) as 행사시작일, b.단체명, d.장례식장, isnull(e.점수6, 0) as 설문조사 "
	'SQL = SQL & " , f.etc2 as etc2_1 "
	SQL = SQL & " , isnull(g.etc2, '미전송') as etc2_2 "
	SQL = SQL & " from 행사마스터 a (nolock) "
	SQL = SQL & " left outer join 행사단체 b (nolock) on a.행사단체 = b.단체코드 "
	SQL = SQL & " left outer join 행사의전팀장 c (nolock) on a.진행팀장 = c.코드 "
	SQL = SQL & " left outer join 행사장례식장 d (nolock) on a.장례식장 = d.코드 "	
	SQL = SQL & " left outer join 행사모니터링 e (nolock) on a.행사번호 = e.행사코드 "
	'SQL = SQL & " left outer join (select etc2, etc4 from ums_data (nolock) where etc2 = '행사_설문조사' and dest_phone not in ('01033001620', '01036828963')) f on a.행사번호 = f.etc4 "
	'SQL = SQL & " left outer join (select etc2, etc4 from ums_log (nolock) where etc2 = '행사_설문조사' and dest_phone not in ('01033001620', '01036828963')) g on a.행사번호 = g.etc4 "
	SQL = SQL & " left outer join (select isnull(SMS_RCPT_MSG, '') etc2, right(sn,13) etc4 from MZSENDLOG (nolock) "
	SQL = SQL & "						where SUBJECT = '[A+라이프 효담 상조] 만족도 평가' "
	SQL = SQL & "                       and PHONE_NUM not in ('01033001620', '01036828963') "
	SQL = SQL & "                  ) g on a.행사번호 = g.etc4 "
	SQL = SQL & " where a.행사상태 in ('완료', '진행') "

	If user_type = "b" Then
		SQL = SQL & " and a.본부 = '"& user_bunbu &"' "
	End if

	if sType = "평가완료" then
		SQL = SQL & " and isnull(e.점수6, 0) <> 0 "
	end if
'	if sType = "문자전송완료" then
'		SQL = SQL & " and (f.etc2 is not null or g.etc2 is not null) and e.점수1 is null "
'	end if
'	if sType = "문자전송미완료" then
'		SQL = SQL & " and (f.etc2 is null and g.etc2 is null) "
'	end if
	if sType = "문자전송완료" then
		SQL = SQL & " and ( isnull(g.etc2, '미전송') in ('전송성공', '') and isnull(e.점수6, 0) = 0 ) "
	end If
	if sType = "문자전송미완료" then
		SQL = SQL & " and isnull(g.etc2, '미전송') in ('미전송') and isnull(e.점수6, 0) = 0 "
	end if
	if sType = "문자전송오류" then
		SQL = SQL & " and isnull(g.etc2, '미전송') not in ('전송성공', '', '미전송') and isnull(e.점수6, 0) = 0 "
	end if
	
	if sValue <> "" then
		SQL = SQL & " and c.성함 = '"& sValue &"' "
	end if
	SQL = SQL & " and a.일반단체구분 not in ('용품배송', '화환배송', '용품+화환배송', '근조화환배송') "
	SQL = SQL & " and left(a.행사시작일시,8) between '"& Replace(sDate,"-","") &"' and '"& Replace(eDate2,"-","") &"' "
	SQL = SQL & " ) "
	SQL = SQL & " select * from qnaListTBL "
	SQL = SQL & " where rowNum between (("& page &" - 1) * "& sPage &") + 1 and "& page &" * "& sPage &" "
	SQL = SQL & " END "
	
	SQL_CNT = " select count(*) as count "	
	SQL_CNT = SQL_CNT & " from 행사마스터 a "
	SQL_CNT = SQL_CNT & " inner join 행사단체 b (nolock) on a.행사단체 = b.단체코드 "
	SQL_CNT = SQL_CNT & " inner join 행사의전팀장 c (nolock) on a.진행팀장 = c.코드 "
	SQL_CNT = SQL_CNT & " inner join 행사장례식장 d (nolock) on a.장례식장 = d.코드 "	
	SQL_CNT = SQL_CNT & " left outer join 행사모니터링 e (nolock) on a.행사번호 = e.행사코드 "
	'SQL_CNT = SQL_CNT & " left outer join (select etc2, etc4 from ums_data (nolock) where etc2 = '행사_설문조사' and dest_phone not in ('01033001620', '01036828963')) f on a.행사번호 = f.etc4 "
	'SQL_CNT = SQL_CNT & " left outer join (select etc2, etc4 from ums_log (nolock) where etc2 = '행사_설문조사' and dest_phone not in ('01033001620', '01036828963')) g on a.행사번호 = g.etc4 "
	SQL_CNT = SQL_CNT & " left outer join (select isnull(SMS_RCPT_MSG, '') etc2, right(sn,13) etc4 from MZSENDLOG (nolock) "
	SQL_CNT = SQL_CNT & "						where SUBJECT = '[A+라이프 효담 상조] 만족도 평가' "
	SQL_CNT = SQL_CNT & "                       and PHONE_NUM not in ('01033001620', '01036828963') "
	SQL_CNT = SQL_CNT & "                  ) g on a.행사번호 = g.etc4 "
	SQL_CNT = SQL_CNT & " where a.행사상태 in ('완료', '진행') "	

	If user_type = "b" Then
		SQL_CNT = SQL_CNT & " and a.본부 = '"& user_bunbu &"' "
	End if
	
	if sType = "평가완료" then
		SQL_CNT = SQL_CNT & " and isnull(e.점수6, 0) <> 0 "
	end if
	if sType = "문자전송완료" then
		SQL_CNT = SQL_CNT & " and ( isnull(g.etc2, '미전송') in ('전송성공', '') and isnull(e.점수6, 0) = 0) "
	end If
	if sType = "문자전송미완료" then
		SQL_CNT = SQL_CNT & " and isnull(g.etc2, '미전송') in ('미전송') and isnull(e.점수6, 0) = 0 "
	end if
	if sType = "문자전송오류" then
		SQL_CNT = SQL_CNT & " and isnull(g.etc2, '미전송') not in ('전송성공', '', '미전송') and isnull(e.점수6, 0) = 0  "
	end if
	if sValue <> "" then
		SQL_CNT = SQL_CNT & " and c.성함 = '"& sValue &"' "
	end if
	SQL_CNT = SQL_CNT & " and a.일반단체구분 not in ('용품배송', '화환배송', '용품+화환배송', '근조화환배송') "
	SQL_CNT = SQL_CNT & " and left(a.행사시작일시,8) between '"& Replace(sDate,"-","") &"' and '"& Replace(eDate2,"-","") &"' "

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

	If user_id = "S1211059" Then
		'Response.write "<br><br><br><br><br><br><br>" &SQL
	End if

%>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->

	<form name="frm" method="post" action="qna_list.asp">
	<input type="hidden" id="page" name="page" value="<%=page %>" />

	<div class="search_box">
		<ul class="sch_form">
			<li class="ty01">
				<span class="dp_box"><input type="text" id="sDate" name="sDate" value="<%=sDate %>" class="datepicker input_ty start-date w100" placeholder="접수일" readonly ></span> ~ 
				<span class="dp_box"><input type="text" id="eDate" name="eDate" value="<%=eDate %>" class="datepicker input_ty end-date w100" placeholder="접수일" readonly ></span>
			</li>
			<li class="ty02">				
				<select name="sType" id="sType" class="select_ty">
					<option value="">전체</option>
					<option value="평가완료">평가완료</option>
					<option value="문자전송완료">문자전송(O)</option>
					<option value="문자전송미완료">문자전송(X)</option>
					<option value="문자전송오류">문자전송(오류)</option>
				</select>
				<input type="text" name="sValue" value="<%= sValue %>" class="input_ty" placeholder="의전팀장명">
			</li>
		</ul>
		<a href="javascript:search();" class="btn_search">검색</a>
	</div><!--// search_box -->

	</form>

	<p class="list_top_noti">*의전팀장명 클릭 시 상세내용을 보실 수 있습니다.</p>

	<table class="list_ty">
		<caption>만족도평가 리스트</caption>
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
			QnA			= arrObj(6,i)
			MsgStat		= arrObj(7,i)			

			Date_Txt = Right(Replace(Split(StartDate, " ")(0), "-", "."), 8) & "<br>" & Split(StartDate, " ")(1)

			if QnA <> 0 then
				QnA_Txt = "<span class='btn_stat ty05'>평가완료</span>"
			else
				if ( MsgStat = "" or MsgStat = "전송성공" ) then
					QnA_Txt = "<span class='btn_stat ty03'>문자전송(O)</span>"
                Elseif ( MsgStat = "미전송" ) then
					QnA_Txt = "<span onclick=""SendMMS('"& Code &"', 'qna_"& i &"');"" class='btn_stat ty07'>문자전송(X)</span>"
				else					
					QnA_Txt = "<span onclick=""SendMMS('"& Code &"', 'qna_"& i &"');"" class='btn_stat ty07'>문자전송(오류)</span>"
				end if
				
			end if
%>
			<tr>
				<td><a href="qna_write.asp?code=<%=FnAesEncrypt(Code, AesEncryptPwd) %>"><%=Name %></a></td>
				<td><%=Date_Txt %></td>
				<td><%=GroupName %></td>
				<td><%=JangName %></td>
				<td id="qna_<%=i %>"><%=QnA_Txt %></td>
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
	function SendMMS(code, id) {
		//alert ('현재 개발 수정중입니다. 개발 완료시 문자 발송 가능합니다.');

		if (!confirm("만족도평가 문자 전송하시겠습니까?")) {
			return false;
		}

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "qna_msg_ok_ajax.asp", //요청을 보낼 서버의 URL
			data: { Code: code }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				if (data == 'S') {
					alert('발송되었습니다.');
					$('#' + id).html("<span class='btn_stat ty03'>문자전송(O)</span>");
				} else if (data == 'Y') {
					alert('발송대기 메세지가 있습니다.');
				} else if (data == 'Y2') {
					alert('발송완료 메세지가 있습니다.');
				}
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