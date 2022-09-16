<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	category = request("category")
	category2 = request("opentype2")

	if opentype2 = "" then 
		opentype2 = "전체"
	end if	
	
	category_list = "<option value='전체'>전체</option>"

	if category = "협력업체" or category = "기업담당자" then
		if category = "협력업체" then
			SQL = "  select b.성함 사원명, b.코드 협력업체코드 "
			SQL = SQL & " from 의전거래처마스터 a (nolock) "
			SQL = SQL & "	inner join 행사의전팀장 b (nolock) on replace(a.거래처명, '(주)','') = b.성함 "
			SQL = SQL & " where 1=1 "
			SQL = SQL & "	and a.계약여부 = '계약' "
			SQL = SQL & "	and b.센터 = '꽃집' "
			SQL = SQL & "	and a.거래처코드 not in ('100068') "
			SQL = SQL & " order by b.성함 asc "
		elseif category = "기업담당자" then
			SQL = " select b.단체명, c.사업장 "
			SQL = SQL & " from 법인마스터 a (nolock) "
			SQL = SQL & "	inner join 행사단체 b (nolock) on a.행사단체 = b.단체코드 "
			SQL = SQL & "	inner join 행사단체_사업장 c (nolock) on a.행사단체 = c.단체코드 "			
			SQL = SQL & " order by b.단체명 "
		end if

		Set ConnAplus = CreateObject("ADODB.Connection")
		ConnAplus.Open CONN_OBJ	

		Set Rs = ConnAplus.execute(SQL)

		If Rs.EOF Then
			rc = 0
		Else
			rc = Rs.RecordCount
			arrObj = Rs.GetRows(rc)
		End If

		Rs.Close
		Set Rs = Nothing
		ConnAplus.Close
		Set ConnAplus = Nothing

		if category = "협력업체" then
			if rc <> 0 then	
				for i=0 to UBound(arrObj,2)
					catecory	= arrObj(0,i)
					if catecory = category2 then
						category_list = category_list & "<option value='"& catecory &"' selected>"& catecory &"</option>"
					else
						category_list = category_list & "<option value='"& catecory &"'>"& catecory &"</option>"
					end if
			
				next
			end if	
		elseif category = "기업담당자" then
			if rc <> 0 then	
				for i=0 to UBound(arrObj,2)
					catecory_a	= arrObj(0,i)
					catecory_b	= arrObj(1,i)
					catecory = catecory_a & " " & catecory_b
					if catecory = category2 then
						category_list = category_list & "<option value='"& catecory &"' selected>"& catecory &"</option>"
					else
						category_list = category_list & "<option value='"& catecory &"'>"& catecory &"</option>"
					end if
			
				next
			end if	
		end if
	end if
		
%>
<select name="opentype2" id="opentype2" class="select_ty w100" ><%=category_list %></select>