<%
	protocol = "http://"
	If Request.ServerVariables("HTTPS") = "on" Then
		protocol = "https://"
	End If 
%>