<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check2.asp"-->

<%
	menu = "진행"
	lnbtype = "N" '배송여부
	lnba = "class='on'"	
	top_btn_save = "N"
	user_type = "a"

	code = Trim(request("Code"))

	'Response.write code
	'response.End
	
	code = FnAesDecrypt(code, AesEncryptPwd)

		'Response.write code
		'response.End

	if code = "" then 
		Response.write code
		response.End
	end if

	SQL = "select 행사번호, 일차, convert(varchar(10), 근무일, 120) as 근무일, 입실시간, 퇴실시간, 내용 "
	SQL = SQL & " from 행사_장례진행 "	
	SQL = SQL & " where 행사번호 = '" & code & "' "	
	SQL = SQL & " order by 일차 asc "
	
	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ
		
	Set Rs = ConnAplus.execute(SQL)

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
	
%>
<script type="text/javascript" language="javascript" src="/js/reception.js"></script>
<script language="javascript" type="text/javascript">
		
	function Write(start) {

		var k = $("a[name='write']").index(start);
		var con = $("div[name='pp']")[k];			
		
		if (con.style.display == "none") {
			con.style.display = "block";
		} else {
			con.style.display = "none";
		}
			
	}
</script>

<script language="javascript" type="text/javascript">
	function ImgList(b_type1, b_type2, b_idx) {


		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/file/img_list.asp", //요청을 보낼 서버의 URL
			data: { b_type1: b_type1, b_type2: b_type2, b_idx: b_idx }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				var id = 'img_list' + b_type2.replace("일차", "");

				$("#" + id).text("");
				$("#" + id).html(data);		

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
</script>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--include virtual="/common/menu.asp"-->
	<!--include virtual="/common/lnb.asp"-->
	<!--#include virtual="/common/top_btns_erp.asp"-->

    <!--
	<dl class="add_cate ty02">
		<dt>진행 - 장례진행</dt>		
		<dd>
			<input type="text" id="p10" name="p10" maxlength="1" onkeyup="chkInteger(this);" class="input_ty w50" placeholder="근무일(일)">
			<a href="javascript:void(0);" onclick="add();" class="btn_ty btn_b ty03 btn_add">추가</a>
		</dd>
		
	</dl>--><!--// add_cate -->

	<ul id="factory_table" class="acc_form">
<%
	if rc = 0 then 		
		i = 0		
	else
		for i=0 to UBound(arrObj,2)
			input1	= arrObj(1,i) '일차
			input2	= arrObj(2,i) '근무일
			input3	= arrObj(3,i) '입실시간
			input4	= arrObj(4,i) '퇴실시간
			input5	= arrObj(5,i) '내용

			input3_1 = Split(input3, ":")(0)
			input3_2 = Split(input3, ":")(1)
			input4_1 = Split(input4, ":")(0)
			input4_2 = Split(input4, ":")(1)
%>
		<li class="on">
			<div class="acc_tit">
				<p class="tit"><span><%=input1 %></span>일차 근무일지</p>
				<a href="javascript:void(0);" onclick="Write(this);" name="write" class="btn_ty">완료</a>				
			</div><!--// acc_tit -->
			<div name='pp' class="acc_cont" style='display:block;'>
				<table class="table_ty verti">
					<caption>근무일지 작성</caption>
					<colgroup>
						<col span="1" class="verti_w01"><col span="2" style="width:*%;">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">근무일</th>
							<td colspan="2"><%=input2 %></td>
						</tr>
						<tr>
							<th scope="row">입실시간</th>
							<td colspan="2"><%=input3 %></td>							
						</tr>
						<tr>
							<th scope="row">퇴실시간</th>
							<td colspan="2"><%=input4 %></td>
						</tr>
						<tr>
							<th scope="row">내용</th>
							<td colspan="2"><%=input5 %></td>
						</tr>
						<tr>
							<th scope="row">사진첨부</th>
							<td colspan="2">
								<div id="img_list<%=input1 %>"></div>
							</td>
						</tr>
					</tbody>
				</table>
				<!--<div class='btm_btns'><a href='javascript:void(0);' onclick='Save(this);' name='save1' class='btn_ty btn_b'>저장</a></div>-->
			</div><!--// acc_cont -->
		</li>
		<script>
			//document.getElementById("p2_<%=i %>").value = "<%=input3_1 %>";
			//document.getElementById("p3_<%=i %>").value = "<%=input3_2 %>";
			//document.getElementById("p4_<%=i %>").value = "<%=input4_1 %>";
			//document.getElementById("p5_<%=i %>").value = "<%=input4_2 %>";
			ImgList('장례진행', '<%=input1 %>일차', '<%=code %>');
		</script>
<%
		next
	end if 
	
'	for k=i to 2
'		response.write "<script>rowadd();</script>"
'	next
	
%>		
	</ul><!--// acc_form -->

	<ul id="factory_table" class="acc_form">	
		<li class="on">
			<table class="table_ty verti">
				<caption>진행-기타정보</caption>
				<colgroup>
					<col span="1" class="verti_w01"><col span="1" style="width:*%;"><col span="2" class="verti_w02">
				</colgroup>

					
					<tr>				
						<th scope="row" class="btnu">용품첨부파일</th>
						<td colspan="3">
							<div id="img_list_1"></div>
						</td>
					</tr>

					<tr>				
						<th scope="row" class="btnu">화환첨부파일</th>
						<td colspan="3">
							<div id="img_list_2"></div>
						</td>
					</tr>

					<tr>				
						<th scope="row" class="btnu">근조기첨부파일</th>
						<td colspan="3">
							<div id="img_list_3"></div>
						</td>
					</tr>

					<tr>				
						<th scope="row" class="btnu">첨부파일</th>
						<td colspan="3">
							<div id="img_list"></div>
						</td>
					</tr>

			</table>
		</li>
	</ul>
	<!--#include virtual="/common/layer_popup.asp"-->

</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->