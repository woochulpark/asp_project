<div class="second_pop" id="secondPopupLayer"></div>
<!--// 
임시 레이어팝업 : 시작 
팝업 사이즈(w공통 + h유동) > 기본 - auto / (중) - .lypM(의전팀장 배정) / (대) - .lypB / (소) - .lypS
-->	

<script type="text/javascript">

	$(function () {
		// Dialog
		$(".second_pop").dialog({
			autoOpen: false
		});

		/* 모든 레이어팝업 공통 */
		$(".ui-dialog-titlebar-close,.ovlay").on("click", function () {
			SecondClose();
		});
		
	});
	//// 레이어팝업 열기 ////
	function SecondOpen(title) {
		$(".second_pop").children("div").prepend("<a href='#' class='hid_f'>Hidden Focus</a>");
		$(".second_pop").dialog("option", "title", title);
		$(".second_pop").dialog("open");
		$("html, body").css("overflow", "hidden");
		$(".ovlay").show();
	}
	function SecondOpen2(title) {
		$(".second_pop").children("div").prepend("<a href='#' class='hid_f'>Hidden Focus</a>");
		$(".second_pop").dialog({
			autoOpen: false,
			dialogClass: "full"
		});
		$(".second_pop").dialog("option", "title", title);
		$(".second_pop").dialog("open");
		$("html, body").css("overflow", "hidden");
		$(".ovlay").show();
	}
	//// 레이어팝업 닫기 ////
	function SecondClose() {
		$(".second_pop").dialog("close");
	}
</script>
<!--// 임시 레이어팝업 : 끝 -->