
<!--#include virtual="/encrypt/FnAesEncrypt.asp"-->

<%
	code = request("Code")
	view_idx = request("view_idx")

	cond_enc = FnAesEncrypt(code, AesEncryptPwd)
	
	If view_idx = "2" Then
		response.redirect "/progression/progression_progress_erp.asp?Code=" & cond_enc
	Else
		response.redirect "reception_sign_erp.asp?Code=" & cond_enc
	End if
%>