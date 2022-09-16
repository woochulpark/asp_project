<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check2.asp"-->

<%

	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadform.DefaultPath = "D:\iisroot\hs\fileupload"

	b_type1 = uploadform("b_type1")
	b_type2 = uploadform("b_type2")
	b_idx = uploadform("b_idx")
	file_old1 = uploadform("file_old1")
	file_old2 = uploadform("file_old2")
	file_old3 = uploadform("file_old3")
	file_old4 = uploadform("file_old4")
	file_old5 = uploadform("file_old5")
	file_old6 = uploadform("file_old6")
	file_old7 = uploadform("file_old7")
	file_old8 = uploadform("file_old8")
	file_old9 = uploadform("file_old9")
	file_old10 = uploadform("file_old10")

	if uploadform("file1") <> "" then
		If split(uploadform("file1").MimeType, "/")(0) <> "image" then
			response.Write "<script>alert('이미지 파일만 등록 가능합니다.');parent.FileUpload('"& b_type1 &"', '"& b_type2 &"', '"& b_idx &"');</script>"
			response.End
		end if
	end if
	if uploadform("file2") <> "" then
		If split(uploadform("file2").MimeType, "/")(0) <> "image" then
			response.Write "<script>alert('이미지 파일만 등록 가능합니다.');parent.FileUpload('"& b_type1 &"', '"& b_type2 &"', '"& b_idx &"');</script>"
			response.End
		end if
	end if
	if uploadform("file3") <> "" then
		If split(uploadform("file3").MimeType, "/")(0) <> "image" then
			response.Write "<script>alert('이미지 파일만 등록 가능합니다.');parent.FileUpload('"& b_type1 &"', '"& b_type2 &"', '"& b_idx &"');</script>"
			response.End
		end if
	end if
	if uploadform("file4") <> "" then
		If split(uploadform("file4").MimeType, "/")(0) <> "image" then
			response.Write "<script>alert('이미지 파일만 등록 가능합니다.');parent.FileUpload('"& b_type1 &"', '"& b_type2 &"', '"& b_idx &"');</script>"
			response.End
		end if
	end if
	if uploadform("file5") <> "" then
		If split(uploadform("file5").MimeType, "/")(0) <> "image" then
			response.Write "<script>alert('이미지 파일만 등록 가능합니다.');parent.FileUpload('"& b_type1 &"', '"& b_type2 &"', '"& b_idx &"');</script>"
			response.End
		end if
	end if
	if uploadform("file6") <> "" then
		If split(uploadform("file6").MimeType, "/")(0) <> "image" then
			response.Write "<script>alert('이미지 파일만 등록 가능합니다.');parent.FileUpload('"& b_type1 &"', '"& b_type2 &"', '"& b_idx &"');</script>"
			response.End
		end if
	end if
	if uploadform("file7") <> "" then
		If split(uploadform("file7").MimeType, "/")(0) <> "image" then
			response.Write "<script>alert('이미지 파일만 등록 가능합니다.');parent.FileUpload('"& b_type1 &"', '"& b_type2 &"', '"& b_idx &"');</script>"
			response.End
		end if
	end if
	if uploadform("file8") <> "" then
		If split(uploadform("file8").MimeType, "/")(0) <> "image" then
			response.Write "<script>alert('이미지 파일만 등록 가능합니다.');parent.FileUpload('"& b_type1 &"', '"& b_type2 &"', '"& b_idx &"');</script>"
			response.End
		end if
	end if
	if uploadform("file9") <> "" then
		If split(uploadform("file9").MimeType, "/")(0) <> "image" then
			response.Write "<script>alert('이미지 파일만 등록 가능합니다.');parent.FileUpload('"& b_type1 &"', '"& b_type2 &"', '"& b_idx &"');</script>"
			response.End
		end if
	end if
	if uploadform("file10") <> "" then
		If split(uploadform("file10").MimeType, "/")(0) <> "image" then
			response.Write "<script>alert('이미지 파일만 등록 가능합니다.');parent.FileUpload('"& b_type1 &"', '"& b_type2 &"', '"& b_idx &"');</script>"
			response.End
		end if
	end if

	if b_type1 = "행사" and b_type2 = "회사지원입력" then
		uploadform.DefaultPath = "D:\iisroot\hs\fileupload\reception\support"
		filepath = "/fileupload/reception/support/"
	elseif b_type1 = "행사" and b_type2 = "기타정보" then
		uploadform.DefaultPath = "D:\iisroot\hs\fileupload\reception\etc"
		filepath = "/fileupload/reception/etc/"
	elseif b_type1 = "장례진행" then
		uploadform.DefaultPath = "D:\iisroot\hs\fileupload\progression"
		filepath = "/fileupload/progression/"
	elseif b_type1 = "정산" then
		uploadform.DefaultPath = "D:\iisroot\hs\fileupload\calculation"
		filepath = "/fileupload/calculation/"
	elseif b_type1 = "배송" and b_type2 = "용품" then
		uploadform.DefaultPath = "D:\iisroot\hs\fileupload\ship\img1"
		filepath = "/fileupload/ship/img1/"
	elseif b_type1 = "배송" and b_type2 = "화환" then
		uploadform.DefaultPath = "D:\iisroot\hs\fileupload\ship\img2"
		filepath = "/fileupload/ship/img2/"
	elseif b_type1 = "배송" and b_type2 = "조기" then
		uploadform.DefaultPath = "D:\iisroot\hs\fileupload\ship\img3"
		filepath = "/fileupload/ship/img3/"
	end if

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	SQL = "delete from 파일저장 where "
	SQL = SQL & " 게시판종류 = '"& b_type1 &"' and 게시판종류2 = '"& b_type2 &"' and 게시판인덱스 = '"& b_idx &"' "
	ConnAplus.execute(SQL)

	if uploadform("file1") <> "" then
		if file_old1 <> "" then
			filepath1 = uploadform.DefaultPath & "\" & file_old1
			uploadform.DeleteFile filepath1
		end If
		uploadform("file1").Save, False
		file1 = uploadform("file1").FileName

'		If filepath = "/fileupload/reception/support/" And b_idx = "2021032400009" then

			' 썸네일이미지를 만들기위한사전작업
			Set objImage = Server.CreateObject("DEXT.ImageProc")
				
				'uploadForm("file1").ImageRotate = 270
				'response.Write "<script>alert('file1 = "& uploadform.DefaultPath &"');</script>"
				imgDefaultFilePath = uploadform.DefaultPath & "\"
				'response.Write "<script>alert('file1 = "& imgDefaultFilePath &"');</script>"
				'이미지 사이즈 가져오기
				imgWidth	= uploadForm("file1").ImageWidth
				imgHeight	= uploadForm("file1").ImageHeight

				' 이미지 가로사이즈 지정
				defaultWidth		= 2000
				'response.Write "<script>alert('이미지 등록 테스트2.');</script>"
				'objImage.ImageRotate = 90
				
				If imgWidth > defaultWidth Then		
					If imgWidth > imgHeight then
						imgWidthM		= Int(imgWidth * defaultWidth / imgHeight)
						imgWidthH		= Int(imgHeight * defaultWidth / imgHeight)
					Else
						imgWidthM		= Int(imgWidth * defaultWidth / imgWidth)
						imgWidthH		= Int(imgHeight * defaultWidth / imgWidth)					
					End If	
				Else					
					imgWidthM		= imgWidth
					imgWidthH		= imgHeight					
				End If
			
				'response.Write "<script>alert('이미지 등록 테스트3.');</script>"
				' 썸네일이미지 저장하기	
				If True = objImage.SetSourceFile(imgDefaultFilePath & file1) Then	
				'response.Write "<script>alert('이미지 등록 테스트4.');</script>"
					uploadform.DeleteFile imgDefaultFilePath & "i_" & file1 '먼저 삭제
				'response.Write "<script>alert('이미지 등록 테스트5.');</script>"
				'response.Write "<script>alert('file1 = "& file1 &"');</script>"
				'response.Write "<script>alert('file1 = "& file1 &"');</script>"
				'response.Write "<script>alert('file1 = "& uploadform.DefaultPath &"');</script>"
				'response.Write "<script>alert('file1 = "& imgDefaultFilePath &"');</script>"
				'response.Write "<script>alert('file1 = "& imgDefaultFilePath & "i_" & file1 &"');</script>"
				'response.Write "<script>alert('imgWidthM = "& imgWidthM &"');</script>"
				'response.Write "<script>alert('imgWidthH = "& imgWidthH &"');</script>"
					lastSavedThumbnailFileName = objImage.SaveAsThumbnail(imgDefaultFilePath & "i_" & file1, imgWidthM, imgWidthH, false)
				'response.Write "<script>alert('이미지 등록 테스트6.');</script>"
					If lastSavedThumbnailFileName <> "" Then
						uploadform.DeleteFile imgDefaultFilePath & file1
						file1 = "i_" & file1				
					End If
				
				End if

			Set objImage = Nothing
			
'		End If
		


		'인서트
		SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file1 &"','"& filepath &"') "
		ConnAplus.execute(SQL)
	else
		if file_old1 <> "" then
			file1 = file_old1
			'인서트
			SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
			SQL = SQL & " ) values ( "
			SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file1 &"','"& filepath &"') "
			ConnAplus.execute(SQL)
		end if
	end if

	if uploadform("file2") <> "" then
		if file_old2 <> "" then
			filepath2 = uploadform.DefaultPath & "\" & file_old2
			uploadform.DeleteFile filepath2
		end if
		uploadform("file2").Save
		file2 = uploadform("file2").FileName

'		If filepath = "/fileupload/reception/support/" And b_idx = "2021032400009" then

			' 썸네일이미지를 만들기위한사전작업
			Set objImage = Server.CreateObject("DEXT.ImageProc")
				
				'uploadForm("file1").ImageRotate = 270
				imgDefaultFilePath = uploadform.DefaultPath & "\"

				'이미지 사이즈 가져오기
				imgWidth	= uploadForm("file2").ImageWidth
				imgHeight	= uploadForm("file2").ImageHeight

				' 이미지 가로사이즈 지정
				defaultWidth		= 2000

				If imgWidth > defaultWidth Then		
					If imgWidth > imgHeight then
						imgWidthM		= imgWidth * defaultWidth / imgHeight
						imgWidthH		= imgHeight * defaultWidth / imgHeight
					Else
						imgWidthM		= imgWidth * defaultWidth / imgWidth
						imgWidthH		= imgHeight * defaultWidth / imgWidth					
					End If					
				Else					
					imgWidthM		= imgWidth
					imgWidthH		= imgHeight
				End If
			
				' 썸네일이미지 저장하기	
				If True = objImage.SetSourceFile(imgDefaultFilePath & file2) Then
					uploadform.DeleteFile imgDefaultFilePath & "i_" & file2 '먼저 삭제
					lastSavedThumbnailFileName = objImage.SaveAsThumbnail(imgDefaultFilePath & "i_" & file2, imgWidthM, imgWidthH, false)

					If lastSavedThumbnailFileName <> "" Then
						uploadform.DeleteFile imgDefaultFilePath & file2
						file2 = "i_" & file2				
					End If
				
				End if

			Set objImage = Nothing
			
'		End If		
		
		
		'인서트
		SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file2 &"','"& filepath &"') "
		ConnAplus.execute(SQL)
	else
		if file_old2 <> "" then
			file2 = file_old2
			'인서트
			SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
			SQL = SQL & " ) values ( "
			SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file2 &"','"& filepath &"') "
			ConnAplus.execute(SQL)
		end if
	end if

	if uploadform("file3") <> "" then
		if file_old3 <> "" then
			filepath3 = uploadform.DefaultPath & "\" & file_old3
			uploadform.DeleteFile filepath3
		end if
		uploadform("file3").Save
		file3 = uploadform("file3").FileName

'		If filepath = "/fileupload/reception/support/" And b_idx = "2021032400009" then

			' 썸네일이미지를 만들기위한사전작업
			Set objImage = Server.CreateObject("DEXT.ImageProc")
				
				'uploadForm("file1").ImageRotate = 270
				imgDefaultFilePath = uploadform.DefaultPath & "\"

				'이미지 사이즈 가져오기
				imgWidth	= uploadForm("file3").ImageWidth
				imgHeight	= uploadForm("file3").ImageHeight

				' 이미지 가로사이즈 지정
				defaultWidth		= 2000

				If imgWidth > defaultWidth Then		
					If imgWidth > imgHeight then
						imgWidthM		= imgWidth * defaultWidth / imgHeight
						imgWidthH		= imgHeight * defaultWidth / imgHeight
					Else
						imgWidthM		= imgWidth * defaultWidth / imgWidth
						imgWidthH		= imgHeight * defaultWidth / imgWidth					
					End If					
				Else					
					imgWidthM		= imgWidth
					imgWidthH		= imgHeight
				End If
			
				' 썸네일이미지 저장하기	
				If True = objImage.SetSourceFile(imgDefaultFilePath & file3) Then
					uploadform.DeleteFile imgDefaultFilePath & "i_" & file3 '먼저 삭제
					lastSavedThumbnailFileName = objImage.SaveAsThumbnail(imgDefaultFilePath & "i_" & file3, imgWidthM, imgWidthH, false)

					If lastSavedThumbnailFileName <> "" Then
						uploadform.DeleteFile imgDefaultFilePath & file3
						file3 = "i_" & file3				
					End If
				
				End if

			Set objImage = Nothing
		
'		End If			
		
		'인서트
		SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file3 &"','"& filepath &"') "
		ConnAplus.execute(SQL)
	else
		if file_old3 <> "" then
			file3 = file_old3
			'인서트
			SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
			SQL = SQL & " ) values ( "
			SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file3 &"','"& filepath &"') "
			ConnAplus.execute(SQL)
		end if
	end if

	if uploadform("file4") <> "" then
		if file_old4 <> "" then
			filepath4 = uploadform.DefaultPath & "\" & file_old4
			uploadform.DeleteFile filepath4
		end if
		uploadform("file4").Save
		file4 = uploadform("file4").FileName

'		If filepath = "/fileupload/reception/support/" And b_idx = "2021032400009" then

			' 썸네일이미지를 만들기위한사전작업
			Set objImage = Server.CreateObject("DEXT.ImageProc")
				
				'uploadForm("file1").ImageRotate = 270
				imgDefaultFilePath = uploadform.DefaultPath & "\"

				'이미지 사이즈 가져오기
				imgWidth	= uploadForm("file4").ImageWidth
				imgHeight	= uploadForm("file4").ImageHeight

				' 이미지 가로사이즈 지정
				defaultWidth		= 2000

				If imgWidth > defaultWidth Then		
					If imgWidth > imgHeight then
						imgWidthM		= imgWidth * defaultWidth / imgHeight
						imgWidthH		= imgHeight * defaultWidth / imgHeight
					Else
						imgWidthM		= imgWidth * defaultWidth / imgWidth
						imgWidthH		= imgHeight * defaultWidth / imgWidth					
					End If					
				Else					
					imgWidthM		= imgWidth
					imgWidthH		= imgHeight
				End If
			
				' 썸네일이미지 저장하기	
				If True = objImage.SetSourceFile(imgDefaultFilePath & file4) Then
					uploadform.DeleteFile imgDefaultFilePath & "i_" & file4 '먼저 삭제
					lastSavedThumbnailFileName = objImage.SaveAsThumbnail(imgDefaultFilePath & "i_" & file4, imgWidthM, imgWidthH, false)

					If lastSavedThumbnailFileName <> "" Then
						uploadform.DeleteFile imgDefaultFilePath & file4
						file4 = "i_" & file4				
					End If	

				End if

			Set objImage = Nothing
			
'		End If		
		
		'인서트
		SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file4 &"','"& filepath &"') "
		ConnAplus.execute(SQL)
	else
		if file_old4 <> "" then
			file4 = file_old4
			'인서트
			SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
			SQL = SQL & " ) values ( "
			SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file4 &"','"& filepath &"') "
			ConnAplus.execute(SQL)
		end if
	end if

	if uploadform("file5") <> "" then
		if file_old5 <> "" then
			filepath5 = uploadform.DefaultPath & "\" & file_old5
			uploadform.DeleteFile filepath5
		end if
		uploadform("file5").Save
		file5 = uploadform("file5").FileName

'		If filepath = "/fileupload/reception/support/" And b_idx = "2021032400009" then

			' 썸네일이미지를 만들기위한사전작업
			Set objImage = Server.CreateObject("DEXT.ImageProc")
				
				'uploadForm("file1").ImageRotate = 270
				imgDefaultFilePath = uploadform.DefaultPath & "\"

				'이미지 사이즈 가져오기
				imgWidth	= uploadForm("file5").ImageWidth
				imgHeight	= uploadForm("file5").ImageHeight

				' 이미지 가로사이즈 지정
				defaultWidth		= 2000

				If imgWidth > defaultWidth Then		
					If imgWidth > imgHeight then
						imgWidthM		= imgWidth * defaultWidth / imgHeight
						imgWidthH		= imgHeight * defaultWidth / imgHeight
					Else
						imgWidthM		= imgWidth * defaultWidth / imgWidth
						imgWidthH		= imgHeight * defaultWidth / imgWidth					
					End If					
				Else					
					imgWidthM		= imgWidth
					imgWidthH		= imgHeight
				End If
			
				' 썸네일이미지 저장하기	
				If True = objImage.SetSourceFile(imgDefaultFilePath & file5) Then
					uploadform.DeleteFile imgDefaultFilePath & "i_" & file5 '먼저 삭제
					lastSavedThumbnailFileName = objImage.SaveAsThumbnail(imgDefaultFilePath & "i_" & file5, imgWidthM, imgWidthH, false)

					If lastSavedThumbnailFileName <> "" Then
						uploadform.DeleteFile imgDefaultFilePath & file5
						file5 = "i_" & file5
					End If					
				
				End if

			Set objImage = Nothing
			
'		End If		
		
		'인서트
		SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file5 &"','"& filepath &"') "
		ConnAplus.execute(SQL)
	else
		if file_old5 <> "" then
			file5 = file_old5
			'인서트
			SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
			SQL = SQL & " ) values ( "
			SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file5 &"','"& filepath &"') "
			ConnAplus.execute(SQL)
		end if
	end if

	if uploadform("file6") <> "" then
		if file_old6 <> "" then
			filepath6 = uploadform.DefaultPath & "\" & file_old6
			uploadform.DeleteFile filepath6
		end if
		uploadform("file6").Save
		file6 = uploadform("file6").FileName

'		If filepath = "/fileupload/reception/support/" And b_idx = "2021032400009" then

			' 썸네일이미지를 만들기위한사전작업
			Set objImage = Server.CreateObject("DEXT.ImageProc")
				
				'uploadForm("file1").ImageRotate = 270
				imgDefaultFilePath = uploadform.DefaultPath & "\"

				'이미지 사이즈 가져오기
				imgWidth	= uploadForm("file6").ImageWidth
				imgHeight	= uploadForm("file6").ImageHeight

				' 이미지 가로사이즈 지정
				defaultWidth		= 2000

				If imgWidth > defaultWidth Then		
					If imgWidth > imgHeight then
						imgWidthM		= imgWidth * defaultWidth / imgHeight
						imgWidthH		= imgHeight * defaultWidth / imgHeight
					Else
						imgWidthM		= imgWidth * defaultWidth / imgWidth
						imgWidthH		= imgHeight * defaultWidth / imgWidth					
					End If					
				Else					
					imgWidthM		= imgWidth
					imgWidthH		= imgHeight
				End If
			
				' 썸네일이미지 저장하기	
				If True = objImage.SetSourceFile(imgDefaultFilePath & file6) Then
					uploadform.DeleteFile imgDefaultFilePath & "i_" & file6 '먼저 삭제
					lastSavedThumbnailFileName = objImage.SaveAsThumbnail(imgDefaultFilePath & "i_" & file6, imgWidthM, imgWidthH, false)

					If lastSavedThumbnailFileName <> "" Then
						uploadform.DeleteFile imgDefaultFilePath & file6
						file6 = "i_" & file6				
					End If					
				End if

			Set objImage = Nothing
	
'		End If		
		
		'인서트
		SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file6 &"','"& filepath &"') "
		ConnAplus.execute(SQL)
	else
		if file_old6 <> "" then
			file6 = file_old6
			'인서트
			SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
			SQL = SQL & " ) values ( "
			SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file6 &"','"& filepath &"') "
			ConnAplus.execute(SQL)
		end if
	end if

	if uploadform("file7") <> "" then
		if file_old7 <> "" then
			filepath7 = uploadform.DefaultPath & "\" & file_old7
			uploadform.DeleteFile filepath7
		end if
		uploadform("file7").Save
		file7 = uploadform("file7").FileName

'		If filepath = "/fileupload/reception/support/" And b_idx = "2021032400009" then

			' 썸네일이미지를 만들기위한사전작업
			Set objImage = Server.CreateObject("DEXT.ImageProc")
				
				'uploadForm("file1").ImageRotate = 270
				imgDefaultFilePath = uploadform.DefaultPath & "\"

				'이미지 사이즈 가져오기
				imgWidth	= uploadForm("file7").ImageWidth
				imgHeight	= uploadForm("file7").ImageHeight

				' 이미지 가로사이즈 지정
				defaultWidth		= 2000

				If imgWidth > defaultWidth Then		
					If imgWidth > imgHeight then
						imgWidthM		= imgWidth * defaultWidth / imgHeight
						imgWidthH		= imgHeight * defaultWidth / imgHeight
					Else
						imgWidthM		= imgWidth * defaultWidth / imgWidth
						imgWidthH		= imgHeight * defaultWidth / imgWidth					
					End If					
				Else					
					imgWidthM		= imgWidth
					imgWidthH		= imgHeight
				End If
			
				' 썸네일이미지 저장하기	
				If True = objImage.SetSourceFile(imgDefaultFilePath & file7) Then
					uploadform.DeleteFile imgDefaultFilePath & "i_" & file7 '먼저 삭제
					lastSavedThumbnailFileName = objImage.SaveAsThumbnail(imgDefaultFilePath & "i_" & file7, imgWidthM, imgWidthH, false)

					If lastSavedThumbnailFileName <> "" Then
						uploadform.DeleteFile imgDefaultFilePath & file7
						file7 = "i_" & file7				
					End If				
				End if

			Set objImage = Nothing
			
'		End If

		'인서트
		SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file7 &"','"& filepath &"') "
		ConnAplus.execute(SQL)
	else
		if file_old7 <> "" then
			file7 = file_old7
			'인서트
			SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
			SQL = SQL & " ) values ( "
			SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file7 &"','"& filepath &"') "
			ConnAplus.execute(SQL)
		end if
	end if

	if uploadform("file8") <> "" then
		if file_old8 <> "" then
			filepath8 = uploadform.DefaultPath & "\" & file_old8
			uploadform.DeleteFile filepath8
		end if
		uploadform("file8").Save
		file8 = uploadform("file8").FileName

'		If filepath = "/fileupload/reception/support/" And b_idx = "2021032400009" then

			' 썸네일이미지를 만들기위한사전작업
			Set objImage = Server.CreateObject("DEXT.ImageProc")
				
				'uploadForm("file1").ImageRotate = 270
				imgDefaultFilePath = uploadform.DefaultPath & "\"

				'이미지 사이즈 가져오기
				imgWidth	= uploadForm("file8").ImageWidth
				imgHeight	= uploadForm("file8").ImageHeight

				' 이미지 가로사이즈 지정
				defaultWidth		= 2000

				If imgWidth > defaultWidth Then		
					If imgWidth > imgHeight then
						imgWidthM		= imgWidth * defaultWidth / imgHeight
						imgWidthH		= imgHeight * defaultWidth / imgHeight
					Else
						imgWidthM		= imgWidth * defaultWidth / imgWidth
						imgWidthH		= imgHeight * defaultWidth / imgWidth					
					End If					
				Else					
					imgWidthM		= imgWidth
					imgWidthH		= imgHeight
				End If
			
				' 썸네일이미지 저장하기	
				If True = objImage.SetSourceFile(imgDefaultFilePath & file8) Then
					uploadform.DeleteFile imgDefaultFilePath & "i_" & file8 '먼저 삭제
					lastSavedThumbnailFileName = objImage.SaveAsThumbnail(imgDefaultFilePath & "i_" & file8, imgWidthM, imgWidthH, false)

					If lastSavedThumbnailFileName <> "" Then
						uploadform.DeleteFile imgDefaultFilePath & file8
						file8 = "i_" & file8				
					End If
				End if

			Set objImage = Nothing
			
'		End If		
		
		'인서트
		SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file8 &"','"& filepath &"') "
		ConnAplus.execute(SQL)
	else
		if file_old8 <> "" then
			file8 = file_old8
			'인서트
			SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
			SQL = SQL & " ) values ( "
			SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file8 &"','"& filepath &"') "
			ConnAplus.execute(SQL)
		end if
	end if

	if uploadform("file9") <> "" then
		if file_old9 <> "" then
			filepath9 = uploadform.DefaultPath & "\" & file_old9
			uploadform.DeleteFile filepath9
		end if
		uploadform("file9").Save
		file9 = uploadform("file9").FileName

'		If filepath = "/fileupload/reception/support/" And b_idx = "2021032400009" then

			' 썸네일이미지를 만들기위한사전작업
			Set objImage = Server.CreateObject("DEXT.ImageProc")
				
				'uploadForm("file1").ImageRotate = 270
				imgDefaultFilePath = uploadform.DefaultPath & "\"

				'이미지 사이즈 가져오기
				imgWidth	= uploadForm("file9").ImageWidth
				imgHeight	= uploadForm("file9").ImageHeight

				' 이미지 가로사이즈 지정
				defaultWidth		= 2000

				If imgWidth > defaultWidth Then		
					If imgWidth > imgHeight then
						imgWidthM		= imgWidth * defaultWidth / imgHeight
						imgWidthH		= imgHeight * defaultWidth / imgHeight
					Else
						imgWidthM		= imgWidth * defaultWidth / imgWidth
						imgWidthH		= imgHeight * defaultWidth / imgWidth					
					End If					
				Else					
					imgWidthM		= imgWidth
					imgWidthH		= imgHeight
				End If
			
				' 썸네일이미지 저장하기	
				If True = objImage.SetSourceFile(imgDefaultFilePath & file9) Then
					uploadform.DeleteFile imgDefaultFilePath & "i_" & file9 '먼저 삭제
					lastSavedThumbnailFileName = objImage.SaveAsThumbnail(imgDefaultFilePath & "i_" & file9, imgWidthM, imgWidthH, false)

					If lastSavedThumbnailFileName <> "" Then
						uploadform.DeleteFile imgDefaultFilePath & file9
						file9 = "i_" & file9				
					End If
				End if

			Set objImage = Nothing
			
'		End If		
		
		'인서트
		SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file9 &"','"& filepath &"') "
		ConnAplus.execute(SQL)
	else
		if file_old9 <> "" then
			file9 = file_old9
			'인서트
			SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
			SQL = SQL & " ) values ( "
			SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file9 &"','"& filepath &"') "
			ConnAplus.execute(SQL)
		end if
	end if

	if uploadform("file10") <> "" then
		if file_old10 <> "" then
			filepath10 = uploadform.DefaultPath & "\" & file_old10
			uploadform.DeleteFile filepath10
		end if
		uploadform("file10").Save
		file10 = uploadform("file10").FileName

'		If filepath = "/fileupload/reception/support/" And b_idx = "2021032400009" then

			' 썸네일이미지를 만들기위한사전작업
			Set objImage = Server.CreateObject("DEXT.ImageProc")
				
				'uploadForm("file1").ImageRotate = 270
				imgDefaultFilePath = uploadform.DefaultPath & "\"

				'이미지 사이즈 가져오기
				imgWidth	= uploadForm("file10").ImageWidth
				imgHeight	= uploadForm("file10").ImageHeight

				' 이미지 가로사이즈 지정
				defaultWidth		= 2000

				If imgWidth > defaultWidth Then		
					If imgWidth > imgHeight then
						imgWidthM		= imgWidth * defaultWidth / imgHeight
						imgWidthH		= imgHeight * defaultWidth / imgHeight
					Else
						imgWidthM		= imgWidth * defaultWidth / imgWidth
						imgWidthH		= imgHeight * defaultWidth / imgWidth					
					End If					
				Else					
					imgWidthM		= imgWidth
					imgWidthH		= imgHeight
				End If
			
				' 썸네일이미지 저장하기	
				If True = objImage.SetSourceFile(imgDefaultFilePath & file10) Then
					uploadform.DeleteFile imgDefaultFilePath & "i_" & file10 '먼저 삭제
					lastSavedThumbnailFileName = objImage.SaveAsThumbnail(imgDefaultFilePath & "i_" & file10, imgWidthM, imgWidthH, false)

					If lastSavedThumbnailFileName <> "" Then
						uploadform.DeleteFile imgDefaultFilePath & file10
						file10 = "i_" & file10				
					End If
				End if

			Set objImage = Nothing
			
'		End If			
		
		'인서트
		SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
		SQL = SQL & " ) values ( "
		SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file10 &"','"& filepath &"') "
		ConnAplus.execute(SQL)
	else
		if file_old10 <> "" then
			file10 = file_old10
			'인서트
			SQL = " INSERT INTO 파일저장 (게시판종류, 게시판종류2, 게시판인덱스, 파일명, 파일경로 "
			SQL = SQL & " ) values ( "
			SQL = SQL & " '"& b_type1 &"','"& b_type2 &"','"& b_idx &"', '"& file10 &"','"& filepath &"') "
			ConnAplus.execute(SQL)
		end if
	end if

	ConnAplus.Close
	Set ConnAplus = Nothing

	Set uploadform = Nothing

%>

<script language="javascript" type="text/javascript">
	alert('저장되었습니다.');
	parent.Close();
	parent.ImgList('<%=b_type1 %>', '<%=b_type2 %>', '<%=b_idx %>');
</script>