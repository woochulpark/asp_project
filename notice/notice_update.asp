<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->
<%
	menu = "공지사항"
	Idx = Trim(request("Idx"))	

	if Idx = "" then 
		response.End
	end if	

	SQL = " select 인덱스,작성자,제목,내용,convert(varchar,등록일,102) as 등록일,파일,파일경로, 게시분류1, 게시분류2, 상단고정 "
	SQL = SQL & " from 공지사항N "
	SQL = SQL & " where 인덱스 = " & Idx & " "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)	

	If Rs.EOF Then
		
	Else
		idx = Rs("인덱스")
		name = Rs("작성자")
		subject = Rs("제목")
		contents = Rs("내용")
		r_date = Rs("등록일")
		filename = Rs("파일")
		filepath = Rs("파일경로")
		opentype1 = Rs("게시분류1")
		opentype2 = Rs("게시분류2")
		opentype3 = Rs("상단고정")
	End If	

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	if opentype3 = "Y" then
		opentype3_Y = "checked"
		opentype3_N = ""
	else
		opentype3_Y = ""
		opentype3_N = "checked"
	end if

%>
<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->

	<form name="frm_write" id="frm_write" method="post" action="notice_update_ok.asp" enctype="multipart/form-data">
	<input type="hidden" id="Idx" name="Idx" value="<%=Idx %>" />

	<table class="form_ty">
		<caption>공지사항 작성 및 수정</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="2" style="width:*%;">
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">상단고정</th>
				<td colspan="2">
					<ul class="checks">
						<li>
							<input type="radio" id="opentype3_1" name='opentype3' value='N' <%=opentype3_N %>>
							<label for="opentype3_1">N</label>
						</li>
						<li>
							<input type="radio" id="opentype3_2" name='opentype3' value='Y' <%=opentype3_Y %>>
							<label for="opentype3_2">Y</label>
						</li>
					</ul>
				</td>
			</tr>
			<tr>
				<th scope="row">게시분류</th>
				<td class="bdr">
					<select name="opentype1" id="opentype1" onchange="CategoryChange(this.value);"class="select_ty w100">
						<option value="전체">전체</option>
						<option value="의전팀장">의전팀장</option>
						<option value="협력업체">협력업체</option>
						<option value="기업담당자">기업담당자</option>
					</select>
				</td>
				<td>
					<span id="category2"></span>					
				</td>
			</tr>
			<tr>
				<th scope="row">제목</th>
				<td colspan="2"><input type="text" id="title" name="title" value="<%=subject %>" class="input_ty w100" placeholder="제목을 입력해주세요."></td>
			</tr>
			<tr>
				<th scope="row">작성자</th>
				<td class="bdr"><input type="text" id="writer" name="writer" value="<%=name %>" class="input_ty w100" placeholder="작성자명"></td>
				<td><input type="text" class="input_ty w100" value="<%=nowdate %>" disabled></td>
			</tr>
			<tr>
				<th scope="row" class="btnu">파일<!--a href="javascript:void(0);" onclick="alert('추후구현');" class="btn_ico ico05">파일첨부</a--></th>
				<td colspan="2">
					<div class="input_file">
						<input type="hidden" name="file_old" id="file_old" value="<%=filename %>">
						<input class="shw_file" value="파일선택" disabled>
						<input type="file" name="file" id="file" class="hid_file">
						<label for="file">업로드</label>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<textarea name="contents" id="contents" class="editor_holder2" style="width:100%; height:300px;"><%=contents %></textarea>
				</td>
			</tr>
		</tbody>
	</table><!--// form_ty -->
	</form>
	<div class="btm_btns sort05">
		<a href="javascript:void(0);" onclick="List();" class="btn_ty ty05 btn_b">리스트</a>
		<a href="javascript:void(0);" onclick="Update();" class="btn_ty btn_b">수정</a>
	</div><!--// btm_btns -->

</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->

<script type="text/javascript" src="/js/tiny_mce/tiny_mce_3.5b1/tiny_mce_src.js"></script>
<script type="text/javascript" src="/js/tiny_mce/board_tiny_layout.js"></script>
<script language="javascript" type="text/javascript">
	function List() {
		location.href = "notice_list.asp";
	}
	function Update() {

		var frm = document.frm_write;

		if (frm.title.value == "") {
			alert("제목을 입력해 주세요.");
			return false;
		}
		if (frm.writer.value == "") {
			alert("작성자를 입력해 주세요.");
			return false;
		}
		if (confirm("수정 하시겠습니까?")) {
			frm.submit();
		}
	}
	function CategoryChange(category) {

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "notice_category_ajax.asp", //요청을 보낼 서버의 URL
			data: { category: category }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				$("#category2").text("");
				$("#category2").html(data);
				//document.getElementById("opentype2").value = "<%=w_category2 %>";
			}
		});
	}

	/* 퍼블 추가 - 191210 */
	$(document).ready(function(){
		var fileTarget = $(".input_file .hid_file"); 
		
		fileTarget.on("change", function(){
			if(window.FileReader){
				var filename = $(this)[0].files[0].name; 
			} else {
				var filename = $(this).val().split('/').pop().split('\\').pop(); 
			}
			
			$(this).siblings(".shw_file").val(filename); 
		}); 
	});
</script>

<script language="javascript" type="text/javascript">
	CategoryChange("<%=opentype1 %>", "<%=opentype2 %>");
	document.getElementById("opentype1").value = "<%=opentype1 %>";
</script>