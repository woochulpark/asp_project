<%
    mName = Trim(request("mName"))
    mPhone = Trim(request("mPhone"))
    input23_view = Trim(request("input23_view"))
%>
<div>
	<table class="form_ty">
		<caption><%=input23_view %>/연락처 수정</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="1" style="width:*%;">
		</colgroup>
		<tbody
			<tr>
				<th scope="row"><%=input23_view %></th>
				<td><input type="text" class="input_ty w100" id="member" placeholder="<%=mName %>"></td>
			</tr>
			<tr>
				<th scope="row">연락처</th>
				<td><input type="text" class="input_ty w100" id="memberphone" maxlength="11" onkeyup="chkInteger(this);" placeholder="<%=mPhone %>"></td>
			</tr>
		</tbody>
	</table>
</div>
<div class="btm_btns">
	<a href="javascript:void(0);" class="btn_ty ty05 btn_b" onclick="MemberAdd($('#member').val(), $('#memberphone').val());">수정</a>
</div><!--// btm_btns -->
