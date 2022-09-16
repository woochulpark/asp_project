<%
	code = Trim(request("Code"))
	code = FnAesDecrypt(code, AesEncryptPwd)
	
	if code = "" then 
		response.write "<script type='text/javascript'>"
		response.write "alert('잘못된 호출입니다.');"
		response.write "location.replace('/gate.asp');"
		response.write "</script>"	
		response.End
	end if

	SQL = "select a.행사번호, datediff(d, dateadd(m, -3, getdate()), a.시스템일자) as 등록일, j.등록일 as 서명일 "
	SQL = SQL & " from 행사마스터 a (nolock) "	
	SQL = SQL & "	left outer join 행사_회사지원서명 j (nolock) on a.행사번호 = j.행사번호 "
	SQL = SQL & " where  a.행사번호 = '" & code & "' "	

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)	

	If Rs.EOF Then
		stat = "a"
	Else		
		signchk = Rs("서명일")
		regdate = Rs("등록일")
	End If	

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing		

	if signchk <> "" and IsNull(signchk) = False then
		response.write "<script type='text/javascript'>"
		response.write "location.replace('/progression/progression_sign_b.asp?Code="& FnAesEncrypt(code, AesEncryptPwd) &"');"
		response.write "</script>"	
		response.End
	elseif regdate < 0 then
		response.write "<script type='text/javascript'>"
		response.write "alert('3개월 지난건("&regdate&").');"
		response.write "location.replace('/gate.asp');"
		response.write "</script>"	
		response.End
	elseif stat = "a" then
		response.write "<script type='text/javascript'>"
		response.write "alert('잘못된 호출입니다.');"
		response.write "location.replace('/gate.asp');"
		response.write "</script>"	
		response.End
	end if	
%>