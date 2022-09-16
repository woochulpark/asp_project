<!--#include virtual="/common/header.asp"-->

<div class="gate_sec">
	<!--#include virtual="/common/top_gl.asp"-->
	<div class="gt_wrap">
		<h1 class="gt_slog"><img src="/images/gt_slog.svg" alt="Total Life Care Service 꿈꾸던 라이프의 시작"></h1>
		<div class="btn_list">
			<a href="tel:1688-8860" class="btn_gt"><p>대표번호<span>1688-8860</span></p></a>
			<a href="tel:1688-8890" class="btn_gt"><p>24시간 장례접수<span>1688-8890</span></p></a>
			<a href="javascript:void(0);" onclick="Reservation();" class="btn_gt last"><p>온라인 장례접수/상담</p></a>
			<a href="/login/login.asp" class="btn_login">로그인</a>
		</div><!--// btn_list -->
	</div><!--// gt_wrap -->
</div><!--// gate_sec -->

<!--#include virtual="/common/layer_popup.asp"-->

<!--#include virtual="/common/footer.asp"-->

<script type="text/javascript" language="javascript" src="/js/reception.js"></script>	
<script language="javascript" type="text/javascript">

	function Reservation() {
		
		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/reservation/reservation_ajax.asp", //요청을 보낼 서버의 URL			
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open2('온라인 장례접수/상담');
			}
		});

	}
	function ReservationOK() {
		var rType = document.frm.r_type.value;
		var rName = document.frm.r_name.value;
		var rPhone = document.frm.r_phone.value;		

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/reservation/reservation_ok_ajax.asp", //요청을 보낼 서버의 URL			
			data: { rType: rType, rName: rName, rPhone: rPhone }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				alert('등록되었습니다.');
				Close();
			}
		});

	}
	function Save() {
		if (!$("#r_name").val()) {
			alert('이름이 입력되지 않았습니다.');
			return false;
		}
		if (!$("#r_phone").val()) {
			alert('전화번호가 입력되지 않았습니다.');
			return false;
		}
		if (!confirm("등록하시겠습니까?")) {
			return false;
		}
		ReservationOK();
	}	
</script>