<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	
		
    G_sabun    = trim(request("code"))											'사원코드
    helperCode = trim(request("hi_mgubun"))										'도우미구분
    uname      = trim(request("hi_mname"))										'성명
    jum        = trim(request("hi_mjumin1")) & trim(request("hi_mjumin2"))		'주민번호
    bnkNam     = trim(request("hi_mbank"))										'은행이름
    bnkCode    = trim(request("hi_mbankno"))									'계좌번호
    bnkUser    = trim(request("hi_mbankname"))									'예금주명
    hp         = replace(trim(request("hi_mphone")),"-","")						'휴대폰번호
	sabun      = user_id														'변경자
	memo	   = request("hi_memo")												'메모
	bankValid  = request("bankValid")


	SQL = " exec p_행사도우미등록 'i', '"& helperCode &"', '"& uname &"', '"& jum &"', '"& G_sabun &"', '"& bnkNam &"', '"& bnkCode &"', '"& bnkUser &"','"& hp &"', '"& sabun & "', '', '" & bankValid & "', '" & bnkUser & "', '" & memo & "' "
	'exec p_행사도우미등록 구분, 도우미구분, 도우미명, 주민번호, 도우미코드, 은행코드, 계좌번호, 예금주명, 휴대폰, 등록자, 지역, 검증, 검증예금주명, 특이사항
	'Response.write SQL


	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ	
    ConnAplus.execute(SQL)

	SQL_isExist = "select * "
	SQL_isExist = SQL_isExist & "from 행사사원계좌변경이력 (nolock) "
	SQL_isExist = SQL_isExist & "where 1=1 and 사원코드 = '" & G_sabun & "' and 은행코드 = '" & bnkNam & "' and 계좌번호 = '" & bnkCode & "' and 예금주명 = '" & bnkUser & "' "

	SQL_isExists = "IF NOT EXISTS(select * from 행사사원계좌변경이력 (nolock) "
	SQL_isExists = SQL_isExists & "where 1=1 and 사원코드='" & G_sabun & "' and 은행코드='" & bnkNam & "' and 계좌번호='" & bnkCode & "' and 예금주명= '" & bnkUser & "')"
	SQL_isExists = SQL_isExists & " BEGIN insert into 행사사원계좌변경이력(사원코드,  은행코드, 계좌번호, 예금주명, 검증, 검증예금주명, 등록자)"
	SQL_isExists = SQL_isExists & " values('" & G_sabun & "', '" & bnkNam & "', '" & bnkCode & "', '" & bnkUser & "', '" & bankValid & "', '" & bnkUser & "', '" & sabun & "') END"

	Response.write SQL_isExists
	ConnAplus.execute(SQL_isExists)

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	

	response.End	
%>
