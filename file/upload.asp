<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check2.asp"-->

<%
	b_type1 = Trim(request("b_type1"))
	b_type2 = Trim(request("b_type2"))
	b_idx = Trim(request("b_idx"))	

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	SQL = " select 파일명, 파일경로 "
	SQL = SQL & " from 파일저장 "
	SQL = SQL & " where 게시판종류 = '"& b_type1 &"' and 게시판종류2 = '"& b_type2 &"' and 게시판인덱스 = '"& b_idx &"' "
	SQL = SQL & " order by 인덱스 asc "

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
%>


<div class="lypB">
	<form name="frm_write" id="frm_write" target="file_upload" method="post" action="/file/upload_ok.asp" enctype="multipart/form-data">

		<input type="hidden" name="b_type1" value="<%=b_type1 %>" />
		<input type="hidden" name="b_type2" value="<%=b_type2 %>" />
		<input type="hidden" name="b_idx" value="<%=b_idx %>" />

		<div class=" lyp_imgs">
<%
	if rc = 0 then
	else
		for i=0 to UBound(arrObj,2)
			filename		= arrObj(0,i)
			filepath		= arrObj(1,i)
%>

			<div class="filebox preview-image">
				<div class="upload-display">
					<img id="img<%=i +1 %>" src="<%=filepath&filename %>" class="upload-thumb">
				</div>
				<input type="hidden" name="file_old<%=i + 1 %>" id="file_old<%=i + 1 %>" value="<%=filename %>">
				<div class="btns">
					<input type="file" name="file<%=i + 1 %>" id="file<%=i + 1 %>" class="upload-hidden">
					<label for="file<%=i + 1 %>" class="btn_ty">파일찾기</label>
					<button onclick="del('<%=i + 1 %>');return false;" class="btn_ty ty06">삭제</button>
				</div>
			</div>

<%
		next
	end if 

	for k=i to 9
%>
			<div class="filebox preview-image">
				<div class="upload-display">
					<img id="img<%=k +1 %>" src="/images/default.png" class="upload-thumb">
				</div>
				<input type="hidden" name="file_old<%=k + 1 %>" id="file_old<%=k + 1 %>">
				<div class="btns">
					<input type="file" name="file<%=k + 1 %>" id="file<%=k + 1 %>" class="upload-hidden">
					<label for="file<%=k + 1 %>" class="btn_ty">파일찾기</label>
					<button onclick="del('<%=k + 1 %>');return false;" class="btn_ty ty06">삭제</button>
				</div>
			</div>
<%
	next
%>
		</div><!--// lyp_imgs -->
	</form>
</div><!--// lypB -->
<iframe width="0" height="0" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" name="file_upload"></iframe>
<p class="lyp_noti">※ 최대 <span>10</span>장까지 첨부가능</p>
<div class="btm_btns">
	<button onclick="filesave();" class="btn_ty btn_b">저장</button>
</div><!--// btm_btns -->

<script language="javascript" type="text/javascript">
	var defaultImg = "/images/default.png"
	var imgTarget = $('.preview-image .upload-hidden');
	imgTarget.on('change', function () {
		var parent = $(this).parent().parent();
		parent.find('img')[0].src = defaultImg;

		if (window.FileReader) {
			//image 파일만 
			if (!$(this)[0].files[0].type.match(/image\//)) {
				return;
			}
			var reader = new FileReader();
			reader.onload = function (e) {
				var src = e.target.result;
				parent.find('img')[0].src = src;
			}
			reader.readAsDataURL($(this)[0].files[0]);
		} else {
			$(this)[0].select();
			$(this)[0].blur();
			var imgSrc = document.selection.createRange().text;
			var img = $(this).siblings('.upload-display').find('img');
			img[0].style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enable='true',sizingMethod='scale',src=\"" + imgSrc + "\")";
		}
	});
	function filesave() {
		//alert($("#file1").val());
		if (!confirm('저장하시겠습니까?')) {
			return false;
		}
		document.frm_write.submit();
	}
	function del(idx) {
		$("#img" + idx).attr("src", defaultImg);
		$("#file_old" + idx).val('');

		var agent = navigator.userAgent.toLowerCase();
		if ((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1)) {
			// ie 일때 input[type=file] init.
			$("#file" + idx).replaceWith($("#excelFile").clone(true));
		} else {
			//other browser 일때 input[type=file] init.
			$("#file" + idx).val("");
		}
		return false;

	}
</script>
