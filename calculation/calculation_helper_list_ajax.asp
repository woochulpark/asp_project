<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	dim sValue
	sValue = request("sValue")	
	sType = request("sType")

	SQL = " select 사원코드, 사원명, 사원구분, left(주민번호,6), replace(휴대폰,' ','') "
	SQL = SQL & " from 행사사원마스터 (nolock) "	
	SQL = SQL & " where 주민번호 is not null "	
	if sValue <> "" then
		SQL = SQL & " and 사원명 like '%" & sValue & "%' "
	end if
	SQL = SQL & " order by 사원명 asc "	

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
%>
			<div><button class="search_btn" type="button" onclick="Close();">닫기</button></div>
			<form>
    		<div class="search_ul">	
        		<div class="search_box">
					<input hidden="hidden" />
        			<input type="text" class="search_input" name="sValue" placeholder="사원명" value="<%= sValue %>" style="width:250px; border:1px solid black;">
					<span><button class="search_btn" type="button" onclick="HelperList3('<%=sType %>', this.form.sValue.value);">검색</button></span>
					<span><button class="search_btn" type="button" onclick="HelperAdd('<%=sType %>');">항목추가</button></span>
					<span><button class="search_btn" type="button" onclick="HelperWrite('<%=sType %>', '<%=sValue %>');">신규등록</button></span>
				</div>
			</div>
			</form>
			<br />
			<div id="HelperList">
				<table class="basetbl alignC">
					<colgroup>
						<col width="60px">
						<col width="150px">
						<col width="150px">
                        <col width="150px">
						<col width="*">
					</colgroup>
					<tr>
						<th>선택</th>
						<th>도우미명</th>
						<th>주민번호</th>
						<th>휴대폰</th>
						<th>수정</th>
					</tr>
<%
	if rc = 0 then 
%>
					<tr><td colspan="5">일치하는 검색결과가 없습니다.</td></tr>
<%
	else
		for i=0 to UBound(arrObj,2)
			mcode	= arrObj(0,i)
			mname	= arrObj(1,i)
			mtype	= arrObj(2,i)
			mjumin	= arrObj(3,i)
			mphone	= arrObj(4,i)
%>
					<tr>
						<td><input type="checkbox" value="<%=mcode %>,<%=mname %>,<%=mtype %>"></td>
						<td><%=mname %></td>						
						<td><%=mjumin %></td>
						<td><%=mphone %></td>
						<td><a href="#" onclick="HelperView('<%=sType %>', '<%=sValue %>', '<%=mcode %>');">수정</a></td>
					</tr>		
<%
		next
	end if 
%>
				</table>
			</div>