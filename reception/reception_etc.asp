<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->
<!--#include virtual="/reception/reception_timjang_check.asp"-->
<%
	menu = "접수"
	menu_sub = "기타정보"
	lnbtype = "N" '배송여부
	lnbc = "class='on'"	
	top_btn_save = "Y"

	code = Trim(request("Code"))
	
	if code = "" then 
		response.End
	end if

	SQL = "select a.행사번호, a.상주명, a.연락처, a.관계, a.변경행사구분, a.변경상품코드, a.변경상품명, a.지원서비스, b.파일명, "
	SQL = SQL & " isnull(convert(varchar(16),a.용품도착일,120),'') as 용품도착일, isnull(convert(varchar(16),a.화환도착일,120),'') as 화환도착일, isnull(convert(varchar(16),a.근조기설치일,120),'') as 근조기설치일 "
	SQL = SQL & " from 행사_기타정보 a (nolock) left outer join 상품코드 b (nolock) on a.변경상품코드 = b.상품코드 "	
	SQL = SQL & " where 행사번호 = '" & code & "' "		

	SQL2 = "select a.상세명칭 as 행사구분 "
	SQL2 = SQL2 & " from 공용코드 a (nolock) "	
	SQL2 = SQL2 & " where a.대표코드  = '00505' and a.구분5 = 'Y' "
	SQL2 = SQL2 & " and ( a.상세명칭 in (select 일반단체구분 from 행사마스터 (nolock) where 행사번호 = '" & code & "' )"
	SQL2 = SQL2 & " 	or a.상세명칭 in (select case when 일반단체구분 = '저가형' then '저가형상향' else 일반단체구분 end from 행사마스터 (nolock) where 행사번호 = '" & code & "') ) "
	SQL2 = SQL2 & " order by a.상세명칭 "

	SQL3 = "select 상세명칭 as 관계 "
	SQL3 = SQL3 & " from 공용코드 a (nolock) "
	SQL3 = SQL3 & " where 대표코드  = '00501' and 구분4 = 'Y' "
	SQL3 = SQL3 & " order by 구분1 "

	SQL4 = "select b.상품명, c.단체명 "
	SQL4 = SQL4 & " from 행사마스터 a (nolock) "
	SQL4 = SQL4 & " 	left outer join 상품코드 b (nolock) on a.상품코드 = b.상품코드 "
	SQL4 = SQL4 & " 	left outer join 행사단체 c (nolock) on a.행사단체 = c.단체코드 "
	SQL4 = SQL4 & " where a.행사번호 = '" & code & "' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)	

	If Rs.EOF Then
		input0 = "insert"
	Else
		input0 = "update"		
		input1 = Rs("행사번호")
		input2 = Rs("상주명")
		input3 = Rs("연락처")
		input4 = Rs("관계")
		input5 = Rs("변경행사구분")
		input6 = Rs("변경상품코드")
		input7 = Rs("변경상품명")
		input8 = Rs("지원서비스")
		input9 = Rs("용품도착일")
		input10 = Rs("화환도착일")
		input11 = Rs("근조기설치일")
		input12 = Rs("파일명")
	End If

	Set Rs = ConnAplus.execute(SQL4)	

	If Rs.EOF Then
		input13 = ""
		input14 = ""		
	Else		
		input13 = Rs("상품명")	
		input14 = Rs("단체명")		
	End If

	Set Rs = ConnAplus.execute(SQL2)

	If Rs.EOF Then
		rc = 0
	Else
		rc = Rs.RecordCount
		arrObj = Rs.GetRows(rc)
	End If	

    Set Rs = ConnAplus.execute(SQL3)

	If Rs.EOF Then
		rc2 = 0
	Else
		rc2 = Rs.RecordCount
		arrObj2 = Rs.GetRows(rc2)
	End If	

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	

	op_gubun = ""

	if rc <> 0 then	
		for i=0 to UBound(arrObj,2)			
			op_gubun = op_gubun + "<option value='"& arrObj(0,i) &"'>"& arrObj(0,i) &"</option>"
		next
	end if

    op_guan = ""

	if rc2 <> 0 then	
		for i=0 to UBound(arrObj2,2)			
			op_guan = op_guan + "<option value='"& arrObj2(0,i) &"'>"& arrObj2(0,i) &"</option>"
		next
	end if

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

	if input9 = "" then
		input9_1 = ""
		input9_2 = "00"
		input9_3 = "00"
	else
		input9_1 = Split(input9, " ")(0)
		input9_2 = left(Split(input9, " ")(1), 2)
		input9_3 = mid(Split(input9, " ")(1), 4, 2)
	end if

	if input10 = "" then
		input10_1 = ""
		input10_2 = "00"
		input10_3 = "00"
	else
		input10_1 = Split(input10, " ")(0)
		input10_2 = left(Split(input10, " ")(1), 2)
		input10_3 = mid(Split(input10, " ")(1), 4, 2)
	end if

	if input11 = "" then
		input11_1 = ""
		input11_2 = "00"
		input11_3 = "00"
	else
		input11_1 = Split(input11, " ")(0)
		input11_2 = left(Split(input11, " ")(1), 2)
		input11_3 = mid(Split(input11, " ")(1), 4, 2)
	end if	
%>
<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->
	<!--#include virtual="/common/lnb.asp"-->
	<!--#include virtual="/common/top_btns.asp"-->

	<form name="frm" method="post" action="reception_etc_ok.asp">
	<input type="hidden" id="p0" name="p0" value="<%=input0 %>" />
	<input type="hidden" id="code" name="code" value="<%=code %>" />

	<table class="form_ty">
		<caption>접수-배송외-기타정보</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="1" style="width:*%;"><col span="2" class="verti_w02">
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">상주명/연락처</th>
				<td class="bdr"><input type="text" id="p1" name="p1" value="<%=input2 %>" class="input_ty w100"></td>
				<td colspan="2">
					<a href="tel:<%=input3 %>" target="_blank" class="blt_tel">전화걸기</a>
					<input type="text" id="p2" name="p2" value="<%=input3 %>" maxlength="11" onkeyup="chkInteger(this);" class="input_ty w80">
				</td>
			</tr>
			<tr>
				<th scope="row">상주와 <br class="m_br">고인의 관계</th>
				<td colspan="3">
					<select id="p3" name="p3" class="select_ty w100">
						<%=op_guan %>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">변경행사구분</th>
				<td colspan="3">
					<select id="p4" name="p4" class="select_ty w100">
						<%=op_gubun %>
					</select>					
				</td>
			</tr>			
			<tr>
				<th scope="row" class="btnu">변경상품<br class="m_br">(<%=input13 %>)<a href="javascript:void(0);" onclick="ItemList();" class="btn_ico ico01">변경상품</a></th>
				<td colspan="3">
					<input type="hidden" id="p5" name="p5" value="<%=input6 %>" />
					<input type="hidden" id="p6" name="p6" value="<%=input7 %>">
					<input type="hidden" id="p18" name="p18" value="<%=input12 %>" />
					<input type="hidden" id="p19" name="p19" value="<%=input14 %>" />					
					<span id="fname" class="input_dt w80"><%=input7 %></span>
					<a href="javascript:void(0);" class="btn_ty ty02" onclick="ItemView();">스펙</a>
				</td>
			</tr>
			<tr>
				<th scope="row">지원서비스</th>
				<td colspan="3">
					<select id="p7" name="p7" class="select_ty w100">
						<option value="N">N</option>
						<option value="Y">Y</option>
						<option value="선택1">선택1</option>
						<option value="선택2">선택2</option>
						<option value="선택3">선택3</option>
						<option value="선택4">선택4</option>
						<option value="선택5">선택5</option>
						<option value="선택6">선택6</option>
						<option value="제외">제외</option>
					</select>					
				</td>
			</tr>
			<!--
			<tr>
				<th scope="row">인수자</th>
				<td colspan="3"><input type="text" id="p20" name="p20" value="<%=p20 %>" class="input_ty w100"></td>
			</tr>
			-->
			<tr>
				<th scope="row">용품도착<a href="javascript:void();" onclick="Reset('a');" class="btn_ico ico07">초기화</a></th>
				<td class="bdr"><span class="dp_box"><input type="text" id="p8" name="p8" value="<%=input9_1 %>" class="datepicker input_ty start-date w100" placeholder="용품도착일" readonly ></span></td>
				<td class="bdr">
					<select id="p9" name="p9" class="select_ty w100">
						<%=op_hour %>
					</select>
				</td>
				<td>
					<select id="p10" name="p10" class="select_ty w100">
						<%=op_min_5 %>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">화환도착<a href="javascript:void();" onclick="Reset('b');" class="btn_ico ico07">초기화</a></th>
				<td class="bdr"><span class="dp_box"><input type="text" id="p11" name="p11" value="<%=input10_1 %>" class="datepicker input_ty start-date w100" placeholder="화환도착일" readonly ></span></td>
				<td class="bdr">
					<select id="p12" name="p12" class="select_ty w100">
						<%=op_hour %>
					</select>
				</td>
				<td>
					<select id="p13" name="p13" class="select_ty w100">
						<%=op_min_5 %>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">근조기설치<a href="javascript:void();" onclick="Reset('c');" class="btn_ico ico07">초기화</a></th>
				<td class="bdr"><span class="dp_box"><input type="text" id="p14" name="p14" value="<%=input11_1 %>" class="datepicker input_ty start-date w100" placeholder="근조기설치일" readonly ></span></td>
				<td class="bdr">
					<select id="p15" name="p15" class="select_ty w100">
						<%=op_hour %>
					</select>
				</td>
				<td>
					<select id="p16" name="p16" class="select_ty w100">
						<%=op_min_5 %>
					</select>
				</td>
			</tr>

			<tr>				
				<th scope="row" class="btnu">용품첨부파일<a href="javascript:void(0);" onclick="FileUpload('배송', '용품', '<%=code %>');" class="btn_ico ico05">첨부파일</a></th>
				<td colspan="3">
					<div id="img_list_1"></div>
				</td>
			</tr>

			<tr>				
				<th scope="row" class="btnu">화환첨부파일<a href="javascript:void(0);" onclick="FileUpload('배송', '화환', '<%=code %>');" class="btn_ico ico05">첨부파일</a></th>
				<td colspan="3">
					<div id="img_list_2"></div>
				</td>
			</tr>

			<tr>				
				<th scope="row" class="btnu">근조기첨부파일<a href="javascript:void(0);" onclick="FileUpload('배송', '조기', '<%=code %>');" class="btn_ico ico05">첨부파일</a></th>
				<td colspan="3">
					<div id="img_list_3"></div>
				</td>
			</tr>

			<tr>
				<th scope="row" class="btnu">공급확인서(서류)<a href="javascript:void(0);" onclick="FileUpload('행사', '<%=menu_sub %>', '<%=code %>');" class="btn_ico ico05">첨부파일</a></th>				
				<td colspan="3">
					<div id="img_list"></div>
				</td>
			</tr>
		</tbody>
	</table>

	</form>

	<table class="form_ty mt">
		<caption>진행-기타정보</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="1" style="width:*%;">
		</colgroup>

			<tr>
				<th scope="row" class="btnu">부고안내<a href="javascript:void(0);" onclick="MsgSend();" class="btn_ico ico04">문자발송</a></th>
				<td><input type="text" id="msg" name="msg" maxlength="11" onkeyup="chkInteger(this);" class="input_ty w100" placeholder="숫자만 입력하세요."></td>
			</tr>
	</table>

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
				if ( b_type1 == "행사")
				{
					$("#img_list").text("");
					$("#img_list").html(data);
				}
				if ( b_type2 == "용품")
				{
					$("#img_list_1").text("");
					$("#img_list_1").html(data);
				}
				if ( b_type2 == "화환")
				{
					$("#img_list_2").text("");
					$("#img_list_2").html(data);
				}
				if ( b_type2 == "조기")
				{
					$("#img_list_3").text("");
					$("#img_list_3").html(data);
				}
			}
		});

	}
	ImgList('행사', '<%=menu_sub %>', '<%=code %>');
	ImgList('배송', '용품', '<%=code %>');
	ImgList('배송', '화환', '<%=code %>');
	ImgList('배송', '조기', '<%=code %>');

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
	function ItemList(sValue) {

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "reception_item_list_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue, sValue_2: "<%=input14 %>" }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open('변경상품');
			}
		});

	}
	function ItemView() {
		var filename = $("#p18").val();
		var spum_g_name = $("#p19").val();
		if (filename == "") {
			alert('등록된 상품이 없습니다.');
			return false;
		}
		window.open('http://pdf.apluslife.co.kr/UTF/item_view.asp?spum_file=' + filename +'&spum_g_name='+ spum_g_name , '_blank');
	}
	function ItemAdd(fcode, fname, file) {
		$("#p5").val(fcode);
		$("#p6").val(fname);
		$("#p18").val(file);

		$("#fname").text(fname);

		Close();
	}
	function MsgSend() {
		var msgno = $("#msg").val();
		if (msgno == "") {
			alert('전화번호를 입력하세요.');
			return false;
		}
		if (!confirm("부고안내 문자 전송하시겠습니까?")) {
			return false;
		}

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/progression/progression_msg_ok_ajax.asp", //요청을 보낼 서버의 URL
			data: { Code: "<%=code %>", msgno: msgno }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				if (data == 'S') {
					alert('발송되었습니다.');
				} else if (data == 'Y') {
					alert('발송대기 메세지가 있습니다.');
				} else if (data == 'Y2') {
					alert('발송완료 메세지가 있습니다.');
				}
			}
		});
	}

	function Save() {
		if (!$("#p1").val()) {
			alert('상주명이 입력되지 않았습니다.');
			return false;
		}
		if (!$("#p2").val()) {
			alert('연락처가 입력되지 않았습니다.');
			return false;
		}
		if (!$("#p6").val()) {
			alert('변경상품이 입력되지 않았습니다.');
			return false;
		}
		/*
		파일업로드체크
		if (!$("#p17").val()) {
		alert('필수항목이 입력되지 않았습니다.');
		return false;
		}
		*/
		/*
		if ( ($("#p8").val() != "" || $("#p11").val() != "" || $("#p14").val() != "") && $("#p20").val() == "" ) {
			alert('인수자 입력되지 않았습니다.');
			return false;
		}
		*/
		if (!confirm('저장하시겠습니까?')) {
			return false;
		}
		document.frm.submit();
    }	
    function Reset(type) {
        if(type == 'a'){
            $("#p8").val('');
            $("#p9").val('00');
            $("#p10").val('00');
        }else if(type == 'b'){
            $("#p11").val('');
            $("#p12").val('00');
            $("#p13").val('00');
        }else{
            $("#p14").val('');
            $("#p15").val('00');
            $("#p16").val('00');
        }
    }
</script>
<%
	if input0 = "update" then
		if input9 = "" then
			input9_2 = "00"
			input9_3 = "00"
		end if
		if input10 = "" then
			input10_2 = "00"
			input10_3 = "00"
		end if
		if input11 = "" then
			input11_2 = "00"
			input11_3 = "00"
		end if
%>
<script>
	document.getElementById("p3").value = "<%=input4 %>";
	document.getElementById("p4").value = "<%=input5 %>";
	document.getElementById("p7").value = "<%=input8 %>";
	document.getElementById("p9").value = "<%=input9_2 %>";
	document.getElementById("p10").value = "<%=input9_3 %>";
	document.getElementById("p12").value = "<%=input10_2 %>";
	document.getElementById("p13").value = "<%=input10_3 %>";
	document.getElementById("p15").value = "<%=input11_2 %>";
	document.getElementById("p16").value = "<%=input11_3 %>";
</script>
<%
	end if
%>