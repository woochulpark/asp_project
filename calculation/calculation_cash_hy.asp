<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->


<%
	menu = "정산"
	lnbtype = "N" '배송여부
	lnbn = "class='on'"	
	top_btn_save = "Y"

	req_ip = request.ServerVariables( "REMOTE_ADDR" )    '// [필수]요청자 IP

	code = Trim(request("Code"))
	
	if code = "" then 
		response.End
	end if

	SQL = "select a.tr_cd, a.product_nm, a.product_amt, a.self_issue, b.res_cd, b.res_msg, b.cno, b.auth_no, b.tran_date, a.issue_type, b.시스템일자"
	SQL = SQL & " , a.auth_value, datediff(hh, b.시스템일자, getdate()) as 경과시간 "
	SQL = SQL & " , case when a.tr_cd = '00201050' and req_type = 'issue' and a.org_cno <> '' and res_cd = '0000' then "
	SQL = SQL & " 			case when (select count(*) from CARD결제신청 (nolock) where tr_cd = '00201050' and req_type = 'cancel' and org_cno = a.org_cno) > 0 then 'NO' "
	SQL = SQL & " 			else 'OK' "
	SQL = SQL & " 			end "
    SQL = SQL & "	else 'NO' "
	SQL = SQL & "   end 취소구분 "
	SQL = SQL & " , a.영수증수신번호 "
	SQL = SQL & " , a.req_type "
	SQL = SQL & " from CARD결제신청 a (nolock) inner join CARD결제결과 b (nolock) on a.idx = b.card_idx "
	SQL = SQL & " where 1=1 "
	SQL = SQL & " and a.tr_cd in ( '00201050' ) "	
	SQL = SQL & " and isnull(a.카드결제구분, '') in ('', 'hangsa') "	
	SQL = SQL & " and a.상조계약코드= '"& code &"' "	
	SQL = SQL & " order by b.시스템일자 desc "

	'Response.write SQL
	'Response.end

	SQL2 = " select case when isnull(승인구분,'미승인') = '미승인' then '미승인' else 승인구분 end as 승인 "
	SQL2 = SQL2 & " from 행사마스터 a (nolock) "
	SQL2 = SQL2 & " where 1=1 "
	SQL2 = SQL2 & " and a.행사번호= '"& code &"' "	


	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ	

	Set Rs = ConnAplus.execute(SQL)	

	If Rs.EOF Then
		rc = 0		
	Else
		rc = Rs.RecordCount
		arrObj = Rs.GetRows(rc)
	End If

	Set Rs = ConnAplus.execute(SQL2)	

	If Not Rs.EOF Then			
		input1 = Rs("승인")
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

	<table class="list_ty total_list">
		<caption>현금영수증 발행 Total</caption>
		<colgroup><col span="1" style="width:100%;"></colgroup>
		<thead>
			<tr>
				<th scope="col">현금영수증 총 발행금액 Total</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><span id="total"></span></td>
			</tr>
		</tbody>
	</table><!--// total_list -->


	<table id="factory_table" class="form_ty hori">
		<caption>현금영수증이력</caption>
		<colgroup>
			<col span="1" class="verti_w03"><col span="3" style="width:*%;">
		</colgroup>
<%
	total = 0
	if rc = 0 then 
	else
		for i=0 to UBound(arrObj,2)
			tr_cd		= arrObj(0,i)
			product_nm	= arrObj(1,i)
			product_amt	= arrObj(2,i)
			self_issue	= arrObj(3,i)
			res_cd		= arrObj(4,i)
			res_msg		= arrObj(5,i)
			cno			= arrObj(6,i)			
			auth_no		= arrObj(7,i)
			tran_date	= arrObj(8,i)
			issue_type	= arrObj(9,i)	
			result_date	= arrObj(10,i)
			auth_value	= arrObj(11,i)
			result_time	= arrObj(12,i)
			card_ok		= arrObj(13,i)
			receipt_hp	= arrObj(14,i)
			req_type	= arrObj(15,i)
			

			tran_date_1 = ""

			If tran_date <> "" Then
				tran_date_1 = Left(tran_date,4) &"-"& Right(Left(tran_date,6),2) &"-"& Right(Left(tran_date,8),2) 
				tran_date_1 = tran_date_1 &" "& Right(Left(tran_date,10),2) &":"& Right(Left(tran_date,12),2) &":"& Right(Left(tran_date,14),2)
			End if

			If req_type = "issue" And res_cd = "0000" Then
				total = total + arrObj(2,i)
			End If
			
			If req_type = "cancel" And res_cd = "0000" Then
				total = total - arrObj(2,i)
			End If

			If req_type = "issue" Then
				tr_msg = "현금영수증 발행"
			Else
				tr_msg = "현금영수증 취소"
			End If
			
			If res_cd = "0000" Then
				tr_msg = tr_msg & " 승인"
			Else
				tr_msg = tr_msg & " 오류"
			End If

			If self_issue = "1" Then
				self_issue_nm = "고객발급"
			Else
				self_issue_nm = "자진발급"
			End If

			If issue_type = "01" Then
				issue_type_nm = "소득공제용"
			Else
				issue_type_nm = "지출증빙용"
			End If

				
			
			
%>

		<tbody>
			<tr>
				<td rowspan="6">
					<%=i+1 %>
					<% If input1 = "미승인" Then %>
						<% if user_type = "a" then '임직원 %>	
							<% If cno <> "" And tr_cd = "00201050" And req_type = "issue" And card_ok = "OK" Then %>
								<br>
								<a href="javascript:void(0);" class="btn_ico ico07 ty03" onclick="javascript:f_submit('<%=cno%>');">승인취소</a>
							<% End If %>
						<% Else %>
							<% If cno <> "" And tr_cd = "00201050" And req_type = "issue" And card_ok = "OK" And result_time <= 4 Then %>
								<br>
								<a href="javascript:void(0);" class="btn_ico ico07 ty03" onclick="javascript:f_submit('<%=cno%>');">승인취소</a>
							<% End If %>
						<% End If %>
					<% End If %>

					<% If cno <> "" And tr_cd = "00201050" And req_type = "issue" And card_ok = "OK" And self_issue = "1" Then %>
						<br>
						<a href="javascript:void(0);" class="btn_ico ico04" onclick="javascript:receipt('<%=cno%>', '<%=receipt_hp%>', '<%=product_amt%>', '', '현금영수증', '승인');" >영수증재전송</a>						
					<% End If %>
					<% If cno <> "" And tr_cd = "00201050" And req_type = "cancel" And self_issue = "1" Then %>
						<br>
						<a href="javascript:void(0);" class="btn_ico ico04" onclick="javascript:receipt('<%=cno%>', '<%=receipt_hp%>', '<%=product_amt%>', '', '현금영수증', '취소');" >영수증재전송</a>						
					<% End If %>

					<br><br>
					<a href="javascript:void(0);" class="btn_ico ico02" onclick="javascript:receiptView('<%=cno%>', '<%=product_amt%>');">영수증 보기</a>

				</td>
				<th scope="row">결제구분</th>
				<th scope="row">매출구분</th>
				<th scope="row">결제금액</th>
			</tr>
			<tr>
				<td><span class="input_dt w100"><%=tr_msg %></span></td>
				<td><span class="input_dt w100"><%=product_nm %></span></td>
				<td><span class="input_dt w100"><%=FormatNumber(product_amt,0) %></span></td>
			</tr>
			<tr>
				<th scope="row">발급구분</th>
				<th scope="row">발행용도</th>
				<th scope="row">인증번호</th>
			</tr>
			<tr>
				<td><span class="input_dt w100"><%=self_issue_nm %></span></td>
				<td><span class="input_dt w100"><%=issue_type_nm%></span></td>
				<td><span class="input_dt w100"><%=auth_value %></span></td>
			</tr>
			<tr>
				<th scope="row">PG거래번호</th>
				<th scope="row">승인일시</th>
				<th scope="row">오류메시지</th>
			</tr>
			<tr>
				<td><span class="input_dt w100"><%=cno %></span></td>
				<td><span class="input_dt w100"><%=tran_date_1 %></span></td>
				<td><span class="input_dt w100"><%=res_msg %></span></td>
			</tr>
		</tbody>
<%
		next
	end if 
%>
	</table><!--// form_ty -->
	<iframe src="" name="card_frame" style="display:none;" width="500" height="500"></iframe>
	<!--#include virtual="/common/layer_popup.asp"-->	

	<form name="frm_mgr" method="post" target="card_frame" action="<%=protocol%>card.apluslife.co.kr/web/easypay_request_utf.asp">
		<input type="hidden" id="code" name="code" value="<%=code %>" />
		<input type="hidden" id="EP_tr_cd"   name="EP_tr_cd"   value="00201050">     <!-- [필수]거래구분(수정불가) -->
		<input type="hidden" id="EP_req_type"  name="EP_req_type"   value="cancel">	
		<input type="hidden" id="req_id"  name="req_id"      value="Cancel">
		<input type="hidden" id="mgr_txtype" name="mgr_txtype" value="51">           <!-- [필수]취소 거래구분 -->

		<input type="hidden" id="req_ip"     name="req_ip"     value="<%=req_ip%>">  <!-- [필수]요청자 IP -->
		<input type="hidden" id="req_id"     name="req_id"     value="">             <!-- [옵션]요청자 ID -->

		<input type="hidden" id="EP_mall_id"	name="EP_mall_id"	value="05540345" >
		<input type="hidden" id="mgr_msg"		name="mgr_msg"		value="취소">

		<input type="hidden" id="life_code"       		name="life_code"            value="<%=code %>">
		<input type="hidden" id="life_sawon_id"       	name="life_sawon_id"        value="<%=user_id%>">
		<input type="hidden" id="life_s_code"       	name="life_s_code"          value="<%=code %>">
		<input type="hidden" id="life_card_gubun"      	name="life_card_gubun"      value="hangsa">	
		<input type="hidden" id="life_card_return"   	name="life_card_return"		value="<%=protocol%>hs.apluslife.co.kr/calculation/calculation_cash_hy.asp">	
		<input type="hidden" id="org_cno"	name="org_cno" size="50"	>

	</form>

	<form name="form1" method="get" action=""> 
		<input type=hidden name=controlNo>
		<input type=hidden name=payment>
	</form>
</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->

<script type="text/javascript">
	$('#total').html('<%=FormatNumber(total,0) %>');
</script>

<script type="text/javascript" language="javascript" src="/js/reception.js"></script>
<script language="javascript" type="text/javascript">

	document.domain = "apluslife.co.kr"; // Cross-site Scripting

	function f_submit(cno) {
		
		var retVal = confirm("현금영수증 발행 취소를 진행 하시겠습니까?");

		if(retVal == true) {
			
			document.getElementById("org_cno").value = cno;

			//alert(document.getElementById("org_cno").value);

			document.frm_mgr.submit();

			//location.href = '<%=protocol%>card.apluslife.co.kr/web/mgr/mgr.asp?id=<%=life_sawon_id%>&c_code=<%=c_code%>&org_cno=<%=cno%>';
		}
	}


	function receipt(cno, receipt_hp, product_amt, install_period, card_gubun, card_result) {
	
		//alert (cno +' '+ receipt_hp +' '+ product_amt +' '+ install_period +' '+ card_gubun +' '+ card_result );

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/reception/reception_card_sms_ajax.asp", //요청을 보낼 서버의 URL
			data: { cno: cno, receipt_hp: receipt_hp, product_amt: product_amt, install_period: install_period, card_gubun: card_gubun, card_result: card_result }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open('현금 영수증 재전송');
			}
		});

	}

	function SendMMS(cno, receipt_hp, product_amt, install_period, card_gubun, card_result) {

		if (!confirm("영수증 전송하시겠습니까?")) {
			return false;
		}

		//alert (cno +' '+ receipt_hp +' '+ product_amt +' '+ install_period +' '+ card_gubun +' '+ card_result );

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/reception/reception_card_mms_ok_ajax.asp", //요청을 보낼 서버의 URL
			data: { cno: cno, receipt_hp: receipt_hp, product_amt: product_amt, install_period: install_period, card_gubun: card_gubun, card_result: card_result, user_id: "<%=user_id%>" }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				if (data == 'S') {
					alert('발송되었습니다.');					
				} 
			}
		});

		Close();

	}

	function receiptView(cno, product_amt) {
		
		window.open("","MEMB_POP_RECEIPT", 'toolbar=0,scroll=1,menubar=0,status=0,resizable=0,width=380,height=700');
		document.form1.action = "http://office.easypay.co.kr/receipt/ReceiptBranch.jsp";
		document.form1.controlNo.value = cno;
		document.form1.payment.value = product_amt;
		document.form1.target = "MEMB_POP_RECEIPT";
		document.form1.submit();
	}
	
</SCRIPT>
