<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%
	menu = "정산"	
	lnbc = "class='on'"	

	code = Trim(request("Code"))
	
	if code = "" then 
		response.End
	end if

	SQL = "select a.상품코드, a.상품명, a.수량, a.지급액, a.거래처코드, a.거래처명, a.비고, a.구매구분, a.구분, b.품목분류, b.품목명 "
	SQL = SQL & " from 행사진행물품 a inner join 행사품목코드 b on a.상품코드 = b.행사품목코드 "
	SQL = SQL & " where 행사번호 = '"& code &"' "
	SQL = SQL & " and 구분 in ('추가','공제','할인','상향','추가상향') and 수량 <> '' "
	SQL = SQL & " order by 상품코드 "

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
			data: { sValue: sValue, sType: "add" }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open('추가및공제내역');
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
	function PartnerAdd() {
		var value = "";
		if ($("input[type='checkbox']").filter(':checked').length > 1) {
			alert("하나만 선택 가능합니다.");
			return false;
		}
		value = $("input[type='checkbox']").filter(':checked').val().split(",");
		$("#partner").val(value[1]);
		$("#partner2").val(value[0]);
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
			if (cellItem.eq(5).val() != '') {
				if (cellItem.eq(1).val() == '공제') {
					money += (parseInt(ClearComma(cellItem.eq(5).val())) * -1)
				}
				else {
					money += parseInt(ClearComma(cellItem.eq(5).val()))
				}
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
		rowItem += "	<th scope='row' colspan='2'>구분</th>"
		rowItem += "	<th scope='row' colspan='2'>품목분류</th>"
		rowItem += "	<th scope='row' colspan='2'>품목명</th>"		
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<td colspan='2'>"
		rowItem += "		<select class='select_ty tc w100'>"
		rowItem += "			<option value='추가'>추가</option>"
		rowItem += "			<option value='공제'>공제</option>"
		rowItem += "			<option value='할인'>할인</option>"
		rowItem += "			<option value='상향'>상향</option>"
		rowItem += "			<option value='추가상향'>추가상향</option>"
		rowItem += "		</select>"
		rowItem += "	</td>"
		rowItem += "	<td colspan='2'>"
		rowItem += "		<span class='input_dt w100'>" + itype + "</span>"
		rowItem += "		<input type='hidden' value='" + itype + "' />"
		rowItem += "	</td>"
		rowItem += "	<td colspan='2'>"
		rowItem += "		<span class='input_dt w100'>" + iname + "</span>"
		rowItem += "		<input type='hidden' value='" + iname + "' />"		
		rowItem += "	</td>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<th scope='row' colspan='3'>수량</th>"
		rowItem += "	<th scope='row' colspan='3'>금액</th>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<td colspan='3'><input type='text' onkeyUp='moneyShape2(this);' class='input_ty w100 tc' value='1' ></td>"
		rowItem += "	<td colspan='3'><input type='text' onkeyUp='moneyShape2(this);' class='input_ty w100 tc ht01' ></td>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<th scope='row' colspan='6'>비고</th>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<td colspan='6'>"
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
				input4 += cellItem.eq(3).val()
				input5 += cellItem.eq(4).val()
				input6 += ClearComma(cellItem.eq(5).val())
				input7 += ClearComma(cellItem.eq(6).val())				
			} else {
				input1 += "," + cellItem.eq(0).val()
				input2 += "," + cellItem.eq(1).val()
				input3 += "," + cellItem.eq(2).val()
				input4 += "," + cellItem.eq(3).val()
				input5 += "," + cellItem.eq(4).val()
				input6 += "," + ClearComma(cellItem.eq(5).val())
				input7 += "|" + cellItem.eq(6).val()				
			}

			no += 1
		})
		if (no == 0) {
			alert('저장할 내용이 없습니다.');
			return false;
		}
		$('#input_icode').val(input1);
		$('#input_type').val(input2);
		$('#input_item0').val(input3);
		$('#input_item').val(input4);
		$('#input_cnt').val(input5);
		$('#input_price').val(input6);
		$('#input_etc').val(input7);

		//alert("(" + input1 + ")(" + input2 + ")(" + input4 + ")(" + input5 + ")(" + input6 + ")(" + input7 + ")");

		document.frm.submit();

		//alert("(" + input1 + ")(" + input2 + ")(" + input3 + ")(" + input4 + ")(" + input5 + ")(" + input6 + ")(" + input7 + ")(" + input8 + ")(" + input9 + ")(" + input10 + ")");

	}
</script>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->
	<!--#include virtual="/common/lnb.asp"-->

	<div class="top_btns sort02">
	<% if save = "" or IsNull(save) = true then %>
		<a href="javascript:void(0);" onclick="ItemList('');" class="btn_ty btn_b ty03 btn_add">추가및공제내역</a>
		<a href="javascript:void(0);" onclick="save();" class="btn_ty ty02 btn_b">저장</a>
	<% end if %>
	</div><!--// top_btns -->

	<form name="frm" method="post" action="calculation_add_ok.asp">
		<input type="hidden" id="code" name="code" value="<%=code %>" />
		<input type="hidden" id="input_icode" name="input_icode" />
		<input type="hidden" id="input_item0" name="input_item0" />
		<input type="hidden" id="input_item" name="input_item" />
		<input type="hidden" id="input_type" name="input_type" />
		<input type="hidden" id="input_cnt" name="input_cnt" />
		<input type="hidden" id="input_price" name="input_price" />
		<input type="hidden" id="input_etc" name="input_etc" />
	</form>

	<table class="list_ty total_list">
		<caption>추가 및 공제내역 Total</caption>
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
		<caption>정산-추가 및 공제내역</caption>
		<colgroup>
			<col span="1" class="verti_w03"><col span="6" style="width:*%;">
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
			buy			= arrObj(8,i)
			etc			= arrObj(6,i)
			btype		= arrObj(7,i)
			itype		= arrObj(9,i)
			iname		= arrObj(10,i)			
			
			If buy = "공제" Then
				total = total + (arrObj(3,i) * -1)
			else
				total = total + arrObj(3,i)
			End if
%>
		<tbody>
			<tr>
				<td rowspan="6">
					<span><%=i+1 %></span>
					<% if save = "" or IsNull(save) = true then %>
						<a href="javascript:void(0);" onclick="del(this);" class="btn_ico ico07 ty03">삭제</a>
					<% End If %>
					<input type="hidden" value="<%=icode %>" />
				</td>
				<th scope="row" colspan="2">구분</th>
				<th scope="row" colspan="2">품목분류</th>
				<th scope="row" colspan="2">품목명</th>
			</tr>
			<tr>
				<td colspan="2">
					<select id="select_<%=i %>" class="select_ty tc w100">
						<option value="추가">추가</option>
						<option value="공제">공제</option>
						<option value="할인">할인</option>
						<option value="상향">상향</option>
						<option value="추가상향">추가상향</option>
					</select>
					<script>
						document.getElementById("select_<%=i %>").value = "<%=buy %>";
					</script>
				</td>
				<td colspan="2">
					<span class="input_dt w100"><%=itype %></span>
					<input type="hidden" value="<%=itype %>" />
				</td>
				<td colspan="2">
					<span class="input_dt w100"><%=iname %></span>
					<input type="hidden" value="<%=iname %>" />
				</td>
			</tr>
			<tr>
				<th scope="row" colspan="3">수량</th>
				<th scope="row" colspan="3">금액</th>
			</tr>
			<tr>
				<td colspan="3"><input type="text" onkeyUp="moneyShape2(this);" value="<%=pcnt %>" class="input_ty w100 tc" ></td>
				<td colspan="3"><input type="text" onkeyUp="moneyShape2(this);" value="<%=price %>" class="input_ty w100 tc ht01" ></td>
			</tr>
			<tr>
				<th scope="row" colspan="6">비고</th>
			</tr>
			<tr>
				<td colspan="6">
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