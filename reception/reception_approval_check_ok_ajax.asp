<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%
	code = request("Code")

	SQL = "select a.상태, b.일반단체구분, b.상품코드, c.변경상품코드, c.변경상품명 "
    	SQL = SQL & " from 행사_승인요청 a  "
    	SQL = SQL & "   inner join 행사마스터 b on a.행사번호 = b.행사번호 "
    	SQL = SQL & "   left outer join 행사_기타정보 c on a.행사번호 = c.행사번호 "
    	SQL = SQL & " where a.행사번호 = '"& code &"' "
	
	SQL2 = "update 행사_승인요청 set 상태 = '진행승인확인', 등록일 = getdate() where 행사번호 = '"& code &"' "

	SQL3 = "update 행사_승인요청 set 상태 = '완료승인확인', 등록일 = getdate() where 행사번호 = '"& code &"' "    
    
	SQL_ERP1 = "update 행사마스터 "
	SQL_ERP1 = SQL_ERP1 & "	set 도착일시 = LEFT(REPLACE(REPLACE(REPLACE(CONVERT(CHAR(19), a.빈소도착, 120),' ',''), '-', ''), ':', ''), 12), "
	SQL_ERP1 = SQL_ERP1 & "		별세일 = LEFT(REPLACE(REPLACE(REPLACE(CONVERT(CHAR(19), a.별세일시, 120),' ',''), '-', ''), ':', ''), 12), "
	SQL_ERP1 = SQL_ERP1 & "		고인성명 = a.고인명, "
	SQL_ERP1 = SQL_ERP1 & "		고인성별 = a.고인성별, "
	SQL_ERP1 = SQL_ERP1 & "		연령 = a.고인연령, "
	SQL_ERP1 = SQL_ERP1 & "		부고사유 = a.사망사유, "
	SQL_ERP1 = SQL_ERP1 & "		장례형태 = a.장례형태, "
	SQL_ERP1 = SQL_ERP1 & "		종교 = a.장례진행종교, "
	SQL_ERP1 = SQL_ERP1 & "		장례식장 = a.장례식장코드, "
	SQL_ERP1 = SQL_ERP1 & "		빈소 = a.호실, "
	SQL_ERP1 = SQL_ERP1 & "		장지 = a.[1차장지], "
	SQL_ERP1 = SQL_ERP1 & "		장지2 = a.[2차장지], "
	SQL_ERP1 = SQL_ERP1 & "		버스사용 = case when a.버스사용여부 = 'Y' then '사용' else '미사용' end, "
	SQL_ERP1 = SQL_ERP1 & "		버스방향 = a.버스장지, "
	SQL_ERP1 = SQL_ERP1 & "		리무진사용 = case when a.리무진사용여부 = 'Y' then '사용' else '미사용' end, "
	SQL_ERP1 = SQL_ERP1 & "		리무진방향 = a.리무진장지, "
	SQL_ERP1 = SQL_ERP1 & "		입관일시 = LEFT(REPLACE(REPLACE(REPLACE(CONVERT(CHAR(19), a.입관일시, 120),' ',''), '-', ''), ':', ''), 12), "
	SQL_ERP1 = SQL_ERP1 & "		발인일시 = LEFT(REPLACE(REPLACE(REPLACE(CONVERT(CHAR(19), a.발인일시, 120),' ',''), '-', ''), ':', ''), 12), "
	SQL_ERP1 = SQL_ERP1 & "		상주 = b.상주명, "
	SQL_ERP1 = SQL_ERP1 & "		상주휴대폰 = b.연락처, "
	SQL_ERP1 = SQL_ERP1 & "		관계 = b.관계, "
	SQL_ERP1 = SQL_ERP1 & "		일반단체구분 = b.변경행사구분, "
	SQL_ERP1 = SQL_ERP1 & "		상품코드 = b.변경상품코드, "
	SQL_ERP1 = SQL_ERP1 & "		저가형지원품목 = 지원서비스 "
	SQL_ERP1 = SQL_ERP1 & "from 행사_고인정보 a inner join 행사_기타정보 b on a.행사번호 = b.행사번호 "
	SQL_ERP1 = SQL_ERP1 & "where 행사마스터.행사번호 = a.행사번호 and a.행사번호 = '"& code &"' "

	SQL_ERP2 = "update 행사마스터_세부추가 "
	SQL_ERP2 = SQL_ERP2 & "	set 용품도착일시 = LEFT(REPLACE(REPLACE(REPLACE(CONVERT(CHAR(19), b.용품도착일, 120),' ',''), '-', ''), ':', ''), 12), "
	SQL_ERP2 = SQL_ERP2 & "		화환도착일시 = LEFT(REPLACE(REPLACE(REPLACE(CONVERT(CHAR(19), b.화환도착일, 120),' ',''), '-', ''), ':', ''), 12), "
	SQL_ERP2 = SQL_ERP2 & "		근조기설치 = LEFT(REPLACE(REPLACE(REPLACE(CONVERT(CHAR(19), b.근조기설치일, 120),' ',''), '-', ''), ':', ''), 12) "
	SQL_ERP2 = SQL_ERP2 & "from 행사_기타정보 b "
	SQL_ERP2 = SQL_ERP2 & "where 행사마스터_세부추가.행사번호 = b.행사번호 and b.행사번호 = '"& code &"' "

    	SQL_ERP3 = "insert into 행사상품변경 (행사번호, 계약코드, 전상품코드, 전회차, 월부금, 전지원금액, 전전용금액, 전납입금액, 전납입잔금, 등록자, 등록일시) "
	SQL_ERP3 = SQL_ERP3 & "	select a.행사번호, a.계약코드, a.상품코드, b.계약회차, b.할인후월부금, 0, 0, isnull(b.총입금액,0), 0, '', getdate() "
	SQL_ERP3 = SQL_ERP3 & "	from 행사마스터 a (nolock) "
	SQL_ERP3 = SQL_ERP3 & "		left outer join 계약마스터3v b (nolock) on a.계약코드 = b.계약코드 "
	SQL_ERP3 = SQL_ERP3 & " where a.행사번호 = '"& code &"' "

	SQL_ERP4 = "update 행사계약마스터 set 상품코드 = '"& ChangeItem &"', 상품액 = (select 상품액 from 상품코드 where 상품코드 = '"& ChangeItem &"') "
        SQL_ERP4 = SQL_ERP4 & " where 행사번호 = '"& code &"' "

	SQL_ERP5 = "select count(*) from 행사상품변경 where 행사번호 = '"& code &"' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)

	If Rs.EOF Then
		sign = "N"
	Else
		sign = "Y"
		stat = Rs("상태")

        	ViewType = Rs("일반단체구분")
		basicItem = Rs("상품코드")
        	ChangeItem = Rs("변경상품코드")

        if stat = "진행승인요청" then

            if ViewType = "용품배송" or ViewType = "화환배송" or ViewType = "용품+화환배송" or ViewType = "근조화환배송" then

		'완료승인확인
                ConnAplus.execute(SQL3)

                ConnAplus.execute(SQL_ERP2)
            else

		'진행승인확인
                ConnAplus.execute(SQL2)

                ConnAplus.execute(SQL_ERP1)

                ConnAplus.execute(SQL_ERP2)

                if basicItem <> ChangeItem then
		    
		    Set Rs5 = ConnAplus.execute(SQL_ERP5)
		    
		    If Rs5(0) = 0 Then	
                    	ConnAplus.execute(SQL_ERP3)		   	
		    end if

		    Set Rs5 = Nothing	                    

                    ConnAplus.execute(SQL_ERP4)

                end if
            end if
        end if
	End If

	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing
	
	if sign = "Y" then
		if stat = "진행승인요청" then 
			response.write "a"
		else
			response.write "b"
		end if
	else
		response.write "c"
	end if

	response.End

%>