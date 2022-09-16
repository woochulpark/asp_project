<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->
<!--#include virtual="/reception/reception_timjang_check.asp"-->
<%
	menu = "접수"
	menu_sub = "회사지원입력"
	lnbtype = "N" '배송여부
	lnbd = "class='on'"	
	top_btn_save = "Y"

	code = Trim(request("Code"))
	
	if code = "" then 
		response.End
	end if

	SQL = "select 행사번호, 사원코드, 사원명, convert(varchar(10), 접수일, 120) as 접수일, 일차, 출동일시, 종료일시 "
	SQL = SQL & " from 행사_회사지원 "	
	SQL = SQL & " where 행사번호 = '" & code & "' "	
	SQL = SQL & " order by 순번 asc "

	SQL2 = "select convert(varchar(10),dateadd(d,0,left(a.행사시작일시,8)),120) as 행사시작일, isnull(b.본부, '') as 본부 "
	SQL2 = SQL2 & " , convert(varchar(10),dateadd(d,0,left(a.행사시작일시,8)),120) as 행사시작일_1 "
	SQL2 = SQL2 & " , convert(varchar(10),dateadd(d,1,left(a.행사시작일시,8)),120) as 행사시작일_2 "
	SQL2 = SQL2 & " , convert(varchar(10),dateadd(d,2,left(a.행사시작일시,8)),120) as 행사시작일_3 "
	SQL2 = SQL2 & " , convert(varchar(10),dateadd(d,3,left(a.행사시작일시,8)),120) as 행사시작일_4 "
	SQL2 = SQL2 & " , convert(varchar(10),dateadd(d,4,left(a.행사시작일시,8)),120) as 행사시작일_5 "	
	SQL2 = SQL2 & " from 행사마스터 a left outer join 행사의전팀장 b on a.진행팀장 = b.코드 "
	SQL2 = SQL2 & " where a.행사번호 = '" & code & "' "	

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ
		
	Set Rs = ConnAplus.execute(SQL)

	If Rs.EOF Then
		rc = 0
	Else
		rc = Rs.RecordCount
		arrObj = Rs.GetRows(rc)
	End If

	Set Rs = ConnAplus.execute(SQL2)

	If Rs.EOF Then
		bonbu = ""
	Else		
		sdate = Rs("행사시작일")
		bonbu = Rs("본부")
		sdate_1 = Rs("행사시작일_1")
		sdate_2 = Rs("행사시작일_2")
		sdate_3 = Rs("행사시작일_3")
		sdate_4 = Rs("행사시작일_4")
		sdate_5 = Rs("행사시작일_5")
	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	op_min = "<option value='00'>00</option>"
    op_min_5 = "<option value='00'>00</option>"
	op_hour = "<option value='00'>00</option>"

	for i=1 to 59
		if i < 10 then
			op_min = op_min & "<option value='0"& i &"'>0"& i &"</option>"
		else
			op_min = op_min & "<option value='"& i &"'>"& i &"</option>"
		end if
	next

    for i=1 to 11
		k = i * 5
		if k < 10 then
			op_min_5 = op_min_5 & "<option value='0"& k &"'>0"& k &"</option>"
		else
			op_min_5 = op_min_5 & "<option value='"& k &"'>"& k &"</option>"
		end if
	next

	for i=1 to 23
		if i < 10 then
			op_hour = op_hour & "<option value='0"& i &"'>0"& i &"</option>"
		else
			op_hour = op_hour & "<option value='"& i &"'>"& i &"</option>"
		end if
	next
		
	if input21 = "" then
		input21_1 = ""
		input21_2 = "00"
		input21_3 = "00"
	else
		input21_1 = Split(input21, " ")(0)
		input21_2 = left(Split(input21, " ")(1), 2)
		input21_3 = mid(Split(input21, " ")(1), 4, 2)
	end if		
%>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->
	<!--#include virtual="/common/lnb.asp"-->
	<!--#include virtual="/common/top_btns.asp"-->

	<form name="frm" method="post" action="reception_support_ok.asp">
	<input type="hidden" id="code" name="code" value="<%=code %>" />
	<input type="hidden" id="input2" name="input2" />
	<input type="hidden" id="input3" name="input3" />
	<input type="hidden" id="input4" name="input4" />
	<input type="hidden" id="input5" name="input5" />
	<input type="hidden" id="input6" name="input6" />
	<input type="hidden" id="input7" name="input7" />
	<input type="hidden" id="input8" name="input8" />
	<input type="hidden" id="input9" name="input9" />

	<p class="sub_tit">인력지원</p>

	<table id="factory_table" class="form_ty hori">
		<caption>접수-배송외-회사지원입력-인력지원</caption>
		<colgroup>
			<col span="1" class="verti_w03"><col span="1" style="width:*%;"><col span="4" class="verti_w04">
		</colgroup>
		<thead>
			<tr>
				<th scope="col" rowspan="2">선택</th>
				<th scope="col" rowspan="2">이름</th>
				<th scope="col" colspan="2">일자</th>
				<th scope="col" colspan="2">일차</th>
			</tr>
			<tr>
				<th scope="col" colspan="2">출동일시</th>
				<th scope="col" colspan="2">종료일시</th>
			</tr>
		</thead>

<%
	if rc = 0 then 
		if bonbu = "수도권" or bonbu = "외주" then
			'response.Write "<script>rowadd();rowadd();</script>"
		else
			'response.Write "<script>rowadd2();rowadd2();</script>"
		end if
	else
		for i=0 to UBound(arrObj,2)			
			input1	= arrObj(1,i)
			input2	= arrObj(2,i)
			input3	= arrObj(3,i)
			input4	= arrObj(4,i)
			input5	= arrObj(5,i)
			input6	= arrObj(6,i)

			input5_1 = Split(input5, ":")(0)
			input5_2 = Split(input5, ":")(1)
			input6_1 = Split(input6, ":")(0)
			input6_2 = Split(input6, ":")(1)
%>
		<tbody>
			<tr>
				<td rowspan="2">
					<p class="checks al"><span>
						<input type="checkbox" id="p1_<%=i %>" name="p1" onchange="CheckDel();">
						<label for="p1_<%=i %>">선택</label>
					</span></p>
				</td>				
				<td rowspan="2">
					<input type="hidden" name="p2" value="<%=input1 %>" />					
				<% if bonbu = "수도권" or bonbu = "외주" then %>
					<input type="hidden" name="p3" value="<%=input2 %>" />
					<span name="p3_txt" class="input_dt w70"><%=input2 %></span>					
					<a href="javascript:void(0);" onclick='HelperList($(this));' class="btn_ico ty02 ico01">검색</a>
				<% else %>					
					<input type='text' name='p3' value="<%=input2 %>" class='input_ty w100' placeholder='이름' />
				<% end if %>
				</td>
				<td colspan="2"><input type="text" name="p4" value="<%=input3 %>" class="datepicker input_ty start-date w100" placeholder="" readonly /></td>
				<td colspan="2">
					<select name="p5" id="p5_<%=i %>" class="select_ty w100" onchange='ch_date($(this), this.value);'>
						<option value="1">1</option>
						<option value="2">2</option>
						<option value="3">3</option>
						<option value="4">4</option>
						<option value="5">5</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>
					<select name="p6" id="p6_<%=i %>" class="select_ty w100" onchange='ch_stime($(this), this.value);'><%=op_hour %></select>
				</td>
				<td>
					<select name="p7" id="p7_<%=i %>" class="select_ty w100"><%=op_min_5 %></select>
				</td>
				<td>
					<select name="p8" id="p8_<%=i %>" class="select_ty w100" onchange='ch_etime($(this), this.value);'><%=op_hour %></select>
				</td>
				<td>
					<select name="p9" id="p9_<%=i %>" class="select_ty w100"><%=op_min_5 %></select>
				</td>
			</tr>			
		</tbody>
		<script>
			document.getElementById("p5_<%=i %>").value = "<%=input4 %>";
			document.getElementById("p6_<%=i %>").value = "<%=input5_1 %>";
			document.getElementById("p7_<%=i %>").value = "<%=input5_2 %>";
			document.getElementById("p8_<%=i %>").value = "<%=input6_1 %>";
			document.getElementById("p9_<%=i %>").value = "<%=input6_2 %>";
		</script>
<%
		next
	end if 
%>

	</table><!--// form_ty -->

	<dl class="add_cate">
		<dt><a href="javascript:void(0);" id="delBtn" onclick="Del();" class="btn_ty btn_b ty04 btn_del">삭제</a></dt><!--// a에 클래스 on추가하면 선택됨 -->
		<dd>
			<input type="text" id="p10" name="p10" onkeyup="chkInteger(this);" class="input_ty w50" placeholder="인원수(명)">
		<% if bonbu = "수도권" or bonbu = "외주" then %>
			<a href="javascript:void(0);" onclick="add('a');" class="btn_ty btn_b ty03 btn_add">추가</a>
		<% else %>
			<a href="javascript:void(0);" onclick="add('b');" class="btn_ty btn_b ty03 btn_add">추가</a>
		<% end if %>
			
		</dd>
	</dl><!--// add_cate -->


	<table class="form_ty">
		<caption>접수-배송외-회사지원입력-인력지원-첨부파일</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="1" style="width:*%;">
		</colgroup>

			<tr>
				<th scope="row">첨부파일<a href="javascript:void(0);" onclick="FileUpload('행사', '<%=menu_sub %>', '<%=code %>');" class="btn_ico ico05">첨부파일</a></th>
				<td><div id="img_list"></div></td>
			</tr>
	</table>

	</form>

	<!--#include virtual="/common/layer_popup.asp"-->
	
	<!--// 사진첨부 : 추후진행-->

</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->

<script type="text/javascript" language="javascript" src="/js/reception.js"></script>
<script language="javascript" type="text/javascript">
	function ImgList(b_type1, b_type2, b_idx) {
		
		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/file/img_list.asp", //요청을 보낼 서버의 URL
			data: { b_type1: b_type1, b_type2: b_type2, b_idx: b_idx }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)			
				$("#img_list").text("");
				$("#img_list").html(data);
			}
		});

	}
	ImgList('행사', '<%=menu_sub %>', '<%=code %>');
	function FileUpload(b_type1, b_type2, b_idx) {		
		
		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/file/upload.asp", //요청을 보낼 서버의 URL
			data: { b_type1: b_type1, b_type2: b_type2, b_idx: b_idx }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open('사진첨부');
			}
		});

	}
	function HelperList(start, sValue) {
		var k = $("input[name=p2]").index(start.closest('td').find('input[name=p2]')[0]);
		
		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "reception_helper_list_ajax.asp", //요청을 보낼 서버의 URL
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
			url: "reception_helper_list_ajax.asp", //요청을 보낼 서버의 URL
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
			url: "reception_helper_write_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue, sType: sType }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open('도우미 등록');
			}
		});

	}
	function HelperView(sType, sValue, code) {

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "reception_helper_update_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue, sType: sType, code: code }, //서버로 보내지는 데이터
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

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "reception_helper_write_ok_ajax.asp", //요청을 보낼 서버의 URL
			data: { hi_mname: hi_mname, hi_mgubun: hi_mgubun, hi_mphone: hi_mphone, hi_mbank: hi_mbank, hi_mbankno: hi_mbankno, hi_mbankname: hi_mbankname, hi_mjumin1: hi_mjumin1, hi_mjumin2: hi_mjumin2 }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				HelperList3(sType, sValue);
			}
		});

	}
	function HelperUpdate(sType, sValue, code) {

		var frm = document.frm_helper;

		if (!frm.hi_mname.value) {
			alert('이름을 입력하세요');
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
		if (!confirm('수정 하시겠습니까?')) {
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

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "reception_helper_update_ok_ajax.asp", //요청을 보낼 서버의 URL
			data: { code: code, hi_mname: hi_mname, hi_mgubun: hi_mgubun, hi_mphone: hi_mphone, hi_mbank: hi_mbank, hi_mbankno: hi_mbankno, hi_mbankname: hi_mbankname, hi_mjumin1: hi_mjumin1, hi_mjumin2: hi_mjumin2 }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				HelperList3(sType, sValue);
			}
		});
	}
	function HelperAdd(k, mcode, mname) {

		$("input[name=p2]")[k].value = mcode;
		$("input[name=p3]")[k].value = mname;
		$("span[name=p3_txt]")[k].innerHTML = mname;

		Close();
	}
	function CheckDel() {
		var value = "";
		if ($("input[type='checkbox']").filter(':checked').length > 0) {
			$("#delBtn").addClass("on");			
		} else {
			$("#delBtn").removeClass("on");
		}
		
	}
	function ch_date(start, sValue) {
		var k = $("select[name=p5]").index(start.closest('td').find('select[name=p5]')[0]);
		//alert(k);
		
		if (sValue == "1")
		{
			$("input[name=p4]")[k].value = "<%=sdate_1%>";
		}
		if (sValue == "2")
		{
			$("input[name=p4]")[k].value = "<%=sdate_2%>";
		}
		if (sValue == "3")
		{
			$("input[name=p4]")[k].value = "<%=sdate_3%>";
		}
		if (sValue == "4")
		{
			$("input[name=p4]")[k].value = "<%=sdate_4%>";
		}
		if (sValue == "5")
		{
			$("input[name=p4]")[k].value = "<%=sdate_5%>";
		}	
		
	}

	function ch_stime(start, sValue) {
		var k = $("select[name=p6]").index(start.closest('td').find('select[name=p6]')[0]);
		//alert(k);		
				
		etime = parseInt(sValue) + 10;	
		
		if (etime >= 23)
		{			
			//alert('종료일시가 시작일시보다 작을순 없습니다.');
			etime = 23;			
		}

		$("select[name=p8]")[k].value = etime; 	
		
	}

	function ch_etime(start, sValue) {
		
		var k = $("select[name=p8]").index(start.closest('td').find('select[name=p8]')[0]);
		//alert(k);		
		
		stime = $("select[name=p6]")[k].value;
		
		etime = sValue; 
		
		if ( stime > etime )
		{
			//if ( etime + 24 - stime > 10  )
			//{
			//	alert('1일 근무시간 10시간을 초과할 수 없습니다. 10시간으로 조정됩니다.');	
			//	etime = parseInt(stime) + 10 - 24;				
			//}
			
		}	
		
		if (etime - stime > 10)
		{
			//alert('1일 근무시간 10시간을 초과할 수 없습니다. 10시간으로 조정됩니다.');
			//etime = parseInt(stime) + 10;					
		}
		
		if (etime < 10)
		{			
			etime = '0' + etime;
		}

		$("select[name=p8]")[k].value = etime; 		
		
	}		
	
	function Save() {
		var k = 0;
		var input1 = ""
		var input2 = ""
		var input3 = ""
		var input4 = ""
		var input5 = ""
		var input6 = ""
		var input7 = ""
		var input8 = ""

		$("#factory_table input[name='p1']").each(function () {

			if ($("#factory_table input[name=p3]")[k].value == "") {
				alert('도우미명이 입력되지 않았습니다.');
				return false;
			}

			if (k == 0) {
				input1 += $("#factory_table input[name=p2]")[k].value
				input2 += $("#factory_table input[name=p3]")[k].value
				input3 += $("#factory_table input[name=p4]")[k].value
				input4 += $("#factory_table select[name=p5]")[k].value
				input5 += $("#factory_table select[name=p6]")[k].value
				input6 += $("#factory_table select[name=p7]")[k].value
				input7 += $("#factory_table select[name=p8]")[k].value
				input8 += $("#factory_table select[name=p9]")[k].value
			} else {
				input1 += "," + $("#factory_table input[name=p2]")[k].value
				input2 += "," + $("#factory_table input[name=p3]")[k].value
				input3 += "," + $("#factory_table input[name=p4]")[k].value
				input4 += "," + $("#factory_table select[name=p5]")[k].value
				input5 += "," + $("#factory_table select[name=p6]")[k].value
				input6 += "," + $("#factory_table select[name=p7]")[k].value
				input7 += "," + $("#factory_table select[name=p8]")[k].value
				input8 += "," + $("#factory_table select[name=p9]")[k].value
			}

			k += 1
		})
		if (k == 0) {
			if(!confirm("저장하시겠습니까?")){
				return false;
			}
			document.frm.submit();
			return false;
		}
		if ($("#factory_table input[name='p1']").length != k) {
			return false;
		}

		$('#input2').val(input1);
		$('#input3').val(input2);
		$('#input4').val(input3);
		$('#input5').val(input4);
		$('#input6').val(input5);
		$('#input7').val(input6);
		$('#input8').val(input7);
		$('#input9').val(input8);

		//alert("(" + input1 + ")(" + input2 + ")(" + input3 + ")(" + input4 + ")(" + input5 + ")(" + input6 + ")(" + input7 + ")(" + input8 + ")");
		
		if(!confirm("저장하시겠습니까?")){
			return false;
		}
		document.frm.submit();
	}
	function Del() {
		$("#factory_table input[type='checkbox']").filter(':checked').each(function () {
			$(this).closest("tbody").remove();
			CheckDel();
		});
	}
	function add(type) {
		var cnt = parseInt($("#p10").val());

		for (i = 0; i < cnt; i++) {
			if (type == "a") {
				rowadd();
			} else {
				rowadd2();
			}

		}
		$("#p10").val("");
	}
	var idcnt = 0;
	function rowadd() {

		var rowItem = ""

		rowItem = "<tbody>"
		rowItem += "<tr>"
		rowItem += "	<td rowspan='2'>"
		rowItem += "		<p class='checks al'><span>"
		rowItem += "			<input type='checkbox' id='p1_1_" + idcnt + "' name='p1' onchange='CheckDel();'>"
		rowItem += "			<label for='p1_1_" + idcnt + "'>선택</label>"
		rowItem += "		</span></p>"
		rowItem += "	</td>"
		rowItem += "	<td rowspan='2'>"
		rowItem += "		<input type='hidden' name='p2' />"
		rowItem += "		<input type='hidden' name='p3' />"
		rowItem += "		<span name='p3_txt' class='input_dt w70'></span>"
		rowItem += "		<a href='javascript:void(0);' onclick='HelperList($(this));' class='btn_ico ty02 ico01'>검색</a>"
		rowItem += "	</td>"
		rowItem += "	<td colspan='2'><input type='text' name='p4' value='<%=sdate %>' class='datepicker start-date input_ty w100' placeholder='' readonly /></td>"
		rowItem += "	<td colspan='2'>"
		rowItem += "		<select name='p5' class='select_ty w100' onchange='ch_date($(this), this.value);'>"
		rowItem += "			<option value='1'>1</option>"
		rowItem += "			<option value='2'>2</option>"
		rowItem += "			<option value='3'>3</option>"
		rowItem += "			<option value='4'>4</option>"
		rowItem += "			<option value='5'>5</option>"
		rowItem += "		</select>"
		rowItem += "	</td>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<td>"
		rowItem += "		<select name='p6' class='select_ty w100' onchange='ch_stime($(this), this.value);'><%=op_hour %></select>"
		rowItem += "	</td>"
		rowItem += "	<td>"
		rowItem += "		<select name='p7' class='select_ty w100'><%=op_min_5 %></select>"
		rowItem += "	</td>"
		rowItem += "	<td>"
		rowItem += "		<select name='p8' class='select_ty w100' onchange='ch_etime($(this), this.value);'><%=op_hour %></select>"
		rowItem += "	</td>"
		rowItem += "	<td>"
		rowItem += "		<select name='p9' class='select_ty w100'><%=op_min_5 %></select>"
		rowItem += "	</td>"
		rowItem += "</tr>"
		rowItem += "</tbody>"

		$('#factory_table').append(rowItem);

		$("input[name='p4']").datepicker({
			autoHide: true,
		});	

		idcnt += 1;

	}
	function rowadd2() {

		var rowItem = ""

		rowItem = "<tbody>"
		rowItem += "<tr>"
		rowItem += "	<td rowspan='2'>"
		rowItem += "		<p class='checks al'><span>"
		rowItem += "			<input type='checkbox' id='p1_1_" + idcnt + "' name='p1' onchange='CheckDel();'>"
		rowItem += "			<label for='p1_1_" + idcnt + "'>선택</label>"
		rowItem += "		</span></p>"
		rowItem += "	</td>"
		rowItem += "	<td rowspan='2'>"
		rowItem += "		<input type='hidden' name='p2' />"
		rowItem += "		<input type='text' name='p3' class='input_ty w100' placeholder='이름' />"
		rowItem += "	</td>"
		rowItem += "	<td colspan='2'><input type='text' name='p4' value='<%=sdate %>' class='datepicker start-date input_ty w100' placeholder='' readonly /></td>"
		rowItem += "	<td colspan='2'>"
		rowItem += "		<select name='p5' class='select_ty w100' onchange='ch_date($(this), this.value);'>"
		rowItem += "			<option value='1'>1</option>"
		rowItem += "			<option value='2'>2</option>"
		rowItem += "			<option value='3'>3</option>"
		rowItem += "			<option value='4'>4</option>"
		rowItem += "			<option value='5'>5</option>"
		rowItem += "		</select>"
		rowItem += "	</td>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<td>"
		rowItem += "		<select name='p6' class='select_ty w100' onchange='ch_stime($(this), this.value);'><%=op_hour %></select>"
		rowItem += "	</td>"
		rowItem += "	<td>"
		rowItem += "		<select name='p7' class='select_ty w100'><%=op_min %></select>"
		rowItem += "	</td>"
		rowItem += "	<td>"
		rowItem += "		<select name='p8' class='select_ty w100' onchange='ch_etime($(this), this.value);'><%=op_hour %></select>"
		rowItem += "	</td>"
		rowItem += "	<td>"
		rowItem += "		<select name='p9' class='select_ty w100'><%=op_min %></select>"
		rowItem += "	</td>"
		rowItem += "</tr>"
		rowItem += "</tbody>"

		$('#factory_table').append(rowItem);

		$("input[name='p4']").datepicker();

		idcnt += 1;
	}
	
</script>
