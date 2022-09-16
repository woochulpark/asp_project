<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check2.asp"-->
<%	if user_id = "" then %>
<!--#include virtual="/reception/sign_check.asp"-->
<% end if %>

<%
	menu = "접수"
	menu_sub = "기타정보"
	lnbtype = "Y" '배송여부
	lnbb = "class='on'"	
	top_btn_save = "Y"

	code = Trim(request("Code"))
	code = FnAesDecrypt(code, AesEncryptPwd)
	
	if code = "" then 
		response.End
	end if
	
	SQL = "select a.행사번호, a.상주명, a.연락처, a.관계, a.변경행사구분, a.변경상품코드, a.변경상품명, a.지원서비스, b.파일명, "
	SQL = SQL & " isnull(convert(varchar(16),a.용품도착일,120),'') as 용품도착일, isnull(convert(varchar(16),a.화환도착일,120),'') as 화환도착일, isnull(convert(varchar(16),a.근조기설치일,120),'') as 근조기설치일 "
	SQL = SQL & " from 행사_기타정보 a (nolock) left outer join 상품코드 b (nolock) on a.변경상품코드 = b.상품코드 "	
	SQL = SQL & " where 행사번호 = '" & code & "' "		

	SQL2 = "select 상세명칭 as 행사구분 "
	SQL2 = SQL2 & " from 공용코드 a (nolock) "
	SQL2 = SQL2 & " where 대표코드  = '00505' and 구분5 = 'Y' "		
	SQL2 = SQL2 & " order by 상세명칭 "

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

	Set Rs = ConnAplus.execute(SQL2)

	If Rs.EOF Then
		rc = 0
	Else
		rc = Rs.RecordCount
		arrObj = Rs.GetRows(rc)
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
<%	if user_id <> "" then %>
	<!--#include virtual="/common/menu.asp"-->		
<%	end if %>
	<!--#include virtual="/common/lnb.asp"-->
	<!--#include virtual="/common/top_btns.asp"-->

	<form name="frm" method="post" action="reception_etc_b_ok.asp">
	<input type="hidden" id="p0" name="p0" value="<%=input0 %>" />
	<input type="hidden" id="code" name="code" value="<%=code %>" />

	<table class="form_ty">
		<caption>접수-배송-기타정보</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="1" style="width:*%;"><col span="2" class="verti_w02">
		</colgroup>
		<tbody>			
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
				<th scope="row" class="btnu">첨부파일<a href="javascript:void(0);" onclick="FileUpload('행사', '<%=menu_sub %>', '<%=code %>');" class="btn_ico ico05">첨부파일</a></th>
				<td colspan="3">
					<div id="img_list"></div>
				</td>
			</tr>
		</tbody>
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
	function Save() {
		if ($("#p8").val() == "" && $("#p11").val() == "") {
			alert('용품도착, 화환도착 입력되지 않았습니다.');
			return false;
		}
		/*
		파일업로드체크
		if (!$("#p17").val()) {
		alert('필수항목이 입력되지 않았습니다.');
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