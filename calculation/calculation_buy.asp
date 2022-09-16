<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%
	menu = "정산"	
	lnbb = "class='on'"	

	code = Trim(request("Code"))
	'response.Write code
	'response.End
	if code = "" then 
		response.End
	end if

	SQL = "select a.상품코드, a.상품명, a.수량, a.지급액, a.결재방법, a.거래처명, a.라인번호, a.거래처코드, a.구매구분, a.비고, b.품목분류, b.품목명 "
	SQL = SQL & " from 행사진행물품 a inner join 행사품목코드 b on a.상품코드 = b.행사품목코드 "
	SQL = SQL & " where 행사번호 = '"& code &"' "
	SQL = SQL & " and 구분 = '구입' and 수량 <> '' "
	SQL = SQL & " order by 상품코드 "

	SQL_P = " select 상세코드, 대표명칭, 상세명칭 "
	SQL_P = SQL_P & " from 공용코드 "	
	SQL_P = SQL_P & " where 대표코드 = '00254' "
	'SQL_P = SQL_P & " and 구분1 in ('공통','수도권') "
	SQL_P = SQL_P & " order by 구분1 "

	SQL_S = "select 승인구분 from 행사마스터 "
	SQL_S = SQL_S & " where 행사번호 = '"& code &"' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ	

	Set Rs = ConnAplus.execute(SQL)	

	If Rs.EOF Then
		rc = 0		
	Else
		rc = Rs.RecordCount
		arrObj = Rs.GetRows(rc)
	End If

	Set Rs = ConnAplus.execute(SQL_P)	

	If Rs.EOF Then
		rc2 = 0		
	Else
		rc2 = Rs.RecordCount
		arrObj2 = Rs.GetRows(rc2)
	End If

	Set Rs = ConnAplus.execute(SQL_S)

	If Rs.EOF Then
		save = ""
	Else		
		save = Rs("승인구분")
	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	category_list = "<option value=''>--선택--</option>"

	if rc2 <> 0 then	
		for i=0 to UBound(arrObj2,2)
			catecory	= arrObj2(2,i)
			category_list = category_list & "<option value='"& catecory &"'>"& catecory &"</option>"
		next
	end if	
%>

<script type="text/javascript" language="javascript" src="/js/reception.js"></script>	
<script language="javascript" type="text/javascript">
	function List() {
		location.href = "calculation_list.asp";
	}
	function ItemList(sValue) {

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "calculation_item_list_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue, sType: "buy" }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open('기본제공비용');
			}
		});

	}
	function PartnerList(start, sValue) {

		$("#partner").attr('id', '')
		$("#partner2").attr('id', '')
		$("#partner3").attr('id', '')
		start.closest('td').find('input').eq(0).attr('id', 'partner')
		start.closest('td').find('input').eq(1).attr('id', 'partner2')
		start.closest('td').find('span').eq(0).attr('id', 'partner3')

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "calculation_partner_list_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open();
			}
		});

	}
	function PartnerList2(sValue) {

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "calculation_partner_list_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open();
			}
		});

	}	
	function ItemAdd() {
		var value = "";
		$("#ItemList input[type='checkbox']").filter(':checked').each(function () {
			//alert($(this).val())
			value = $(this).val().split(",")			
			add(value[0], value[1], value[2])
		})
		Close();
	}
	function PartnerAdd(pcode, partner) {
		//$("input[name=p2]")[k].value = mcode;
		//$("input[name=p3]")[k].value = mname;
		//$("span[name=p3_txt]")[k].innerHTML = mname;
		$("#partner").val(pcode);
		$("#partner2").val(partner);
		$("#partner3").text(partner);
		Close();
	}
	function moneyShape2(Moneytxt) {
		moneyShape(Moneytxt);		
		totalInteger();
	}	
	function totalInteger() {
		var money = 0;
		$('#factory_table tbody').each(function () {
			var cellItem = $(this).find(":input")
			if (cellItem.eq(4).val() != '') {
				money += parseInt(ClearComma(cellItem.eq(4).val()))
			}
		})
		//alert(comma(String(money)));
		$('#total').html(comma(String(money)));
	}
	function add(icode, itype, iname) {

		var rowItem = ""

		rowItem = "<tbody>"
		rowItem += "<tr>"
		rowItem += "	<td rowspan='6'>"
		rowItem += "		<span></span><a href='javascript:void(0);' onclick='del(this);' class='btn_ico ico07 ty03'>삭제</a>"
		rowItem += "		<input type='hidden' value='" + icode + "'/>"
		rowItem += "	</td>"
		rowItem += "	<th scope='row'>품목분류</th>"
		rowItem += "	<th scope='row'>품목명</th>"
		rowItem += "	<th scope='row'>수량</th>"		
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<td>"
		rowItem += "		<span class='input_dt w100'>" + itype + "</span>"
		rowItem += "		<input type='hidden' value='" + itype + "' />"
		rowItem += "	</td>"
		rowItem += "	<td>"
		rowItem += "		<span class='input_dt w100'>" + iname + "</span>"
		rowItem += "		<input type='hidden' value='" + iname + "' />"
		rowItem += "	</td>"
		rowItem += "	<td><input type='text' class='input_ty w100 tc' onkeyUp='moneyShape2(this);' value='1' /></td>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<th>금액</th>"
		rowItem += "	<th>결제방법</th>"
		rowItem += "	<th>협력업체</th>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<td><input type='text' class='input_ty w100 tc ht01' onkeyUp='moneyShape2(this);' /></td>"
		rowItem += "	<td><select class='select_ty tc w100'><%=category_list %></select></td>"
		rowItem += "	<td>"
		rowItem += "		<span class='input_dt w70'></span>"
		rowItem += "		<input type='hidden' value=''/>"
		rowItem += "		<input type='hidden' value=''/>"
		rowItem += "		<a href='javascript:void(0);' onclick='PartnerList($(this));' class='btn_ico ico01 ty02'>검색</a>"
		rowItem += "	</td>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<th scope='row' colspan='3'>비고</th>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<td colspan='3'>"
		rowItem += "		<input type='text' class='input_ty w100' />"
		rowItem += "	</td>"
		rowItem += "</tr>"
		rowItem += "</tbody>"

		$('#factory_table').append(rowItem);
		fnSetRowNo()
	}
	function del(tbody) {
		tbody.closest("tbody").remove();
		fnSetRowNo();
		totalInteger();
	}
	function fnSetRowNo() {

		var tbody = $("#factory_table tbody");
		var tbody_cnt = tbody.length; // tbody 태그들의 갯수	

		tbody.each(function (i) {
			var cellItem = $(this).find("span")
			cellItem.eq(0).text(i + 1);
		});

	}
	function save() {
		if (!confirm('저장하시겠습니까?')) {
			return false;
		}
		var input1 = ""
		var input2 = ""
		var input3 = ""
		var input4 = ""
		var input5 = ""
		var input6 = ""
		var input7 = ""
		var input8 = ""
		var input9 = ""
		var input10 = ""
		var input11 = ""
		var no = 0;
		$('#factory_table tbody').each(function () {
			var cellItem = $(this).find(":input")

			if (no == 0) {
				input1 += cellItem.eq(0).val()
				input2 += cellItem.eq(1).val()
				input3 += cellItem.eq(2).val()
				input4 += ClearComma(cellItem.eq(3).val())
				input5 += ClearComma(cellItem.eq(4).val())
				input6 += cellItem.eq(5).val()
				input7 += cellItem.eq(6).val()
				input8 += cellItem.eq(7).val()
				input9 += cellItem.eq(8).val()
				input10 += cellItem.eq(9).val()
				input11 += cellItem.eq(10).val()
			} else {
				input1 += "," + cellItem.eq(0).val()
				input2 += "," + cellItem.eq(1).val()
				input3 += "," + cellItem.eq(2).val()
				input4 += "," + ClearComma(cellItem.eq(3).val())
				input5 += "," + ClearComma(cellItem.eq(4).val())
				input6 += "," + cellItem.eq(5).val()
				input7 += "," + cellItem.eq(6).val()
				input8 += "," + cellItem.eq(7).val()
				input9 += "|" + cellItem.eq(8).val()
				input10 += "," + cellItem.eq(9).val()
				input11 += "," + cellItem.eq(10).val()
			}

			no += 1
		})
		if (no == 0) {
			alert('저장할 내용이 없습니다.');
			return false;
		}
		$('#input_icode').val(input1);
		$('#input_item0').val(input2);
		$('#input_item').val(input3);
		$('#input_pcode').val(input7);
		$('#input_partner').val(input8);
		$('#input_cnt').val(input4);
		$('#input_price').val(input5);
		$('#input_pay').val(input6);
		$('#input_etc').val(input9);

		document.frm.submit();

		//alert("(" + input1 + ")(" + input2 + ")(" + input3 + ")(" + input4 + ")(" + input5 + ")(" + input6 + ")(" + input7 + ")(" + input8 + ")(" + input9 + ")(" + input10 + ")(" + input11 + ")");
		

	}
</script>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->
	<!--#include virtual="/common/lnb.asp"-->
	
	<div class="top_btns sort02">
	<% if save = "" or IsNull(save) = true then %>
		<a href="javascript:void(0);" onclick="ItemList('');" class="btn_ty btn_b ty03 btn_add">기본제공비용</a>
		<a href="javascript:void(0);" onclick="save();" class="btn_ty ty02 btn_b">저장</a>
	<% end if %>
	</div><!--// top_btns -->	

	<form name="frm" method="post" action="calculation_buy_ok.asp">
		<input type="hidden" id="code" name="code" value="<%=code %>" />
		<input type="hidden" id="input_icode" name="input_icode" />
		<input type="hidden" id="input_item0" name="input_item0" />
		<input type="hidden" id="input_item" name="input_item" />
		<input type="hidden" id="input_pcode" name="input_pcode" />
		<input type="hidden" id="input_partner" name="input_partner" />
		<input type="hidden" id="input_cnt" name="input_cnt" />
		<input type="hidden" id="input_price" name="input_price" />
		<input type="hidden" id="input_pay" name="input_pay" />
		<input type="hidden" id="input_etc" name="input_etc" />
	</form>

	<table class="list_ty total_list">
		<caption>기본제공비용(구입) Total</caption>
		<colgroup><col span="1" style="width:100%;"></colgroup>
		<thead>
			<tr>
				<th scope="col">Total</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><span id="total"></span></td>
			</tr>
		</tbody>
	</table><!--// total_list -->


	<table id="factory_table" class="form_ty hori">
		<caption>정산-기본제공비용(구입)</caption>
		<colgroup>
			<col span="1" class="verti_w03"><col span="3" style="width:*%;">
		</colgroup>
<%
	total = 0
	if rc = 0 then 
	else
		for i=0 to UBound(arrObj,2)
			icode		= arrObj(0,i)
			item		= arrObj(1,i)
			pcnt		= FormatNumber(arrObj(2,i),0)
			price		= FormatNumber(arrObj(3,i),0)
			pay			= arrObj(4,i)
			pname		= arrObj(5,i)
			pcode		= arrObj(7,i)			
			buy			= arrObj(8,i)
			etc			= arrObj(9,i)
			itype		= arrObj(10,i)
			iname		= arrObj(11,i)

			total = total + arrObj(3,i)
%>
		<tbody>
			<tr>
				<td rowspan="6">
					<%=i+1 %>
					<% if save = "" or IsNull(save) = true then %>
						<a href="javascript:void(0);" onclick="del(this);" class="btn_ico ico07 ty03">삭제</a>
					<% end if %>
					<input type="hidden" value="<%=icode %>" />
				</td>
				<th scope="row">품목분류</th>
				<th scope="row">품목명</th>
				<th scope="row">수량</th>
			</tr>
			<tr>
				<td>
					<span class="input_dt w100"><%=itype %></span>
					<input type="hidden" value="<%=itype %>" />
				</td>
				<td>
					<span class="input_dt w100"><%=iname %></span>
					<input type="hidden" value="<%=iname %>" />
				</td>				
				<td><input type="text" class="input_ty w100 tc" onkeyUp="moneyShape2(this);" value="<%=pcnt %>" /></td>
			</tr>
			<tr>
				<th scope="row">금액</th>
				<th scope="row">결제방법</th>
				<th scope="row">협력업체</th>
			</tr>
			<tr>
				<td><input type="text" class="input_ty w100 tc ht01" onkeyUp="moneyShape2(this);" value="<%=price %>" /></td>				
				<td>
					<select id="select_<%=i %>" class="select_ty tc w100"><%=category_list %></select>
					<script>
						document.getElementById("select_<%=i %>").value = "<%=pay %>";
					</script>					
				</td>
				<td>
					<span class="input_dt w70"><%=pname %></span>					
					<input type="hidden" value="<%=pcode %>" />
					<input type="hidden" value="<%=pname %>" />
					<a href="javascript:void(0);" onclick="PartnerList($(this));" class="btn_ico ico01 ty02">검색</a>
				</td>
			</tr>
			<tr>
				<th scope="row" colspan="3">비고</th>
			</tr>
			<tr>
				<td colspan="3">
					<input type="text" class="input_ty w100" value="<%=etc %>" />					
				</td>
			</tr>
		</tbody>
<%
		next
	end if 
%>
	</table><!--// form_ty -->

	<!--#include virtual="/common/layer_popup.asp"-->

</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->

<script type="text/javascript">
	$('#total').html('<%=FormatNumber(total,0) %>');
</script>