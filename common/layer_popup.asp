﻿<div class="ly_pop" id="popupLayer"></div>
<!--// 
임시 레이어팝업 : 시작 
팝업 사이즈(w공통 + h유동) > 기본 - auto / (중) - .lypM(의전팀장 배정) / (대) - .lypB / (소) - .lypS
-->	

<script type="text/javascript">

	$(function () {
		// Dialog
		$(".ly_pop").dialog({
			autoOpen: false
		});

		/* 모든 레이어팝업 공통 */
		$(".ui-dialog-titlebar-close,.ovlay").on("click", function () {
			Close();
		});
		
	});
	//// 레이어팝업 열기 ////
	function Open(title) {
		$(".ly_pop").children("div").prepend("<a href='#' class='hid_f'>Hidden Focus</a>");
		$(".ly_pop").dialog("option", "title", title);
		$(".ly_pop").dialog("open");
		$("html, body").css("overflow", "hidden");
		$(".ovlay").show();
	}
	function Open2(title) {
		$(".ly_pop").children("div").prepend("<a href='#' class='hid_f'>Hidden Focus</a>");
		$(".ly_pop").dialog({
			autoOpen: false,
			dialogClass: "full"
		});
		$(".ly_pop").dialog("option", "title", title);
		$(".ly_pop").dialog("open");
		$("html, body").css("overflow", "hidden");
		$(".ovlay").show();
	}
	//// 레이어팝업 닫기 ////
	function Close() {		
		
		if ($("#popup_check_ag").val() == "HelperList3") {
			HelperList3($("#sType_popup").val(), $("#sValue_popup").val());
			return false;
		}
		if ($("#popup_check_ag").val() == "HelperList") {
			HelperList($("#sValue_popup").val());
			return false;
		}

		$(".ly_pop").dialog("close");
		$("html, body").css("overflow", "visible");
		$(".ovlay").hide();
	}
</script>
<!--// 임시 레이어팝업 : 끝 -->