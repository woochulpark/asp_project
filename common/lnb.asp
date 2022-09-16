<script type="text/javascript">
	$(function(){
		// Top 값
		function LnbT(){
			var subTh = $(".stop_sec").innerHeight();
			$(".lnb_sec").css("top", subTh);
		}

		// sub_wrap 상단 여백
		function SwTp(){
			var LnbH = $(".lnb_sec").innerHeight();
			//console.log(LnbH);
			var subTH = $(".stop_sec").innerHeight();
			//console.log(subTH);
			$(".sub_wrap").css("padding-top", parseInt(LnbH) + parseInt(subTH));
			//console.log(parseInt(LnbH) + parseInt(subTH));
			//var subWpt = $(".sub_wrap").css("padding-top").replace("px", "");
			//console.log(subWpt);
			//$(".sub_wrap").css("padding-top", parseInt(LnbH) + parseInt(subWpt));
			//console.log(parseInt(LnbH) + parseInt(subWpt));
		}

		$(window).load(function(){
			LnbT();
			SwTp();
		});

		$(window).resize(function(){
			setTimeout(function(){
				LnbT();
				SwTp();
			}, 1000);
		});


		// Open Lnb Sec
		$(".btn_lnb_open").on("click",function(e){
			e.preventDefault();
			$(".open_lnb_sec").stop().slideDown(400);
		});

		// Close Lnb Sec
		$(".btn_lnb_close").on("click", function(e){
			e.preventDefault();
			$(".open_lnb_sec").stop().slideUp(400);
		});
	});
</script>

<%
	SQL = "select isnull(a.공급확인서, 'N') 공급확인서 "  
	SQL = SQL & " from 행사단체 a (nolock) "
	SQL = SQL & " 	inner join 행사마스터 b (nolock) on a.단체코드 = b.행사단체 "	
	SQL = SQL & " where 1=1 "
	SQL = SQL & " and b.행사번호 = '" & code & "' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)	


	If Rs.EOF Then
		sign_menu = "N"		
	Else
		if Rs("공급확인서") = "N" then
			sign_menu = "N"		
		else
			sign_menu = "Y"		
		end if		
	End If	

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	
%>


<!--// 상단 Tab 메뉴 -->
<% if menu = "접수" and lnbtype = "N" then %>
<div class="lnb_sec">
	<div class="lnb">
		<a href="/reception/reception_info.asp?Code=<%=code %>" <%=lnba %>>기본정보</a>
		<a href="/reception/reception_goin.asp?Code=<%=code %>" <%=lnbb %>>고인정보</a>
		<a href="/reception/reception_etc.asp?Code=<%=code %>" <%=lnbc %>>기타정보</a>
	<% if sign_menu = "Y" then %>
		<a href="/reception/reception_support.asp?Code=<%=code %>" <%=lnbd %>>회사지원입력</a>
		<a href="/reception/reception_sign.asp?Code=<%=code %>" <%=lnbe %>>회사지원서명</a>
	<% end if %>
	    <a href="/reception/reception_card.asp?Code=<%=code %>" <%=lnbj %>>카드결제</a>
		<a href="/reception/reception_card_hy.asp?Code=<%=code %>" <%=lnbk %>>카드이력</a>
		<a href="/reception/reception_cash.asp?Code=<%=code %>" <%=lnbm %>>현금영수증</a>
		<a href="/reception/reception_cash_hy.asp?Code=<%=code %>" <%=lnbn %>>현금영수증이력</a>
	</div><!--// lnb -->

	<a href="javascript:void(0);" class="btn_lnb_open">서브메뉴 열기</a>

	<div class="open_lnb_sec">
		<div class="open_lnb">
			<a href="/reception/reception_info.asp?Code=<%=code %>" <%=lnba %>>기본정보</a>
			<a href="/reception/reception_goin.asp?Code=<%=code %>" <%=lnbb %>>고인정보</a>
			<a href="/reception/reception_etc.asp?Code=<%=code %>" <%=lnbc %>>기타정보</a>
	<% if sign_menu = "Y" then %>
			<a href="/reception/reception_support.asp?Code=<%=code %>" <%=lnbd %>>회사지원입력</a>
			<a href="/reception/reception_sign.asp?Code=<%=code %>" <%=lnbe %>>회사지원서명</a>
	<% end if %>
			<a href="/reception/reception_card.asp?Code=<%=code %>" <%=lnbj %>>카드결제</a>
			<a href="/reception/reception_card_hy.asp?Code=<%=code %>" <%=lnbk %>>카드이력</a>
			<a href="/reception/reception_cash.asp?Code=<%=code %>" <%=lnbm %>>현금영수증</a>
			<a href="/reception/reception_cash_hy.asp?Code=<%=code %>" <%=lnbn %>>현금영수증이력</a>
		</div>
		<a href="javascript:void(0);" class="btn_lnb_close">닫기</a>
	</div>
</div>
<% elseif menu = "접수" and lnbtype = "Y" then %>
<div class="lnb_sec">
	<div class="lnb">
		<a href="/reception/reception_info_b.asp?Code=<%=FnAesEncrypt(code, AesEncryptPwd) %>" <%=lnba %>>기본정보</a>		
		<a href="/reception/reception_etc_b.asp?Code=<%=FnAesEncrypt(code, AesEncryptPwd) %>" <%=lnbb %>>기타정보</a>		
		<a href="/reception/reception_sign_b.asp?Code=<%=FnAesEncrypt(code, AesEncryptPwd) %>" <%=lnbc %>>회사지원서명</a>
		<a href="/reception/reception_card_b.asp?Code=<%=FnAesEncrypt(code, AesEncryptPwd) %>" <%=lnbj %>>카드결제</a>
		<a href="/reception/reception_card_b_hy.asp?Code=<%=FnAesEncrypt(code, AesEncryptPwd) %>" <%=lnbk %>>카드이력</a>
		<a href="/reception/reception_cash_b.asp?Code=<%=FnAesEncrypt(code, AesEncryptPwd) %>" <%=lnbm %>>현금영수증</a>
		<a href="/reception/reception_cash_b_hy.asp?Code=<%=FnAesEncrypt(code, AesEncryptPwd) %>" <%=lnbn %>>현금영수증이력</a>
	</div><!--// lnb -->

	<a href="javascript:void(0);" class="btn_lnb_open">서브메뉴 열기</a>

	<div class="open_lnb_sec">
		<div class="open_lnb">
			<a href="/reception/reception_info_b.asp?Code=<%=FnAesEncrypt(code, AesEncryptPwd) %>" <%=lnba %>>기본정보</a>			
			<a href="/reception/reception_etc_b.asp?Code=<%=FnAesEncrypt(code, AesEncryptPwd) %>" <%=lnbb %>>기타정보</a>			
			<a href="/reception/reception_sign_b.asp?Code=<%=FnAesEncrypt(code, AesEncryptPwd) %>" <%=lnbc %>>회사지원서명</a>
			<a href="/reception/reception_card_b.asp?Code=<%=FnAesEncrypt(code, AesEncryptPwd) %>" <%=lnbj %>>카드결제</a>
			<a href="/reception/reception_card_b_hy.asp?Code=<%=FnAesEncrypt(code, AesEncryptPwd) %>" <%=lnbk %>>카드이력</a>
			<a href="/reception/reception_cash_b.asp?Code=<%=FnAesEncrypt(code, AesEncryptPwd) %>" <%=lnbm %>>현금영수증</a>
			<a href="/reception/reception_cash_b_hy.asp?Code=<%=FnAesEncrypt(code, AesEncryptPwd) %>" <%=lnbn %>>현금영수증이력</a>
		</div>
		<a href="javascript:void(0);" class="btn_lnb_close">닫기</a>
	</div>
</div>
<% elseif menu = "진행" then %>
<div class="lnb_sec">
	<div class="lnb">
		<a href="/progression/progression_progress.asp?Code=<%=code %>" <%=lnba %>>장례진행</a>
		<a href="/progression/progression_info.asp?Code=<%=code %>" <%=lnbb %>>기본정보</a>
		<a href="/progression/progression_goin.asp?Code=<%=code %>" <%=lnbc %>>고인정보</a>
		<a href="/progression/progression_etc.asp?Code=<%=code %>" <%=lnbd %>>기타정보</a>
	<% if sign_menu = "Y" then %>		
		<a href="/progression/progression_sign.asp?Code=<%=code %>" <%=lnbe %>>회사지원서명</a>
	<% end if %>
		<a href="/progression/progression_card.asp?Code=<%=code %>" <%=lnbj %>>카드결제</a>
		<a href="/progression/progression_card_hy.asp?Code=<%=code %>" <%=lnbk %>>카드이력</a>
		<a href="/progression/progression_cash.asp?Code=<%=code %>" <%=lnbm %>>현금영수증</a>
		<a href="/progression/progression_cash_hy.asp?Code=<%=code %>" <%=lnbn %>>현금영수증이력</a>
	</div><!--// lnb -->

	<a href="javascript:void(0);" class="btn_lnb_open">서브메뉴 열기</a>

	<div class="open_lnb_sec">
		<div class="open_lnb">
			<a href="/progression/progression_progress.asp?Code=<%=code %>" <%=lnba %>>장례진행</a>
			<a href="/progression/progression_info.asp?Code=<%=code %>" <%=lnbb %>>기본정보</a>
			<a href="/progression/progression_goin.asp?Code=<%=code %>" <%=lnbc %>>고인정보</a>
			<a href="/progression/progression_etc.asp?Code=<%=code %>" <%=lnbd %>>기타정보</a>			
	<% if sign_menu = "Y" then %>
			<a href="/progression/progression_sign.asp?Code=<%=code %>" <%=lnbe %>>회사지원서명</a>
	<% end if %>
			<a href="/progression/progression_card.asp?Code=<%=code %>" <%=lnbj %>>카드결제</a>
			<a href="/progression/progression_card_hy.asp?Code=<%=code %>" <%=lnbk %>>카드이력</a>
			<a href="/progression/progression_cash.asp?Code=<%=code %>" <%=lnbm %>>현금영수증</a>
			<a href="/progression/progression_cash_hy.asp?Code=<%=code %>" <%=lnbn %>>현금영수증이력</a>
		</div>
		<a href="javascript:void(0);" class="btn_lnb_close">닫기</a>
	</div>
</div>
<% elseif menu = "정산" then %>
<div class="lnb_sec">
	<div class="lnb">
		<a href="/calculation/calculation_info.asp?Code=<%=code %>" <%=lnba %>>행사정보</a>
		<a href="/calculation/calculation_buy.asp?Code=<%=code %>" <%=lnbb %>>기본제공비용(구입)</a>
		<a href="/calculation/calculation_add.asp?Code=<%=code %>" <%=lnbc %>>추가 및 공제내역</a>
		<a href="/calculation/calculation_helper.asp?Code=<%=code %>" <%=lnbd %>>도우미</a>		
		<a href="/calculation/calculation_etc.asp?Code=<%=code %>" <%=lnbe %>>행사특이사항</a>
		<a href="/calculation/calculation_self.asp?Code=<%=code %>" <%=lnbf %>>용품명세서(자체)</a>
		<a href="/calculation/calculation_total.asp?Code=<%=code %>" <%=lnbg %>>정산내역</a>
		<a href="/calculation/calculation_file.asp?Code=<%=code %>" <%=lnbh %>>첨부파일</a>
		<a href="/calculation/calculation_card.asp?Code=<%=code %>" <%=lnbj %>>카드결제</a>
		<a href="/calculation/calculation_card_hy.asp?Code=<%=code %>" <%=lnbk %>>카드이력</a>
		<a href="/calculation/calculation_cash.asp?Code=<%=code %>" <%=lnbm %>>현금영수증</a>
		<a href="/calculation/calculation_cash_hy.asp?Code=<%=code %>" <%=lnbn %>>현금영수증이력</a>
	</div><!--// lnb -->

	<a href="javascript:void(0);" class="btn_lnb_open">서브메뉴 열기</a>

	<div class="open_lnb_sec">
		<div class="open_lnb">
			<a href="/calculation/calculation_info.asp?Code=<%=code %>" <%=lnba %>>행사정보</a>
			<a href="/calculation/calculation_buy.asp?Code=<%=code %>" <%=lnbb %>>기본제공비용(구입)</a>
			<a href="/calculation/calculation_add.asp?Code=<%=code %>" <%=lnbc %>>추가 및 공제내역</a>
			<a href="/calculation/calculation_helper.asp?Code=<%=code %>" <%=lnbd %>>도우미</a>		
			<a href="/calculation/calculation_etc.asp?Code=<%=code %>" <%=lnbe %>>행사특이사항</a>
			<a href="/calculation/calculation_self.asp?Code=<%=code %>" <%=lnbf %>>용품명세서(자체)</a>
			<a href="/calculation/calculation_total.asp?Code=<%=code %>" <%=lnbg %>>정산내역</a>
			<a href="/calculation/calculation_file.asp?Code=<%=code %>" <%=lnbh %>>첨부파일</a>
			<a href="/calculation/calculation_card.asp?Code=<%=code %>" <%=lnbj %>>카드결제</a>
			<a href="/calculation/calculation_card_hy.asp?Code=<%=code %>" <%=lnbk %>>카드이력</a>
			<a href="/calculation/calculation_cash.asp?Code=<%=code %>" <%=lnbm %>>현금영수증</a>
			<a href="/calculation/calculation_cash_hy.asp?Code=<%=code %>" <%=lnbn %>>현금영수증이력</a>
		</div>
		<a href="javascript:void(0);" class="btn_lnb_close">닫기</a>
	</div>
</div>
<% end if %>
<!--// lnb_sec -->