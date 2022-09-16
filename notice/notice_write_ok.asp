<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/conf/dbmsConnect.asp"-->

<%
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadform.DefaultPath = "D:\iisroot\hs\fileupload\notice"

	title = uploadform("title")
	writer = uploadform("writer")
	'file = uploadform("file")
	contents = uploadform("contents")
	opentype1 = uploadform("opentype1")
	opentype2 = uploadform("opentype2")
	opentype3 = uploadform("opentype3")
	
	uploadform("file").Save
	file = uploadform("file").FileName

	Set uploadform = Nothing

	if opentype1 = "전체" or opentype1 = "의전팀장" then
		opentype2 = "전체"
	end if

	SQL = " INSERT INTO 공지사항N (작성자, 제목, 내용, 등록일, 수정일, 파일, 파일경로, 게시분류1, 게시분류2, 상단고정 "
	SQL = SQL & " ) values ( "
	SQL = SQL & " '"& writer &"','"& title &"','"& contents &"', getdate(),getdate(),'"& file &"','/fileupload/notice/', '"& opentype1 &"', '"& opentype2 &"', '"& opentype3 &"' ) "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	response.write "<script type='text/javascript'>"
	response.write "alert('등록되었습니다.');"
	response.write "location.replace('notice_list.asp');"
	response.write "</script>"

	response.End

%>