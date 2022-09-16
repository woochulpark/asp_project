<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%
	menu = "진행"
	menu_sub = "기타정보"
	lnbtype = "N" '배송여부
	lnbd = "class='on'"	
	top_btn_save = "Y"

	code = Trim(request("Code"))
	
	if code = "" then 
		response.End
	end if

	SQL = "select 행사번호, 상주명, 연락처, 관계, 변경행사구분, 변경상품코드, 변경상품명, 지원서비스, "
	SQL = SQL & " isnull(convert(varchar(16),용품도착일,120),'') as 용품도착일, isnull(convert(varchar(16),화환도착일,120),'') as 화환도착일, isnull(convert(varchar(16),근조기설치일,120),'') as 근조기설치일 "
	SQL = SQL & " from 행사_기타정보 "	
	SQL = SQL & " where 행사번호 = '" & code & "' "	

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)	

	If Rs.EOF Then
		input0 = ""
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

	if input9 = "" then
		input9_1 = ""
		input9_2 = ""
		input9_3 = ""
	else
		input9_1 = Split(input9, " ")(0)
		input9_2 = left(Split(input9, " ")(1), 2)
		input9_3 = mid(Split(input9, " ")(1), 4, 2)
	end if

	if input10 = "" then
		input10_1 = ""
		input10_2 = ""
		input10_3 = ""
	else
		input10_1 = Split(input10, " ")(0)
		input10_2 = left(Split(input10, " ")(1), 2)
		input10_3 = mid(Split(input10, " ")(1), 4, 2)
	end if

	if input11 = "" then
		input11_1 = ""
		input11_2 = ""
		input11_3 = ""
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

	<form name="frm" method="post" action="progression_etc_ok.asp">			
	<input type="hidden" id="code" name="code" value="<%=code %>" />

	<table class="form_ty">
		<caption>진행-기타정보</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="1" style="width:*%;"><col span="2" class="verti_w02">
		</colgroup>

			<tr>
				<th scope="row">상주명/연락처</th>
				<td class="bdr"><input type="text" value="<%=input2 %>" class="input_ty w100" placeholder="" disabled></td>
				<td colspan="2"><a href="tel:<%=input3 %>" target="_blank" class="blt_tel">전화걸기</a><input type="text" value="<%=input3 %>" class="input_ty w80" placeholder="010-1234-5678" disabled></td>
			</tr>
			<tr>
				<th scope="row">상주와 <br class="m_br">고인의 관계</th>
				<td colspan="3">
					<select class="select_ty w100" disabled>
						<option value="<%=input4 %>"><%=input4 %></option>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">지원서비스</th>
				<td colspan="3">
					<select class="select_ty w100" disabled>
						<option value="<%=input8 %>"><%=input8 %></option>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">용품도착</th>
				<td class="bdr"><span class="dp_box"><input type="text" id="p8" name="p8" value="<%=input9_1 %>" class="datepicker input_ty start-date w100" placeholder="용품도착일" readonly ></span></td>
				<td class="bdr">
					<select id="p9" name="p9" class="select_ty w100"><%=op_hour %></select>					
				</td>
				<td>
					<select id="p10" name="p10" class="select_ty w100"><%=op_min_5 %></select>					
				</td>
			</tr>
			<tr>
				<th scope="row">화환도착</th>
				<td class="bdr"><span class="dp_box"><input type="text" id="p11" name="p11" value="<%=input10_1 %>" class="datepicker input_ty start-date w100" placeholder="화환도착일" readonly ></span></td>
				<td class="bdr">
					<select id="p12" name="p12" class="select_ty w100"><%=op_hour %></select>					
				</td>
				<td>
					<select id="p13" name="p13" class="select_ty w100"><%=op_min_5 %></select>					
				</td>
			</tr>
			<tr>
				<th scope="row">근조기설치</th>
				<td class="bdr"><span class="dp_box"><input type="text" id="p14" name="p14" value="<%=input11_1 %>" class="datepicker input_ty start-date w100" placeholder="근조기설치일" readonly ></span></td>
				<td class="bdr">
					<select id="p15" name="p15" class="select_ty w100"><%=op_hour %></select>					
				</td>
				<td>
					<select id="p16" name="p16" class="select_ty w100"><%=op_min_5 %></select>					
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
			url: "progression_msg_ok_ajax.asp", //요청을 보낼 서버의 URL
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
		/*
		파일업로드체크
		if (!$("#p17").val()) {
		alert('필수항목이 입력되지 않았습니다.');
		return false;
		}
		*/
		document.frm.submit();
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