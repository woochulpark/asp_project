//// 진행승인요청 ////
function Approval(code) {

	if (!confirm("진행승인요청 하시겠습니까?")) {
		return false;
	}

	$.ajax({
		type: "POST", //데이터 전송타입 (POST,GET)
		cache: false, //캐시 사용여부(true,false)
		url: "reception_approval_ok_ajax.asp", //요청을 보낼 서버의 URL
		data: { code: code }, //서버로 보내지는 데이터
		datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
		success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
			if (data == "a") {
				alert("승인요청 되었습니다.");
				location.reload();
			} else if (data === "b") {
				alert("이미 승인요청중 입니다.");
			} else if (data === "c") {
				alert("근무일지가 등록되지 않았습니다.");
			} else {
				alert("잘못된 요청입니다.");
			}
		}
	});

}
//// 진행승인확인 ////
function ApprovalOK(code) {

	if (!confirm("진행승인확인 하시겠습니까?")) {
		return false;
	}

	$.ajax({
		type: "POST", //데이터 전송타입 (POST,GET)
		cache: false, //캐시 사용여부(true,false)
		url: "reception_approval_check_ok_ajax.asp", //요청을 보낼 서버의 URL
		data: { code: code }, //서버로 보내지는 데이터
		datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
		success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
			if (data == "a") {
				alert("진행승인확인 되었습니다.");
				location.reload();
			} else if (data == "b") {
				alert("이미 진행승인확인 되어있는 행사입니다.");
			} else if (data == "c") {
				alert("진행승인 요청되지 않았습니다.");
			} else {
				alert("잘못된 요청입니다.");
			}
		}
	});

}
//// 완료승인요청 ////
function Complete(code) {

	if (!confirm("완료승인요청 하시겠습니까?")) {
		return false;
	}

	$.ajax({
		type: "POST", //데이터 전송타입 (POST,GET)
		cache: false, //캐시 사용여부(true,false)
		url: "progression_complete_ok_ajax.asp", //요청을 보낼 서버의 URL
		data: { code: code }, //서버로 보내지는 데이터
		datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
		success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
			if (data == "a") {
				alert("승인요청 되었습니다.");
				location.reload();
			} else if (data == "b") {
				alert("이미 승인요청중 입니다.");
			} else if (data == "c") {
				alert("근무일지가 등록되지 않았습니다.");
			} else if (data === "z") {
				alert("근무일지가 등록되지 않았습니다.\n내용은 5자 이상이어야 합니다.");
			} else {
				alert("잘못된 요청입니다.");
			}
		}
	});

}
//// 완료승인확인 ////
function CompleteOK(code) {

	if (!confirm("완료승인확인 하시겠습니까?")) {
		return false;
	}

	$.ajax({
		type: "POST", //데이터 전송타입 (POST,GET)
		cache: false, //캐시 사용여부(true,false)
		url: "progression_complete_check_ok_ajax.asp", //요청을 보낼 서버의 URL
		data: { code: code }, //서버로 보내지는 데이터
		datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
		success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
			if (data == "a") {
				alert("완료승인확인 되었습니다.");
				location.reload();
			} else if (data == "b") {
				alert("이미 완료승인확인 되어있는 행사입니다.");
			} else if (data == "c") {
				alert("진행승인 요청되지 않았습니다.");
			} else {
				alert("잘못된 요청입니다.");
			}
		}
	});

}


//// 완료승인확인 ////
function CompleteOK_erp(code) {

	if (!confirm("완료승인확인 하시겠습니까?")) {
		return false;
	}

	$.ajax({
		type: "POST", //데이터 전송타입 (POST,GET)
		cache: false, //캐시 사용여부(true,false)
		url: "progression_complete_check_ok_ajax_erp.asp", //요청을 보낼 서버의 URL
		data: { code: code }, //서버로 보내지는 데이터
		datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
		success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
			if (data == "a") {
				alert("완료승인확인 되었습니다.");
				location.reload();
			} else if (data == "b") {
				alert("이미 완료승인확인 되어있는 행사입니다.");
			} else if (data == "c") {
				alert("진행승인 요청되지 않았습니다.");
			} else {
				alert("잘못된 요청입니다.");
			}
		}
	});

}

//// 해당 리스트로 이동 ////
function List(menu) {
	location.href = menu + "_list.asp";
}
//// 숫자만입력 ////
function chkInteger(Form1) {
	for (i = 0; i < Form1.value.length; i++) {
		if ((Form1.value.charAt(i) < '0') || (Form1.value.charAt(i) > '9')) {
			alert('숫자만 입력가능합니다.');
			Form1.value = ''
			Form1.focus();
			return false;
		}
	} // end for 
	return true;
}
//// 천단위 콤마 ////
function comma(num) {
	var len, point, str, str_s, str2;

	if (num == "") {
		num = "0";
	}

	num = num + "";
	num = ClearComma(num);

	if (num.indexOf(".") != -1) {
		str_s = num.split(".")
		num = String(parseInt(str_s[0]));
		num2 = "." + str_s[1].substr(0, 2);
	} else {
		num = String(parseInt(num));
		num2 = "";
	}

	point = num.length % 3;
	len = num.length;

	str = num.substring(0, point);

	while (point < len) {
		if (str != "") str += ",";
		str += num.substring(point, point + 3);
		point += 3;
	}
	return str + num2;
}
//// 천단위 콤마 지우기 ////
function ClearComma(value1) {
	newValue = '';
	for (i = 0; i < value1.length; i++) {
		if (value1.charAt(i) != ",")
			newValue = newValue + value1.charAt(i);
	}
	return newValue;
}
//// 천단위 콤마 ////
function moneyShape(Moneytxt) {
	var money;
	money = ClearComma(Moneytxt.value);
	Moneytxt.value = comma(money);
	/*
	if (chkInteger(Moneytxt)) {
	tmpValue = '';
	header = '';
	if (money.charAt(0) == "-" || money.charAt(0) == "+") {
	header = money.charAt(0);
	money = money.substring(1, money.length);
	}
	if (money.length > 3) {
	while (money.length > 3) {
	if (tmpValue != "")
	tmpValue = money.substring(money.length - 3, money.length) + "," + tmpValue;
	else
	tmpValue = money.substring(money.length - 3, money.length);

	money = money.substring(0, money.length - 3);
	}
	if (money.length > 0) tmpValue = header + money + ',' + tmpValue;
	Moneytxt.value = tmpValue;
	}
	}
	*/
}

/// 파일 상세보기 ///
function FileView(filename) {

	$.ajax({
		type: "POST", //데이터 전송타입 (POST,GET)
		cache: false, //캐시 사용여부(true,false)
		url: "/file/view.asp", //요청을 보낼 서버의 URL
		data: { filename: filename }, //서버로 보내지는 데이터
		datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
		success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
			$("#popupLayer").text("");
			$("#popupLayer").html(data);
			Open('원본보기');
		}
	});

}