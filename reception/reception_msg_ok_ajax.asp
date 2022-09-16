<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
	code = request("Code")
	input8 = request("input8")
	input8_enc = input8 & ".pdf"


	SQL = "exec [p_문자발송_고객접수안내] '"& code &"', '"& user_id &"', '"& FnAesEncrypt(code, AesEncryptPwd) &"'  "	
	SQL2 = "select * from ums_data (nolock) where etc2 = '행사_고객접수안내' and etc4 = '"& code &"' "
	SQL3 = "select * from ums_log (nolock) where etc2 = '행사_고객접수안내' and etc4 = '"& code &"'"
	SQL4 = "select isnull(b.사진, '') 사진 from 행사마스터 a (nolock) left outer join 행사의전팀장 b (nolock) on a.진행팀장 = b.코드 " 
	SQL4 = SQL4 & " where a.진행팀장 is not null and b.계약여부 = '계약' and a.행사번호 = '"& code &"'"

	'response.end

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL4)

	If Rs.EOF Then
		sign = "Y3"		
	Else
		sign = "N"
		team_pic = Rs("사진")
	End If

	if team_pic <> "" then	
	
		'파일객체 인스턴스 생성
		Set fso = Server.CreateObject("Scripting.FileSystemObject")

		'경로 설정

		folderPath = "D:\iisroot\sms\team_pic\"

		folderPath_copy = "D:\unitel\Upload\"

		
		if not (fso.fileexists(folderPath_copy & team_pic)) then

			'response.write folderPath & team_pic

			Set orgFile = fso.GetFile(folderPath & team_pic)

			orgFile.copy (folderPath_copy & team_pic)
		end if		

		Set fso = Nothing

	end if

	if sign = "N" then

		Set Rs = ConnAplus.execute(SQL2)

		If Rs.EOF Then
			sign = "N"
		Else
			sign = "Y"
		End If

		'if sign = "N" then

			'Set Rs = ConnAplus.execute(SQL3)

			'If Rs.EOF Then
			'	sign = "N"
			'Else
			'	sign = "Y2"
			'End If

		'end if

	end if

	if sign = "N" then
		Set Rs = ConnAplus.execute(SQL)
		sign = "S"
	end if

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	
	
	response.write sign	

	response.End

%>