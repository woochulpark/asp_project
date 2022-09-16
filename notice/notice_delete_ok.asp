<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/conf/dbmsConnect.asp"-->

<%
	Idx = Trim(request("Idx"))

	SQL = " delete 공지사항N "
	SQL = SQL & " where 인덱스 = " & Idx

	SQL2 = " select 파일 from 공지사항N "
	SQL2 = SQL2 & " where 인덱스 = " & Idx

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL2)

	If Rs.EOF Then		
	Else		
		filename = Rs("파일")		
	End If	

	ConnAplus.execute(SQL)

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing
	
	if filename <> "" then
		Set uploadform = Server.CreateObject("DEXT.FileUpload")
		uploadform.DefaultPath = "D:\iisroot\hs\file\notice"
		filepath = uploadform.DefaultPath & "\" & filename
		uploadform.DeleteFile filepath
		Set uploadform = Nothing
	end if	

	response.write "<script type='text/javascript'>"
	response.write "alert('삭제되었습니다.');"
	response.write "location.replace('notice_list.asp');"
	response.write "</script>"	

	response.End

%>