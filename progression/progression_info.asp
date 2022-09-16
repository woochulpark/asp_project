<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->
<%
	menu = "진행"
	lnbtype = "N" '배송여부
	lnbb = "class='on'"
	top_btn_save = "N"

	code = Trim(request("Code"))

	if code = "" then 
		response.End
	end if

	SQL = "select b.단체명 as 단체 "
	SQL = SQL & " , a.행사번호 as 접수번호 "
	SQL = SQL & " , left(a.행사시작일시,4) +'.'+ right(left(a.행사시작일시,6),2) +'.'+ right(left(a.행사시작일시,8),2) +' '+ right(left(a.행사시작일시,10),2) +':'+ right(left(a.행사시작일시,12),2)   as 접수일시 "
	SQL = SQL & " , a.진행팀장 as 의전팀장코드 "
	SQL = SQL & " , c.성함 as 의전팀장 "
	SQL = SQL & " , c.연락처 as 의전팀장연락처 "
	SQL = SQL & " , case when a.일반단체구분 in ('용품배송', '근조화환배송', '용품+화환배송', '화환배송') then '배송' else '장례' end as 행사구분 "
	SQL = SQL & " , d.상품명 as 진행상품 "
	SQL = SQL & " , isnull((select sum(입금액) from 수납마스터 (nolock) where 계약코드 = a.계약코드),0) as 납입부금 "
	SQL = SQL & " , left(e.계약일자,4) +'-'+ right(left(e.계약일자,6),2) +'-'+ right(left(e.계약일자,8),2) as 계약일자 "
	SQL = SQL & " , f.계약자명 as 직원명 "
	SQL = SQL & " , f.계약자휴대폰 as 직원연락처 "
	SQL = SQL & " , f.회원명 as 회원명 "
	SQL = SQL & " , f.휴대폰 as 회원연락처 "
	SQL = SQL & " , a.행사지점 as 부서명 "
	SQL = SQL & " , a.행사소속 as 소속 "
	SQL = SQL & " , a.행사사번 as 직책 "
	SQL = SQL & " , a.회원과관계 as 고인과의관계 "
	SQL = SQL & " , a.현위치 "
	SQL = SQL & " , f.계약코드 "
	SQL = SQL & " , f.회원코드 "
	SQL = SQL & " from 행사마스터 a (nolock) "
	SQL = SQL & "	left outer join 행사단체 b (nolock) on a.행사단체 = b.단체코드 "	
	SQL = SQL & "	left outer join 행사의전팀장 c (nolock) on a.진행팀장 = c.코드 "	
	SQL = SQL & "	left outer join 상품코드 d (nolock) on a.상품코드 = d.상품코드 "	
	SQL = SQL & "	left outer join 계약마스터 e (nolock) on a.계약코드 = e.계약코드 "	
	SQL = SQL & "	left outer join 행사계약마스터 f (nolock) on a.행사번호 = f.행사번호 "	
	SQL = SQL & "	left outer join 행사장례식장 g (nolock) on a.장례식장 = g.코드 "	
	SQL = SQL & " where  a.행사번호 = '" & code & "' "
	
	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)	

	If Rs.EOF Then
		
	Else		
		input1 = Rs("단체")
		input2 = Rs("접수번호")
		input3 = Rs("접수일시")		
		input4 = Rs("의전팀장코드")
		input5 = Rs("의전팀장")
		input6 = Rs("의전팀장연락처")
		input7 = Rs("행사구분")
		input8 = Rs("진행상품")
		input9 = Rs("납입부금")
		input10 = Rs("계약일자")
		input11 = Rs("직원명")
		input12 = Rs("직원연락처")
		input13	= Rs("회원명")
		input14 = Rs("회원연락처")
		input15 = Rs("부서명")
		input16 = Rs("소속")		
		input17 = Rs("직책")
		input18 = Rs("고인과의관계")
		input19 = Rs("현위치")
		input20 = Rs("계약코드")
		input21 = Rs("회원코드")
	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	
%>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->	
	<!--#include virtual="/common/lnb.asp"-->
	<!--#include virtual="/common/top_btns.asp"-->

	<input type="hidden" name="tcode" id="tcode" value="<%=input4 %>" />
	<input type="hidden" name="mname" id="mname" value="<%=input11 %>" />
	<input type="hidden" name="mphone" id="mphone" value="<%=input12 %>" />

	<table class="table_ty verti">
		<caption>진행-기본정보</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="2" style="width:*%;">
		</colgroup>

			<tr>
				<th scope="row">단체</th>
				<td colspan="2"><%=input1 %></td>
			</tr>
			<tr>
				<th scope="row">접수번호</th>
				<td colspan="2"><%=input2 %></td>
			</tr>
			<tr>
				<th scope="row">접수일시</th>
				<td colspan="2"><%=input3 %></td>
			</tr>
			<tr>
				<th scope="row" rowspan="2">담당 <br class="m_br">의전팀장</th>
				<td colspan="2">
					<span id="tname"><%=input5 %></span> 					
				</td>
			</tr>
			<tr>
				<td colspan="2"><a href="tel:<%=input6 %>" target="_blank" class="blt_tel">전화걸기</a><span id="tphone"><%=input6 %></span></td>				
			</tr>
			<tr>
				<th scope="row">행사구분</th>
				<td colspan="2" class="ht01"><%=input7 %></td>
			</tr>
			<tr>
				<th scope="row">진행상품</th>
				<td colspan="2"><%=input8 %></td>
			</tr>
			<tr>
				<th scope="row" class="btnu">납입부금<a href="#" class="btn_ico ico02" onclick="DepositView();">납입내역</a></th>
				<td class="bdr"><%=input9 %></td>
				<td><%=input10 %></td>
			</tr>
			<tr>
				<th scope="row">직원명</th>
				<td colspan="2">
					<span id="mname_t"><%=input11 %></span>					
				</td>
			</tr>
			<tr>
				<th scope="row">연락처</th>
				<td colspan="2"><a href="tel:<%=input12 %>" target="_blank" class="blt_tel">전화걸기</a><span id="mphone_t"><%=input12 %></span></td>				
			</tr>
			<tr>
				<th scope="row">부서명</th>
				<td colspan="2"><%=input15 %></td>
			</tr>
			<tr>
				<th scope="row">소속</th>
				<td colspan="2"><%=input16 %></td>
			</tr>
			<tr>
				<th scope="row">직책</th>
				<td colspan="2"><%=input17 %></td>
			</tr>
			<tr>
				<th scope="row">고인과의 관계</th>
				<td colspan="2"><%=input18 %></td>
			</tr>
			<tr>
				<th scope="row">현위치</th>
				<td colspan="2"><%=input19 %></td>
			</tr>
	</table>
	<!--#include virtual="/common/layer_popup.asp"-->

</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->

<script type="text/javascript" language="javascript" src="/js/reception.js"></script>
<script language="javascript" type="text/javascript">
	
	function DepositView() {
		var gcode = '<%=input20 %>'
		
		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/reception/reception_deposit_ajax.asp", //요청을 보낼 서버의 URL
			data: { Code: gcode }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open('납입내역');
			}
		});

	}
		
</script>