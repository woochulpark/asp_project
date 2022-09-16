<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%
	menu = "정산"	
	lnbe = "class='on'"	

	code = Trim(request("Code"))
	
	if code = "" then 
		response.End
	end if

	SQL = "select 제단, 제단금액, 제단할인율, 제단할인금액, 입금일자, 장지특이사항, 고인특이사항, 행사특이사항 "
	SQL = SQL & " from 행사특이사항 "
	SQL = SQL & " where  행사번호 = '" & code & "' "

	'SQL_etc = "exec p_행사정산조회_new '" & code & "'"

	SQL_etc = "select 일차, 내용 from 행사_장례진행 a (nolock) where 행사번호 = '" & code & "' order by 행사번호, 일차 "
	worklog = ""

	SQL_S = "select 정산완료일 from 행사마스터 "
	SQL_S = SQL_S & " where 행사번호 = '"& code &"' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)

	If Rs.EOF Then
		
	Else
		jedan = Trim(Rs("제단"))
		jedanpay = FormatNumber(Trim(Rs("제단금액")),0)
		sale = Rs("제단할인율")
		salepay = FormatNumber(Rs("제단할인금액"),0)
		indate = Rs("입금일자")
		jangjietc = Rs("장지특이사항")
		goinetc = Rs("고인특이사항")
		hangsaetc = Rs("행사특이사항")
		
		if indate <> "" then
			indate = left(indate,4)&"-"&mid(indate,5,2)&"-"&mid(indate,7,2)
		end if		
	End If


	Set Rs = ConnAplus.execute(SQL_etc)

	If Rs.EOF Then
		
	Else
		Do While Rs.EOF = False
			workday = Rs("일차")
			content = Rs("내용")
			worklog = worklog & workday & "일차: " & content &  chr(10) & chr(13)
			Rs.moveNext
		loop		
	End If

	Set Rs = ConnAplus.execute(SQL_S)

	If Rs.EOF Then
		save = ""
	Else		
		save = Rs("정산완료일")
	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing
%>
<script type="text/javascript" language="javascript" src="/js/reception.js"></script>	
<script language="javascript" type="text/javascript">
	function List() {
		location.href = "calculation_list.asp";
	}
	function Save() {
		if (!confirm('저장하시겠습니까?')) {
			return false;
		}
		document.frm.submit();
	}
	// 행사총지급액 구하기.
	function moneyShape5(Moneytxt) {
		moneyShape(Moneytxt);
		updateField(Moneytxt.name);
	}	
	function updateField(fid) {
		if (fid == 'jedanpay') {  // 금액입력
			if (parseInt(ClearComma(document.frm.sale.value)) > 0) {  // 할인율이 등록되어 있을경우
				document.frm.salepay.value = comma((parseInt(ClearComma(document.frm.jedanpay.value)) * (document.frm.sale.value * 0.01)));
			}
		}
		if (fid == 'sale') { // 할인율등록
			if (parseInt(ClearComma(document.frm.jedanpay.value)) > 0) {  // 총금액이 등록되었을 경우..
				document.frm.salepay.value = comma((parseInt(ClearComma(document.frm.jedanpay.value)) * (document.frm.sale.value * 0.01)));
			}
		}
	}
	// 행사특이사항 제단할인율 변경 시
	function changeSale() {		
		if (parseInt(ClearComma(document.frm.jedanpay.value)) > 0) {  // 총금액이 등록되었을 경우..
			document.frm.salepay.value = comma((parseInt(ClearComma(document.frm.jedanpay.value)) * (document.frm.sale.value * 0.01)));
		}
	}
</script>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->
	<!--#include virtual="/common/lnb.asp"-->

	<div class="top_btns no_use"></div><!--// top_btns -->

	<form name="frm" method="post" action="calculation_etc_ok.asp">
	<input type="hidden" id="code" name="code" value="<%=code %>" />

	<p class="sub_tit">1. 제단</p>
	<table class="form_ty">
		<caption>정산-행사특이사항-제단</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="1" style="width:*%;">
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">구분</th>
				<td>
					<ul class="checks">
						<li>
							<input type="radio" id="jedan_1" name="jedan" value='협력업체' <% if jedan="협력업체" then response.write " checked" end if %>>
							<label for="jedan_1">협력업체</label>
						</li>
						<li>
							<input type="radio" id="jedan_2" name="jedan" value='병원' <% if jedan="병원" then response.write " checked" end if %>>
							<label for="jedan_2">병원</label>
						</li>
					</ul><!--// checks -->
				</td>
			</tr>
			<tr>
				<th scope="row">금액</th>
				<td><input type="text" name="jedanpay" value="<%=jedanpay%>" maxlength="20" class="input_ty w100" onkeyUp='moneyShape5(this);'></td>
			</tr>
			<tr>
				<th scope="row">할인율</th>
				<td><input type="text" name="sale" value="<%=sale%>" maxlength="3" class="input_ty w90" onkeyUp='changeSale();' >%</td>
			</tr>
			<tr>
				<th scope="row">할인금액</th>
				<td><input type="text" name="salepay" value="<%=salepay%>"  maxlength="20" class="input_ty w100" onkeyUp='moneyShape5(this);' ></td>
			</tr>
			<!-- <tr>
				<th scope="row">입금일자</th>
				<td><span class="dp_box w100"><input type="text" name="indate" class="datepicker input_ty start-date w100" placeholder="입금일자" value="<%=indate %>" readonly ></span></td>
			</tr> -->
		</tbody>
	</table><!--// form_ty -->

	<p class="sub_tit mt">2. 장지 특이사항</p>
	<textarea name="jangjietc" class="tarea_ty w100" placeholder="내용을 입력해주세요."><%=jangjietc %></textarea>
	<p class="sub_tit mt">3. 대체 및 기타내역</p>
	<textarea name="goinetc" class="tarea_ty w100" placeholder="내용을 입력해주세요."><%=goinetc %></textarea>
	<p class="sub_tit mt">4. 근무일지</p>
	<textarea name="hangsaetc" class="tarea_ty w100" placeholder="수정이 불가합니다. 근무일지를 확인해주세요." style="color:#858585;" readOnly><%=worklog %></textarea>

	</form>
	
	<% if save = "" or IsNull(save) = true then %>
	<div class="btm_btns">
		<a href="javascript:void();" onclick="Save();" class="btn_ty btn_b">저장</a>
	</div>
	<% end if %>

</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->
