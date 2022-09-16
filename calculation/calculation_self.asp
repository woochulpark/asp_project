<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%
	menu = "정산"
	lnbf = "class='on'"	

	code = Trim(request("Code"))
		
	if code = "" then 
		response.End
	end if

	SQL = "select a.상품코드, a.상품명, a.수량, a.지급액, a.거래처코드, a.거래처명, a.비고, a.구매구분, a.구분, a.본부, a.센터, isnull(b.단가,0) as 판매금액 "
	SQL = SQL & " from 행사진행물품 a left outer join 행사용품코드 b on a.상품코드 = b.행사용품코드 "
	SQL = SQL & " where 행사번호 = '"& code &"' "
	SQL = SQL & " and 구분 = '자체' "
	SQL = SQL & " order by 상품코드 "

	SQL_P = "  select 대표명칭 의전본부명 "
	SQL_P = SQL_P & " from 공용코드 (nolock) "	
	SQL_P = SQL_P & " where 대표코드 = '00301' "
	SQL_P = SQL_P & "	and 구분5 = 'Y' "
	SQL_P = SQL_P & "	and 대표명칭 <> '테스트' "
	SQL_P = SQL_P & " order by 구분4 "

	SQL_S = "select 승인구분, 본부, 센터 from 행사마스터 (nolock) "
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
		bonbu_s = ""
		center_s = ""
	Else		
		save = Rs("승인구분")
		bonbu_s = Rs("본부")
		center_s = Rs("센터")
	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing

	category_list = "<option value=''>--선택--</option>"

	if rc2 <> 0 then	
		for i=0 to UBound(arrObj2,2)
			catecory	= arrObj2(0,i)
			selected = ""
			If bonbu_s = catecory Then 
				selected = "selected"			
			End If
			category_list = category_list & "<option value='"& catecory &"' "& selected &" >" & catecory &"</option>"
		next
	end if	

%>
<%
	If user_id = "S1211059" Then
		'Response.write "SQL= " & SQL 
		'Response.write "SQL_p= " & SQL_p 
		'Response.write "SQL_s= " & SQL_s 
	End If
%>	
<script type="text/javascript" language="javascript" src="/js/reception.js"></script>	
<script language="javascript" type="text/javascript">
	function List() {
		location.href = "calculation_list.asp";
	}
	function ItemList(sType, sType2, sValue) {

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "calculation_store_list_ajax.asp", //요청을 보낼 서버의 URL
			data: { sType: sType, sType2: sType2, sValue: sValue }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)						
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open();
			}
		});

	}
	function CategoryList(start, sValue, sValue2) {

		$("#category").attr('id', '')
		start.closest('tr').find('span').eq(0).attr('id', 'category')

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "calculation_category_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue, sValue2: sValue2 }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				$("#category").text("");
				$("#category").html(data);
			}
		});

	}
	function CategoryList2(start, sValue, sValue2) {

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "calculation_category_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue, sValue2: sValue2 }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				$(start).text("");
				$(start).html(data);
			}
		});

	}
	function CategoryChange(sValue, sValue2) {

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "calculation_category2_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue, sValue2: sValue2 }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				$("#category2_span").text("");
				$("#category2_span").html(data);
			}
		});

	}	
	function ItemAdd() {
		var value = "";
		$("#ItemList input[type='checkbox']").filter(':checked').each(function () {
			//alert($(this).val())
			value = $(this).val().split(",");
			add(value[0], value[1], value[2], value[3]);
		})
		Close();
	}		
	function totalInteger() {
		var money = 0;
		$('#factory_table tbody').each(function () {
			var cellItem = $(this).find(":input")
			if (cellItem.eq(6).val() != '') {
				money += parseInt(ClearComma(cellItem.eq(6).val()))
			}
		})
		//alert(comma(String(money)));
		$('#total').html(comma(String(money)));
	}
	function add(icode, iname1, iname2, price) {

		var rowItem = ""

		rowItem = "<tbody>"
		rowItem += "<tr>"
		rowItem += "	<td rowspan='6'><span></span>"
		rowItem += "		<a href='javascript:void(0);' onclick='del(this);' class='btn_ico ico07 ty03'>삭제</a>"
		rowItem += "		<input type='hidden' value='" + icode + "'/>"
		rowItem += "		<input type='hidden' value='" + price + "'/>"
		rowItem += "	</td>"
		rowItem += "	<th scope='row' colspan='6'>품목(중분류-소분류)</th>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<td colspan='3'>"
		rowItem += "		<span class='input_dt w100'>" + iname1 + "</span>"		
		rowItem += "		<input type='hidden' value='" + iname1 + "' />"
		rowItem += "	</td>"
		rowItem += "	<td colspan='3'>"
		rowItem += "		<span class='input_dt w100'>" + iname2 + "</span>"
		rowItem += "		<input type='hidden' value='" + iname2 + "' />"
		rowItem += "	</td>"		
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<th scope='row' colspan='2'>수량</th>"
		rowItem += "	<th scope='row' colspan='2'>본부</th>"
		rowItem += "	<th scope='row' colspan='2'>센터</th>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<td colspan='2'><input type='text' onkeyUp='moneyShape(this);' value='1' class='input_ty w100' /></td>"
		rowItem += "	<td colspan='2'>"
		rowItem += "		<select onchange='CategoryList($(this), this.value);' class='select_ty tc w100'><%=category_list %></select>"
		rowItem += "	</td>"
		rowItem += "	<td colspan='2'><span><select class='select_ty tc w100'><option value='<%=center_s%>'><%=center_s%></option></select></span></td>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<th scope='row' colspan='6'>비고</th>"
		rowItem += "</tr>"
		rowItem += "<tr>"
		rowItem += "	<td colspan='6'><input type='text' class='input_ty w100' /></td>"		
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
		var no = 0;

		$('#factory_table tbody').each(function () {
			var cellItem = $(this).find(":input")

			if (no == 0) {
				input1 += cellItem.eq(0).val()
				input2 += cellItem.eq(1).val()
				input3 += cellItem.eq(2).val()
				input4 += cellItem.eq(3).val()
				input5 += ClearComma(cellItem.eq(4).val())
				input6 += cellItem.eq(5).val()
				input7 += cellItem.eq(6).val()
				input8 += cellItem.eq(7).val()
			} else {
				input1 += "," + cellItem.eq(0).val()
				input2 += "," + cellItem.eq(1).val()
				input3 += "," + cellItem.eq(2).val()
				input4 += "," + cellItem.eq(3).val()
				input5 += "," + ClearComma(cellItem.eq(4).val())
				input6 += "," + cellItem.eq(5).val()
				input7 += "," + cellItem.eq(6).val()
				input8 += "|" + cellItem.eq(7).val()				
			}

			no += 1
		})

		$('#input_icode').val(input1);
		$('#input_price').val(input2);
		$('#input_item').val(input3);
		$('#input_item2').val(input4);
		$('#input_cnt').val(input5);
		$('#input_bonbu').val(input6);
		$('#input_center').val(input7);
		$('#input_etc').val(input8);


		
		if ( "<%=user_id%>" == "S1211059")
		{
			//alert ("테스트");
			//alert (input1);
			//alert (input2);
			//alert (input3);
			//alert (input4);
			//alert (input5);
			//alert (input6);
			//alert (input7);
			//alert (input8);

			//alert("(" + input1 + ")(" + input2 + ")(" + input3 + ")(" + input4 + ")(" + input5 + ")(" + input6 + ")(" + input7 + ")(" + input8 + ")(" + input9 + ")(" + input10 + ")(" + input11 + ")");

			alert("(" + input1 + ")(" + input2 + ")(" + input3 + ")(" + input4 + ")(" + input5 + ")(" + input6 + ")(" + input7 + ")(" + input8 + ")" );

			document.frm.submit();

		}
		else
		{
			document.frm.submit();
		}

	}
	function save_1() {
		if (!confirm('재고관리시스템 용품 자체 현황을 가져오기 하시겠습니까?\n\n기존데이터 삭제 후 재고관리시스템 내용으로 다시 저장됩니다.\n\n재고관리시스템 내용이 없을경우는 삭제되지 않습니다.')) {
			return false;
		}
		document.frm.action = "calculation_self_2_ok.asp"
		document.frm.submit();
	}
</script>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->
	<!--#include virtual="/common/lnb.asp"-->

	<div class="top_btns sort02">
	<% if save = "" or IsNull(save) = true then %>
		<!--
		<a href="javascript:void(0);" onclick="ItemList();" class="btn_ty btn_b ty03 btn_add">용품명세서</a>
		<a href="javascript:void(0);" onclick="save();" class="btn_ty ty02 btn_b">저장</a>
		-->
		<a href="javascript:void(0);" class="btn_ty ty02 btn_b" onclick="save_1();">재고관리 가져오기</a>
		<a href="javascript:void(0);" class="btn_ty ty02 btn_b" onclick="Complete('<%=code %>');">완료승인요청</a>
	<% end if %>
	</div><!--// top_btns -->

	<form name="frm" method="post" action="calculation_self_ok.asp">
		<input type="hidden" id="code" name="code" value="<%=code %>" />
		<input type="hidden" id="input_icode" name="input_icode" />
		<input type="hidden" id="input_item" name="input_item" />
		<input type="hidden" id="input_item2" name="input_item2" />				
		<input type="hidden" id="input_cnt" name="input_cnt" />
		<input type="hidden" id="input_price" name="input_price" />
		<input type="hidden" id="input_etc" name="input_etc" />
		<input type="hidden" id="input_center" name="input_center" />
		<input type="hidden" id="input_bonbu" name="input_bonbu" />
	</form>

	<table id="factory_table" class="form_ty hori">
		<caption>정산-용품명세서(자체)</caption>
		<colgroup>
			<col span="1" class="verti_w03"><col span="6" style="width:*%;">
		</colgroup>
<%
	total = 0
	if rc = 0 then 
	else
		for i=0 to UBound(arrObj,2)
			icode		= arrObj(0,i)
			item		= Split(arrObj(1,i), "-")
			pcnt		= FormatNumber(arrObj(2,i),0)
			price		= arrObj(11,i)			
			etc			= arrObj(6,i)
			bonbu		= arrObj(9,i)
			center		= arrObj(10,i)

			total = total + arrObj(3,i)

			if ubound(item) > 0 then
				item_1 = item(0)
				item_2 = item(1)
			else
				item_1 = item(0)
				item_2 = ""
			end if
%>
		<tbody>
			<tr>
				<td rowspan="6">
					<span><%=i+1 %></span>
					<!--<a href="javascript:void(0);" onclick="del(this);" class="btn_ico ico07 ty03">삭제</a>-->
					<input type="hidden" value="<%=icode %>" />
					<input type="hidden" value="<%=price %>" />
				</td>
				<th scope="row" colspan="6">품목(중분류-소분류)</th>
			</tr>
			<tr>
				<td colspan="3">
					<span class="input_dt w100"><%=item_1 %></span>
					<input type="hidden" value="<%=item_1 %>" />
				</td>
				<td colspan="3">
					<span class="input_dt w100"><%=item_2 %></span>
					<input type="hidden" value="<%=item_2 %>" />
				</td>
			</tr>
			<tr>
				<th scope="row" colspan="2">수량</th>
				<th scope="row" colspan="2">본부</th>
				<th scope="row" colspan="2">센터</th>
			</tr>
			<tr>
				<td colspan="2">					
					<input type="text" onkeyUp="moneyShape(this);" value="<%=pcnt %>" class="input_ty w100" />
				</td>
				<td colspan="2">
					<select id="select_<%=i %>" onchange="CategoryList($(this), this.value, '');" class="select_ty tc w100">
						<%=category_list %>
					</select>
					<script>
						document.getElementById("select_<%=i %>").value = "<%=bonbu %>";
					</script>
				</td>
				<td colspan="2">
					<span id="select2_<%=i %>"></span>
					<script>
						CategoryList2($("#select2_<%=i %>"), "<%=bonbu %>", "<%=center %>");
					</script>					
				</td>
			</tr>
			<tr>
				<th scope="row" colspan="6">비고</th>
			</tr>
			<tr>
				<td colspan="6">
					<input type="text" value="<%=etc %>" class="input_ty w100" />
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