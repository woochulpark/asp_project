<%
    cno = Trim(request("cno"))
	receipt_hp = Trim(request("receipt_hp"))
	product_amt = Trim(request("product_amt"))
	install_period = Trim(request("install_period"))	
	card_gubun = Trim(request("card_gubun"))	
	card_result = Trim(request("card_result"))

%>
<div>
	<table class="form_ty">
		<caption>영수증 수신 연락처</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="1" style="width:*%;">
		</colgroup>
		<tbody			
			<tr>
				<th scope="row">영수증 수신번호</th>
				<td><input type="text" class="input_ty w100" id="receipt_hp" maxlength="12" onkeyup="chkInteger(this);" placeholder="<%=receipt_hp %>" value="<%=receipt_hp %>"></td>
			</tr>
		</tbody>
	</table>
</div>
<div class="btm_btns">
	<a href="javascript:void(0);" class="btn_ty ty05 btn_b" onclick="SendMMS('<%=cno%>', $('#receipt_hp').val(), '<%=product_amt%>', '<%=install_period%>', '<%=card_gubun%>', '<%=card_result%>' );">영수증 재전송</a>
</div><!--// btm_btns -->
