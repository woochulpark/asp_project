<div class="gate_ly_sec">

	<form name="frm" id="frm" method="post">

	<p class="top_tit">연락처를 남겨주시면 상담원이 신속하게 연락드리겠습니다.</p>

	<ul class="checks rad_ty02">
		<li>
			<input type="radio" id="r_type_1" name="r_type" value="장례접수" checked>
			<label for="r_type_1">장례접수</label>
		</li>
		<li>
			<input type="radio" id="r_type_2" name="r_type" value="사전장례상담">
			<label for="r_type_2">사전 장례 상담</label>
		</li>
	</ul><!--// checks -->

	<ul class="gate_form">
		<li><input type="text" id="r_name" name="r_name" maxlength="15" class="input_ty w100" placeholder="이름을 입력해주세요."></li>
		<li><input type="text" id="r_phone" name="r_phone" maxlength="11" onkeyup="chkInteger(this);" class="input_ty w100" placeholder="연락처를 입력해주세요."></li>
	</ul><!--// gate_form -->

	<p class="checks chk_ty02"><span>
		<input type="checkbox" id="" name="" checked>
		<label for="">수집된 개인정보는 장례접수 / 사전 장례상담 제공을 목적으로만 사용함을 동의합니다.</label>
	</span></p>

	</form>
</div><!--// gate_ly_sec -->

<div class="btm_btns">
	<a href="javascript:void(0);" onclick="Save();" class="btn_ty btn_b">신청</a>
</div><!--// btm_btns -->