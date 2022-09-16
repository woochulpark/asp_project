<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
	
	code = Trim(request.Form("code"))


	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	SQL_DELTE = " DELETE FROM 행사도우미 WHERE 행사번호 = '"& code &"' "
	
	Set Rs = ConnAplus.execute(SQL_DELTE)

		SQL = " INSERT INTO 행사도우미 (행사번호, 라인번호, 구분, 사원코드, 사원명, 시작일자, 작업시간, 도우미단가, 작업수당, "
		SQL = SQL & " 시간외수당, 총액, 지급액, 세액, 일차, 시작시간, 변경세액, 소득세, 주민세, 등록자, 시스템일자 ) "		
		SQL = SQL & " select a.행사번호, a.순번 라인번호, b.사원구분 구분, a.사원코드, a.사원명 "
		SQL = SQL & " 	, convert(varchar(8), a.접수일, 112) 시작일자 " ', NULL 종료일자
		SQL = SQL & "	, a.경과시간 작업시간 "
		SQL = SQL & "	, c.구분1 도우미단가 "
		SQL = SQL & "	, (a.경과시간 * c.구분1) 작업수당 "	
		SQL = SQL & "	, 0 시간외수당 "	
		SQL = SQL & "	, (a.경과시간 * c.구분1) 총액 "	
		SQL = SQL & "	, convert(int, (a.경과시간 * c.구분1) "	
		SQL = SQL & "	  - (((a.경과시간 * c.구분1) * 0.03 / 10) * 10) "	
		SQL = SQL & "	  - (((a.경과시간 * c.구분1) * 0.003 / 10) * 10)) 지급액 "	
		SQL = SQL & "	, convert(int, (((a.경과시간 * c.구분1) * 0.03 / 10) * 10)) "	
		SQL = SQL & "	  + convert(int, (((a.경과시간 * c.구분1) * 0.003 / 10) * 10)) 세액 " '	, null 결제방법	
		SQL = SQL & "	, convert(varchar, a.일차) + '일차' 일차 "	
		SQL = SQL & "	, replace(a.출동일시, ':', '') 시작시간 "	
		SQL = SQL & "	, convert(int, (((a.경과시간 * c.구분1) * 0.03 / 10) * 10)) "	
		SQL = SQL & "	  + convert(int, (((a.경과시간 * c.구분1) * 0.003 / 10) * 10)) 변경세액 "	
		SQL = SQL & "	, convert(int, (((a.경과시간 * c.구분1) * 0.03 / 10) * 10)) 속득세 "	
		SQL = SQL & "	, convert(int, (((a.경과시간 * c.구분1) * 0.003 / 10) * 10)) 주민세 "	
		SQL = SQL & "	, '"& user_id &"' 등록자 "	
		SQL = SQL & "	, getdate() 시스템일자 "	
		SQL = SQL & " from ( select * "
		SQL = SQL & " 			, case when convert(int, left(출동일시,2)) <= convert(int, left(종료일시,2)) then convert(int, left(종료일시,2)) - convert(int, left(출동일시,2)) "
		SQL = SQL & " 			  else convert(int, left(종료일시,2)) + 24 - convert(int, left(출동일시,2)) "
		SQL = SQL & " 			  end 경과시간 "
		SQL = SQL & " 		from 행사_회사지원 (nolock) ) a "	
		SQL = SQL & "	inner join 행사사원마스터 b (nolock) on a.사원코드 = b.사원코드 "	
		SQL = SQL & "	inner join 공용코드 c (nolock) on b.사원구분 = c.대표명칭 "	
		SQL = SQL & " where 1=1 "	
		SQL = SQL & " and c.대표코드 = '00255' "	
		SQL = SQL & " and a.행사번호 = '"& code &"' "

		Set Rs = ConnAplus.execute(SQL)

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	response.write "<script type='text/javascript'>"
	response.write "alert('인력지원 도우미 현황 가져오기 완료되었습니다.');"
	response.write "location.replace('calculation_helper.asp?Code="& code &"');"
	response.write "</script>"

	response.End

%>
