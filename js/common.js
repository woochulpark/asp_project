$(function(){
	// 메뉴 펼치기
	$(".btn_mopen").on("click", function(e){
		e.preventDefault();
		$("html, body").css("overflow", "hidden");
		$(".wrap").css("overflow-y", "hidden");
		$(".btn_mclose").addClass("view");
		$(".hid_sec").addClass("view");
		$(".ovlay").fadeIn(400);
	});

	// 메뉴 접기
	$(".btn_mclose, .ovlay").on("click", function(e){
		e.preventDefault();
		$("html, body").css("overflow", "visible");
		$(".wrap").css("overflow-y", "auto");
		$(".btn_mclose").removeClass("view");
		$(".hid_sec").removeClass("view");
		$(".ovlay").fadeOut(400);
	});

	// Datepicker
	/*$(".datepicker").datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat: "yy.mm.dd",
		showOn: "button",
		buttonImage: "../images/ico_cal.svg",
		buttonImageOnly: true,
		buttonText: "Select date"
	});*/

	var $startDate = $(".start-date");
	var $endDate = $(".end-date");

	$startDate.datepicker({
		autoHide: true,
	});

	$endDate.datepicker({
		autoHide: true,
		startDate: $startDate.datepicker("getDate"),
	});

	$startDate.on("change", function () {
		$endDate.datepicker("setStartDate", $startDate.datepicker("getDate"));
	});


	/*
	$(window).load(function(){
		var screen_size = $(window).width();
	});

	$(window).resize(function(){
		var screen_size = $(window).width();
		if(screen_size > 800){
		}else{
		}
	});
	*/

	// 팝업 hidden focus 주기
	//$(".ly_pop").children("div").prepend("<a href='#' class='hid_f'>Hidden Focus</a>");
});