<!--#include virtual="/common/header.asp"-->

<div class="login_sec">
	<!--#include virtual="/common/top_gl_login.asp"-->
	<script type="text/javascript">
		$(function(){
			$(".lg_tabs > a").on("click", function(e){
				e.preventDefault();
				$(".lg_tabs > a").removeClass("on");
				$(this).addClass("on");
			});
		});
		function checkLogin() {
			if (!$("#input_id").val()) {
				alert("ID를 입력해주세요.");
				return false;
			}
			if (!$("#input_pwd").val()) {
				alert("Password를 입력해주세요.");
				return false;
			}			
			frm.submit();
		}
		function Chang_Type(type) {
			$("#input_type").val(type);
		}
		function Change_Btn() {
			if ($("#input_id").val().length > 0 && $("#input_pwd").val().length > 0) {
				$("#login_btn").addClass('on');
			} else {
				$("#login_btn").removeClass('on');
			}
		}
	</script>
	<form name="frm" id="frm" method="post" action="login_ok.asp">
	<input type="hidden" id="input_type" name="input_type" value="a" />

	<div class="lg_wrap">
		<div class="lg_tabs">
			<a href="#" onclick="Chang_Type('a')" class="on">임직원</a>
			<a href="#" onclick="Chang_Type('b')">의전팀장</a>
			<a href="#" onclick="Chang_Type('c')">기업담당자</a>
			<a href="#" onclick="Chang_Type('d')">협력업체</a>
		</div><!--// lg_tabs -->

		<ul class="form_sec">
			<li>
				<input type="text" class="input_ty lg_id w100" placeholder="아이디를 입력해주세요." id="input_id" name="input_id" onkeyup="Change_Btn();">
				<input type="password" class="input_ty lg_pw w100" placeholder="비밀번호를 입력해주세요." id="input_pwd" name="input_pwd" onkeyup="Change_Btn();">
				<a href="#" class="btn_login" id="login_btn" onclick="checkLogin();">로그인</a>
			</li>			
		</ul><!--// form_sec -->
	</div><!--// lg_wrap -->

	</form>
</div><!--// login_sec -->

<!--#include virtual="/common/footer.asp"-->