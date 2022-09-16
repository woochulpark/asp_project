<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	
		
    G_sabun    = trim(request("code"))
    helperCode = trim(request("hi_mgubun"))
    uname      = trim(request("hi_mname"))
    jum        = trim(request("hi_mjumin1")) & trim(request("hi_mjumin2"))  
    bnkNam     = trim(request("hi_mbank"))
    bnkCode    = trim(request("hi_mbankno"))
    bnkUser    = trim(request("hi_mbankname"))
    hp         = replace(trim(request("hi_mphone")),"-","")

	SQL = " exec p_행사도우미등록 'i', '"& helperCode &"', '"& uname &"', '"& jum &"', '"& G_sabun &"', '"& bnkNam &"', '"& bnkCode &"', '"& bnkUser &"','"& hp &"', '"& sabun &"','' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ	

    ConnAplus.execute(SQL)    

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	

	response.End	
%>
