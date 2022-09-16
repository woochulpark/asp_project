<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	code = Trim(request("code"))		
	
	SQL = " SELECT 회수자, convert(varchar(16),회수일,120) as 회수일 "
	SQL = SQL & " FROM 근조기회수 "
	SQL = SQL & " WHERE 행사번호 = '"& code &"' "	

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)	

	If Rs.EOF Then
		collname = ""
		colldate = ""
	Else
		collname	 = Rs("회수자")
		colldate	 = Rs("회수일")		
	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	

	op_min = "<option value='00'>00분</option>"
    op_min_5 = "<option value='00'>00</option>"
	op_hour = "<option value='00'>00시</option>"

	for i=1 to 59
		if i < 10 then
			op_min = op_min & "<option value='0"& i &"'>0"& i &"분</option>"
		else
			op_min = op_min & "<option value='"& i &"'>"& i &"분</option>"
		end if
	next

    for i=1 to 11
		k = i * 5
		if k < 10 then
			op_min_5 = op_min_5 & "<option value='0"& k &"'>0"& k &"</option>"
		else
			op_min_5 = op_min_5 & "<option value='"& k &"'>"& k &"</option>"
		end if
	next

	for i=1 to 23
		if i < 10 then
			op_hour = op_hour & "<option value='0"& i &"'>0"& i &"시</option>"
		else
			op_hour = op_hour & "<option value='"& i &"'>"& i &"시</option>"
		end if
	next	
	
	if colldate <> "" then
		value = Split(colldate, " ")
		value2 = Split(value(1), ":")	
		colldate = value(0)
		collhour = value2(0)
		collmin = value2(1)
	else
		colldate = ""
		collhour = "00"
		collmin = "00"
	end if	
%>

<div>	
	<table class="form_ty no_l">
		<caption>근조기</caption>
		<colgroup>
			<col span="1" class="verti_w05"><col span="1" style="width:*%;">
		</colgroup>

			<tr>
				<th scope="row">회수자</th>
				<td><input type="text" id="cName" name="cName" value="<%=collname %>" class="input_ty w100" placeholder="회수자 이름을 입력하세요."></td>
			</tr>
			<tr>
				<th scope="row" rowspan="2">회수일시</th>
				<td>
					<span class="dp_box w100"><input type="text" id="cDate" name="cDate" value="<%=colldate %>" class="datepicker input_ty start-date w100" placeholder="회수일시를 선택해주세요." readonly ></span>
				</td>
			</tr>
			<tr>
				<td class="ty02">
					<select id="cHour" name="cHour" class="select_ty w_c50"><%=op_hour %></select>
					<select id="cMin" name="cMin" class="select_ty w_c50"><%=op_min_5 %></select>
				</td>
			</tr>
	</table>
</div>

<% 	if collname = "" then %>
	<div class="btm_btns">
		<a href="javascript:void(0);" onclick="Save('a', '<%=code %>');" class="btn_ty btn_b">회수</a>
	</div><!--// btm_btns -->
<% 	else %>
	<div class="btm_btns sort04">
		<a href="javascript:void(0);" onclick="Save('c', '<%=code %>');" class="btn_ty ty07 btn_b">회수 취소</a>
		<a href="javascript:void(0);" onclick="Save('b', '<%=code %>');" class="btn_ty ty05 btn_b">수정</a>
	</div><!--// btm_btns -->
<% 	end if %>

<script language="javascript" type="text/javascript">
	$(function () {		
		$("#cDate").datepicker({
			autoHide: true,
		  });
	})
</script>
<% 	if collname <> "" then %>
<script language="javascript" type="text/javascript">
	document.getElementById("cHour").value = "<%=collhour %>";
	document.getElementById("cMin").value = "<%=collmin %>";
</script>
<% 	end if %>