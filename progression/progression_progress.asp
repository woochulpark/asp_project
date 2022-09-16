<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%
	menu = "진행"
	lnbtype = "N" '배송여부
	lnba = "class='on'"	
	top_btn_save = "N"

	code = Trim(request("Code"))
	
	if code = "" then 
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

<script type="text/javascript" language="javascript" src="/js/reception.js?ver=1"></script>
<script language="javascript" type="text/javascript">
	function Save(start) {
			
		var input1 = ""
		var input2 = ""
		var input3 = ""
		var input4 = ""
		var input5 = ""
		var input6 = ""
		var input7 = ""
		var input8 = ""

		var k = $("a[name='save1']").index(start);

		input1 = $("#factory_table input[name=p1]")[k].value
		input2 = $("#factory_table select[name=p2]")[k].value
		input3 = $("#factory_table select[name=p3]")[k].value
		input4 = $("#factory_table select[name=p4]")[k].value
		input5 = $("#factory_table select[name=p5]")[k].value
		input6 = $("#factory_table textarea[name=p6]")[k].value

		if (input1 == "") {
			alert("근무일을 선택해주세요.");
			return false;
		}

		if(input6.length < 5) {
			alert("내용은 5자 이상이어야 합니다.");
			return false;
		}

		if(!confirm('등록하시겠습니까?')){
			return false;
		}

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "progression_progress_ok_ajax.asp", //요청을 보낼 서버의 URL
			data: { Code: <%=code %>, input0: k+1, input1: input1, input2: input2, input3: input3, input4: input4, input5: input5, input6: input6  }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
			
				if(data == "insert" || data == "update"){
					alert('등록되었습니다.');
					if(data == "insert"){						
						$("#factory_table a[name='write']")[k].setAttribute('class', 'btn_ty');
						$("#factory_table a[name='write']")[k].innerHTML = "완료";											
					}
				}else{
					alert('이전일자 근무일지 먼저 등록해주세요.');
				}
			}
		});
			
	}		
	function Write(start) {

		var k = $("a[name='write']").index(start);
		var con = $("div[name='pp']")[k];			
		
		if (con.style.display == "none") {
			con.style.display = "block";
		} else {
			con.style.display = "none";
		}
			
	}
	function add() {
		var cnt = parseInt($("#p10").val());

		for (i = 0; i < cnt; i++) {				
			rowadd();
		}
		$("#p10").val("");
	}
	function rowadd() {
		
		var dtype = $("#factory_table input[name='p1']").length + 1;
		
		var rowItem = ""

		rowItem = "<li class='on'>"
		rowItem += "<div class='acc_tit'>"
		rowItem += "	<p class='tit'><span>" + dtype + "</span>일차 근무일지</p>"
		rowItem += "	<a href='javascript:void(0);' onclick='Write(this);' name='write' class='btn_ty ty02'>작성하기</a>"
		rowItem += "</div>"
		rowItem += "<div name='pp' class='acc_cont' style='display:none;'>"
		rowItem += "	<table class='form_ty'>"
		rowItem += "		<caption>근무일지 작성</caption>"
		rowItem += "		<colgroup>"
		rowItem += "			<col span='1' class='verti_w01'><col span='2' style='width:*%;'>"
		rowItem += "		</colgroup>"
		rowItem += "		<tdody>"
		rowItem += "			<tr>"
		rowItem += "				<th scope='row'>근무일</th>"
		rowItem += "				<td colspan='2'><span class='dp_box w100'><input type='text' name='p1' class='datepicker input_ty start-date w100' placeholder='근무일' readonly ></span></td>"
		rowItem += "			</tr>"		
		rowItem += "			<tr>"
		rowItem += "				<th scope='row'>입실시간</th>"
		rowItem += "				<td class='bdr'>"
		rowItem += "					<select name='p2' class='select_ty w100'><%=op_hour %></select>"
		rowItem += "				</td>"
		rowItem += "				<td>"
		rowItem += "					<select name='p3' class='select_ty w100'><%=op_min_5 %></select>"
		rowItem += "				</td>"
		rowItem += "			</tr>"
		rowItem += "			<tr>"
		rowItem += "				<th scope='row'>퇴실시간</th>"
		rowItem += "				<td class='bdr'>"
		rowItem += "					<select name='p4' class='select_ty w100'><%=op_hour %></select>"
		rowItem += "				</td>"
		rowItem += "				<td>"
		rowItem += "					<select name='p5' class='select_ty w100'><%=op_min_5 %></select>"
		rowItem += "				</td>"
		rowItem += "			</tr>"
		rowItem += "			<tr>"
		rowItem += "				<th scope='row'>내용</th>"
		rowItem += "				<td colspan='2'>"
		rowItem += "					<textarea name='p6' class='tarea_ty' placeholder='내용을 입력해주세요.'></textarea>"		
		rowItem += "				</td>"
		rowItem += "			</tr>"
		rowItem += "			<tr>"
		rowItem += "				<th scope='row'>사진첨부<a href='javascript:void(0);' onclick=\"FileUpload('장례진행', '"+ dtype +"일차', '<%=code %>');\" class='btn_ico ico05'>사진첨부</a></th>"
		rowItem += "				<td colspan='2'><div id='img_list"+ dtype +"'></div></td>"
		rowItem += "			</tr>"
		rowItem += "		</tbody>"		
		rowItem += "	</table>"
		rowItem += "	<div class='btm_btns'><a href='javascript:void(0);' onclick='Save(this);' name='save1' class='btn_ty btn_b'>저장</a></div>"
		rowItem += "</div>"
		rowItem += "</li>"
		
		$('#factory_table').append(rowItem);

		$("input[name='p1']").datepicker({
			autoHide: true
		});	

		ImgList('장례진행', dtype +'일차', '<%=code %>');
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
			}
		});

	}
	//ImgList('행사', '<%=menu_sub %>', '<%=code %>');
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
</script>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->
	<!--#include virtual="/common/lnb.asp"-->
	<!--#include virtual="/common/top_btns.asp"-->


	<dl class="add_cate ty02">
		<dt>진행 - 장례진행</dt>
		<dd>
			<input type="text" id="p10" name="p10" maxlength="1" onkeyup="chkInteger(this);" class="input_ty w50" placeholder="근무일(일)">
			<a href="javascript:void(0);" onclick="add();" class="btn_ty btn_b ty03 btn_add">추가</a>
		</dd>
	</dl><!--// add_cate -->

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
			<div name='pp' class="acc_cont" style='display:none;'>
				<table class="form_ty">
					<caption>근무일지 작성</caption>
					<colgroup>
						<col span="1" class="verti_w01"><col span="2" style="width:*%;">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">근무일</th>
							<td colspan="2"><span class="dp_box w100"><input type="text" name="p1" value="<%=input2 %>" class="datepicker input_ty start-date w100" placeholder="근무일" readonly ></span></td>
						</tr>
						<tr>
							<th scope="row">입실시간</th>
							<td class="bdr">
								<select name="p2" id="p2_<%=i %>" class="select_ty w100"><%=op_hour %></select>								
							</td>
							<td>
								<select name="p3" id="p3_<%=i %>" class="select_ty w100"><%=op_min_5 %></select>								
							</td>
						</tr>
						<tr>
							<th scope="row">퇴실시간</th>
							<td class="bdr">								
								<select name="p4" id="p4_<%=i %>" class="select_ty w100"><%=op_hour %></select>
							</td>
							<td>
								<select name="p5" id="p5_<%=i %>" class="select_ty w100"><%=op_min_5 %></select>
							</td>
						</tr>
						<tr>
							<th scope="row">내용</th>
							<td colspan="2">
								<textarea name="p6" class="tarea_ty" placeholder="내용을 입력해주세요."><%=input5 %></textarea>
							</td>
						</tr>
						<tr>
							<th scope="row">사진첨부<a href="javascript:void(0);" onclick="FileUpload('장례진행', '<%=input1 %>일차', '<%=code %>');" class="btn_ico ico05">사진첨부</a></th>
							<td colspan="2">
								<div id="img_list<%=input1 %>"></div>
							</td>
						</tr>
					</tbody>
				</table>
				<div class='btm_btns'><a href='javascript:void(0);' onclick='Save(this);' name='save1' class='btn_ty btn_b'>저장</a></div>
			</div><!--// acc_cont -->
		</li>
		<script>
			document.getElementById("p2_<%=i %>").value = "<%=input3_1 %>";
			document.getElementById("p3_<%=i %>").value = "<%=input3_2 %>";
			document.getElementById("p4_<%=i %>").value = "<%=input4_1 %>";
			document.getElementById("p5_<%=i %>").value = "<%=input4_2 %>";
			ImgList('장례진행', '<%=input1 %>일차', '<%=code %>');
		</script>
<%
		next
	end if 
	
	for k=i to 2
		response.write "<script>rowadd();</script>"
	next
	
%>		
	</ul><!--// acc_form -->	

	<!--#include virtual="/common/layer_popup.asp"-->

</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->