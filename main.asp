<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<div class="main_wrap">
	<!--#include virtual="/common/menu.asp"-->
	
	<p class="main_slog">Total Life Care Service <br>꿈꾸던 라이프의 시작 <br> A+라이프</p>

	<div class="main_btns">
<% 	if user_type = "a" then %>
		<!--// 임직원 -->
		<a href="/reception/reception_list.asp" class="mb01">접수</a>
		<a href="/progression/progression_list.asp" class="mb02">진행</a>
		<a href="/calculation/calculation_list.asp" class="mb03">정산</a>
		<a href="/product/product_list.asp" class="mb04">상품검색</a>
		<a href="/itemcare/itemcare_list.asp" class="mb05">재고관리</a>
		<a href="/funeral/funeral_list.asp" class="mb06">장례식장</a>
		<a href="/approval/approval_list.asp" class="mb07">승인현황</a>
		<a href="/delivery/delivery_list.asp" class="mb08">배송</a>
		<a href="/teamleader/teamleader_list.asp" class="mb09">의전팀장</a>
		<a href="/geunjogi/geunjogi_list.asp" class="mb10">근조기</a>
		<a href="/statis/statis.asp" class="mb11">통계</a>
		<a href="/qna/qna_list.asp" class="mb12">만족도평가</a>
		<a href="/reservation/reservation_list.asp" class="mb13">상담신청확인</a>
<% 	elseif user_type = "b" then %>
		<!--// 의전팀장 -->
		<a href="/reception/reception_list.asp" class="mb01">접수</a>
		<a href="/progression/progression_list.asp" class="mb02">진행</a>
		<a href="/calculation/calculation_list.asp" class="mb03">정산</a>
		<a href="/product/product_list.asp" class="mb04">상품검색</a>
		<a href="/itemcare/itemcare_list.asp" class="mb05">재고관리</a>
		<a href="/funeral/funeral_list.asp" class="mb06">장례식장</a>
		<a href="/approval/approval_list.asp" class="mb07">승인현황</a>
		<a href="/geunjogi/geunjogi_list.asp" class="mb10">근조기</a>
		<a href="/statis/statis.asp" class="mb11">통계</a>
		<a href="/qna/qna_list.asp" class="mb12">만족도평가</a>
<%	elseif user_type = "c" then %>
		<!--// 기업담당자 -->
		<a href="/reception/reception_list_c.asp" class="mb01 full">접수현황</a>
<%	elseif user_type = "d" then %>
		<!--// 협력업체 -->
		<a href="/delivery/delivery_list_d.asp" class="mb08 full">배송</a>		
<%	end if %>
	</div><!--// main_btns -->

	<div class="mbans">
		<a href="tel:1688-8890" class="mban_tel">장례접수<span>1688-8890</span></a>
		<a href="/notice/notice_list.asp" class="mban_noti">공지사항</a>
	</div><!--// mbans -->
</div><!--// main_wrap -->

<!--#include virtual="/common/footer.asp"-->