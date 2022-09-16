<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check2.asp"-->

<%
	filename = Trim(request("filename"))
%>


<div class="lypB">
	<div class="img_vp">
		<img src="<%=filename%>">
	</div><!--// img_vp -->
</div><!--// lypB -->