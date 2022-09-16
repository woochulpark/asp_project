<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->
<!--#include virtual="/reception/reception_timjang_check.asp"-->
<%
	menu = "접수"
	lnbtype = "N" '배송여부
	lnbb = "class='on'"	
	top_btn_save = "Y"

	code = Trim(request("Code"))
	
	if code = "" then 
		response.End
	end if

	SQL = "select 행사번호, isnull(convert(varchar(16),빈소도착,120),'') as 빈소도착, isnull(convert(varchar(16),별세일시,120),'') as 별세일시, 고인명, 고인성별, 고인연령, 사망사유, 장례형태, 장례진행종교, 장례식장코드, "
	SQL = SQL & " 장례식장명, 호실, [1차장지], [1차장지코드], [2차장지], 버스사용여부, 버스장지, 리무진사용여부, 리무진장지, isnull(convert(varchar(16),입관일시,120),'') as 입관일시, isnull(convert(varchar(16),발인일시,120),'') as 발인일시 "
	SQL = SQL & " from 행사_고인정보 "	
	SQL = SQL & " where 행사번호 = '" & code & "' "	
	
	SQL2 = "select convert(varchar(10),시스템일자,120) as 등록일 "
	SQL2 = SQL2 & ", convert(varchar(10),dateadd(d,1,시스템일자),120) 등록일1 , convert(varchar(10),dateadd(d,2,시스템일자),120) 등록일2 "
	SQL2 = SQL2 & "from 행사마스터 where 행사번호 = '" & code & "' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL2)

	If Rs.EOF Then
		regdate1 = ""
		regdate2 = ""
	Else
		regdate = Rs("등록일")
		regdate1 = Rs("등록일1")
		regdate2 = Rs("등록일2")
		'regdate = Rs("등록일")
		'regdate = Split(regdate,"-")
		'regdate1 = regdate(0) & "-" & regdate(1) & "-" & Cstr(Cint(regdate(2)) + 1)
		'regdate2 = regdate(0) & "-" & regdate(1) & "-" & Cstr(Cint(regdate(2)) + 2)
	End if

	Set Rs = ConnAplus.execute(SQL)	

	If Rs.EOF Then
		input22 = "insert"		
	Else
		input1 = Rs("행사번호")
		input2 = Rs("빈소도착")
		input3 = Rs("별세일시")		
		input4 = Rs("고인명")
		input5 = Rs("고인성별")
		input6 = Rs("고인연령")
		input7 = Rs("사망사유")
		input8 = Rs("장례형태")
		input9 = Rs("장례진행종교")
		input10 = Rs("장례식장코드")
		input11 = Rs("장례식장명")
		input12 = Rs("호실")
		input13	= Rs("1차장지")
		input14	= Rs("1차장지코드")
		input15 = Rs("2차장지")
		input16 = Rs("버스사용여부")
		input17 = Rs("버스장지")
		input18 = Rs("리무진사용여부")
		input19 = Rs("리무진장지")
		input20 = Rs("입관일시")
		input21 = Rs("발인일시")
		input22 = "update"
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

	if input2 = "" then
		input2_1 = ""
		input2_2 = "00"
		input2_3 = "00"
	else
		input2_1 = Split(input2, " ")(0)
		input2_2 = left(Split(input2, " ")(1), 2)
		input2_3 = mid(Split(input2, " ")(1), 4, 2)
	end if

	if input3 = "" then
		input3_1 = ""
		input3_2 = "00"
		input3_3 = "00"
	else
		input3_1 = Split(input3, " ")(0)
		input3_2 = left(Split(input3, " ")(1), 2)
		input3_3 = mid(Split(input3, " ")(1), 4, 2)
	end if

	if input20 = "" then
		input20_1 = regdate1
		input20_2 = "00"
		input20_3 = "00"
	else
		input20_1 = Split(input20, " ")(0)
		input20_2 = left(Split(input20, " ")(1), 2)
		input20_3 = mid(Split(input20, " ")(1), 4, 2)
	end if

	if input21 = "" then
		input21_1 = regdate2
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

	<form name="frm" method="post" action="reception_goin_ok.asp">
	<input type="hidden" id="p29" name="p29" value="<%=input22 %>" />
	<input type="hidden" id="code" name="code" value="<%=code %>" />

	<table class="form_ty">
		<caption>접수-배송외-고인정보</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="1" style="width:*%;"><col span="2" class="verti_w02">
		</colgroup>

			<tr>
				<th scope="row">빈소도착</th>
				<td class="bdr"><span class="dp_box"><input type="text" id="p1" name="p1" value="<%=input2_1 %>" class="datepicker input_ty start-date w100" placeholder="빈소도착일" readonly ></span></td>
				<td class="bdr">
					<select id="p2" name="p2" class="select_ty w100"><%=op_hour %></select>					
				</td>
				<td>
					<select id="p3" name="p3" class="select_ty w100"><%=op_min %></select>					
				</td>
			</tr>
			<tr>
				<th scope="row">별세일시</th>
				<td class="bdr"><span class="dp_box"><input type="text" id="p4" name="p4" value="<%=input3_1 %>" class="datepicker input_ty start-date w100" placeholder="별세일시" readonly ></span></td>
				<td class="bdr">
					<select id="p5" name="p5" class="select_ty w100"><%=op_hour %></select>
				</td>
				<td>
					<select id="p6" name="p6" class="select_ty w100"><%=op_min_5 %></select>
				</td>
			</tr>
			<tr>
				<th scope="row">고인명</th>
				<td colspan="3"><input type="text" id="p7" name="p7" value="<%=input4 %>" class="input_ty w100"></td>
			</tr>
			<tr>
				<th scope="row">고인성별/연령</th>
				<td class="bdr">
					<select id="p8" name="p8" class="select_ty w100">
						<option value="남">남</option>
						<option value="여">여</option>
					</select>					
				</td>
				<td colspan="2"><input type="text" id="p9" name="p9" value="<%=input6 %>" maxlength="3" onkeyup="chkInteger(this);" class="input_ty w90">세</td>
			</tr>
			<tr>
				<th scope="row">사망사유</th>
				<td colspan="3">
					<select id="p10" name="p10" class="select_ty w100">
						<option value="병사">병사</option>
						<option value="외인사">외인사</option>
						<option value="기타및불상">기타 및 불상</option>
					</select>					
				</td>
			</tr>
			<tr>
				<th scope="row">장례형태</th>
				<td colspan="3">
					<select id="p11" name="p11" onchange="ChangeFuneral(this.value);" class="select_ty w100">
						<option value="화장">화장</option>
						<option value="매장">매장</option>
						<option value="시신기증">시신기증</option>
					</select>					
				</td>
			</tr>
			<tr>
				<th scope="row">장례 진행 종교</th>
				<td colspan="3"><input type="text" id="p12" name="p12" value="<%=input9 %>" class="input_ty w100"></td>
			</tr>
			<tr>
				<th scope="row" class="btnu">장례식장<a href="javascript:void(0);" class="btn_ico ico01" onclick="FuneralList();">장례식장</a></th>
				<td colspan="3">
					<input type="text" id="p13" name="p13" value="<%=input11 %>" class="input_ty w100" readonly>
					<input type="hidden" id="p14" name="p14" value="<%=input10 %>" />
				</td>
			</tr>
			<tr>
				<th scope="row">호실</th>
				<td colspan="3"><input type="text" id="p15" name="p15" value="<%=input12 %>" class="input_ty w100"></td>
			</tr>
			<tr>
				<th scope="row" class="btnu">1차 장지<span class="th_str">(화장일 경우)</span><a href="javascript:void(0);" class="btn_ico ico01" onclick="FirstJangJi();">1차 장지</a></th>
				<td colspan="3">
					<input type="text" id="p16" name="p16" value="<%=input13 %>" class="input_ty w100" <% if input8 = "화장" then response.write "readonly" end if %>>
					<input type="hidden" id="p17" name="p17" value="<%=input14 %>" />
				</td>
			</tr>
			<tr>
				<th scope="row">2차 장지</th>
				<td colspan="3"><input type="text" id="p18" name="p18" value="<%=input15 %>" class="input_ty w100"></td>
			</tr>
			<tr>
				<th scope="row" rowspan="2">버스</th>
				<td colspan="3">
					<ul class="checks">
						<li>							
							<input type="radio" name='p19' id="p19_1" value='Y'>
							<label for="p19_1">사용</label>
						</li>
						<li>
							<input type="radio" name='p19' id="p19_2" value='N'>
							<label for="p19_2">미사용</label>
						</li>
					</ul><!--// checks -->
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<ul class="checks">
						<li>
							<input type="radio" name='p20' id="p20_1" value='화장장'>
							<label for="p20_1">화장장</label>
						</li>
						<li>
							<input type="radio" name='p20' id="p20_2" value='장지'>
							<label for="p20_2">장지</label>
						</li>
					</ul><!--// checks -->
				</td>
			</tr>
			<tr>
				<th scope="row" rowspan="2">리무진</th>
				<td colspan="3">
					<ul class="checks">
						<li>
							<input type="radio" name='p21' id="p21_1" value='Y'>
							<label for="p21_1">사용</label>
						</li>
						<li>
							<input type="radio" name='p21' id="p21_2" value='N'>
							<label for="p21_2">미사용</label>
						</li>
					</ul><!--// checks -->
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<ul class="checks">
						<li>
							<input type="radio" name='p22' id="p22_1" value='화장장'>
							<label for="p22_1">화장장</label>
						</li>
						<li>
							<input type="radio" name='p22' id="p22_2" value='장지'>
							<label for="p22_2">장지</label>
						</li>
					</ul><!--// checks -->
				</td>
			</tr>
			<tr>
				<th scope="row">입관시간</th>
				<td class="bdr"><span class="dp_box"><input type="text" id="p23" name="p23" value="<%=input20_1 %>" class="datepicker input_ty start-date w100" placeholder="입관시간" readonly ></span></td>
				<td class="bdr">
					<select id="p24" name="p24" class="select_ty w100"><%=op_hour %></select>					
				</td>
				<td>
					<select id="p25" name="p25" class="select_ty w100"><%=op_min_5 %></select>					
				</td>
			</tr>
			<tr>
				<th scope="row">발인일시</th>
				<td class="bdr"><span class="dp_box"><input type="text" id="p26" name="p26" value="<%=input21_1 %>" class="datepicker input_ty start-date w100" placeholder="발인일시" readonly ></span></td>
				<td class="bdr">
					<select id="p27" name="p27" class="select_ty w100"><%=op_hour %></select>					
				</td>
				<td>
					<select id="p28" name="p28" class="select_ty w100"><%=op_min_5 %></select>					
				</td>
			</tr>
	</table>

	</form>

	<!--#include virtual="/common/layer_popup.asp"-->	

</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->

<script type="text/javascript" language="javascript" src="/js/reception.js"></script>
<script language="javascript" type="text/javascript">

	function FuneralList(sValue) {

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "reception_funeral_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open('장례식장');
			}
		});

	}
	function FuneralAdd(fcode, fname) {
		$("#p14").val(fcode);
		$("#p13").val(fname);

		Close();
	}
	function ChangeFuneral(val) {
		if (val != "화장") {
			$('#p16').prop('readonly', false);
		} else {
			$('#p16').prop('readonly', true);
		}
		$("#p16").val("");
		$("#p17").val("");
		$("#p18").val("");
	}
	function FirstJangJi(sValue) {
		var val = $("#p11").val();
		if (val != "화장") {
			alert('장례형태가 화장일때만 선택 가능합니다.');
			return false;
		}
		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "reception_fristjangji_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open('1차장지');
			}
		});
	}
	function FristJangJiAdd(fcode, fname) {
		$("#p17").val(fcode);
		$("#p16").val(fname);

		Close();
	}
	function Save() {
		if (!$("#p1").val()) {
			alert('빈소도착일이 입력되지 않았습니다.');
			return false;
		}
		if (!$("#p4").val()) {
			alert('별세일시가 입력되지 않았습니다.');
			return false;
		}
		if (!$("#p7").val()) {
			alert('고인명이 입력되지 않았습니다.');
			return false;
		}
		if (!$("#p9").val()) {
			alert('고인연령이 입력되지 않았습니다.');
			return false;
		}
		if (!$("#p12").val()) {
			alert('장례 진행종교가 입력되지 않았습니다.');
			return false;
		}
		if (!$("#p13").val()) {
			alert('장례식장이 입력되지 않았습니다.');
			return false;
		}
		if (!$("#p15").val()) {
			alert('호실(빈소)이 입력되지 않았습니다.');
			return false;
		}
		if ($("#p11").val() == "화장") {
			if (!$("#p16").val()) {
				alert('1차 장지가 입력되지 않았습니다.');
				return false;
			}
			if (!$("#p18").val()) {
				alert('2차 장지가 입력되지 않았습니다.');
				return false;
			}
		}
		/*
		if (!$("input:radio[name='p19']:checked").val()) {
			alert('필수항목이 입력되지 않았습니다.');
			return false;
		}
		if (!$("input:radio[name='p20']:checked").val()) {
			alert('필수항목이 입력되지 않았습니다.');
			return false;
		}
		if (!$("input:radio[name='p21']:checked").val()) {
			alert('필수항목이 입력되지 않았습니다.');
			return false;
		}
		if (!$("input:radio[name='p22']:checked").val()) {
			alert('필수항목이 입력되지 않았습니다.');
			return false;
		}
		*/
		document.frm.submit();
	}

</script>
<script>
<%
	if input22 = "update" then
%>
	document.getElementById("p2").value = "<%=input2_2 %>";
	document.getElementById("p3").value = "<%=input2_3 %>";
	document.getElementById("p5").value = "<%=input3_2 %>";
	document.getElementById("p6").value = "<%=input3_3 %>";
	document.getElementById("p8").value = "<%=input5 %>";
	document.getElementById("p10").value = "<%=input7 %>";
	document.getElementById("p11").value = "<%=input8 %>";
	document.getElementById("p24").value = "<%=input20_2 %>";
	document.getElementById("p25").value = "<%=input20_3 %>";
	document.getElementById("p27").value = "<%=input21_2 %>";
	document.getElementById("p28").value = "<%=input21_3 %>";
	$("input:radio[name='p19']:radio[value='<%=input16 %>']").prop('checked', true);
	$("input:radio[name='p20']:radio[value='<%=input17 %>']").prop('checked', true);
	$("input:radio[name='p21']:radio[value='<%=input18 %>']").prop('checked', true);
	$("input:radio[name='p22']:radio[value='<%=input19 %>']").prop('checked', true);
<%
	else
%>
	document.getElementById("p24").value = "12";
	document.getElementById("p27").value = "05";
<%
	end if	
%>
</script>