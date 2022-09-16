<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/conf/dbmsConnect.asp"-->

<%
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadform.DefaultPath = "D:\iisroot\hs\fileupload\notice"

	Idx = uploadform("Idx")
	title = uploadform("title")
	writer = uploadform("writer")	
	file_old = uploadform("file_old")
	contents = uploadform("contents")
	opentype1 = uploadform("opentype1")
	opentype2 = uploadform("opentype2")
	opentype3 = uploadform("opentype3")

	if uploadform("file") = "" and file_old <> "" then
		file = file_old
	else
		if file_old <> "" then
			filepath = uploadform.DefaultPath & "\" & file_old
			uploadform.DeleteFile filepath
		end if

		uploadform("file").Save
		file = uploadform("file").FileName
	end if

	Set uploadform = Nothing

	SQL = " update 공지사항N "
	SQL = SQL & " set 작성자 = '"& writer &"', "
	SQL = SQL & " 제목 = '"& title &"', "
	SQL = SQL & " 내용 = '"& contents &"', "
	SQL = SQL & " 수정일 = getdate(), "
	SQL = SQL & " 파일 = '"& file &"', "
	SQL = SQL & " 파일경로 = '/fileupload/notice/', "
	SQL = SQL & " 게시분류1 = '"& opentype1 &"', "
	SQL = SQL & " 게시분류2 = '"& opentype2 &"', "
	SQL = SQL & " 상단고정 = '"& opentype3 &"' "
	SQL = SQL & " where 인덱스 = " & Idx

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	response.write "<script type='text/javascript'>"
	response.write "alert('수정되었습니다.');"
	response.write "location.replace('notice_list.asp?Idx="& Idx &"');"
	response.write "</script>"

	response.End

%>