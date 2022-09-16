<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%    
	menu = "정산"
	lnbg = "class='on'"	

	code = Trim(request("Code"))
	
	if code = "" then 
		response.End
	end if  

	g_1 = 0		'진행상품금액
	g_2 = 0		'추가
	g_3 = 0		'할인
	g_4 = 0		'CLng(g_1) + CLng(g_2) - CLng(g_3) 
	g_5 = 0		'부금
	g_6 = 0		'수입총액
	g_6_1 = 0
	g_6_2 = 0
	g_7 = 0
	g_8 = 0		'현장지출
	g_9 = 0		'회사입금액
	g_10 = 0	'현금정산액
	g_11 = ""	'현금정산일자
	g_12 = 0	'영수증
	g_13 = ""	'카드사
	g_14 = 0	'자체용품금액
	g_15 = 0	'카드결제액
	g_16 = 0	'총지출경비
	g_17 = 0
	g_18 = 0	'지출비율
	g_19 = 0	'Y or N
	g_20 = ""	'현금영수증성명
	g_21 = ""	'현금영수증번호
	g_22 = 0	'팀장입금액
	g_23 = ""	'팀장입금일자
	g_24 = ""	'현금영수증승인번호
	g_25 = 0	'상품권사용여부
	g_26 = 0	'청구금액
	

	SQL2 = "select "
    SQL2 = SQL2 & " ISNULL((select SUM(지급액) from 행사진행물품 where 행사번호 = '"& code &"' and 구분 in ('추가', '상향', '추가상향')), 0) as 추가, "	
	SQL2 = SQL2 & " ISNULL((select SUM(지급액) from 행사진행물품 where 행사번호 = '"& code &"' and 구분 in ('공제', '할인')), 0) as 할인, "
    SQL2 = SQL2 & " ISNULL((select SUM(지급액) from 행사진행물품 where 행사번호 = '"& code &"' and 구분 = '구입' and 결재방법 in ('현금','현금영수증 발행','간이영수증 발행')), 0) as 현장지출 "

	SQL = "exec p_행사정산조회 '" & code & "' "	

	SQL_S = "select 승인구분 from 행사마스터 "
	SQL_S = SQL_S & " where 행사번호 = '"& code &"' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ


	Set rs = ConnAplus.execute(SQL2)

	If rs.EOF Then
		total_add = 0
		total_sale = 0
        total_g8 = 0
	Else
		total_add = rs("추가")
		total_sale = rs("할인")
        total_g8 = rs("현장지출")
	End If

	Set rs = ConnAplus.execute(SQL)	

	If rs.EOF Then
		
	Else
		g_1 = rs("진행상품금액")
		'g_2 = rs("추가금액")
		g_2 = total_add
		'g_3 = rs("할인상주공제")
		g_3 = total_sale
		'g_4 = rs("매출") '매출
		g_4 = CLng(g_1) + CLng(g_2) - CLng(g_3)        
		
		If CLng(g_1) > 0 Then
			g_4 = CLng(g_1) + CLng(g_2) - CLng(g_3)
		End If
			
		If isnull(rs("부금")) = True Then
			g_5 = 0
		Else
			g_5 = CLng(rs("부금"))
		End If

		g_6 = g_4 - g_5 '수입총액

		'g_8 = rs("현장지출")
        g_8 = total_g8
		'g_9 = rs("회사입금액")		
		g_10 = rs("현금정산액")
		g_11 = rs("현금정산일자")

        g_9 = g_10 - g_8

		If g_11 <> "" Then
			g_11 = Left(g_11, 4) & "-" & Mid(g_11, 5, 2) & "-" & Right(g_11, 2)
		End If

		g_13 = rs("카드사")
		g_14 = rs("자체용품금액")
		g_15 = rs("카드결제액")
		g_16 = rs("총지출경비")		

		g_18 = rs("지출비율")
			
		If g_19 = "" Then
			g_19 = "N"
		Else
			g_19 = "Y"
		End If

		g_20 = rs("현금영수증성명")
		g_21 = rs("현금영수증번호")
		g_22 = rs("팀장입금액")
		g_23 = rs("팀장입금일자")
		If g_23 <> "" Then
			g_23 = Left(g_23, 4) & "-" & Mid(g_23, 5, 2) & "-" & Right(g_23, 2)
		End If

		REM '현금영수증 금액 (부금 + 현금정산액)

		g_12 = rs("영수증")
		g_24 = rs("현금영수증승인번호")

		g_25 = rs("상품권사용여부")
		If g_25 = "N" Then
			g_25 = "N"
		Else
			g_25 = "Y"
		End If

		g_26 = rs("청구금액")
	End If

	Set Rs = ConnAplus.execute(SQL_S)

	If Rs.EOF Then
		save = ""
	Else		
		save = Rs("승인구분")
	End If

	'행사특이사항 저장여부
    'SQL_CHECK = "select * from 행사특이사항 where 행사번호 = '"& code &"' "

    'Set rs = ConnAplus.execute(SQL_CHECK)
    'If rs.EOF Then
    '    check_flag = "no"
    'End If

    'if check_flag = "no" then
	'	response.write "<script type='text/javascript'>"
	'	response.write "alert('행사특이사항이 등록되지 않았습니다.');"
	'	response.write "location.replace('calculation_etc.asp?Code="& code &"');"
	'	response.write "</script>"
	'	response.End
	'end if

	rs.Close
	Set rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	
%>

<script type="text/javascript" language="javascript" src="/js/reception.js"></script>	
<script language="javascript" type="text/javascript">
	function List() {
		location.href = "calculation_list.asp";
	}
	function Save() {
		if(!confirm('저장하시겠습니까?')){
			return false;
		}
		document.frm.submit();
	}
	function updateTotal() {
		var g_10 = parseInt(ClearComma($("#g_10").val()))
		if($("#g_10").val() == ""){
			g_10 = 0
		}
		var g_5 = parseInt(<%=g_5 %>)
		var g_8 = parseInt(<%=g_8 %>)
		var g_9 = g_10 - g_8
		var g_12 = g_5 + g_10

		if(g_9 < 0){
			g_9 = g_9 * -1
			g_9 = "-" + comma(g_9);
		}else{
			g_9 = comma(g_9);
		}
		$("#g_9").val(g_9);
		$("#g_10").val(comma($("#g_10").val()));
		$("#g_12").val(comma(g_12));
	}
</script>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->

	<!--#include virtual="/common/lnb.asp"-->

	<div class="top_btns no_use"></div><!--// top_btns -->

	<form name="frm" method="post" action="calculation_total_ok.asp">
	<input type="hidden" id="code" name="code" value="<%=code %>" />
	<input type="hidden" id="g_14" name="g_14" value="<%=g_14 %>" />
	<input type="hidden" id="g_16" name="g_16" value="<%=g_16 %>" />
	<input type="hidden" id="g_18" name="g_18" value="<%=g_18 %>" />
	<input type="hidden" id="g_26" name="g_26" value="<%=g_26 %>" />

	<p class="sub_tit">1. 행사정산</p>
	<table class="form_ty hori">
		<caption>정산-정산내역-행사정산</caption>
		<colgroup>
			<col span="1" class="verti_w04"><col span="2" style="width:*%;">
		</colgroup>

		<tbody>
			<tr>
				<th scope="row" rowspan="8">의전<br>정산</th>
				<th scope="col">①진행상품금액</th>
				<th scope="col">②추가/상향금액(고객)</th>
			</tr>
			<tr>
				<td><input type="text" name="g_1" value="<%=FormatNumber(g_1,0) %>" class="input_ty tc w100" readonly></td>
				<td><input type="text" name="g_2" value="<%=FormatNumber(g_2,0) %>" class="input_ty tc w100" readonly></td>
			</tr>
			<tr>
				<th scope="col">③할인/상주공제</th>
				<th scope="col">④매출(=①+②-③)</th>
			</tr>
			<tr>
				<td><input type="text" name="g_3" value="<%=FormatNumber(g_3,0) %>" class="input_ty tc w100" readonly></td>
				<td><input type="text" name="g_4" value="<%=FormatNumber(g_4,0) %>" class="input_ty tc w100" readonly></td>
			</tr>
			<tr>
				<th scope="col">⑤부금</th>
				<th scope="col">⑥수입총액(④-⑤)</th>
			</tr>
			<tr>
				<td><input type="text" name="g_5" value="<%=FormatNumber(g_5,0) %>" class="input_ty tc w100" readonly></td>
				<td><input type="text" name="g_6" value="<%=FormatNumber(g_6,0) %>" class="input_ty tc w100" readonly></td>
			</tr>
			<tr>
				<th scope="col">⑦현장(현금)지출</th>
				<th scope="col">⑧회사입금액<br class="m_br">(현금정산-⑦)</th>
			</tr>
			<tr>
				<td><input type="text" name="g_8" value="<%=FormatNumber(g_8,0) %>" class="input_ty tc w100" readonly></td>
				<td><input type="text" name="g_9" id="g_9" value="<%=FormatNumber(g_9,0) %>" class="input_ty tc w100" readonly></td>
			</tr>
		</tbody>
	</table><!--// form_ty -->

	<p class="sub_tit mt">2. 정산방법</p>
	<table class="form_ty">
		<caption>정산-정산내역-정산방법</caption>
		<colgroup>
			<col span="2" class="verti_w01"><col span="1" style="width:*%;">
		</colgroup>

		<tbody>
			<tr>
				<th scope="row" rowspan="2">현금정산</th>
<!-- 
				<th scope="row">정산일</th>
				<td><span class="dp_box w100"><input type="text" name="g_11" id="g_11" value="<%=g_11%>" class="datepicker input_ty start-date w100" placeholder="정산일" readonly ></span></td>
 -->
			</tr>
			<tr>
				<th scope="row">금액</th>
				<td><input type="text" name="g_10" id="g_10" maxlength="20" value="<%=FormatNumber(g_10,0) %>" onkeyup="updateTotal();" class="input_ty w100" style="border-bottom:solid 1px #eaeaea;" readOnly></td>
			</tr>
			<tr>
				<th scope="row" rowspan="2">카드정산</th>
				<!--	
				<th scope="row">카드사</th>
				<td><input type="text" name="g_13" id="g_13" value="<%=g_13%>" class="input_ty w100" readOnly></td> 
				-->
			</tr>
			<tr>
				<th scope="row" style="border-top:solid 1px #eaeaea;">금액</th>
				<td><input type="text" name="g_15" id="g_15" maxlength="20" value="<%=FormatNumber(g_15,0) %>" onkeyup="moneyShape(this);" class="input_ty w100" readOnly></td>
			</tr>
			<!--
			<tr>
				<th scope="row" rowspan="2">의전팀장<br>입금금액</th>
				<th scope="row">금액</th>
				<td><input type="text" name="g_22" id="g_22" maxlength="20" value="<%=FormatNumber(g_22,0) %>" onkeyup="moneyShape(this);" class="input_ty w100"></td>
			</tr>
			<tr>
				<th scope="row">입금일자</th>
				<td><span class="dp_box w100"><input type="text" name="g_23" id="g_23" value="<%=g_23%>" class="datepicker input_ty start-date w100" placeholder="입금일자" readonly ></span></td>
			</tr>
			<tr>
				<th scope="row">상품권<br>사용여부</th>
				<td colspan="2">
					<ul class="checks">
						<li>
							<input type="radio" id="g_25_1" name="g_25" value="Y" <% if g_25 ="Y" then response.write "checked" end if %>>
							<label for="g_25_1">사용</label>
						</li>
						<li>
							<input type="radio" id="g_25_2" name="g_25" value="N" <% if g_25 ="N" then response.write "checked" end if %>>
							<label for="g_25_2">미사용</label>
						</li>
					</ul>// checks
				</td>
			</tr> 
			-->
		</tbody>
	</table><!--// form_ty -->

	<!-- 
	<p class="sub_tit mt">3. 현금영수증</p>
	<table class="form_ty">
		<caption>정산-정산내역-현금영수증</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="1" style="width:*%;">
		</colgroup>
	
		<tbody>
			<tr>
				<th scope="row">현금영수증<br>발행유무</th>
				<td>
					<ul class="checks">
						<li>
							<input type="radio" id="g_19_1" name="g_19" value="Y" <% if g_19 ="Y" then response.write "checked" end if %>>
							<label for="g_19_1">발행</label>
						</li>
						<li>
							<input type="radio" id="g_19_2" name="g_19" value="N" <% if g_19 ="N" then response.write "checked" end if %>>
							<label for="g_19_2">미발행</label>
						</li>
					</ul>// checks
				</td>
			</tr>
			<tr>
				<th scope="row">금액</th>
				<td><input type="text" name="g_12" id="g_12" maxlength="20" value="<%=FormatNumber(g_12,0) %>" onkeyup="moneyShape(this);" class="input_ty w100"></td>
			</tr>
			<tr>
				<th scope="row">성명</th>
				<td><input type="text" name="g_20" maxlength="30" value="<%=g_20%>" class="input_ty w100"></td>
			</tr>
			<tr>
				<th scope="row">발급전화번호</th>
				<td><input type="text" name="g_21" maxlength="50" value="<%=g_21%>" class="input_ty w100"></td>
			</tr>
			<tr>
				<th scope="row">승인번호</th>
				<td><input type="text" name="g_24" maxlength="50" value="<%=g_24%>" class="input_ty w100"></td>
			</tr>
		</tbody>
	</table>// form_ty 
	-->

	</form>

	<!-- <% if save = "" or IsNull(save) = true then %>
	<div class="btm_btns">
		<a href="javascript:void();" onclick="Save();" class="btn_ty btn_b">저장</a>
	</div>// btm_btns
	<% end if %> -->

</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->