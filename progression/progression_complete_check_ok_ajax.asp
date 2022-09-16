<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
	code = request("Code")

	SQL = "select 상태 from 행사_승인요청 where 행사번호 = '"& code &"' "
	
	SQL2 = "update 행사_승인요청 set 상태 = '완료승인확인', 등록일 = getdate() where 행사번호 = '"& code &"' "

	SQL_3 = "select 행사번호, 일차, convert(varchar(10), 근무일, 120) as 근무일, 입실시간, 퇴실시간, 내용 "
	SQL_3 = SQL_3 & " from 행사_장례진행 "	
	SQL_3 = SQL_3 & " where 행사번호 = '" & code & "' "	
	SQL_3 = SQL_3 & " order by 일차 asc "

	SQL_4 = "select count(*) from 행사특이사항 where 행사번호 = '"& code &"' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)

	If Rs.EOF Then
		sign = "N"
	Else
		sign = "Y"
		stat = Rs("상태")
		if stat = "완료승인요청" then		

			Set Rs3 = ConnAplus.execute(SQL_3)
						
			Set Rs4 = ConnAplus.execute(SQL_4)

			If Rs3.EOF Then
				rc = 0
			Else
				rc = Rs3.RecordCount
				arrObj = Rs3.GetRows(rc)

				for i=0 to UBound(arrObj,2)
					input1	= arrObj(1,i) '일차
					input2	= arrObj(2,i) '근무일
					input3	= arrObj(3,i) '입실시간
					input4	= arrObj(4,i) '퇴실시간
					input5	= arrObj(5,i) '내용
					
					If i = 0 then	
						input_1 = input1 & "일차: " & input5 

						
						If Rs4(0) = 0 then 
							SQL4_1 = " INSERT INTO 행사특이사항 (행사번호, 행사특이사항, 시스템일자 "
							SQL4_1 = SQL4_1 & " ) values ( '"& code &"', '"& input_1 &"', getdate() ) "		
						Else
							SQL4_1 = " update 행사특이사항 set 행사특이사항 = isnull(행사특이사항,'') + char(13) + char(10) + '"& input_1 &"' "
							SQL4_1 = SQL4_1 & " where 행사번호 = '"& code &"' "			
						End If
						'Response.write SQL4_1

						'ConnAplus.execute(SQL4_1)

					Else
						input_1 = input1 & "일차: " & input5

						SQL4_1 = " update 행사특이사항 set 행사특이사항 = isnull(행사특이사항,'') + char(13) + char(10) + '"& input_1 &"' "
						SQL4_1 = SQL4_1 & " where 행사번호 = '"& code &"' "
						
						'ConnAplus.execute(SQL4_1)

					End If					

				Next				
			End If

			Set Rs3 = Nothing
			Set Rs4 = Nothing			
			
			ConnAplus.execute(SQL2) '상태변경

		End If
	End If

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing
	
	if sign = "Y" then
		if stat = "완료승인요청" then 
			response.write "a"
		else
			response.write "b"
		end if
	else
		response.write "c"
	end if

	response.End

%>