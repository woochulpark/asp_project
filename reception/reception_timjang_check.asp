<%
	code = Trim(request("Code"))	

	SQL = "select 진행팀장 from 행사마스터 where 행사번호 = '"& code &"' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)	

	If Rs.EOF Then
		hangsa_tj = ""
	Else		
		hangsa_tj = Rs("진행팀장")
	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	

	' 의전팀장이 배정되지 않으면 기본정보로 보낸다.
	if hangsa_tj = "" then
		response.write "<script type='text/javascript'>"
		response.write "alert('의전팀장이 배정되지 않았습니다.');"
		response.write "location.replace('reception_info.asp?Code="& code &"');"
		response.write "</script>"
	end if	
%>