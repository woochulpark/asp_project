<%@ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/conf/dbmsConnect.asp"-->

<%
	'http://hs.apluslife.co.kr/login/login_erp.asp?input_id=s1211059&input_menu=input_1&Code=2022021100027
	
	input_id = Request("input_id")	
	input_menu = Request("input_menu")
	code = Request("code")

	if input_menu = "input_1" Then
		url = "http://hs.apluslife.co.kr/reception/reception_info.asp" & "?Code=" & Code
	ElseIf input_menu = "input_2" Then
		url = "http://hs.apluslife.co.kr/progression/progression_progress.asp" & "?Code=" & Code
	ElseIf input_menu = "input_3" Then
		url = "http://hs.apluslife.co.kr/calculation/calculation_info.asp" & "?Code=" & Code
    Else
		url = "http://hs.apluslife.co.kr/main.asp"
	End If
	
	input_type = "a"
	
%>

<script type="text/javascript" language="javascript">
	
	if(navigator.userAgent.indexOf("Trident") > 0){		
		var url = 'http://hs.apluslife.co.kr/login/login_erp.asp?input_id=<%=input_id%>&input_menu=<%=input_menu%>&Code=<%=Code%>';
		window.location = 'microsoft-edge:' + url;
		setTimeout(close);
	}
    //window.close();
</script>

<%

	input_pwd = ""

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ
	
	pwSQL = " select 비밀번호 from 사원마스터 (nolock) where 재직구분 = '재직' and 사원코드 = '"& input_id &"' "
	Set Rs = ConnAplus.execute(pwSQL)
	If Not Rs.EOF Then
		input_pwd = Rs("비밀번호")
	End If
	
	loginSQL = "select '임직원' 권한, 사원코드, 사원명, 휴대폰, '' as 권한코드, '' as 본부, '' as 센터, '' as 기타코드 "
	loginSQL = loginSQL & "from 사원마스터v a (nolock) "
	loginSQL = loginSQL & "where 1=1 "
	loginSQL = loginSQL & "and a.본부명 in ( '본사', '셀뱅킹대리점') "
	loginSQL = loginSQL & "and a.지사명 in ( '본사', '의전임직원', '효담라이프케어') "
	loginSQL = loginSQL & "and isnull(a.퇴사일자,'') = '' "	
	loginSQL = loginSQL & "and a.재직구분 = '재직' "
	loginSQL = loginSQL & "and a.사원코드 not in ('S1210368', 'S1212773', 'S1203692', 'S1201219', 'S1210369', 'A0110017', 'S1212591') "
	loginSQL = loginSQL & "and a.소속직급명 in ('임직원', '지점총무', '대표이사') "	
	loginSQL = loginSQL & "and a.사원코드 = '"& input_id &"' "	
	loginSQL = loginSQL & "and PWDCOMPARE('"& input_pwd &"',a.암호화비번) = '1' "

	'Response.write "<script>alert('a1');</script>"

	boardSQL = "select 임직원기본, 의전팀장기본, 협력업체기본, 기업담당자기본, 협력업체최고, 기업담당자최고, 임직원최고, 의전팀장최고 "
	boardSQL = boardSQL & "from 리스트조회기간 "

	Set Rs = ConnAplus.execute(boardSQL)

	If Rs.EOF Then
		boardA = 30
		boardB = 30
		boardC = 30
		boardD = 30
		boardAM = 0
		boardBM = 0
		boardCM = 3
		boardDM = 3
	Else
		boardA = Rs("임직원기본")
		boardB = Rs("의전팀장기본")
		boardC = Rs("협력업체기본")
		boardD = Rs("기업담당자기본")
		boardAM = Rs("임직원최고")
		boardBM = Rs("의전팀장최고")
		boardCM = Rs("협력업체최고")
		boardDM = Rs("기업담당자최고")
	End If
	
	board = boardA
	boardmax = boardAM
	
	'Response.write "<script>alert('a2');</script>"

	Set Rs = ConnAplus.execute(loginSQL)

	If Rs.EOF Then
		'Response.write "<script>alert('a3');</script>"
		Response.write "<script>alert('로그인에 실패하였습니다');location.href='/login/login.asp';</script>"
	Else
		'Response.write "<script>alert('a4');</script>"
		Response.Cookies("APLUS")("type") = input_type
		Response.Cookies("APLUS")("typename") = Rs("권한")
		Response.cookies("APLUS")("id") = Rs("사원코드")
		Response.cookies("APLUS")("name") = Rs("사원명")
		Response.cookies("APLUS")("phone") = Rs("휴대폰")
		Response.Cookies("APLUS")("authcode") = Rs("권한코드")
		Response.Cookies("APLUS")("bunbu") = Rs("본부")
		Response.Cookies("APLUS")("center") = Rs("센터")
		Response.Cookies("APLUS")("etccode") = Rs("기타코드")
		
		Response.Cookies("APLUS")("board") = board
		Response.Cookies("APLUS")("boardmax") = boardmax

%>		
		<script>location.href="<%=url%>";</script>
<%
		
	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	response.End

%>
