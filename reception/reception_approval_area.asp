<%	
	SQL = "select 상태 from 행사_승인요청 where 행사번호 = '"& code &"' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)	

	If Rs.EOF Then
		hangsa_stat = ""
	Else		
		hangsa_stat = Rs("상태")
	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	if user_type = "a" then
		if hangsa_stat = "진행승인요청" then
%>
			<div><input type="button" value="진행승인확인" onclick="ApprovalOK('<%=code %>');" /></div><br />
<%
		end if
	else
		if hangsa_stat = "" then	
%>
			<div><input type="button" value="진행승인요청" onclick="Approval('<%=code %>');" /></div><br />
<%
		end if
	end if
%>
