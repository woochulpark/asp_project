<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%
	menu = "공지사항"	
	
	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	SQL = " select count(*) as count "
	SQL = SQL & " from 공지사항N "

	Set Rs = ConnAplus.execute(SQL)

	tCnt = Rs("count")

	'임시 협력업체-해당협력업체이름 또는 기업담당자-담당기업이름
	user_subname = ""

	if user_type = "b" then
		SQL_TXT = " and 게시분류1 in ('전체', '의전팀장') "
	elseif user_type = "c" then		
		SQL_TXT = " and (게시분류1 = '전체' or (게시분류1 = '기업담당자' and 게시분류2 in ('전체', '"& user_groupname & " " & user_workplace &"'))) "
	elseif user_type = "d" then		
		SQL_TXT = " and (게시분류1 = '전체' or (게시분류1 = '협력업체' and 게시분류2 in ('전체', '"& user_name &"'))) "
	else
		SQL_TXT = ""
	end if
	
	SQL = " select 인덱스,작성자,제목,내용,convert(varchar,등록일,102) as 등록일,파일,파일경로, 게시분류1, 게시분류2 "	
	SQL = SQL & " from 공지사항N "
	SQL = SQL & " where 상단고정 = 'N' "
	SQL = SQL & SQL_TXT
	SQL = SQL & " order by 인덱스 desc "
	
	
	SQL2 = " select 인덱스,작성자,제목,내용,convert(varchar,등록일,102) as 등록일,파일,파일경로,게시분류1,게시분류2 "
	SQL2 = SQL2 & " from 공지사항N "
	SQL2 = SQL2 & " where 상단고정 = 'Y' "	
	SQL2 = SQL2 & SQL_TXT
	SQL2 = SQL2 & " order by 인덱스 desc "	
		
	Set Rs = ConnAplus.execute(SQL)

	If Rs.EOF Then
		rc = 0		
	Else
		rc = Rs.RecordCount
		arrObj = Rs.GetRows(rc)
	End If	

	Set Rs = ConnAplus.execute(SQL2)

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
%>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->

	<ul class="noti_list">
<%
	if rc2 = 0 then
	else
		for i=0 to UBound(arrObj2,2)	
			idx			= arrObj2(0,i)
			name		= arrObj2(1,i)
			subject		= arrObj2(2,i)
			contents	= arrObj2(3,i)
			r_date		= arrObj2(4,i)
			filename	= arrObj2(5,i)
			filepath	= arrObj2(6,i)
			opentype1	= arrObj2(7,i)
			opentype2	= arrObj2(8,i)

			if opentype1 = "전체" then
				opentype2 = "전체"
			end if
%>
		<li class="top">
			<dl class="tit">
				<dt><%=subject %></dt>
				<dd>
					<span class="name"><%=name %></span><span class="date"><%=r_date %></span>		
				</dd>
		<%	if user_type = "a" then %>					
				<dd class="type"><span>[고정Y]</span><span>[<%=opentype1 %>-<%=opentype2 %>]</span></dd>
		<%	end if %>
			</dl><!--// tit -->
			<div class="cont">
				<%=contents %>
				<dl class="btm">
				<% if filename <> "" then %>
					<dt><a href="/file/download.asp?filepath=<%=filepath &filename %>" class="btn_ty ty02 btn_down">파일</a></dt>
				<% end if %>
		<%	if user_type = "a" then %>
					<dd>
						<a href="javascript:void(0);" onclick="Update(<%=idx %>);" class="btn_ty">수정</a>
						<a href="javascript:void(0);" onclick="Delete(<%=idx %>);" class="btn_ty ty06">삭제</a>
					</dd>
		<%	end if %>
				</dl><!--// btm -->
			</div><!--// cont -->
		</li>
<%
		next
	end if 
%>
<%
	if rc = 0 then 
%>						
		<li class="date_n">등록된 공지가 없습니다.</li>
<%
	else
		for i=0 to UBound(arrObj,2)			
			idx			= arrObj(0,i)
			name		= arrObj(1,i)
			subject		= arrObj(2,i)
			contents	= arrObj(3,i)
			r_date		= arrObj(4,i)
			filename	= arrObj(5,i)
			filepath	= arrObj(6,i)
			opentype1	= arrObj(7,i)
			opentype2	= arrObj(8,i)

			if opentype1 = "전체" then
				opentype2 = "전체"
			end if
%>
		<li>
			<dl class="tit">
				<dt><%=subject %></dt>
				<dd>
					<span class="name"><%=name %></span><span class="date"><%=r_date %></span>		
				</dd>
		<%	if user_type = "a" then %>
				<dd class="type"><span>[고정N]</span><span>[<%=opentype1 %>-<%=opentype2 %>]</span></dd>
		<%	end if %>
			</dl><!--// tit -->
			<div class="cont">
				<%=contents %>
				<dl class="btm">
				<% if filename <> "" then %>
					<dt><a href="/file/download.asp?filepath=<%=filepath %>&filename=<%=filename %>" target="_blank" class="btn_ty ty02 btn_down">파일</a></dt>
				<% end if %>
		<%	if user_type = "a" then %>
					<dd>
						<a href="javascript:void(0);" onclick="Update(<%=idx %>);" class="btn_ty">수정</a>
						<a href="javascript:void(0);" onclick="Delete(<%=idx %>);" class="btn_ty ty06">삭제</a>
					</dd>
		<%	end if %>
				</dl><!--// btm -->
			</div><!--// cont -->
		</li>				
<%
		next
	end if 
%>		
	</ul>
<% if user_type = "a" then %>	
	<div class="btm_btns">
		<a href="javascript:void(0);" onclick="Write();" class="btn_ty btn_b">공지사항등록</a>
	</div><!--// btm_btns -->
<% end if %>
</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->

<script language="javascript" type="text/javascript">
	$(function () {
		$(".noti_list > li > .tit").on("click", function () {
			if ($(this).parent().is(".view")) {
				$(this).parent().removeClass("view");
				$(this).parent().find(".cont").slideUp(400);
			} else {
				$(this).parent().addClass("view");
				$(this).parent().find(".cont").slideDown(400);
			}
		});
	});	
	function Update(idx) {
		location.href = "notice_update.asp?Idx=" + idx;
	}
	function Delete(idx) {
		if (!confirm("삭제 하시겠습니까?")) {
			return false;
		}
		location.href = "notice_delete_ok.asp?Idx=" + idx;
	}	
	function Write() {
		location.href = "notice_write.asp";
	}	
</script>