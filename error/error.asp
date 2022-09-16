<%@Language="VBSCRIPT"%>
<%
  Option Explicit
  On Error Resume Next
  Response.Clear
  Dim objError
  Set objError = Server.GetLastError()
%>
<html>
<head>
<title>ASP 500 Error</title>
<style>
BODY  { FONT-FAMILY: Arial; FONT-SIZE: 10pt;
        BACKGROUND: #ffffff; COLOR: #000000;
        MARGIN: 15px; }
H2    { FONT-SIZE: 16pt; COLOR: #ff0000; }
TABLE { BACKGROUND: #000000; PADDING: 5px; }
TH    { BACKGROUND: #0000ff; COLOR: #ffffff; }
TR    { BACKGROUND: #cccccc; COLOR: #000000; }
</style>
</head>
<body>

<h2 align="center">ASP 500 Error</h2>

<p align="center">An error occurred processing the page you requested.<br>
Please see the details below for more information.</p>

<div align="center"><center>

<table>
<% If Len(CStr(objError.ASPCode)) > 0 Then %>
  <tr>
    <th nowrap align="left" valign="top">IIS Error Number</th>
    <td align="left" valign="top"><%=objError.ASPCode%></td>
  </tr>
<% End If %>
<% If Len(CStr(objError.Number)) > 0 Then %>
  <tr>
    <th nowrap align="left" valign="top">COM Error Number</th>
    <td align="left" valign="top"><%=objError.Number%>
    <%=" (0x" & Hex(objError.Number) & ")"%></td>
  </tr>
<% End If %>
<% If Len(CStr(objError.Source)) > 0 Then %>
  <tr>
    <th nowrap align="left" valign="top">Error Source</th>
    <td align="left" valign="top"><%=objError.Source%></td>
  </tr>
<% End If %>
<% If Len(CStr(objError.File)) > 0 Then %>
  <tr>
    <th nowrap align="left" valign="top">File Name</th>
    <td align="left" valign="top"><%=objError.File%></td>
  </tr>
<% End If %>
<% If Len(CStr(objError.Line)) > 0 Then %>
  <tr>
    <th nowrap align="left" valign="top">Line Number</th>
    <td align="left" valign="top"><%=objError.Line%></td>
  </tr>
<% End If %>
<% If Len(CStr(objError.Description)) > 0 Then %>
  <tr>
    <th nowrap align="left" valign="top">Brief Description</th>
    <td align="left" valign="top"><%=objError.Description%></td>
  </tr>
<% End If %>
<% If Len(CStr(objError.ASPDescription)) > 0 Then %>
  <tr>
    <th nowrap align="left" valign="top">Full Description</th>
    <td align="left" valign="top"><%=objError.ASPDescription%></td>
  </tr>
<% End If %>
</table>

</center></div>

</body>
</html>
