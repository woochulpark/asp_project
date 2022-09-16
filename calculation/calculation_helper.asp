<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%
	menu = "정산"	
	lnbd = "class='on'"	

	code = Trim(request("Code"))
	
	if code = "" then 
		response.End
	end if

	SQL = "select 사원코드, 사원명, 구분, 일차, 시작일자, 시작시간, 작업시간, 도우미단가, 작업수당, 시간외수당, 총액, 세액, 지급액, 소득세, 주민세 "
	SQL = SQL & " from 행사도우미 "
	SQL = SQL & " where 행사번호 = '"& code &"' "	
	SQL = SQL & " order by 라인번호 asc "

	SQL_P = " select 상세코드,대표명칭,상세명칭 "
	SQL_P = SQL_P & " from 공용코드 "	
	SQL_P = SQL_P & " where 대표코드 = '00255' "
	SQL_P = SQL_P & " order by 상세코드 asc "

	SQL_I = "select 행사시작일시 "
	SQL_I = SQL_I & " , CONVERT(varchar,DATEADD(dd,1,left(a.행사시작일시,8)),112) as 행사일시2일차 "
	SQL_I = SQL_I & " , CONVERT(varchar,DATEADD(dd,2,left(a.행사시작일시,8)),112) as 행사일시3일차 "
	SQL_I = SQL_I & " , CONVERT(varchar,DATEADD(dd,3,left(a.행사시작일시,8)),112) as 행사일시4일차 "
	SQL_I = SQL_I & " , CONVERT(varchar,DATEADD(dd,4,left(a.행사시작일시,8)),112) as 행사일시5일차 "
	SQL_I = SQL_I & " , isnull(b.본부,'') 본부 "
	SQL_I = SQL_I & " from 행사마스터 a (nolock) left outer join 행사의전팀장 b (nolock) on a.진행팀장 = b.코드" 
	SQL_I = SQL_I & " where a.행사번호 = '"& code &"'"	

	SQL_S = "select 승인구분 from 행사마스터 "
	SQL_S = SQL_S & " where 행사번호 = '"& code &"' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ	

	Set Rs = ConnAplus.execute(SQL)	

	If Rs.EOF Then
		rc = 0		
	Else
		rc = Rs.RecordCount
		arrObj = Rs.GetRows(rc)
	End If	

	Set Rs = ConnAplus.execute(SQL_P)	

	If Rs.EOF Then
		rc2 = 0
	Else
		rc2 = Rs.RecordCount
		arrObj2 = Rs.GetRows(rc2)
	End If

	Set Rs = ConnAplus.execute(SQL_I)	

	If Rs.EOF Then
		sdate_d = ""
	Else
		sdate_d = Left(Trim(Rs("행사시작일시")),8)
		sdate_d2 = Left(Trim(Rs("행사일시2일차")),8)
		sdate_d3 = Left(Trim(Rs("행사일시3일차")),8)
		sdate_d4 = Left(Trim(Rs("행사일시4일차")),8)
		sdate_d5 = Left(Trim(Rs("행사일시5일차")),8)
		hangsa_bonbu = Rs("본부")
	End if

	Set Rs = ConnAplus.execute(SQL_S)

	If Rs.EOF Then
		save = ""
	Else		
		save = Rs("승인구분")
	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	type_list = ""

	if rc2 <> 0 then	
		for i=0 to UBound(arrObj2,2)
			catecory	= arrObj2(1,i)
			type_list = type_list & "<option value='"& catecory &"'>"& catecory &"</option>"
		next
	end if

	day_list = "<option value='1일차'>1일차</option>"
	day_list = day_list & "<option value='2일차'>2일차</option>"
	day_list = day_list & "<option value='3일차'>3일차</option>"
	day_list = day_list & "<option value='4일차'>4일차</option>"
	day_list = day_list & "<option value='5일차'>5일차</option>"


	time_list = "<option value='0000'>0000</option>"
	hour_list = ""	

	for i=1 to 24
		if i < 10 then
			time_list = time_list & "<option value='0"& i &"00'>0"& i &"00</option>"
		else
			time_list = time_list & "<option value='"& i &"00'>"& i &"00</option>"
		end if
		hour_list = hour_list & "<option value='"& i &"'>"& i &"</option>"
	next	

%>

<script type="text/javascript" language="javascript" src="/js/reception.js"></script>	
<script language="javascript" type="text/javascript">
	function List() {
		location.href = "calculation_list.asp";
	}
	function HelperList(sValue) {

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			//url: "calculation_helper_list_ajax.asp", //요청을 보낼 서버의 URL
			url: "/reception/reception_helper_list_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue, sType: "" }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)										
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open('도우미');
			}
		});

	}
	function HelperList2(start, sValue) {
		var k = $("input[name=hname]").index(start.closest('td').find('input[name=hname]')[0]);
		
		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/reception/reception_helper_list_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue, sType: k }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open('도우미');
			}
		});

	}
	function HelperList3(sType, sValue) {

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/reception/reception_helper_list_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue, sType: sType }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open('도우미');
			}
		});

	}
	function HelperWrite(sType, sValue) {

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/reception/reception_helper_write_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue, sType: sType }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open('도우미 등록');
			}
		});

	}
	function HelperView(sType, sValue, code, popupCheck) {

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/reception/reception_helper_update_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue, sType: sType, code: code, popup_check_ag: popupCheck}, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open('도우미 수정');
			}
		});

	}
	function HelperInsert(sType, sValue) {

		var frm = document.frm_helper;

		if (!frm.hi_mname.value) {
			alert('도우미명을 입력하세요');
			frm.uname.focus();
			return false;
		}
		if (!frm.hi_mjumin1.value) {
			alert('주민번호를 입력하세요');
			form.jum1.focus();
			return false;
		}
		if (!frm.hi_mjumin2.value) {
			alert('주민번호를 입력하세요');
			form.jum2.focus();
			return false;
		}
		if (!confirm('도우미 등록 하시겠습니까?')) {
			return false;
		}

		var hi_mname = frm.hi_mname.value;
		var hi_mgubun = frm.hi_mgubun.value;
		var hi_mphone = frm.hi_mphone.value;
		var hi_mbank = frm.hi_mbank.value;
		var hi_mbankno = frm.hi_mbankno.value;
		var hi_mbankname = frm.hi_mbankname.value;
		var hi_mjumin1 = frm.hi_mjumin1.value;
		var hi_mjumin2 = frm.hi_mjumin2.value;

		var bankName = frm.bankName.value;
		var bankValid = frm.bankValid.value;
		var hi_memo = frm.hi_memo.value;

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/reception/reception_helper_write_ok_ajax.asp", //요청을 보낼 서버의 URL
			data: { hi_mname: hi_mname, hi_mgubun: hi_mgubun, hi_mphone: hi_mphone, hi_mbank: hi_mbank, hi_mbankno: hi_mbankno, hi_mbankname: hi_mbankname, hi_mjumin1: hi_mjumin1, hi_mjumin2: hi_mjumin2, bankName: bankName, bankValid: bankValid, hi_memo: hi_memo }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				HelperList3(sType, sValue);
			}
		});

	}
	function HelperUpdate(sType, sValue, code) {

		var frm = document.frm_helper;

		if (!frm.hi_mname.value) {
			alert('도우미명을 입력하세요');
			frm.uname.focus();
			return false;
		}
		if (!frm.hi_mjumin1.value) {
			alert('주민번호를 입력하세요');
			form.jum1.focus();
			return false;
		}
		if (!frm.hi_mjumin2.value) {
			alert('주민번호를 입력하세요');
			form.jum2.focus();
			return false;
		}
		if (!confirm('도우미 수정 하시겠습니까?')) {
			return false;
		}
	
		var hi_mname = frm.hi_mname.value;
		var hi_mgubun = frm.hi_mgubun.value;
		var hi_mphone = frm.hi_mphone.value;
		var hi_mbank = frm.hi_mbank.value;
		var hi_mbankno = frm.hi_mbankno.value;
		var hi_mbankname = frm.hi_mbankname.value;
		var hi_mjumin1 = frm.hi_mjumin1.value;
		var hi_mjumin2 = frm.hi_mjumin2.value;
		var hi_memo = frm.hi_memo.value;
		var bankValid = frm.bankValid.value;

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/reception/reception_helper_update_ok_ajax.asp", //요청을 보낼 서버의 URL
			data: { code: code, hi_mname: hi_mname, hi_mgubun: hi_mgubun, hi_mphone: hi_mphone, hi_mbank: hi_mbank, hi_mbankno: hi_mbankno, hi_mbankname: hi_mbankname, bankValid: bankValid, hi_mjumin1: hi_mjumin1, hi_mjumin2: hi_mjumin2, hi_memo: hi_memo }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				HelperList3(sType, sValue);
			}
		});

	}
	function HelperAdd(k, mcode, mname, mtype, mpay) {
		
		if (k == "") {
			add(mcode, mname, mtype, mpay);
		} else {
			$("input[name=mcode]")[k].value = mcode;
			$("span[name=hname_txt]")[k].innerHTML = mname;
			$("input[name=hname]")[k].value = mname;
			$("select[name=htype]")[k].value = mtype;			
			$("input[name=hjobpay]")[k].value = mpay;

			if (mtype == "장례예식사")
			{
				$("select[name=hhour]")[k].value = 3;
			}
			
			var sValue = $("select[name=htype]")[k].value;  // 조문객도우미					
			var jobtime = $("select[name=hhour]")[k].value; // 8
			var jobdate = $("input[name=hdate]")[k].value;	// 20220126					

			$.ajax({
				type: "POST", //데이터 전송타입 (POST,GET)
				cache: false, //캐시 사용여부(true,false)
				url: "/calculation/calculation_helper_workpay_ajax.asp", //요청을 보낼 서버의 URL
				data: { sValue: sValue, sType: k, jobtime: jobtime, jobdate: jobdate }, //서버로 보내지는 데이터
				datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
				success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
					$("#popupLayer").text("");
					$("#popupLayer").html(data);
					//Open('도우미작업수당');
				}
			});

			updateRow(k);
			updateTotal();
		}

		Close();
	}	
	function add(mcode, hname, htype, mpay) {
		var hdate = $("#hdate").val();

		var rowItem = ""

		rowItem = "<tbody>"
		rowItem += "<tr>"
		rowItem += "	<td rowspan='8'>"
		rowItem += "		<span></span><a href='javascript:void(0);' onclick='del(this);' class='btn_ico ico07 ty03'>삭제</a>"
		rowItem += "		<input type='hidden' name='mcode' value='" + mcode + "' />"
		rowItem += "	</td>"
		rowItem += "	<th scope='row'>도우미</th>"
		rowItem += "	<th scope='row'>구분</th>"
		rowItem += "	<th scope='row'>일차</th>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<td>"
		rowItem += "		<a href='javascript:void(0);' name='hname_txt' class='input_dt w70' onclick='HelperView(" + htype + ", " + hname + ", " + mcode +");'>"
		rowItem += "			<span name='hname_txt' class='input_dt w70'>" + hname + "</span>"
		rowItem += "		</a>"
		rowItem += "		<input type='hidden' name='hname' value='" + hname + "' />"
		rowItem += "		<a href='javascript:void(0);' onclick='HelperList2($(this));' class='btn_ico ico01 ty02'>검색</a>"
		rowItem += "	</td>"		
		rowItem += "	<td>"
		rowItem += "		<select name='htype' class='select_ty tc w100' onchange='changehtype(this);'><%=type_list %></select>"
		rowItem += "	</td>"
		rowItem += "	<td>"
		rowItem += "		<select name='hday' class='select_ty tc w100' onchange='changehday(this);'><%=day_list %></select>"
		rowItem += "	</td>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<th scope='row'>시작일</th>"
		rowItem += "	<th scope='row'>시작시간</th>"
		rowItem += "	<th scope='row'>작업시간</th>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<td>"
		rowItem += "		<input type='text' maxlength='8' name='hdate' value='<%=sdate_d %>' class='input_ty w100 tc' readonly />"
		rowItem += "	</td>"
		rowItem += "	<td>"
		rowItem += "		<select name='htime' class='select_ty tc w100'><%=time_list %></select>"
		rowItem += "	</td>"
		rowItem += "	<td>"
		rowItem += "		<select name='hhour' onchange='changeHour(this);' class='select_ty tc w100'><%=hour_list %></select>"
		rowItem += "	</td>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<th scope='row'>단가</th>"
		rowItem += "	<th scope='row'>작업수당</th>"
		rowItem += "	<th scope='row'>시간외수당</th>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<td>"
		rowItem += "		<input type='text' name='hjobpay' onkeyup='changeJobpay(this);' value='" + mpay + "' class='input_ty w100 tc' />"
		rowItem += "	</td>"
		rowItem += "	<td>"
		rowItem += "		<input type='text' name='hworkpay' value='" + mpay + "' class='input_ty w100 tc' readonly />"
		rowItem += "	</td>"
		rowItem += "	<td>"
		rowItem += "		<input type='text' name='hetcpay' onkeyup='changeEtcpay(this);' class='input_ty w100 tc' value='0' />"
		rowItem += "	</td>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<th scope='row'>총액</th>"
		rowItem += "	<th scope='row'>세액</th>"
		rowItem += "	<th scope='row'>지급액</th>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<td>"
		rowItem += "		<input type='text' name='htotalpay' value='0' class='input_ty w100 tc' readonly />"
		rowItem += "	</td>"
		rowItem += "	<td>"
		rowItem += "		<input type='text' name='htex' value='0' class='input_ty w100 tc' readonly />"		
		rowItem += "	</td>"
		rowItem += "	<td>"		
		rowItem += "		<input type='text' name='hpay' value='0' class='input_ty w100 tc' readonly />"
		rowItem += "		<input type='hidden' name='htex2' value='0' readonly />"
		rowItem += "		<input type='hidden' name='htex3' value='0' readonly />"
		rowItem += "	</td>"
		rowItem += "</tr>"
		rowItem += "</tbody>"

		$('#factory_table').append(rowItem);

		var k = $("input[name=hworkpay]").length;
		$("select[name=htype]")[k - 1].value = htype;

		fnSetRowNo();

				
		if (htype == "장례예식사")
		{
			$("select[name=hhour]")[k - 1].value = 3;
		}		
		
		var sValue = $("select[name=htype]")[k - 1].value;  // 조문객도우미					
		var jobtime = $("select[name=hhour]")[k - 1].value; // 8
		var jobdate = $("input[name=hdate]")[k - 1].value;	// 20220126					

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/calculation/calculation_helper_workpay_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue, sType: k - 1, jobtime: jobtime, jobdate: jobdate }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				//Open('도우미작업수당');
			}
		});
		
		//updateRow(k);
		//updateTotal();

		updateRow(k- 1);
		updateTotal();
	}
	function del(tbody) {
		tbody.closest("tbody").remove();
		fnSetRowNo();
		updateTotal();
	}
	function fnSetRowNo() {

		var tbody = $("#factory_table tbody");
		var tbody_cnt = tbody.length; // tbody 태그들의 갯수	

		tbody.each(function (i) {
			var cellItem = $(this).find("span")
			cellItem.eq(0).text(i + 1);
		});

	}

	function save() {
		if (!confirm('저장하시겠습니까?')) {
			return false;
		}
		var input1 = ""
		var input2 = ""
		var input3 = ""
		var input4 = ""
		var input5 = ""
		var input6 = ""
		var input7 = ""
		var input8 = ""
		var input9 = ""
		var input10 = ""
		var input11 = ""
		var input12 = ""
		var input13 = ""
		var input14 = ""
		var input15 = ""
		var input16 = ""
		var input17 = ""
		var no = 0;
		$('#factory_table tbody').each(function () {
			var cellItem = $(this).find(":input")

			if (no == 0) {
				input1 += cellItem.eq(0).val()
				input2 += cellItem.eq(1).val()
				input3 += cellItem.eq(2).val()
				input4 += cellItem.eq(3).val()
				input5 += cellItem.eq(4).val()
				input6 += cellItem.eq(5).val()
				input7 += cellItem.eq(6).val()
				input8 += ClearComma(cellItem.eq(7).val())
				input9 += ClearComma(cellItem.eq(8).val())
				input10 += ClearComma(cellItem.eq(9).val())
				input11 += ClearComma(cellItem.eq(10).val())
				input12 += ClearComma(cellItem.eq(11).val())
				input13 += ClearComma(cellItem.eq(12).val())
				input14 += ClearComma(cellItem.eq(13).val())
				input15 += ClearComma(cellItem.eq(14).val())				
			} else {
				input1 += "," + cellItem.eq(0).val()
				input2 += "," + cellItem.eq(1).val()
				input3 += "," + cellItem.eq(2).val()
				input4 += "," + cellItem.eq(3).val()
				input5 += "," + ClearComma(cellItem.eq(4).val())
				input6 += "," + ClearComma(cellItem.eq(5).val())
				input7 += "," + cellItem.eq(6).val()
				input8 += "," + ClearComma(cellItem.eq(7).val())
				input9 += "," + ClearComma(cellItem.eq(8).val())
				input10 += "," + ClearComma(cellItem.eq(9).val())
				input11 += "," + ClearComma(cellItem.eq(10).val())
				input12 += "," + ClearComma(cellItem.eq(11).val())
				input13 += "," + ClearComma(cellItem.eq(12).val())
				input14 += "," + ClearComma(cellItem.eq(13).val())
				input15 += "," + ClearComma(cellItem.eq(14).val())				
			}

			no += 1
		})

		$('#input_mcode').val(input1);
		$('#input_hname').val(input2);
		$('#input_htype').val(input3);
		$('#input_hday').val(input4);
		$('#input_hdate').val(input5);
		$('#input_htime').val(input6);
		$('#input_hhour').val(input7);
		$('#input_hjobpay').val(input8);
		$('#input_hworkpay').val(input9);
		$('#input_hetcpay').val(input10);
		$('#input_htotalpay').val(input11);
		$('#input_htex').val(input12);
		$('#input_hpay').val(input13);
		$('#input_htex2').val(input14);
		$('#input_htex3').val(input15);

		document.frm.submit();

		//alert("(" + input1 + ")(" + input2 + ")(" + input3 + ")(" + input4 + ")(" + input5 + ")(" + input6 + ")(" + input7 + ")(" + input8 + ")(" + input9 + ")(" + input10 + ")(" + input11 + ")(" + input12 + ")(" + input13 + ")(" + input14 + ")(" + input15 + ")(" + input16 + ")(" + input17 + ")");

	}	

	function save_1() {
		if (!confirm('인력지원 도우미 현황을 가져오기 하시겠습니까?\n\n기존데이터 삭제 후 인력지원 도우미 내용으로 다시 저장됩니다.')) {
			return false;
		}
		document.frm.action = "calculation_helper_2_ok.asp"
		document.frm.submit();
	}	
</script>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->
	<!--#include virtual="/common/lnb.asp"-->

	<div class="top_btns sort03">
	<% if save = "" or IsNull(save) = true then %>
		<% If hangsa_bonbu = "수도권" Or hangsa_bonbu = "외주" Then %>
		<a href="javascript:void(0);" onclick="save_1();" class="btn_ty ty01 btn_b" style="margin-right: 5px;">인력지원 가져오기</a>	
		<% End If %> 
		<a href="javascript:void(0);" onclick="HelperList('');" class="btn_ty ty03 btn_b btn_add">도우미 추가</a>
		<a href="javascript:void(0);" onclick="save();" class="btn_ty ty02 btn_b">저장</a>
	<% end if %>
	</div><!--// top_btns -->

	<form name="frm" method="post" action="calculation_helper_ok.asp">
		<input type="hidden" id="code" name="code" value="<%=code %>" />
		<input type="hidden" id="input_mcode" name="input_mcode" />
		<input type="hidden" id="input_hname" name="input_hname" />
		<input type="hidden" id="input_htype" name="input_htype" />
		<input type="hidden" id="input_hday" name="input_hday" />
		<input type="hidden" id="input_hdate" name="input_hdate" />
		<input type="hidden" id="input_htime" name="input_htime" />
		<input type="hidden" id="input_hhour" name="input_hhour" />
		<input type="hidden" id="input_hjobpay" name="input_hjobpay" />
		<input type="hidden" id="input_hworkpay" name="input_hworkpay" />
		<input type="hidden" id="input_hetcpay" name="input_hetcpay" />
		<input type="hidden" id="input_htotalpay" name="input_htotalpay" />
		<input type="hidden" id="input_htex" name="input_htex" />
		<input type="hidden" id="input_hpay" name="input_hpay" />
		<input type="hidden" id="input_htex2" name="input_htex2" />
		<input type="hidden" id="input_htex3" name="input_htex3" />		
	</form>

	<div id="prt">

		<table class="list_ty total_list">
			<caption>도우미 Total</caption>
			<colgroup><col span="5" style="width:*%;"></colgroup>
			<thead>
				<tr>
					<th scope="col">작업수당</th>
					<th scope="col">시간외수당</th>
					<th scope="col">총액</th>
					<th scope="col">세액</th>
					<th scope="col">지급액</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><span id="t_workpay"></span></td>
					<td><span id="t_etcpay"></span></td>
					<td><span id="t_totalpay"></td>
					<td><span id="t_tex"></span></td>
					<td><span id="t_pay"></span></td>
				</tr>
			</tbody>
		</table><!--// total_list -->

		<table id="factory_table" class="form_ty hori">
			<caption>정산-도우미</caption>
			<colgroup>
				<col span="1" class="verti_w03"><col span="3" style="width:*%;">
			</colgroup>
<%
	t_workpay = 0
	t_etcpay = 0
	t_totalpay = 0
	t_tex = 0
	t_pay = 0

	if rc = 0 then 
	else
		for i=0 to UBound(arrObj,2)
			mcode		= arrObj(0,i)
			hname		= arrObj(1,i)
			htype		= arrObj(2,i)
			hday		= arrObj(3,i)
			hdate		= arrObj(4,i)
			htime		= arrObj(5,i)
			hhour		= arrObj(6,i)			
			hjobpay		= FormatNumber(arrObj(7,i),0)
			hworkpay	= FormatNumber(arrObj(8,i),0)
			hetcpay		= FormatNumber(arrObj(9,i),0)
			htotalpay	= FormatNumber(arrObj(10,i),0)
			htex		= FormatNumber(arrObj(11,i),0)
			hpay		= FormatNumber(arrObj(12,i),0)
			htex2		= arrObj(13,i)
			htex3		= arrObj(14,i)

			t_workpay = t_workpay + arrObj(8,i)
			t_etcpay = t_etcpay + arrObj(9,i)
			t_totalpay = t_totalpay + arrObj(10,i)
			t_tex = t_tex + arrObj(11,i)
			t_pay = t_pay + arrObj(12,i)
%>
			<tbody>
				<tr>
					<td rowspan="8">
						<span><%=i+1 %></span>
						<% if save = "" or IsNull(save) = true then %>
							<a href="javascript:void(0);" onclick="del(this);" class="btn_ico ico07 ty03">삭제</a>
						<% End If %>
						<input type="hidden" name="mcode" value="<%=mcode %>" />
					</td>
					<th scope="row">도우미</th>
					<th scope="row">구분</th>
					<th scope="row">일차</th>
				</tr>
				<tr>
					<td>
						<a href="javascript:void(0);" name="hname_txt" class="input_dt w70" onclick="HelperView('<%=htype %>', '<%=hname %>', '<%=mcode %>', 'true');">
							<%=hname %>
						</a>
						<input type="hidden" value="<%=hname %>" name="hname" />
						<a href="javascript:void(0);" onclick="HelperList2($(this));" class="btn_ico ico01 ty02">검색</a>
					</td>
					<td>
						<select id="type_<%=i %>" name="htype" onchange="changehtype(this);" class="select_ty tc w100"><%=type_list %></select>
						<script>
							document.getElementById("type_<%=i %>").value = "<%=htype %>";
						</script>		
					</td>
					<td>
						<select id="day_<%=i %>" name="hday" onchange="changehday(this);" class="select_ty tc w100"><%=day_list %></select>						
					</td>
				</tr>
				<tr>
					<th scope="row">시작일</th>
					<th scope="row">시작시간</th>
					<th scope="row">작업시간</th>
				</tr>
				<tr>
					<td><input type="text" class="input_ty w100 tc" name="hdate" value="<%=hdate %>" readonly="readonly"></td>
					<td>
						<select id="time_<%=i %>" name="htime" class="select_ty tc w100"><%=time_list %></select>
						<script>
							document.getElementById("time_<%=i %>").value = "<%=htime %>";
						</script>
					</td>
					<td>
						<select id="hour_<%=i %>" name="hhour" onchange="changeHour(this);" class="select_ty tc w100"><%=hour_list %></select>
						<script>
							document.getElementById("hour_<%=i %>").value = "<%=hhour %>";
						</script>
					</td>
				</tr>
				<tr>
					<th scope="row">단가</th>
					<th scope="row">작업수당</th>
					<th scope="row">시간외수당</th>
				</tr>
				<tr>
					<td>				
						<input type="text" name="hjobpay" onkeyup="changeJobpay(this)" value="<%=hjobpay %>" class="input_ty w100 tc" />
					</td>
					<td>
						<input type="text" name="hworkpay" value="<%=hworkpay %>" class="input_ty w100 tc" readonly />					
					</td>
					<td>
						<input type="text" name="hetcpay" onkeyup="changeEtcpay(this);" value="<%=hetcpay %>" class="input_ty w100 tc" />
					</td>
				</tr>
				<tr>
					<th scope="row">총액</th>
					<th scope="row">세액</th>
					<th scope="row">지급액</th>
				</tr>
				<tr>
					<td>
						<!--span name="htotalpay_txt" class="input_dt w100"><%=htotalpay %></span>
						<input type="hidden" name="htotalpay" value="<%=htotalpay %>" /-->
						<input type="text" name="htotalpay" class="input_ty w100 tc" value="<%=htotalpay %>" readonly />
					</td>
					<td>
						<!--span name="htex_txt" class="input_dt w100"><%=htex %></span>
						<input type="hidden" name="htex" value="<%=htex %>" /-->
						<input type="text" name="htex" class="input_ty w100 tc" value="<%=htex %>" readonly />
					</td>
					<td>
						<!--span name="hpay_txt" class="input_dt w100"><%=hpay %></span>
						<input type="hidden" name="hpay" value="<%=hpay %>" readonly /-->
						<input type="text" name="hpay" class="input_ty w100 tc" value="<%=hpay %>" readonly />
						<input type="hidden" name="htex2" value="<%=htex2 %>" />
						<input type="hidden" name="htex3" value="<%=htex3 %>" />
					</td>
				</tr>
			</tbody>
			<script>
				document.getElementById("day_<%=i %>").value = "<%=hday %>";
			</script>
<%
		next
	end if 
%>
		</table><!--// form_ty -->

	</div>

	<div class="btm_btns sort03">
		<a href="javascript:void(0);" onclick="PrintDiv();" class="btn_ty ty05 btn_print btn_b">출력</a>		
	</div><!--// btm_btns -->

	<!--#include virtual="/common/layer_popup.asp"-->
	<!--#include virtual="/common/second_layer_popup.asp"-->
</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->

<script type="text/javascript">
	$('#t_workpay').html('<%=FormatNumber(t_workpay,0) %>');
	$('#t_etcpay').html('<%=FormatNumber(t_etcpay,0) %>');
	$('#t_totalpay').html('<%=FormatNumber(t_totalpay,0) %>');
	$('#t_tex').html('<%=FormatNumber(t_tex,0) %>');
	$('#t_pay').html('<%=FormatNumber(t_pay,0) %>');

	//도우미 구분 변경시	
	function changehtype(start) {
		var k = $("select[name=htype]").index(start);
		//alert($("select[name=hday]")[k].value)
		
		if ($("select[name=htype]")[k].value == "장례예식사")
		{
			$("select[name=hhour]")[k].value = 3;
		}

		var sValue = $("select[name=htype]")[k].value;  // 조문객도우미
		var jobtime = $("select[name=hhour]")[k].value; // 8
		var jobdate = $("input[name=hdate]")[k].value;	// 20220126					

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/calculation/calculation_helper_workpay_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue, sType: k, jobtime: jobtime, jobdate: jobdate }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				//Open('도우미작업수당');
				//alert(sValue);
				//alert(jobtime);
				//alert(jobdate);

			}
		});
	}

	//일차 변경시
	function changehday(start) {
		var k = $("select[name=hday]").index(start);
		//alert($("select[name=hday]")[k].value)

		if ($("select[name=hday]")[k].value == "1일차") {
			$("input[name=hdate]")[k].value = "<%=sdate_d %>";
		} else if ($("select[name=hday]")[k].value == "2일차") {
			$("input[name=hdate]")[k].value = "<%=sdate_d2 %>";
		} else if ($("select[name=hday]")[k].value == "3일차") {
			$("input[name=hdate]")[k].value = "<%=sdate_d3 %>";
		} else if ($("select[name=hday]")[k].value == "4일차") {
			$("input[name=hdate]")[k].value = "<%=sdate_d4 %>";
		} else if ($("select[name=hday]")[k].value == "5일차") {
			$("input[name=hdate]")[k].value = "<%=sdate_d5 %>";
		}	
		
		var sValue = $("select[name=htype]")[k].value;  // 조문객도우미
		var jobtime = $("select[name=hhour]")[k].value; // 8
		var jobdate = $("input[name=hdate]")[k].value;	// 20220126					

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/calculation/calculation_helper_workpay_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue, sType: k, jobtime: jobtime, jobdate: jobdate }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				//Open('도우미작업수당');
				//alert(sValue);
				//alert(jobtime);
				//alert(jobdate);

			}
		});
	}

	function HelperWorkpay(k, workpay) {			
		//alert(workpay);
		$("input[name=hworkpay]")[k].value = comma(workpay);
		
		updateRow(k);
		updateTotal();
	}

	//작업시간 변경시
	function changeHour(start) {
		var k = $("select[name=hhour]").index(start);

		var sValue = $("select[name=htype]")[k].value;  // 조문객도우미
		var jobtime = $("select[name=hhour]")[k].value; // 8
		var jobdate = $("input[name=hdate]")[k].value;	// 20220126					

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/calculation/calculation_helper_workpay_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue, sType: k, jobtime: jobtime, jobdate: jobdate }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				//Open('도우미작업수당');
				//alert(sValue);
				//alert(jobtime);
				//alert(jobdate);

			}
		});

		updateRow(k);
		updateTotal();
	}
	//단가 변경시
	function changeJobpay(start) {
		var k = $("input[name=hjobpay]").index(start);
		$("input[name=hjobpay]")[k].value = comma(parseInt(ClearComma(start.value)));

		updateRow(k);
		updateTotal();
	}
	//시간외수당 변경시
	function changeEtcpay(start) {
		var k = $("input[name=hetcpay]").index(start);
		$("input[name=hetcpay]")[k].value = comma(start.value);

		updateRow(k);
		updateTotal();
	}
	function updateRow(k) {
		// 작업수당
		//var sum1 = parseInt(ClearComma($("select[name=hhour]")[k].value)) * parseInt(ClearComma($("input[name=hjobpay]")[k].value));
		//$("input[name=hworkpay]")[k].value = comma(sum1);

		var sum1 = parseInt(ClearComma($("input[name=hworkpay]")[k].value));
		// 총액		
		$("input[name=htotalpay]")[k].value = comma(sum1 + parseInt(ClearComma($("input[name=hetcpay]")[k].value)));
		//$("span[name=htotalpay_txt]")[k].innerHTML = comma(sum1 + parseInt(ClearComma($("input[name=hetcpay]")[k].value)));
		// 소득세
		var tax_sum = parseInt(parseInt(sum1 + parseInt(ClearComma($("input[name=hetcpay]")[k].value))) * 0.03 / 10) * 10;
		$("input[name=htex2]")[k].value = parseInt(tax_sum);
		// 주민세
		var tax_sum2 = parseInt(parseInt(sum1 + parseInt(ClearComma($("input[name=hetcpay]")[k].value))) * 0.003 / 10) * 10;
		$("input[name=htex3]")[k].value = parseInt(tax_sum2);
		// 소득세 + 주민세
		//document.form.c_32[k].value = tax_sum + tax_sum2;
		// 세액
		$("input[name=htex]")[k].value = comma(tax_sum + tax_sum2);
		//$("span[name=htex_txt]")[k].innerHTML = comma(tax_sum + tax_sum2);
		// 지급액
		$("input[name=hpay]")[k].value = comma(sum1 + parseInt(ClearComma($("input[name=hetcpay]")[k].value)) - parseInt(ClearComma($("input[name=htex]")[k].value)));
		//$("span[name=hpay_txt]")[k].innerHTML = comma(sum1 + parseInt(ClearComma($("input[name=hetcpay]")[k].value)) - parseInt(ClearComma($("input[name=htex]")[k].value)));
	}
	function updateTotal() {
		// 작업수당
		var t_workpay = 0;
		$('input[name=hworkpay]').each(function () {
			t_workpay += parseInt(ClearComma($(this).val()));
		});
		$('#t_workpay').html(comma(t_workpay));
		// 시간외수당
		var t_etcpay = 0;
		$('input[name=hetcpay]').each(function () {
			t_etcpay += parseInt(ClearComma($(this).val()));
		});
		$('#t_etcpay').html(comma(t_etcpay));
		// 총액
		var t_totalpay = 0;
		$('input[name=htotalpay]').each(function () {
			t_totalpay += parseInt(ClearComma($(this).val()));
		});
		$('#t_totalpay').html(comma(t_totalpay));
		// 세액
		var t_tex = 0;
		$('input[name=htex]').each(function () {
			t_tex += parseInt(ClearComma($(this).val()));
		});
		$('#t_tex').html(comma(t_tex));
		// 지급액
		var t_pay = 0;
		$('input[name=hpay]').each(function () {
			t_pay += parseInt(ClearComma($(this).val()));
		});
		$('#t_pay').html(comma(t_pay));
	}

	var printDiv;
	var initBody;

	function PrintDiv() {
		printDiv = document.getElementById("prt");

		window.onbeforeprint = beforePrint;
		window.onafterprint = afterPrint;

		window.print();
	}
	function beforePrint() {
		initBody = document.body.innerHTML;
		document.body.innerHTML = printDiv.innerHTML;
	}
	function afterPrint() {
		location.reload();
		//document.body.innerHTML = initBody;
	}
</script>