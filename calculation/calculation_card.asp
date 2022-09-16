<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->
<!--#include virtual="/reception/reception_timjang_check.asp"-->
<%
	menu = "정산"
	lnbtype = "N" '배송여부
	lnbj = "class='on'"	
	top_btn_save = "Y"

	code = Trim(request("Code"))
	
	if code = "" then 
		response.End
	end if

	SQL = " select 행사상태 "
	SQL = SQL & " from 행사마스터 a (nolock) "
	SQL = SQL & " where 1=1 "
	SQL = SQL & " and a.행사번호= '"& code &"' "	

	'Response.write SQL
	'Response.end
	
	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ	

	Set Rs = ConnAplus.execute(SQL)	

	If Not Rs.EOF Then			
		input1 = Rs("행사상태")
	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	if input1 = "완료" then
		response.write "<script type='text/javascript'>"
		response.write "alert('완료 이후 카드결제 불가');"	
		response.write "location.replace('/calculation/calculation_info.asp?Code="& code &"');"
		response.write "</script>"
		'response.End
	end if	

%>
<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->
	<!--#include virtual="/common/lnb.asp"-->

	<div class="top_btns sort01">
		<a href="javascript:void(0);" class="btn_ty ty02 btn_b" onclick="Save();">카드결제 요청</a>
	</div>

	<form name="frm" method="post" target="card_frame" action="<%=protocol%>card.apluslife.co.kr/web/easypay_request_utf.asp">	
		<input type="hidden" id="code" name="code" value="<%=code %>" />
		<input type="hidden" id="EP_cert_type" name="EP_cert_type" value="2" />
		<input type="hidden" id="EP_order_no" name="EP_order_no" />	

		<input type="hidden" id="EP_mall_nm"            name="EP_mall_nm"           value="">           <!-- 가맹점 명 -->
		<input type="hidden" id="EP_user_id"            name="EP_user_id"           value="">           <!-- 고객ID -->
		<input type="hidden" id="EP_user_nm"            name="EP_user_nm"           value="">           <!-- 고객명 -->
		<input type="hidden" id="EP_user_mail"          name="EP_user_mail"         value="">           <!-- 고객Email -->
		<input type="hidden" id="EP_user_phone1"        name="EP_user_phone1"       value="">           <!-- 고객전화번호 -->
		<input type="hidden" id="EP_user_phone2"        name="EP_user_phone2"       value="">           <!-- 고객휴대폰 -->
		<input type="hidden" id="EP_user_addr"          name="EP_user_addr"         value="">           <!-- 고객주소 -->
		<input type="hidden" id="EP_product_type"       name="EP_product_type"      value="">           <!-- 상품정보구분 0(실물), 1(컨텐츠) -->
		<input type="hidden" id="EP_memb_user_no"       name="EP_memb_user_no"      value="">           <!-- 가맹점 고객 일련번호 -->
		<input type="hidden" id="EP_user_define1"       name="EP_user_define1"      value="">           <!-- 여유필드 -->
		<input type="hidden" id="EP_user_define2"       name="EP_user_define2"      value="">           <!-- 여유필드 -->
		<input type="hidden" id="EP_user_define3"       name="EP_user_define3"      value="">           <!-- 여유필드 -->
		<input type="hidden" id="EP_user_define4"       name="EP_user_define4"      value="">           <!-- 여유필드 -->
		<input type="hidden" id="EP_user_define5"       name="EP_user_define5"      value="">           <!-- 여유필드 -->
		<input type="hidden" id="EP_user_define6"       name="EP_user_define6"      value="">           <!-- 여유필드 -->
		<!-- [END]가맹점 주문자 필드 -->

		<!-- [START]인증 요청 필드 -->
		<input type="hidden" id="EP_tr_cd"              name="EP_tr_cd"             value="00101000">   <!-- 거래구분(수정불가) -->
		<input type="hidden" id="EP_pay_type"           name="EP_pay_type"          value="card">       <!-- 결제수단(수정불가) -->
		<input type="hidden" id="EP_tot_amt"            name="EP_tot_amt"           value="">           <!-- 결제총금액 -->
		<input type="hidden" id="EP_currency"           name="EP_currency"          value="00">         <!-- 통화코드 : 00(원), 01(달러)-->
		<input type="hidden" id="EP_escrow_yn"          name="EP_escrow_yn"         value="N">          <!-- 에스크로여부(수정불가) -->
		<input type="hidden" id="EP_complex_yn"         name="EP_complex_yn"        value="N">          <!-- 복합결제여부(수정불가) -->
		<input type="hidden" id="EP_req_type"           name="EP_req_type"          value="0">          <!-- 카드결제종류(수정불가) -->
		<input type="hidden" id="EP_card_amt"           name="EP_card_amt"          value="">           <!-- 신용카드 결제금액 -->
		<input type="hidden" id="EP_wcc"                name="EP_wcc"               value="@">          <!-- 신용카드 WCC(수정불가) -->
		<input type="hidden" id="EP_card_no"            name="EP_card_no"           value="">           <!-- 신용카드번호 -->
		<input type="hidden" id="EP_expire_date"        name="EP_expire_date"       value="">           <!-- 유효기간 -->
		<input type="hidden" id="EP_card_txtype"        name="EP_card_txtype"       value="20">         <!-- 처리종류  -->
		<input type="hidden" id="EP_noint"       		name="EP_noint"       	    value="00">
		<input type="hidden" id="tax_flg"       		name="tax_flg"       	    value="TG01">
		<input type="hidden" id="EP_mall_id"			name="EP_mall_id"           value="05540345">
		<input type="hidden" id="life_code"       		name="life_code"            value="<%=code %>">
		<input type="hidden" id="life_sawon_id"       	name="life_sawon_id"        value="<%=user_id%>">
		<input type="hidden" id="life_s_code"       	name="life_s_code"          value="<%=code %>">
		<input type="hidden" id="life_card_gubun"      	name="life_card_gubun"      value="hangsa">	
		<input type="hidden" id="life_card_return"   	name="life_card_return"		value="<%=protocol%>hs.apluslife.co.kr/calculation/calculation_card_hy.asp">	
		<input type="hidden" id="click_count"       	name="click_count"			value="0">

		<table class="form_ty">
			<caption>접수-배송외-고인정보</caption>
			<colgroup>
				<col span="1" class="verti_w01"><col span="4" class="verti_w02">
			</colgroup>
				<tr>
					<th scope="row">영수증 수신번호</th>
					<td class="bdr" colspan="4"><input type="text" id="receipt_hp" name="receipt_hp" value="" class="input_ty w100" maxlength="12" placeholder="휴대폰번호 필수입력 미입력시 영수증 발송 불가"></td>				
				</tr>
				<tr>
					<th scope="row">매출구분</th>
					<td colspan="4">
						<select id="EP_product_nm" name="EP_product_nm" class="select_ty w100" onchange="amt_type_Change(this.value);">
							<option value="장례서비스" selected>행사매출</option>
							<option value="용품구매">용품배송</option>
							<option value="화환구매">화환배송</option>						
						</select>					
					</td>
				</tr>
				<tr>
					<th scope="row">과세방법</th>
					<td colspan="4">
						<select id="EP_amt_type" name="EP_amt_type" class="select_ty w100" onchange="amtChange();">
							<option value="1" >과세</option>
							<option value="2" selected >비과세</option>
						</select>					
					</td>
				</tr>
				<tr>
					<th scope="row">카드구분</th>
					<td colspan="4">
						<select id="EP_user_type" name="EP_user_type" class="select_ty w100">
							<option value="0" selected >개인</option>
							<option value="1" >법인</option>
						</select>					
					</td>
				</tr>
				<tr>
					<th scope="row">할부개월</th>
					<td colspan="4">
						<select id="EP_install_period" name="EP_install_period" class="select_ty w100">
							<option value="00"  selected >일시불</option>
							<option value="02" >2개월</option>
							<option value="03" >3개월</option>
							<option value="04" >4개월</option>
							<option value="05" >5개월</option>
							<option value="06" >6개월</option>
							<option value="07" >7개월</option>
							<option value="08" >8개월</option>
							<option value="09" >9개월</option>
							<option value="10" >10개월</option>
							<option value="11" >11개월</option>
							<option value="12" >12개월</option>
						</select>					
					</td>
				</tr>
				<tr>
					<th scope="row">카드번호</th>
					<td class="bdr"><input type="text" id="card_no1" name="card_no1" value="" class="input_ty w100" maxlength="4"></td>
					<td class="bdr"><input type="text" id="card_no2" name="card_no2" value="" class="input_ty w100" maxlength="4"></td>
					<td class="bdr"><input type="text" id="card_no3" name="card_no3" value="" class="input_ty w100" maxlength="4"></td>
					<td class="bdr"><input type="text" id="card_no4" name="card_no4" value="" class="input_ty w100" maxlength="4"></td>
				</tr>
				<tr>
					<th scope="row">유효기간</th>
					<td class="bdr"><input type="text" id="expire_yy" name="expire_yy" value="" class="input_ty w100" placeholder="2010"></td>
					<td class="bdr">년</td>
					<td class="bdr"><input type="text" id="expire_mm" name="expire_mm" value="" class="input_ty w100" placeholder="01"></td>
					<td class="bdr">월</td>
				</tr>
				<tr>
					<th scope="row">소유주확인</th>
					<td class="bdr" colspan="4"><input type="text" id="EP_auth_value" name="EP_auth_value" value="" class="input_ty w100" maxlength="10" placeholder="개인: 생년월일(6자), 법인: 사업자번호(10자)"></td>				
				</tr>

				<tr>
					<th scope="row">결제금액</th>
					<td class="bdr" colspan="4"><input type="text" id="EP_product_amt" name="EP_product_amt" value="" class="input_ty w100" onKeyUp = "moneyShape2(this); amtChange();"></td>				
				</tr>
				<tr>
					<th scope="row">과세금액</th>
					<td class="bdr" colspan="4"><input type="text" id="com_tax_amt" name="com_tax_amt" value="" class="input_ty w100" readonly></td>				
				</tr>
				<tr>
					<th scope="row">부가세</th>
					<td class="bdr" colspan="4"><input type="text" id="com_vat_amt" name="com_vat_amt" value="" class="input_ty w100" readonly></td>				
				</tr>
				<tr>
					<th scope="row">비과세금액</th>
					<td class="bdr" colspan="4"><input type="text" id="com_free_amt" name="com_free_amt" value="" class="input_ty w100" readonly></td>				
				</tr>
				<tr>
					<th scope="row">에러메시지</th>
					<td class="bdr" colspan="4"><input type="text" id="res_msg" name="res_msg" value="" class="input_ty w100" readonly></td>				
				</tr>
		</table>

	</form>

	<iframe src="" name="card_frame" style="display:none;" width="500" height="500"></iframe>
	<!--<iframe src="" name="card_frame" style="display:none;" width="500" height="500"></iframe>-->
	<!--#include virtual="/common/layer_popup.asp"-->	

</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->

<script type="text/javascript" language="javascript" src="/js/reception.js"></script>
<script language="javascript" type="text/javascript">
	
	document.domain = "apluslife.co.kr"; // Cross-site Scripting

	f_init();

   /* 입력 자동 Setting */
    function f_init(){
        var frm_pay = document.frm;

        var today = new Date();
        var year  = today.getFullYear();
        var month = today.getMonth() + 1;
        var date  = today.getDate();
        var time  = today.getTime();

        if(parseInt(month) < 10) {
            month = "0" + month;
        }

        if(parseInt(date) < 10) {
            date = "0" + date;
        }

        frm_pay.EP_mall_id.value        = "05540345";                                 //가맹점 ID
        frm_pay.EP_mall_nm.value        = "(주)에이플러스라이프";                            //가맹점 명

        frm_pay.EP_memb_user_no.value   = "";                              //가맹점 고객 일련번호
        frm_pay.EP_user_id.value        = "apluslife";                                 //가맹점 고객 ID
        frm_pay.EP_user_nm.value        = "(주)에이플러스라이프";                             //가맹점 고객 이름
        frm_pay.EP_user_mail.value      = "life@apluslife.co.kr";                      //가맹점 고객 이메일
        frm_pay.EP_user_phone1.value    = "16888890";                               //가맹점 고객 번호1
        frm_pay.EP_user_phone2.value    = "";                              //가맹점 고객 번호2
        frm_pay.EP_user_addr.value      = "서울특별시 강남구 역삼로415, 7층 (대치동, 성진빌딩)";                     //가맹점 고객 주소
        frm_pay.EP_product_type.value   = "0";                                        //상품정보구분 0:실물, 1:서비스

        frm_pay.EP_order_no.value       = "ORDER_" + year + month + date + time;      //가맹점 주문번호


      //amtChange();
		amt_type_Change("장례서비스")

		<%
			test_check = "Y"
			if user_id = "S1211059" and test_check = "Y" then
		%>

			//frm_pay.EP_product_nm.value     = "테스트";                               //상품명
			frm_pay.EP_product_amt.value    = "1,004";                                 //상품 금액
			frm_pay.EP_user_type.value      = "0";                                    //카드 구분 0:개인, 1:법인

			frm_pay.card_no1.value   = "4906";                                        //카드번호
			frm_pay.card_no2.value   = "2541";                                        //카드번호
			frm_pay.card_no3.value   = "6521";                                        //카드번호
			frm_pay.card_no4.value   = "2192";                                        //카드번호
			frm_pay.expire_yy.value   = "2022";                                       //유효기간_yy
			frm_pay.expire_mm.value   = "02";                                         //유효기간_mm
			frm_pay.EP_install_period.value   = "00";                                 //할부개월
			frm_pay.EP_auth_value.value   = "780518";                                 //주민번호

			frm_pay.com_tax_amt.value    = "0";                                    //과세 금액
			frm_pay.com_vat_amt.value    = "0";                                    //부가세
			frm_pay.com_free_amt.value    = "1,004";                                    //비과세 금액
			
		<%
			end if
		%>


    }

	function amtChange() {
	
		var obj = document.getElementById("EP_amt_type");
		
		if (ClearComma(document.getElementById("EP_product_amt").value) == "" || ClearComma(document.getElementById("EP_product_amt").value) <= 0 ) {
			//alert ("상품금액을 입력해주세요");
			//return;
		}
		else {
			//alert (document.getElementById("EP_product_amt").value)/ 1.10 ;
			if (obj.value == "1" ){
				
				var amt_1 = ClearComma(document.getElementById("EP_product_amt").value) / 1.1;	
				document.getElementById("com_tax_amt").value = Math.floor(amt_1);
			
				var amt_2 = Math.ceil(amt_1) * 0.1;
				//alert (amt_2);
				
				document.getElementById("com_vat_amt").value = Math.floor(amt_2);
				document.getElementById("com_free_amt").value = 0;


				if (parseInt(ClearComma(document.getElementById("com_tax_amt").value)) + parseInt(ClearComma(document.getElementById("com_vat_amt").value)) !=					parseInt(ClearComma(document.getElementById("EP_product_amt").value)) ) {
					document.getElementById("com_tax_amt").value = Math.ceil(amt_1);
					document.getElementById("com_vat_amt").value = Math.floor(amt_1 * 0.1);	

	

					//alert (document.getElementById("com_tax_amt").value);
					//alert (document.getElementById("com_vat_amt").value);
					//alert (document.getElementById("EP_product_amt").value);
					//alert (parseInt(document.getElementById("com_tax_amt").value) + parseInt(document.getElementById("com_vat_amt").value));

					if (parseInt(ClearComma(document.getElementById("com_tax_amt").value)) + parseInt(ClearComma(document.getElementById("com_vat_amt").value)) != parseInt(ClearComma(document.getElementById("EP_product_amt").value)) ) {
						document.getElementById("com_tax_amt").value = Math.ceil(amt_1);
						document.getElementById("com_vat_amt").value = Math.ceil(amt_1) * 0.1;	



						//alert (document.getElementById("com_tax_amt").value);
						//alert (document.getElementById("com_vat_amt").value);
						//alert (document.getElementById("EP_product_amt").value);
						//alert (parseInt(document.getElementById("com_tax_amt").value) + parseInt(document.getElementById("com_vat_amt").value));
					}
				
				}	
				
				document.getElementById("com_tax_amt").value = ClearComma(document.getElementById("com_tax_amt").value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
				document.getElementById("com_vat_amt").value = ClearComma(document.getElementById("com_vat_amt").value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");	
				
				//return;
			}			
			else {
				
				document.getElementById("com_tax_amt").value = 0;
				document.getElementById("com_vat_amt").value = 0;
				document.getElementById("com_free_amt").value = ClearComma(document.getElementById("EP_product_amt").value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
				//alert("11");
				//return;
			}
		
		}

    }

	function amt_type_Change(input) {
		//alert(input);

		document.getElementById("EP_amt_type").options[0] = null;
		document.getElementById("EP_amt_type").options[1] = null;

		num = new Array("과세","비과세");
		vnum = new Array("1","2");
		
		if (input == "용품구매")
		{
			document.getElementById("EP_amt_type").options[0] = new Option(num[0],vnum[0]);	
		}
		else {
			document.getElementById("EP_amt_type").options[0] = new Option(num[1],vnum[1]);	
		}

		if ("<%=user_type%>" == "a")
		{
			//document.getElementById("EP_amt_type").options[0] = null;
			//document.getElementById("EP_amt_type").options[0] = new Option(num[0],vnum[0]);
			//document.getElementById("EP_amt_type").options[1] = new Option(num[1],vnum[1]);	
		}

		amtChange();
	
	}

	function moneyShape2(Moneytxt) {
		moneyShape(Moneytxt);
		//totalInteger();
	}	

	function Save() {
		/*
		if (!$("#p1").val()) {
			alert('빈소도착일이 입력되지 않았습니다.');
			return false;
		}
		if (!$("#p4").val()) {
			alert('별세일시가 입력되지 않았습니다.');
			return false;
		}
		if (!$("#p7").val()) {
			alert('고인명이 입력되지 않았습니다.');
			return false;
		}
		if (!$("#p9").val()) {
			alert('고인연령이 입력되지 않았습니다.');
			return false;
		}
		if (!$("#p12").val()) {
			alert('장례 진행종교가 입력되지 않았습니다.');
			return false;
		}
		if (!$("#p13").val()) {
			alert('장례식장이 입력되지 않았습니다.');
			return false;
		}
		if (!$("#p15").val()) {
			alert('호실(빈소)이 입력되지 않았습니다.');
			return false;
		}
		if ($("#p11").val() == "화장") {
			if (!$("#p16").val()) {
				alert('1차 장지가 입력되지 않았습니다.');
				return false;
			}
			if (!$("#p18").val()) {
				alert('2차 장지가 입력되지 않았습니다.');
				return false;
			}
		}
		
		if (!$("input:radio[name='p19']:checked").val()) {
			alert('필수항목이 입력되지 않았습니다.');
			return false;
		}
		if (!$("input:radio[name='p20']:checked").val()) {
			alert('필수항목이 입력되지 않았습니다.');
			return false;
		}
		if (!$("input:radio[name='p21']:checked").val()) {
			alert('필수항목이 입력되지 않았습니다.');
			return false;
		}
		if (!$("input:radio[name='p22']:checked").val()) {
			alert('필수항목이 입력되지 않았습니다.');
			return false;
		}
		*/
		/* 카드번호 설정 */
		document.getElementById("EP_card_no").value = $("#card_no1").val() + $("#card_no2").val() + $("#card_no3").val() + $("#card_no4").val();
		//frm_pay.EP_card_no.value = frm_pay.card_no1.value + frm_pay.card_no2.value + frm_pay.card_no3.value + frm_pay.card_no4.value;

		/* 유효기간 설정 */
		document.getElementById("EP_expire_date").value = $("#expire_yy").val().substring(2, 4) + $("#expire_mm").val();
		//frm_pay.EP_expire_date.value = frm_pay.expire_yy.value.substring(2, 4) + frm_pay.expire_mm.value;
		
        /* 결제금액 설정 */
		document.getElementById("EP_tot_amt").value = ClearComma($("#EP_product_amt").val());
		document.getElementById("EP_card_amt").value = ClearComma($("#EP_product_amt").val());
        //frm_pay.EP_tot_amt.value = frm_pay.EP_product_amt.value;
		//frm_pay.EP_card_amt.value = frm_pay.EP_product_amt.value;

		//alert(document.getElementById("EP_card_no").value);
		//alert(document.getElementById("EP_expire_date").value);
		//$("#셀렉트박스ID option:selected").val(); 
		//alert ($("#EP_install_period option:selected").val());
		//alert ($("#EP_product_amt").val());
		//alert ($("#EP_order_no").val());
		

		if ( $("#receipt_hp").val().length < 10 ) {
			alert('영수증 수신번호 입력되지 않았습니다.');
			return false;
		}
		
		if ( ClearComma($("#EP_product_amt").val()) < 1000 ) {
			alert('결제금액은 1천원 이상입니다.');
			return false;
		}
		if ( ClearComma($("#EP_product_amt").val()) < 50000 && ClearComma($("#EP_install_period option:selected").val()) != "00" ) {
			alert('결제금액이 5만원 미만일 경우 할부개월수는 일시납을 선택하여야 합니다.');
			return false;
		}		
		if ( $("#EP_card_no").val().length < 13 )
         {
            alert("신용카드번호가 입력되지 않았습니다. 정확하게 입력되었는지 확인바랍니다.");          
            return false;
        }
        if ( $("#expire_yy").val().length < 4) {
			alert('유효기간(년)이 입력되지 않았습니다. 4자리 입력입니다.');
			return false;
		}
		if ( $("#expire_mm").val().length < 2) {
			alert('유효기간(월)이 입력되지 않았습니다. 2자리(0포함) 입력입니다.');
			return false;
		}
		if ( $("#EP_user_type option:selected").val() == "0" && $("#EP_auth_value").val().length < 6 ) 
		{
			alert('생년월일이 입력되지 않았습니다. 6자리 입력입니다.');
			return false;
		}
		if ( $("#EP_user_type option:selected").val() == "1" && $("#EP_auth_value").val().length < 10 ) 
		{
			alert('사업자번호가 입력되지 않았습니다. 10자리 입력입니다.');
			return false;
		}		
		
		if (!confirm("카드결제를 진행하시겠습니까?")) {
			return false;
		}

		document.getElementById("EP_product_amt").value = ClearComma($("#EP_product_amt").val());
		document.getElementById("com_tax_amt").value = ClearComma($("#com_tax_amt").val());
		document.getElementById("com_vat_amt").value = ClearComma($("#com_vat_amt").val());
		document.getElementById("com_free_amt").value = ClearComma($("#com_free_amt").val());

		//alert("결제신청");
		document.frm.submit();
	}

</script>
