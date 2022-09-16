<%@ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<%Response.Charset = "UTF-8" %>

<%

	Response.Expires = -1
	Response.Expiresabsolute = Now() - 1
	Response.AddHeader "pragma","no-cache"
	Response.AddHeader "chche-control", "private"
	Response.CacheControl = "no-cache"
	
	
	response.Cookies("APLUS").Path = "/"
	response.Cookies("APLUS") = ""
	response.Cookies("APLUS").Expires = Date - 1	

	'response.Redirect "/index.asp"
%>

<script>	
	location.href = "/gate.asp";
</script>