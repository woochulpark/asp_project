<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D" NAME="CDO for Windows 2000 Type Library" -->
<!--METADATA TYPE= "typelib" NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll" -->
<!--METADATA TYPE="typelib" NAME= "ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4"-->

<%
	'''''''''''''''''''''''''
	'	dbms 연결정보 설정	'
	'''''''''''''''''''''''''
	Dim DBMS_IP			' dbms 아이피
	Dim DBMS_PORT		' dbms 포트

	Dim CONN_DB			' 접속 데이타베이스
	Dim CONN_ID			' 접속 아이디
	Dim CONN_PW			' 접속 비밀번호

	DIM CONN_OBJ		' dbms 연결

	Dim OBJ_CONN1		' 연결 객체1
	Dim OBJ_CONN2		' 연결 객체2
	Dim OBJ_CONN3		' 연결 객체3
	Dim OBJ_CONN4		' 연결 객체4
	Dim OBJ_CONN5		' 연결 객체5
	Dim OBJ_CONN6		' 연결 객체6

	Dim OBJ_RS1			' 데이타 객체1
	Dim OBJ_RS2			' 데이타 객체2
	Dim OBJ_RS3			' 데이타 객체3
	Dim OBJ_RS4			' 데이타 객체4
	Dim OBJ_RS5			' 데이타 객체5
	Dim OBJ_RS6			' 데이타 객체6


%>
<%
	'''''''''''''''''''''''''
	'	공통 Login dbms 연결정보 설정	'
	'''''''''''''''''''''''''
	' local
	DBMS_IP = "172.17.254.15"
	DBMS_PORT = "1433"
	CONN_DB = "LifeERP"
	CONN_ID = "AplusErp"
	CONN_PW = "dldkfvl667@#"	

	'DBMS_IP = "172.17.254.15"
	'DBMS_PORT = "1433"
	'CONN_DB = "LifeERP_20191202"
	'CONN_ID = "AplusErp"
	'CONN_PW = "dldkfvl667@#"

	' live
	'DBMS_IP = "211.235.198.66"		
	'DBMS_PORT = "1433"
	'CONN_DB = "DB_BIP_MGT"
	'CONN_ID = "USER_BIP_MGT"
	'CONN_PW = "xhdrPvpdlwl~!"

	CONN_OBJ = "Provider=SQLOLEDB.1;Password=" & CONN_PW & ";User ID=" & CONN_ID & ";Initial Catalog=" & CONN_DB & ";Data Source=" & DBMS_IP & "," & DBMS_PORT
%>



<%
Dim rs, conn, cmd
'----------------------------------------------------------------------------------------- ' DB Handling 관련
Sub OpenDBConnection(ByVal m_strcon)
	Set conn = Server.CreateObject("ADODB.Connection")
	conn.Open m_strcon
End Sub

Sub CloseDBConnection
	conn.Close
	Set conn = Nothing
End Sub

Sub OpenDBRecordSet
	Set rs = Server.CreateObject("ADODB.RecordSet")
	rs.CursorLocation=adUseClient
End Sub

Sub OpenDBRecordSet1
	Set rs = Server.CreateObject("ADODB.RecordSet")
End Sub

Sub CloseDBRecordSet
	rs.Close
	Set rs = Nothing
End Sub

Sub CloseDBRecordSet1
	Set rs = Nothing
End Sub

Sub OpenDBCommand
	set cmd=Server.CreateObject("ADODB.Command")
End Sub

Sub CloseDBCommand
	set cmd.ActiveConnection = Nothing
	set cmd=Nothing
End Sub
'----------------------------------------------------------------------------------------- ' HTML 태그 및 코드제어 관련
Function SI(byVal str)
	str = Replace(str,"'","''")
	SI = Str
End Function

' HTML 효과
Function CheckHTML(CheckValue)
	CheckValue = replace(CheckValue, "&lt", "&#38&#108&#116")
	CheckValue = replace(CheckValue, "&gt", "&#38&#103&#116")
	CheckValue = replace(CheckValue, "&Lt", "&#38&#76&#116")
	CheckValue = replace(CheckValue, "&Gt", "&#38&#71&#116")
	CheckValue = replace(CheckValue, "&lT", "&#38&#108&#84")
	CheckValue = replace(CheckValue, "&gT", "&#38&#103&#84")
	CheckValue = replace(CheckValue, "&LT", "&#38&#76&#84")
	CheckValue = replace(CheckValue, "&GT", "&#38&#71&#84")
	CheckHTML = CheckValue
End Function

Function CheckTag(CheckValue)
	CheckValue = replace(CheckValue, "&", "&amp;")
	CheckValue = replace(CheckValue, "<", "&lt;")
	CheckValue = replace(CheckValue, ">", "&gt;")
	CheckValue = replace(CheckValue, "'", "&quot;")
	CheckValue = replace(CheckValue, """", "&#34;")
	CheckValue = replace(CheckValue, " ", "&nbsp;")

	CheckValue = replace(CheckValue, "%", "")
	CheckValue = replace(CheckValue,"(select;)","")
	CheckValue = replace(CheckValue,"(insert;)","")
	CheckValue = replace(CheckValue,"(delete;)","")
	CheckValue = replace(CheckValue,"(drop;)","")
	CheckValue = replace(CheckValue,"(script;)","")
	CheckValue = replace(CheckValue,"(union;)","")

	CheckValue = Replace(CheckValue,"<html", "&lt;html")
	CheckValue = Replace(CheckValue,"</html", "&lt;/html")
	CheckValue = Replace(CheckValue,"<a", "&lt;a")
	CheckValue = Replace(CheckValue,"</a", "&lt;/a")
	CheckValue = Replace(CheckValue,"<input", "&lt;input")
	CheckValue = Replace(CheckValue,"<bgsound", "&lt;bgsound")
	CheckValue = Replace(CheckValue,"<script","&lt;script")
	CheckValue = Replace(CheckValue,"</script","&lt;/script")
	CheckValue = Replace(CheckValue,"<iframe", "&lt;iframe")
	CheckValue = Replace(CheckValue,"</iframe", "&lt;/iframe")
	CheckValue = Replace(CheckValue,"<meta", "&lt;meta")
	CheckValue = Replace(CheckValue,"<body", "&lt;body")
	CheckValue = Replace(CheckValue,"</body", "&lt;/body")
	CheckValue = Replace(CheckValue,"<object", "&lt;object")
	CheckValue = Replace(CheckValue,"</object", "&lt;/object")
	CheckValue = Replace(CheckValue,"<param", "&lt;param")
	CheckValue = Replace(CheckValue,"<xml", "&lt;xml")
	CheckValue = Replace(CheckValue,"</xml", "&lt;/xml")

	CheckValue = replace(CheckValue,"(\|\'|#|\/\*|\*\/|\\\|\;)","")

	CheckTag = CheckValue
End Function

Function CheckQuotation(CheckValue)
	arrCheckValue = Split(CheckValue, "<")
	For i = 1 To UBound(arrCheckValue)
		If LCase(Left(arrCheckValue(i), 4)) = "html" Then
			CheckValue = Replace(CheckValue,"<"&Left(arrCheckValue(i), 4)&"", "&lt;"&Left(arrCheckValue(i), 4)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 5)) = "table" Then
			CheckValue = Replace(CheckValue,"<"&Left(arrCheckValue(i), 5)&"", "&lt;"&Left(arrCheckValue(i), 5)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 2)) = "tr" Then
			CheckValue = Replace(CheckValue,"<"&Left(arrCheckValue(i), 2)&"", "&lt;"&Left(arrCheckValue(i), 2)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 2)) = "td" Then
			CheckValue = Replace(CheckValue,"<"&Left(arrCheckValue(i), 2)&"", "&lt;"&Left(arrCheckValue(i), 2)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 7)) = "bgsound" Then
			CheckValue = Replace(CheckValue,"<"&Left(arrCheckValue(i), 7)&"", "&lt;"&Left(arrCheckValue(i), 7)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 6)) = "script" Then
			CheckValue = Replace(CheckValue,"<"&Left(arrCheckValue(i), 6)&"", "&lt;"&Left(arrCheckValue(i), 6)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 6)) = "iframe" Then
			CheckValue = Replace(CheckValue,"<"&Left(arrCheckValue(i), 6)&"", "&lt;"&Left(arrCheckValue(i), 6)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 4)) = "body" Then
			CheckValue = Replace(CheckValue,"<"&Left(arrCheckValue(i), 4)&"", "&lt;"&Left(arrCheckValue(i), 4)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 5)) = "tbody" Then
			CheckValue = Replace(CheckValue,"<"&Left(arrCheckValue(i), 4)&"", "&lt;"&Left(arrCheckValue(i), 4)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 6)) = "object" Then
			CheckValue = Replace(CheckValue,"<"&Left(arrCheckValue(i), 6)&"", "&lt;"&Left(arrCheckValue(i), 6)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 5)) = "param" Then
			CheckValue = Replace(CheckValue,"<"&Left(arrCheckValue(i), 5)&"", "&lt;"&Left(arrCheckValue(i), 5)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 3)) = "xml" Then
			CheckValue = Replace(CheckValue,"<"&Left(arrCheckValue(i), 3)&"", "&lt;"&Left(arrCheckValue(i), 3)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 3)) = "img" Then
			CheckValue = Replace(CheckValue,"<"&Left(arrCheckValue(i), 3)&"", "&lt;"&Left(arrCheckValue(i), 3)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 3)) = "div" Then
			CheckValue = Replace(CheckValue,"<"&Left(arrCheckValue(i), 3)&"", "&lt;"&Left(arrCheckValue(i), 3)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 1)) = "a" Then
			CheckValue = Replace(CheckValue,"<"&Left(arrCheckValue(i), 3)&"", "&lt;"&Left(arrCheckValue(i), 3)&"")
		End If
	Next
	arrCheckValue = Split(CheckValue, "</")
	For i = 1 To UBound(arrCheckValue)
		If LCase(Left(arrCheckValue(i), 4)) = "html" Then
			CheckValue = Replace(CheckValue,"</"&Left(arrCheckValue(i), 4)&"", "&lt;/"&Left(arrCheckValue(i), 4)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 5)) = "table" Then
			CheckValue = Replace(CheckValue,"</"&Left(arrCheckValue(i), 5)&"", "&lt;/"&Left(arrCheckValue(i), 5)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 2)) = "tr" Then
			CheckValue = Replace(CheckValue,"</"&Left(arrCheckValue(i), 2)&"", "&lt;/"&Left(arrCheckValue(i), 2)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 2)) = "td" Then
			CheckValue = Replace(CheckValue,"</"&Left(arrCheckValue(i), 2)&"", "&lt;/"&Left(arrCheckValue(i), 2)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 7)) = "bgsound" Then
			CheckValue = Replace(CheckValue,"</"&Left(arrCheckValue(i), 7)&"", "&lt;/"&Left(arrCheckValue(i), 7)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 6)) = "script" Then
			CheckValue = Replace(CheckValue,"</"&Left(arrCheckValue(i), 6)&"", "&lt;/"&Left(arrCheckValue(i), 6)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 6)) = "iframe" Then
			CheckValue = Replace(CheckValue,"</"&Left(arrCheckValue(i), 6)&"", "&lt;/"&Left(arrCheckValue(i), 6)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 4)) = "body" Then
			CheckValue = Replace(CheckValue,"</"&Left(arrCheckValue(i), 4)&"", "&lt;/"&Left(arrCheckValue(i), 4)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 5)) = "tbody" Then
			CheckValue = Replace(CheckValue,"</"&Left(arrCheckValue(i), 4)&"", "&lt;/"&Left(arrCheckValue(i), 4)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 6)) = "object" Then
			CheckValue = Replace(CheckValue,"</"&Left(arrCheckValue(i), 6)&"", "&lt;/"&Left(arrCheckValue(i), 6)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 5)) = "param" Then
			CheckValue = Replace(CheckValue,"</"&Left(arrCheckValue(i), 5)&"", "&lt;/"&Left(arrCheckValue(i), 5)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 3)) = "xml" Then
			CheckValue = Replace(CheckValue,"</"&Left(arrCheckValue(i), 3)&"", "&lt;/"&Left(arrCheckValue(i), 3)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 3)) = "div" Then
			CheckValue = Replace(CheckValue,"</"&Left(arrCheckValue(i), 3)&"", "&lt;/"&Left(arrCheckValue(i), 3)&"")
		ElseIf  LCase(Left(arrCheckValue(i), 1)) = "a" Then
			CheckValue = Replace(CheckValue,"</"&Left(arrCheckValue(i), 3)&"", "&lt;/"&Left(arrCheckValue(i), 3)&"")
		End If
	Next

	CheckValue = replace(CheckValue, "'", "&apos;")
	CheckValue = replace(CheckValue, """", "&quot;")
	CheckValue = Trim(Replace(CheckValue, "|", "&#124;"))

'	CheckValue = LCase(CheckValue)
'	CheckValue = replace(CheckValue, "&amp;" , "&")
'	CheckValue = replace(CheckValue, "&lt;" , "<")
'	CheckValue = replace(CheckValue, "&gt;" , ">")
'	CheckValue = replace(CheckValue, "&quot;", "'")
'	CheckValue = replace(CheckValue, "&#34;", """")
'	CheckValue = Replace(CheckValue,"<script","&lt;script")
'	CheckValue = Replace(CheckValue,"</script","&lt;/script")
'	CheckValue = Replace(CheckValue,"<a","&lt;a")
'	CheckValue = Replace(CheckValue,"</a","&lt;/a")
'	CheckValue = Replace(CheckValue,"<iframe","&lt;iframe")
'	CheckValue = Replace(CheckValue,"</iframe","&lt;/iframe")

'	CheckValue = Replace(CheckValue,"</html", "&lt;/html")
'	CheckValue = Replace(CheckValue,"<table", "&lt;table")
'	CheckValue = Replace(CheckValue,"</table", "&lt;/table")
'	CheckValue = Replace(CheckValue,"<tr", "&lt;tr")
'	CheckValue = Replace(CheckValue,"</tr", "&lt;/tr")
'	CheckValue = Replace(CheckValue,"<td", "&lt;td")
'	CheckValue = Replace(CheckValue,"</td", "&lt;/td")
'	CheckValue = Replace(CheckValue,"<a", "&lt;a")
'	CheckValue = Replace(CheckValue,"</a", "&lt;/a")
'	CheckValue = Replace(CheckValue,"<img", "&lt;img")
'	CheckValue = Replace(CheckValue,"<input", "&lt;input")
'	CheckValue = Replace(CheckValue,"<bgsound", "&lt;bgsound")
'	CheckValue = Replace(CheckValue,"<script","&lt;script")
'	CheckValue = Replace(CheckValue,"</script","&lt;/script")
'	CheckValue = Replace(CheckValue,"<link", "&lt;link")
'	CheckValue = Replace(CheckValue,"<iframe", "&lt;iframe")
'	CheckValue = Replace(CheckValue,"</iframe", "&lt;/iframe")
'	CheckValue = Replace(CheckValue,"<meta", "&lt;meta")
'	CheckValue = Replace(CheckValue,"<body", "&lt;body")
'	CheckValue = Replace(CheckValue,"</body", "&lt;/body")
'	CheckValue = Replace(CheckValue,"<style", "&lt;style")
'	CheckValue = Replace(CheckValue,"</style", "&lt;/style")
'	CheckValue = Replace(CheckValue,"<object", "&lt;object")
'	CheckValue = Replace(CheckValue,"</object", "&lt;/object")
'	CheckValue = Replace(CheckValue,"<param", "&lt;param")
'	CheckValue = Replace(CheckValue,"</param", "&lt;/param")
'	CheckValue = Replace(CheckValue,"<xml", "&lt;xml")
'	CheckValue = Replace(CheckValue,"</xml", "&lt;/xml")

	CheckQuotation = CheckValue
End Function

Function CheckQuotation2(CheckValue)
'CheckValue = LCase(CheckValue)
	CheckValue = replace(CheckValue, "&amp;" , "&")
	CheckValue = replace(CheckValue, "&lt;" , "<")
	CheckValue = replace(CheckValue, "&gt;" , ">")
	CheckValue = replace(CheckValue, "&quot;", "'")
	CheckValue = replace(CheckValue, "&#34;", """")
	CheckValue = Replace(CheckValue,"<script","&lt;script")
	CheckValue = Replace(CheckValue,"</script","&lt;/script")
	CheckValue = Replace(CheckValue,"<a","&lt;a")
	CheckValue = Replace(CheckValue,"</a","&lt;/a")
	CheckValue = Replace(CheckValue,"<iframe","&lt;iframe")
	CheckValue = Replace(CheckValue,"</iframe","&lt;/iframe")

	CheckQuotation2 = CheckValue
End Function

Function CheckCR(CheckValue)
'	CheckValue = replace(CheckValue, vbCrLf, "<br>")
	CheckValue = replace(CheckValue, "&quot;", "'")
	CheckCR = CheckValue
End Function

Function HtmlTagRemover(content, cutlen)
  j=1
  tmpb=2
  length = len(content)
  htmlRemovedContent = content

  Do while length > 0
   k = mid(htmlRemovedContent,j,1)

   if k="<" then
    tmpb = 0
   elseif k = ">" then
    tmpb = 1
   end if

   if tmpb = 0 then
    htmlRemovedContent = left(htmlRemovedContent,j-1) & mid(htmlRemovedContent,j+1)
   elseif tmpb = 1 then
    htmlRemovedContent = left(htmlRemovedContent,j-1) & mid(htmlRemovedContent,j+1)
    tmpb = 2
   else
    j=j+1
   end if
 
   length = length -1
  loop
   
  if cutlen <> 0 then
   htmlRemovedContent = left(htmlRemovedContent, cutlen)
  end if

  HtmlTagRemover = htmlRemovedContent

 End Function

'----------------------------------------------------------------------------------------- ' Depth에 따른 공백 추가
Function Get_Blank(ByVal m_len)
	Dim m_str, m_cnt
 	m_str=""
	for m_cnt=1 to m_len
		m_str=m_str&"&nbsp;&nbsp;"
	next
	Get_Blank = m_str
End Function
'----------------------------------------------------------------------------------------- ' 페이지 관련
Function Get_Script_Name()                                                                                                                 ' 현재 페이지명 구함.
	Dim m_scname, m_scna, m_scnl
	m_scname = Request.ServerVariables("SCRIPT_NAME")
	m_scna = split(m_scname,"/")
	m_scnl = UBound(m_scna)
	Get_Script_Name = m_scna(m_scnl)
End Function

Function Get_Start_Page(ByVal m_cpage, ByVal m_conternp)                                                                                   ' 페이지 카운트 시 시작페이지 구함.
	Dim m_tspage, m_spage
	if Len(CStr(m_cpage))=1 then
		m_spage=1
	elseif Len(CStr(m_cpage))>=2 then
		m_tspage	= (m_cpage\m_conternp)
		if (m_cpage mod m_conternp)=0 then m_tspage=m_tspage-1
		m_spage	= (m_tspage)*10+1
	End if
	Get_Start_Page =m_spage
End Function
'----------------------------------------------------------------------------------------- ' DB 관련(현재 사용되지 않음 => 차후 삭제 예정)
Sub Run_Insert(ByVal m_strcon, ByVal proc_name, ByVal inputParams)                                                                         ' DB 내용 저장

	Dim m_strSQL, fnstr, fvstr
	collectInsertParams inputParams,fnstr,fvstr
	m_strSQL = "insert into "&table_name&"("&fnstr&") values("&fvstr&")"
	RunSQLOnly m_strcon, m_strSQL

End Sub

Sub Run_Update(ByVal m_strcon, ByVal table_name, ByVal inputParams)                                                                        ' DB 내용 수정

	Dim m_strSQL, fnstr
	collectUpdateParams inputParams,fnstr
	m_strSQL = "update "&table_name&" set "&fnstr
	RunSQLOnly m_strcon, m_strSQL

End Sub

'----------------------------------------------------------------------------------------- ' 경고메세지 관련
Sub Popup_Msg(ByVal m_msg)                                                                                                                 ' alert출력 후 바로이전 페이지(BACK)로 이동
	Response.Write "<script language='javascript'>"&vbCrLf
	Response.Write "alert('"&m_msg&"');" &vbCrLf
	Response.Write "window.history.back();" &vbCrLf
	Response.Write "</script>" &vbCrLf
	Response.End
End Sub

Sub Popup_Msg2(ByVal m_msg, ByVal m_page, ByVal m_depth)                                                                                   ' alert출력 후 지정한 페이지로 이동
	Dim m_url, xi
	if m_depth=0 then
		m_url = "./"&m_page
	else
		m_url ="../"
		For xi=2 to m_depth : m_url=m_url&"../" : Next
		m_url = m_url & m_page
	end if
	Response.Write "<script language='javascript'>"&vbCrLf
	Response.Write "alert('"&m_msg&"');" &vbCrLf
	Response.Write "window.location.href='"&m_url&"';" &vbCrLf
	Response.Write "</script>" &vbCrLf
	Response.End
End Sub

Sub Popup_Msg3(ByVal m_msg, ByVal count)                                                                                                   ' alert출력 후 지정한 단계(Depth)로 페이지 이동
	Response.Write "<script language='javascript'>"&vbCrLf
	Response.Write "alert('"&m_msg&"');" &vbCrLf
	Response.Write "window.history.go(" & count & ");" &vbCrLf
	Response.Write "</script>" &vbCrLf
	Response.End
End Sub

Sub Popup_Msg_Root(ByVal m_msg, ByVal m_page)                                                                                              ' alert출력 후 지정한 페이지로 이동
	Response.Write "<script language='javascript'>"&vbCrLf
	Response.Write "alert('"&m_msg&"');" &vbCrLf
	Response.Write "window.location.href='"&m_page&"';" &vbCrLf
	Response.Write "</script>" &vbCrLf
	Response.End
End Sub
'----------------------------------------------------------------------------------------- ' DB 관련
Sub RunSQLOnly(ByVal m_strcon, ByVal SQL)                                                                                                  ' DB 쿼리 or 프로시저 실행
        Dim OutPutParms
        OpenDBCommand
        cmd.ActiveConnection = m_strcon
        cmd.CommandType = adCmdText
        cmd.CommandText = SQL
        cmd.Execute , , adExecuteNoRecords
        CloseDBCommand
End Sub

Function RunSQLReturnArrayCount(ByVal m_strcon, ByVal SQL)                                                                                 ' 조회 결과를 배열형식으로 출력할때 레코드의 개수 카운트

    Dim ii, m_output
	OpenDBConnection m_strcon
    OpenDBRecordset
    With rs
        .Open SQL, conn, adOpenForwardOnly, adLockReadOnly
        If Not rs.EOF Then
            m_output=Trim(rs(0))
        End If
    End With
    CloseDBRecordSet
	CloseDBConnection
    RunSQLReturnArrayCount = m_output

End Function

Sub RunSQLReturnArray(ByVal m_strcon, ByVal SQL, ByRef Record_Count, ByRef db_OutputArray)                                                 ' 조회 결과를 배열형식으로 저장 후 여러개의 레코드나 단일 레코드를 출력
		OpenDBConnection m_strcon
        OpenDBRecordset
        With rs
            .Open SQL, conn, adOpenForwardOnly, adLockReadOnly
            If rs.EOF Then
                Record_Count = 0
            Else
                Record_Count = .RecordCount
                db_OutputArray = .GetRows()
            End If
        End With
        CloseDBRecordSet
		CloseDBConnection

End Sub

Function RunSQLReturnSingleValue(ByVal m_strcon,ByVal SQL)                                                                                 ' 조회 결과 중 하나의 값만 출력

        Dim ii, m_output
		OpenDBConnection m_strcon
        OpenDBRecordset
        With rs
            .Open SQL, conn, adOpenForwardOnly, adLockReadOnly
            If Not rs.EOF Then
            m_output=Trim(rs(0))
            End If
        End With
        CloseDBRecordSet
		CloseDBConnection
        RunSQLReturnSingleValue = m_output

End Function

Sub RunSQLReturnArrayValue(ByVal m_strcon, ByVal SQL, ByRef db_rc, ByRef db_OutputArray)                                                   ' 조회 결과 중 하나의 레코드만 출력

        Dim ii, oArray, arrDim
        oArray = Array()
        db_rc = 0
		OpenDBConnection m_strcon
        OpenDBRecordset
        With rs
            	.Open SQL, conn, adOpenForwardOnly, adLockReadOnly
            	If Not rs.EOF Then
            		db_rc = 1
            		arrDim = rs.Fields.Count
            		ReDim oArray(arrDim)
		For ii=0 to (arrDim-1)
			oArray(ii) = rs(ii)
		Next
            	End If
        End With
		db_OutputArray = oArray
		CloseDBRecordSet
		CloseDBConnection
End Sub

Sub RunSQLReturnPageArray(ByVal m_strcon, ByVal SQL, ByVal ps, ByVal cp, ByRef rc, ByRef db_OutputArray)                                   ' 조회 결과를 배열형식으로 저장 후 출력

	Dim limit

	OpenDBConnection m_strcon
	OpenDBRecordSet

	'limit=ps*(cp-1)
	'SQL=SQL&" LIMIT "&limit&","&ps

            ' Init the ADO objects & the stored proc parameters
            With rs
                .MaxRecords = ps*cp
                ' Open the required recordset
                .Open SQL, conn, adOpenForwardOnly, adLockReadOnly
                If rs.EOF Then
                    rc = 0
                Else
                   rc = .RecordCount
'                   .PageSize=ps
'                   .AbsolutePage=cp
                    db_OutputArray = .GetRows(ps)
                End If
                ' Disconnect the recordset and clean up
            End With
	CloseDBRecordSet
	CloseDBConnection
End Sub

Sub RunSQLReturnPageArray2(ByVal m_strcon, ByVal SQL1, ByVal SQL2, ByVal ps, ByRef cp,ByRef tp, ByRef rc, ByRef db_OutputArray)                ' 조회 결과를 배열형식으로 저장 후 출력

	Dim rsc1, rsc2, record_count, limit
	record_count = 0
	OpenDBConnection m_strcon
	Set rsc1 = Server.CreateObject("ADODB.Recordset")
	With rsc1
		.CursorLocation=adUseClient
        .Open SQL1, conn, adOpenForwardOnly, adLockReadOnly
		if Not rsc1.EOF then record_count = rsc1(0)
		.Close
	End With
	Set rsc1 = Nothing

	rc = record_count

	if record_count>0 then
		tp=rc\ps
		If (tp*ps)<>rc Then tp=tp+1
		If Cint(cp)>Cint(tp) Then cp=tp
		Set rsc2 = Server.CreateObject("ADODB.Recordset")
	        With rsc2
			.CursorLocation=adUseClient
			'limit=ps*(cp-1)
			'SQL2=SQL2&" LIMIT "&limit&","&ps

	        .MaxRecords = ps*cp
			.Open SQL2, conn, adOpenForwardOnly, adLockReadOnly
			if rsc2.EOF then
				rc = 0
			Else
				'rc = .RecordCount
'				.PageSize=ps
'				.AbsolutePage=cp
				db_OutputArray = .GetRows(ps)
			End if
			.Close
		End With
	        	Set rsc2 = Nothing
	end if
	CloseDBConnection
End Sub
'-------------------------------------------------------------------------------------- ' 페이지 카운트 관련
Sub Write_Page_Index(ByVal m_cnp, ByVal m_cp, ByVal m_sp, ByVal m_tp, ByVal m_filename, ByVal m_first, ByVal m_second)                     ' 페이지 카운트를 이전페이지/다음페이지 형태로만 출력
	Dim mm_str
	if Len(Trim(m_first))=0 then
		mm_str=""
	else
		mm_str = m_first&"&"
	end if
	if m_tp>m_cnp then
		if m_sp=1 then
			Response.Write "<td style='padding-left:10; padding-right:10;' align='center'>이전10개</td>"
		else
			Response.Write "<td style='padding-left:10; padding-right:10;' align='center'><a href='"&m_filename&"?"&mm_str&m_second&"="&(cint(m_sp)-m_cnp)&"' class='page_count1'>이전10개</a></td>"
		end if
		For a=m_sp to m_sp+m_cnp-1
			if a>m_tp then
				exit for
			else
				if a=Cint(m_cp) then
		 			Response.Write "<td style='padding-left:5; padding-right:5; padding-top:3' align='center'><font color=#797A74><b>"&a&"</b></font></td>"
				else
					Response.Write "<td style='padding-left:5; padding-right:5; padding-top:3' align='center'><a href='"&m_filename&"?"&mm_str&m_second&"="&a&"' class='page_count1'><font color=#797A74>"&a&"</font></a></td>"
				End if
			end if
		Next
		if ((m_sp\m_cnp)=(m_tp\m_cnp)) then
			 Response.Write "<td style='padding-left:10; padding-right:10;' align='center'>다음10개</td>"
		else
			Response.Write "<td style='padding-left:10; padding-right:10;' align='center'><a href='"&m_filename&"?"&mm_str&m_second&"="&a&"' class='page_count1'> 다음10개</a></td>"
		end if
	else
		Response.Write "<td style='padding-left:10; padding-right:10;' align='center'>이전10개</td>"
		For a=m_sp to m_tp
			if a=int(m_cp) then
				Response.Write "<td style='padding-left:5; padding-right:5; padding-top:3' align='center'><font color=#797A74><b>"&a&"</b></font><td>"
			else
				Response.Write "<td style='padding-left:5; padding-right:5; padding-top:3' align='center'><a href='"&m_filename&"?"&mm_str&m_second&"="&a&"' class='page_count1'><font color=#797A74>"&a&"</font></a></td>"
			end if
		next
		Response.Write "<td style='padding-left:10; padding-right:10;' align='center'>다음10개</td>"
	end if
End Sub
'=========================================================================================
Sub Write_Page_Index1(ByVal m_cnp, ByVal m_cp, ByVal m_sp, ByVal m_tp, ByVal m_filename, ByVal m_first, ByVal m_second, ByVal m_rc, ByVal e_cp, ByVal e_sp)                        ' 페이지 카운트를 첫페이지/이전페이지/다음페이지/끝페이지 형태로 출력
	Dim mm_str
	if Len(Trim(m_first))=0 then
		mm_str=""
	else
		mm_str = m_first&"&"
	end if

	Response.Write "<table border='0' cellspacing='0' cellpadding='0' height='30'>"
	Response.Write "<tr>"
	if m_cp > 1 then
	Response.Write "<td align='left'><a href='"&m_filename&"?"&mm_str&"cp=1&sp="&m_sp&"'><img src='/images/board/btn_first_page.gif' align='absmiddle' border='0' alt='첫 페이지'></a></td>"
	else
	Response.Write "<td align='left'><img src='/images/board/btn_first_page.gif' align='absmiddle' border='0' alt='첫 페이지'></td>"
	end if

	if m_tp>m_cnp then
		if m_sp=1 then
			Response.Write "<td align='center' style='padding:0px 3px 0px 10px'><img src='/images/board/btn_prev_page.gif' align='absmiddle' border='0' alt='이전 10페이지'></td>"
		else
			Response.Write "<td align='center' style='padding:0px 3px 0px 10px'><a href='"&m_filename&"?"&mm_str&m_second&"="&(cint(m_sp)-m_cnp)&"'><img src='/images/board/btn_prev_page.gif' align='absmiddle' border='0' alt='이전 10페이지'></a></td>"
		end if
		For a=m_sp to m_sp+m_cnp-1
			if a>m_tp then
				exit for
			else
				if a=Cint(m_cp) then
		 			Response.Write "<td align='center' style='padding:2px 5px 0px 5px'><font class='page_count_01'>"&a&"</font></td>"
				else
					Response.Write "<td align='center' style='padding:2px 5px 0px 5px'><a href='"&m_filename&"?"&mm_str&m_second&"="&a&"' class='page_count_02'>"&a&"</a></td>"
				End if
			end if
		Next
		if ((m_sp\m_cnp)=(m_tp\m_cnp)) then
			Response.Write "<td align='center' style='padding:0px 10px 0px 3px'><img src='/images/board/btn_next_page.gif' align='absmiddle' border='0' alt='다음 10페이지'></td>"
		else
			Response.Write "<td align='center' style='padding:0px 10px 0px 3px'><a href='"&m_filename&"?"&mm_str&m_second&"="&a&"' class='page_count_02'><img src='/images/board/btn_next_page.gif' align='absmiddle' border='0' alt='다음 10페이지'></a></td>"
		end if
	else
		Response.Write "<td align='center' style='padding:0px 3px 0px 10px'><img src='/images/board/btn_prev_page.gif' align='absmiddle' border='0' alt='이전 10페이지'></td>"
		For a=m_sp to m_tp
			if a=int(m_cp) then
				Response.Write "<td align='center' style='padding:2px 5px 0px 5px'><font class='page_count_01'>"&a&"</font><td>"
			else
				Response.Write "<td align='center' style='padding:2px 5px 0px 5px'><a href='"&m_filename&"?"&mm_str&m_second&"="&a&"' class='page_count_02'>"&a&"</a></td>"
			end if
		next
		Response.Write "<td align='center' style='padding:0px 10px 0px 3px'><img src='/images/board/btn_next_page.gif' align='absmiddle' border='0' alt='다음 10페이지'></td>"

	end if

	if Cint(m_cp) = Cint(e_cp) then
	Response.Write "<td align='right'><img src='/images/board/btn_end_page.gif' align='absmiddle' border='0' alt='마지막 페이지'></td>"
	else
	Response.Write "<td align='right'><a href='"&m_filename&"?"&mm_str&"cp="&e_cp&"&sp="&e_sp&"'><img src='/images/board/btn_end_page.gif' align='absmiddle' border='0' alt='마지막 페이지'></a></td>"
	end if
	Response.Write "<tr>"
	Response.Write "</table>"
End Sub
'--------------------------------------------------------------------------------------

'--------------------------------------------------------------------------------------												' Debug용으로, 필요한 내용 페이지상에 출력 및 Break
Function WRT(ByVal theField, ByVal theValue)
	Response.Write theField & " = " & theValue & "<br>"
End Function

Function ENDS()
	Response.End
End Function

%>