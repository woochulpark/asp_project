<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<%
Response.Buffer = False
filepath = Request("filepath")
filename = Request("filename")

Set objDownload = Server.CreateObject("DEXT.FileDownload")
objDownload.Download filepath & filename
Set uploadform = Nothing
%>