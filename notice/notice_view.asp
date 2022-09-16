<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/conf/dbmsConnect.asp"-->
<%
	Idx = Trim(request("Idx"))
	page = Trim(request("page"))

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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="robots" content="noindex, nofollow" />
	<link href="/css/common.css" rel="stylesheet" type="text/css" />		
	<script type="text/javascript" src="/js/lib.js"></script>
	<script type="text/javascript" src="/js/jquery-1.7.2.min.js"></script>	
	<script language="javascript" type="text/javascript">
		function List() {
			location.href = "notice_list.asp?page=<%=page %>";
		}
		function Update() {
			location.href = "notice_update.asp?Idx=<%=Idx %>";
		}
		function Delete() {
			if(confirm("정말 삭제하시겠습니까?")){
				location.href = "notice_delete_ok.asp?Idx=<%=Idx %>";
			}		
		}
	</script>
</head>
<body>
<div id="container">
	
	<div id="body">        
		<div class="blockM">				
			<h3 class="sbj">공지사항</h3>

			<table class="Vtable alignL mb10" style="border:1px solid black;">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="17%" />
					<col width="33%" />
				</colgroup>
				<tr>
					<th>상단고정</th>
					<td colspan="3">
						<%=opentype3 %>
					</td>
				</tr>
				<tr>
					<th>게시분류</th>
					<td colspan="3"><%=opentype1 %> - <%=opentype2 %></td>
				</tr>
				<tr>
					<th>제목</th>
					<td colspan="3"><%=subject %></td>
				</tr>
				<tr>
					<th>작성자</th>
					<td><%=name %></td>
					<th>등록일</th>
					<td><%=r_date %></td>
				</tr>
				<tr>
					<th>파일</th>
					<td colspan="3"><%=filename %></td>
				</tr>
				<tr>
					<td colspan="4"><%=contents %></th>
				</tr>
			</table>
			<div>
				<input type="botton" onclick="List();" value="리스트" />
				<input type="botton" onclick="Update();" value="수정" />
				<input type="botton" onclick="Delete();" value="삭제" />				
			</div>			

		</div>
	</div>

</div>
</body>
</html>