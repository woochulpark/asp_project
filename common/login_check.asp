<%	
	dim user_idx, user_id, user_name

	'mbr_IP = Request.ServerVariables("REMOTE_ADDR")        

	'If mbr_IP <> "192.168.0.100" Then 
		'response.write "접근 권한이 없습니다.<br>"
		'response.write "해당 자리의 IP를 전달해 주세요."
		'response.End 
	'End If

	'response.Cookies("APLUS").domain = "apluselife.com"
	user_info = request.Cookies("APLUS")

	if (user_info <> "") And (Not isNull(user_info))  Then
		user_type = request.Cookies("APLUS")("type") '로그인타입
		user_typeame = request.Cookies("APLUS")("typename") '권한
		user_id	= request.Cookies("APLUS")("id") '사원코드
		user_name = request.Cookies("APLUS")("name") '사원명
		user_phone = request.Cookies("APLUS")("phone") '휴대폰
		user_authcode = request.Cookies("APLUS")("authcode") '권한코드
		user_bunbu = request.Cookies("APLUS")("bunbu") '본부
		user_center = request.Cookies("APLUS")("center") '센터
		user_etccode = request.Cookies("APLUS")("etccode") '기타코드
		
		user_groupname = request.Cookies("APLUS")("groupname") '단체명
		user_workplace = request.Cookies("APLUS")("workplace") '사업장

		user_board = request.Cookies("APLUS")("board")
		user_boardmax = request.Cookies("APLUS")("boardmax")
	Else
		response.Cookies("APLUS") = ""
		response.Write "<script>location.href='/gate.asp'</script>"
		response.End
	End if	
%>