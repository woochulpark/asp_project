<%@ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/conf/dbmsConnect.asp"-->
<%
	input_id = Trim(request.Form("input_id"))
	input_pwd = Trim(request.Form("input_pwd"))
	input_type = Trim(request.Form("input_type"))

	'response.Write "input_id: " & input_id & "<br>"
	'response.Write "input_pwd: " & input_pwd & "<br>"
	'response.Write "input_type: " & input_type & "<br>"	

	'response.End	

	if input_type = "a" then
	'임직원
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
	elseif input_type = "b" then
	'의전팀장
		loginSQL = "select '의전팀장' 권한, a.사원코드, b.성함 사원명, b.연락처 휴대폰, b.코드 권한코드, b.본부, b.센터, '' as 기타코드 "
		loginSQL = loginSQL & "from 사원마스터v a (nolock) "
		loginSQL = loginSQL & "inner join 행사의전팀장 b (nolock) on a.사원코드 = b.라이프코드 "
		loginSQL = loginSQL & "where 1=1 "
		loginSQL = loginSQL & "and b.계약여부 = '계약' "
		loginSQL = loginSQL & "and a.사원코드 not in ('S1212272', 'A0090015', 'G1200001', 'S1211748', 'S1210382') "			
		loginSQL = loginSQL & "and a.사원코드 = '"& input_id &"' "
		loginSQL = loginSQL & "and PWDCOMPARE('"& input_pwd &"',a.암호화비번) = '1' "
	elseif input_type = "c" then
	'기업담당자
		loginSQL = "select '기업담당자' 권한, c.ID 사원코드, b.단체명 + c.사업장 사원명, c.핸드폰번호 휴대폰, c.ID 권한코드, '' as 본부, '' as 센터, b.단체코드 as 기타코드, b.단체명, c.사업장 "
		loginSQL = loginSQL & "from 법인마스터 a (nolock) "
		loginSQL = loginSQL & "inner join 행사단체 b (nolock) on a.행사단체 = b.단체코드 "
		loginSQL = loginSQL & "inner join 법인마스터_인력현황 c (nolock) on a.행사단체 = c.단체코드 "
		loginSQL = loginSQL & "where 1=1 "		
		loginSQL = loginSQL & "and c.ID = '"& input_id &"' "
		loginSQL = loginSQL & "and PWDCOMPARE('"& input_pwd &"',c.암호화비번) = '1' "	
	elseif input_type = "d" then
	'협력업체
		loginSQL = "select '협력업체' 권한, a.사업자번호 as 사원코드, b.성함 사원명, b.연락처 휴대폰, b.코드 권한코드, b.본부, b.센터, a.거래처코드 as 기타코드 "
		loginSQL = loginSQL & "from 의전거래처마스터 a (nolock)  "
		loginSQL = loginSQL & "inner join 행사의전팀장 b (nolock) on replace(a.거래처명, '(주)','') = b.성함 "
		loginSQL = loginSQL & "where 1=1 "
		loginSQL = loginSQL & "and b.계약여부 = '계약' "
		loginSQL = loginSQL & "and b.센터 = '꽃집' "
		loginSQL = loginSQL & "and a.거래처코드 not in ('100068') "
		loginSQL = loginSQL & "and a.사업자번호 = '"& input_id &"' "
		loginSQL = loginSQL & "and PWDCOMPARE('"& input_pwd &"',a.암호화비번) = '1' "
	end if	

	boardSQL = "select 임직원기본, 의전팀장기본, 협력업체기본, 기업담당자기본, 협력업체최고, 기업담당자최고, 임직원최고, 의전팀장최고 "
	boardSQL = boardSQL & "from 리스트조회기간 "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ
	
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

	If input_type = "a" Then
		board = boardA
		boardmax = boardAM
	ElseIf input_type = "b" Then
		board = boardB
		boardmax = boardBM
	ElseIf input_type = "c" Then
		board = boardC
		boardmax = boardCM
	Else
		board = boardD
		boardmax = boardDM
	End If

	Set Rs = ConnAplus.execute(loginSQL)

	If Rs.EOF Then
		Response.write "<script>alert('로그인에 실패하였습니다');location.href='/login/login.asp';</script>"
	Else
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

		if input_type = "c" then
			Response.Cookies("APLUS")("groupname") = Rs("단체명")
			Response.Cookies("APLUS")("workplace") = Rs("사업장")
		end if

		Response.write "<script>location.href='/main.asp';</script>"
	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	response.End

%>