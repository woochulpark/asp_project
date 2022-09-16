﻿<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	dim sValue
	sValue = request("sValue")	
	sType = request("sType")	
	code = request("code")

	SQL = " select 대표명칭 from 공용코드 where 대표코드 =  '00255' "	
	SQL2 = " select 은행코드,은행명 from 은행코드 where 사용구분 =  'Y' "		

	SQL3 = " select 사원명,사원구분,주민번호,isnull(휴대폰,' ') 휴대폰,은행코드,계좌번호,예금주명,지역 "
    SQL3 = SQL3 + " from 행사사원마스터  where 사원코드 = '"& code &"' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ		
		
	Set Rs = ConnAplus.execute(SQL)

	If Rs.EOF Then
		rc = 0		
	Else
		rc = Rs.RecordCount
		arrObj = Rs.GetRows(rc)
	End If

	Set Rs = ConnAplus.execute(SQL2)

	If Rs.EOF Then
		rc2 = 0		
	Else
		rc2 = Rs.RecordCount
		arrObj2 = Rs.GetRows(rc2)
	End If

	Set Rs = ConnAplus.execute(SQL3)
    if not(Rs.bof or Rs.eof) then
        hi_mcode		= code '도우미 사번
        hi_mgubun		= Rs("사원구분")
        hi_mname		= Rs("사원명")
        hi_mjumin1		= Left(Rs("주민번호") ,6)
		hi_mjumin2		= Right(Rs("주민번호") ,7)
        hi_mbank		= Rs("은행코드")
        hi_mbankno		= Rs("계좌번호")
        hi_mbankname	= Rs("예금주명")
        hi_mphone		= replace(trim(Rs("휴대폰")),"-","")
    end if

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	

	gubun_list = ""
	if rc <> 0 then	
		for i=0 to UBound(arrObj,2)
			gubun	= arrObj(0,i)
			gubun_list = gubun_list & "<option value='"& gubun &"'>"& gubun &"</option>"
		next
	end if

	bank_list = "<option value=''>== 은행선택==</option>"
	if rc2 <> 0 then	
		for i=0 to UBound(arrObj2,2)
			bankcode	= arrObj2(0,i)
			bankname	= arrObj2(1,i)
			bank_list = bank_list & "<option value='"& bankcode &"'>"& bankname &"</option>"
		next
	end if	
%>
			<div><button class="search_btn" type="button" onclick="HelperList3('<%=sType %>','<%=sValue %>');">닫기</button></div>			
			<div id="HelperWrite">
				<form name="frm_helper" id="frm_helper">
				<table class="basetbl alignC">
					<colgroup>
						<col width="200px">						
						<col width="*">
					</colgroup>
					<tr>
						<th>도우미명</th>
						<td><input type="text" name="hi_mname" value="<%=hi_mname %>" style="border:1px solid black;" readonly /></td>
					</tr>
					<tr>
						<th>도우미구분</th>
						<td><select name="hi_mgubun" id="hi_mgubun"><%=gubun_list %></select></td>
					</tr>
					<tr>
						<th>연락처</th>
						<td><input type="text" name="hi_mphone" value="<%=hi_mphone %>" style="border:1px solid black;" /></td>
					</tr>
					<tr>
						<th>은행</th>
						<td><select name="hi_mbank" id="hi_mbank"><%=bank_list %></select></td>
					</tr>
					<tr>
						<th>계좌번호</th>
						<td><input type="text" name="hi_mbankno" value="<%=hi_mbankno %>" style="border:1px solid black;" /></td>
					</tr>
					<tr>
						<th>예금주명</th>
						<td><input type="text" name="hi_mbankname" value="<%=hi_mbankname %>" style="border:1px solid black;" /></td>
					</tr>
					<tr>
						<th>주민번호</th>
						<td><input type="text" name="hi_mjumin1" value="<%=hi_mjumin1 %>" maxlength="6" style="border:1px solid black;" />-<input type="text" name="hi_mjumin2" value="<%=hi_mjumin2 %>" maxlength="7" style="border:1px solid black;" /></td>
					</tr>
				</table>
				</form>
			</div>
			<div><button class="search_btn" type="button" onclick="HelperList3('<%=sType %>','<%=sValue %>');">리스트</button></div>
			<div><button class="search_btn" type="button" onclick="HelperUpdate('<%=sType %>','<%=sValue %>','<%=code %>');">수정</button></div>

<script>
	document.getElementById("hi_mgubun").value = "<%=hi_mgubun %>";
	document.getElementById("hi_mbank").value = "<%=hi_mbank %>";
</script>