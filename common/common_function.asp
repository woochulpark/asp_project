<%
	'	============================================================================
	'	=	성별 텍스트 변경
	'	============================================================================
	Function GenderChange(Index)
		Dim Text
				
		Select Case Index
			Case 1
				Text = "Male"
			Case 0
				Text = "Female"
			Case Else
				'Text = "Not Found"
		End Select

		GenderChange = Text
	End Function

	'	============================================================================
	'	=	랜덤 문자열 만들기
	'	============================================================================
	Function RandomString(Cnt)
		Dim str, tStr			
			
		Randomize()
		
		For cntArr = 1 To Cnt
			flg = Int(Rnd() * 10)
			If flg < 5 Then
				tStr = Int(Rnd() * 10)
			Else
				tStr = Int(Rnd() * 26)
				tStr = Chr(asc("a") + tStr)
			End If
			str = str & tStr
		Next

		RandomString = str
	End Function

	'	============================================================================
	'	=	파일 읽어오기
	'	============================================================================
	Function GetFileForm(Url)
		Dim obj, FilePath, FileContent

		Set obj = Server.CreateObject("Scripting.FileSystemObject")
		FilePath = Server.MapPath(Url)

		Set FileContent = obj.OpenTextFile(FilePath, 1)
		GetFileForm = FileContent.readall

		FileContent.Close
		Set MailContent = Nothing

		Set obj = Nothing
	End Function

	Function ReadUTF8File(Url)
		Dim Stream, TextBuffer, FilePath

		FilePath = Server.MapPath(Url)

		Set Stream = Server.CreateObject("ADODB.Stream")
		With Stream
			.Charset = "utf-8"
			.Type = 2 'adTypeText
			.Open
			.LoadFromFile FilePath
			.Position = 0
			ReadUTF8File = .ReadText
			.Close
		End With

		Set Stream = Nothing
	End Function  

	Function WriteUTF8File(sFileName, sText)
		Dim Stream

		Set Stream = Server.CreateObject("ADODB.Stream")
		With Stream
			.Charset = "utf-8"
			.Type = 2 'adTypeText
			.Open
			.WriteText sText
			.SaveToFile sFileName, 2 'adSaveCreateOverWrite
			.Close
		End With

		Set Stream = Nothing
	End Function

	'	============================================================================
	'	=
	'	=	Function : reTitle(str, len)
	'	=
	'	=	한영구분 str 을 len 길이만큼 제거후 + "..."
	'	=
	'	============================================================================
	Public Function getLength(str, strlen)
	  dim rValue
	  dim nLength, tmpStr, tmpLen, f

	  nLength = 0.00
	  rValue = ""

	  for f = 1 to len(str)
	     tmpStr = MID(str,f,1)
	     tmpLen = ASC(tmpStr)
	     if  (tmpLen < 0) then
	      ' 한글
	       nLength = nLength + 1.4        '한글일때 길이값 설정
	       rValue = rValue & tmpStr
	     elseif (tmpLen >= 97 and tmpLen <= 122) then
	      ' 영문 소문자
	       nLength = nLength + 0.75       '영문소문자 길이값 설정
	       rValue = rValue & tmpStr
	     elseif (tmpLen >= 65 and tmpLen <= 90) then
	       ' 영문 대문자
	       nLength = nLength + 1.5           ' 영문대문자 길이값 설정
	       rValue = rValue & tmpStr
	     else
	       ' 그외 키값
	       nLength = nLength + 0.8         '특수문자 기호값...
	       rValue = rValue & tmpStr

	     end if

	     If (nLength > strlen) then
	       rValue = rValue & ".."
	       exit for
	    end if
	  next
	  getLength = rValue
	End Function

	' ============================================================
	'  FN_HtmlMinus( htmlDoc )
	'
	' 내용중 HTML 내용을 뺀 텍스트만 나오게
	' ============================================================
	Private Function FN_HtmlMinus( htmlDoc )
		set Com_rex    = new Regexp
		Com_rex.Pattern  = "<[^<|>]*>"  'Test(검색-문자열)
		Com_rex.IgnoreCase = true    'replace (검색-문자열, 대체-문자열)
		Com_rex.Global  = true    'Execute (검색-문자열)
		FN_HtmlMinus  = Com_rex.Replace(htmlDoc,"")
		set Com_rex = nothing
	end Function

	' ============================================================
	'  DateFormat( datetime )
	'
	'  yyyy-mm-dd 로 출력
	' ============================================================
	Public Function DateFormat(datetime)
		yy = Year(datetime)
		mm = Month(datetime)
		dd = Day(datetime)
		
		if mm < 10 then 
			mm = "0" & mm
		end if 
		if dd < 10 then 
			dd = "0" & dd
		end if 

		DateFormat = yy & "-" & mm & "-" & dd
	End Function

	' ============================================================
	' HTML 효과 X
	' ============================================================
	Function CheckWord(CheckValue)
		CheckValue = replace(CheckValue, "&" , "&amp;")
		CheckValue = replace(CheckValue, "<", "&lt;")
		CheckValue = replace(CheckValue, ">", "&gt;")
	'	CheckValue = replace(CheckValue, "'", "&apos;")
		CheckValue = replace(CheckValue, "'", "&#39")
	'	CheckValue = replace(CheckValue, "'", "''")
		CheckValue = replace(CheckValue, """", "&quot;")
		CheckValue = Trim(Replace(CheckValue, "|", "&#124;"))
		CheckWord = CheckValue
	End Function

	Function CheckWord2(CheckValue)
		CheckValue = replace(CheckValue, "&lt;div&gt;", "")
		CheckValue = replace(CheckValue, "&lt;/div&gt;", "")
		CheckWord2 = CheckValue
	End Function

	' ============================================================
	' 초 => 분:초 변경
	' ============================================================
	Function ChangeTime(value)
		MTime = value \ 60
		If MTime < 10 Then
			MTime = "0" & MTime
		End If
		STime = value MOD 60
		If STime < 10 Then
			STime = "0" & STime
		End If
		ChangeTime = MTime & ":" & STime
	End Function

	
	' ============================================================
	' 영문 월이름 변경
	' ============================================================
	Function getMonthName(getMonth)

	   On Error Resume Next

	   Dim arrayMonth 
	   arrayMonth = array("january","February","March", _
	   "April","May", "June", "July", _ 
	   "August","September", _ 
	   "October","November", "December" )
	   getMonth = Cint(getMonth)

	   If Err.number <> 0 Then
		  Response.Write err.description & "<br>" & err.source & "<br>" 
		  Err.clear
	   End If

	   If getMonth < 1 OR getMonth > 12 Then
		  getMonthName = "1~12 사이의 숫자를 입력하세요."
	   Else
		  getMonthName = arrayMonth(Cint(getMonth)-1)
	   End If

	End Function


%>