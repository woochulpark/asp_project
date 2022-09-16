<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ	

	SQL = "exec P_사번채번 '도우미'"
	ConnAplus.execute(SQL)    

    SQL = "select 번호 from 채번마스터 where 업무구분 = '사원코드' and 시작문자 = 'G'"
    Set rs = ConnAplus.execute(SQL)	

    If rs.bof Or rs.eof Then        
	    response.Write "error"
    Else
        G_sabun    = "G"+rs("번호") '도우미 사번신규 생성
        helperCode = trim(request("hi_mgubun"))
        uname      = trim(request("hi_mname"))
        jum        = trim(request("hi_mjumin1")) & trim(request("hi_mjumin2"))  
        bnkNam     = trim(request("hi_mbank"))
        bnkCode    = trim(request("hi_mbankno"))
        bnkUser    = trim(request("hi_mbankname"))
        hp         = Trim(replace(trim(request("hi_mphone")),"-",""))
        sabun      = user_id
		memo = request("hi_memo")

        bankValid  = trim(request("bankValid"))
        bankName   = trim(request("bankName"))

        SQL = " exec p_행사도우미등록 'i', '" & helperCode & "', '" & uname & "', '" & jum & "', '" & G_sabun & "', '" & bnkNam & "', '" & bnkCode & "', '" & bnkUser & "','" & hp & "', '" & sabun & "', '', '" & bankValid & "', '" & bankName & "', '" & memo & "' " 
		'exec p_행사도우미등록 구분, 도우미구분, 도우미명, 주민번호, 도우미코드, 은행코드, 계좌번호, 예금주명, 휴대폰, 등록자, 지역, 검증, 검증예금주명, 특이사항
        ConnAplus.execute(SQL)
		Response.write SQL

		SQL_record = "insert into 행사사원계좌변경이력(사원코드,  은행코드, 계좌번호, 예금주명, 검증, 검증예금주명, 등록자)"
		SQL_record = SQL_record & " values('" & G_sabun & "', '" & bnkNam & "', '" & bnkCode & "', '" & bnkUser & "', '" & bankValid & "', '" & bankName & "', '" & sabun & "')"
		Response.write SQL_record
		ConnAplus.execute(SQL_record)
		
		response.Write "ok"        
        
    End If

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	

	response.End	
%>
