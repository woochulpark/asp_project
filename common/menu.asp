<script type="text/javascript">
	$(function(){
		var Memi = $(".mem_info > p");
		var Mem_n = $(".mem_info .name");

		if (Memi.innerHeight() < Mem_n.innerHeight()){
			Memi.addClass("multi");
		} else {
		}
	});
</script>

<!--// 우측 상단 메뉴 -->
<div class="gnb_sec">
	<a href="javascript:void(0);" class="btn_mopen">메뉴 열기</a>
	<a href="javascript:void(0);" class="btn_mclose">메뉴 닫기</a>

	<div class="hid_sec">
		<a href="/main.asp" class="logo">A+라이프</a>
		<dl>
			<dt>
				<div class="mem_info">
					<p>
						<span class="name"><%=user_name %></span>
						<span class="na_ap">님</span>
					</p>
				</div>
				<a href="/login/logout.asp" class="btn_logout">로그아웃</a>
			</dt>
			<dd>
				<div class="gnb">
				<% 	if user_type = "a" then %>
					<a href="/reception/reception_list.asp">접수</a>
					<a href="/progression/progression_list.asp">진행</a>
					<a href="/calculation/calculation_list.asp">정산</a>
					<a href="/product/product_list.asp">상품검색</a>
					<a href="/itemcare/itemcare_list.asp">재고관리</a>
					<a href="/funeral/funeral_list.asp">장례식장</a>
					<a href="/approval/approval_list.asp">승인현황</a>
					<a href="/delivery/delivery_list.asp">배송</a>
					<a href="/teamleader/teamleader_list.asp">의전팀장</a>
					<a href="/geunjogi/geunjogi_list.asp">근조기</a>
					<a href="/statis/statis.asp">통계</a>
					<a href="/qna/qna_list.asp">만족도평가</a>
					<a href="/reservation/reservation_list.asp">상담신청확인</a>
					<a href="/notice/notice_list.asp">공지사항</a>                    
				<% 	elseif user_type = "b" then %>
					<a href="/reception/reception_list.asp">접수</a>
					<a href="/progression/progression_list.asp">진행</a>
					<a href="/calculation/calculation_list.asp">정산</a>
					<a href="/product/product_list.asp">상품검색</a>
					<a href="/itemcare/itemcare_list.asp">재고관리</a>
					<a href="/funeral/funeral_list.asp">장례식장</a>
					<a href="/approval/approval_list.asp">승인현황</a>
					<a href="/geunjogi/geunjogi_list.asp">근조기</a>
					<a href="/statis/statis.asp">통계</a>
					<a href="/qna/qna_list.asp">만족도평가</a>
					<a href="/notice/notice_list.asp">공지사항</a>
				<%	elseif user_type = "c" then %>
					<a href="/reception/reception_list_c.asp">접수현황</a>
					<a href="/notice/notice_list.asp">공지사항</a>
				<%	elseif user_type = "d" then %>
					<a href="/delivery/delivery_list_d.asp">배송</a>
					<a href="/notice/notice_list.asp">공지사항</a>
				<%	end if %>
				</div><!--// gnb -->
			</dd>
		</dl>
	</div><!--// hid_sec -->
</div><!--// gnb_sec -->