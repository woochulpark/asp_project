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
        helperCode = Trim(request("hi_mgubun"))
        uname      = Trim(request("hi_mname"))
        jum        = Trim(request("hi_mjumin1")) & trim(request("hi_mjumin2"))  
        bnkNam     = Trim(request("hi_mbank"))
        bnkCode    = Trim(request("hi_mbankno"))
        bnkUser    = Trim(request("hi_mbankname"))
        hp         = Trim(replace(trim(request("hi_mphone")),"-",""))
        sabun      = user_id

		bankName   = Trim(request("bankName")
		bankValid  = Trim(request("bankValid")

        SQL = " exec p_행사도우미등록 'i', '" & helperCode & "', '" & uname & "', '" & jum & "', '" & G_sabun & "', '" & bnkNam & "', '" & bnkCode & "', '" & bnkUser & "','" & hp & "', '" & sabun & "', '', '" & bankName & "', '" & bankValid & "' " 
		'exec p_행사도우미등록 구분, 도우미구분, 도우미명, 주민번호, 도우미코드, 은행코드, 계좌번호, 예금주명, 휴대폰, 등록자, 지역, 검증, 검증예금주명
		
        ConnAplus.execute(SQL)
		
		Response.write SQL
		Response.Write "ok"        
        
    End If

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	

	response.End	
%>
