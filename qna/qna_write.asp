<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check2.asp"-->

<%
	menu = "만족도 평가"
	code = request("code")

	If Right(code,2) = "==" Then
		DB_ENC = "Y"
	Else
		DB_ENC = "N"
		code = FnAesDecrypt(code, AesEncryptPwd)	' ASP 페이지 암호화
	End if	
	
	if user_id = "S1211059" then
		'response.write code
		'response.End
	end if	

	if code = "" then 
		response.End
	end if



	SQL = " select a.행사번호, c.성함, convert(varchar(16),a.시스템일자,120) as 행사시작일, a.행사시작일시, a.행사종료일시, b.단체명, d.장례식장, a.고인성명, a.회원과관계, a.의전관, a.계약코드, f.회원코드, "
	SQL = SQL & " isnull(e.점수1, 0) as qna1, isnull(e.점수2, 0) as qna2, isnull(e.점수3, 0) as qna3, isnull(e.점수4, 0) as qna4, "
	SQL = SQL & " isnull(e.점수5, 0) as qna5, isnull(e.점수6, 0) as qna6, isnull(e.건의사항, '') as qna7, isnull(e.문제사항, '') as qna8 "
	SQL = SQL & " , a.일반단체구분 "
	SQL = SQL & " from 행사마스터 a (nolock) "
	SQL = SQL & " inner join 행사단체 b (nolock) on a.행사단체 = b.단체코드 "
	SQL = SQL & " inner join 행사의전팀장 c (nolock) on a.진행팀장 = c.코드 "
	SQL = SQL & " inner join 행사장례식장 d (nolock) on a.장례식장 = d.코드 "
	SQL = SQL & " inner join 행사계약마스터 f (nolock) on a.행사번호 = f.행사번호 "
	SQL = SQL & " left outer join 행사모니터링 e (nolock) on a.행사번호 = e.행사코드 "

	If DB_ENC = "Y" then
		SQL = SQL & " where a.행사번호 = dbo.fnDecryption('" & code & "','apluslife') "
	Else
		SQL = SQL & " where a.행사번호 = '" & code & "' "
	End if

	if user_id = "" then
		SQL = SQL & " and datediff(d, dateadd(m, -2, getdate()), left(a.행사시작일시,8)) > 0 "
	end if

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)	

	If Rs.EOF Then
		response.write "<script type='text/javascript'>"
		response.write "alert('2달이 지난 행사입니다.');"
		response.write "location.replace('http://www.apluslife.co.kr');"
		response.write "</script>"	
		response.End
	Else
		tname		 = Rs("성함")
		startdate	 = Rs("행사시작일")
		groupname	 = Rs("단체명")
		jangname	 = Rs("장례식장")
		gname		 = Rs("고인성명")
		family		 = Rs("회원과관계")
		qna1		 = Rs("qna1")
		qna2		 = Rs("qna2")
		qna3		 = Rs("qna3")
		qna4		 = Rs("qna4")
		qna5		 = Rs("qna5")
		qna6		 = Rs("qna6")
		qna7		 = Rs("qna7")
		qna8		 = Rs("qna8")
		st			 = Rs("행사시작일시")
		dt			 = Rs("행사종료일시")
		tcode		 = Rs("의전관")
		gcode		 = Rs("계약코드")
		hcode		 = Rs("회원코드")
		gubun		 = Rs("일반단체구분")
	End If	

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing
%>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
<%	if user_id <> "" then %>
	<!--#include virtual="/common/menu.asp"-->
<%	end if %>

	<form name="frm" method="post" action="qna_write_ok.asp">			
	<input type="hidden" name="code" value="<%=code %>" />
	<input type="hidden" name="tcode" value="<%=tcode %>" />
	<input type="hidden" name="st" value="<%=st %>" />
	<input type="hidden" name="dt" value="<%=dt %>" />
	<input type="hidden" name="gcode" value="<%=gcode %>" />
	<input type="hidden" name="hcode" value="<%=hcode %>" />
	<input type="hidden" name="gubun" value="<%=gubun %>" />

	<table class="table_ty verti">
		<caption>만족도 평가 상세</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="1" style="width:*%;">
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">단체</th>
				<td><%=groupname %></td>
			</tr>
			<tr>
				<th scope="row">접수일시</th>
				<td><%=startdate %></td>
			</tr>
			<tr>
				<th scope="row">담당 의전팀장</th>
				<td><%=tname %></td>
			</tr>
			<tr>
				<th scope="row">고인명</th>
				<td><%=gname %></td>
			</tr>
			<!--
			<tr>
				<th scope="row">고인과의 관계</th>
				<td><%=family %></td>
			</tr>
			-->
			<tr>
				<th scope="row">장례식장</th>
				<td><%=jangname %></td>
			</tr>
		</tbody>
	</table><!--// table_ty -->

	<p class="sub_tit ty01 mt">만족도 평가</p>
	<ul class="ques_form">
		<li>
			<p class="tit"><span>01</span>이번 장례 접수 시 저희 상담원이 신속하고 친절하게 업무처리되었으며, 담당 의전팀장도 장례식장에 2시간 이내로 도착되었습니까?</p>
			<ul class="checks rad_ty02 blt">
				<li>
					<input type="radio" id="qna1_1" name='qna1' value='10' >
					<label for="qna1_1">예</label>
				</li>
				<li>
					<input type="radio" id="qna1_2" name='qna1' value='0' >
					<label for="qna1_2">아니오</label>
				</li>
			</ul><!--// rad_ty02 -->
		</li>
		<li>
			<p class="tit"><span>02</span>장례가 진행되는 동안 담당 의전팀장이 자리를 비우지 않고 장례절차나 일정 등에 대해서 충분하게 설명을 했습니까?</p>
			<ul class="checks rad_ty02 blt">
				<li>
					<input type="radio" id="qna2_1" name="qna2" value='10' >
					<label for="qna2_1">예</label>
				</li>
				<li>
					<input type="radio" id="qna2_2" name="qna2" value='0' >
					<label for="qna2_2">아니오</label>
				</li>
			</ul><!--// rad_ty02 -->
		</li>
		<li>
			<p class="tit"><span>03</span>경황없으신 회원님을 대신해서 조문객 도우미들이 일을 도와드렸는데, 저희 도우미들의 복장이나 서비스 친절도는 만족하셨습니까?</p>
			<ul class="checks rad_ty02 blt">
				<li>
					<input type="radio" id="qna4_1" name="qna4" value='10' >
					<label for="qna4_1">예</label>
				</li>
				<li>
					<input type="radio" id="qna4_2" name="qna4" value='0' >
					<label for="qna4_2">아니오</label>
				</li>
			</ul><!--// rad_ty02 -->
		</li>
		<li>
			<p class="tit"><span>04</span>혹시라도 장례 중에 저희 의전팀으로부터 서비스에 대한 팁이나 봉사료를 요구받은 적은 없으십니까?</p>
			<ul class="checks rad_ty02 blt">
				<li>
					<input type="radio" id="qna3_1" name="qna3" value='10' >
					<label for="qna3_1">예</label>
				</li>
				<li>
					<input type="radio" id="qna3_2" name="qna3" value='0' >
					<label for="qna3_2">아니오</label>
				</li>
			</ul><!--// rad_ty02 -->
		</li>
		<li>
			<p class="tit"><span>05</span>장지 이동 시 불편함이 없었고, 차량상태도 쾌적하고 불편함이 없으셨습니까?</p>
			<ul class="checks rad_ty02 blt">
				<li>
					<input type="radio" id="qna5_1" name="qna5" value='10' >
					<label for="qna5_1">예</label>
				</li>
				<li>
					<input type="radio" id="qna5_2" name="qna5" value='0' >
					<label for="qna5_2">아니오</label>
				</li>
			</ul><!--// rad_ty02 -->
		</li>
		<li>
			<p class="tit"><span>06</span>마지막으로 이번 장례를 치루면서 고객님께서 전체적인 점수를 주신다면 별 다섯개 중에서 몇 개를 주실 수 있습니까?</p>
			<ul class="checks rad_ty02 blt multi">
				<li>
					<input type="radio" id="qna6_1" name="qna6" value='50' >
					<label for="qna6_1">★★★★★</label>
				</li>
				<li>
					<input type="radio" id="qna6_2" name="qna6" value='40' >
					<label for="qna6_2">★★★★</label>
				</li>
				<li>
					<input type="radio" id="qna6_3" name="qna6" value='30' >
					<label for="qna6_3">★★★</label>
				</li>
				<li>
					<input type="radio" id="qna6_4" name="qna6" value='20' >
					<label for="qna6_4">★★</label>
				</li>
				<li>
					<input type="radio" id="qna6_5" name="qna6" value='10' >
					<label for="qna6_5">★</label>
				</li>
			</ul><!--// rad_ty02 -->
		</li>
		<li>
			<p class="tit"><span>07</span>불편하셨다거나, 혹은 저희 A+라이프 효담 상조에 남겨주실 말씀이 있으십니까?</p>
			<p class="stit">건의사항 및 기타사항</p>
			<textarea name="qna7" class="tarea_ty w100" placeholder="내용을 입력해주세요."><%=qna7 %></textarea>
			<p class="stit">불만 및 개선사항</p>
			<textarea name="qna8" class="tarea_ty w100" placeholder="내용을 입력해주세요."><%=qna8 %></textarea>
		</li>
	</ul><!--// ques_form -->

<%	if qna6 = 0 then %>
	<div class="btm_btns">
		<a href="javascript:void(0);" onclick="Save();" class="btn_ty btn_b">저장</a>
	</div><!--// btm_btns -->
<%	end if %>
	

</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->

<script language="javascript" type="text/javascript">
	function Save() {
		if (!$("input:radio[name='qna1']:checked").val()) {
			alert('1번 질문은 필수 입력 항목입니다.');
			return false;
		}
		if (!$("input:radio[name='qna2']:checked").val()) {
			alert('2번 질문은 필수 입력 항목입니다.');
			return false;
		}
		if (!$("input:radio[name='qna3']:checked").val()) {
			alert('3번 질문은 필수 입력 항목입니다.');
			return false;
		}
		if (!$("input:radio[name='qna4']:checked").val()) {
			alert('4번 질문은 필수 입력 항목입니다.');
			return false;
		}
		if (!$("input:radio[name='qna5']:checked").val()) {
			alert('5번 질문은 필수 입력 항목입니다.');
			return false;
		}
		if (!$("input:radio[name='qna6']:checked").val()) {
			alert('6번 질문은 필수 입력 항목입니다.');
			return false;
		}
		if (!confirm("등록하시겠습니까?")) {
			return false;
		}
		document.frm.submit();
	}
</script>

<%	if qna1 < 100 then %>
<script language="javascript" type="text/javascript">
<!--
	$("input:radio[name='qna1']:radio[value='<%=qna1 %>']").prop('checked', true);
	$("input:radio[name='qna2']:radio[value='<%=qna2 %>']").prop('checked', true);
	$("input:radio[name='qna3']:radio[value='<%=qna3 %>']").prop('checked', true);
	$("input:radio[name='qna4']:radio[value='<%=qna4 %>']").prop('checked', true);
	$("input:radio[name='qna5']:radio[value='<%=qna5 %>']").prop('checked', true);
	$("input:radio[name='qna6']:radio[value='<%=qna6 %>']").prop('checked', true);
//-->
</script>
<%	end if %>