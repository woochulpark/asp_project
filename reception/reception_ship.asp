<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check2.asp"-->

<%
	menu = "배송현황"
	lnbtype = "N" '배송여부
	lnbe = "class='on'"	
	top_btn_save = "Y"

	code = Trim(request("code"))
	gubun = Trim(request("gubun"))

	if code = "" then 
		response.Write "<script>alert('잘못된 접근입니다.');window.close();location.replace('kakaotalk://inappbrowser/close');</script>"
		response.End
	end if

	If gubun = "1_2_3" Then
		check = "6"
	ElseIf gubun = "1_2" Then
		check = "3"
	ElseIf gubun = "1_3" Then
		check = "4"
	ElseIf gubun = "2_3" Then
		check = "5"
	ElseIf gubun = "1" Then
		check = "0"
	ElseIf gubun = "2" Then
		check = "0"
	ElseIf gubun = "3" Then
		check = "0"
	End if
	
	
	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	SQL = "select b.단체명 as 단체 "
	SQL = SQL & " , a.행사번호 as 접수번호 "
	SQL = SQL & " , left(a.행사시작일시,4) +'.'+ right(left(a.행사시작일시,6),2) +'.'+ right(left(a.행사시작일시,8),2) +' '+ right(left(a.행사시작일시,10),2) +':'+ right(left(a.행사시작일시,12),2) as 접수일시 "
	SQL = SQL & " , a.진행팀장 as 의전팀장코드 "
	SQL = SQL & " , c.성함 as 의전팀장 "
	SQL = SQL & " , c.연락처 as 의전팀장연락처 "		
	SQL = SQL & " , f.계약자명 as 직원명 "
	SQL = SQL & " , f.계약자휴대폰 as 직원연락처 "
	SQL = SQL & " , f.회원명 as 회원명 "
	SQL = SQL & " , f.휴대폰 as 회원연락처 "
	SQL = SQL & " , a.행사지점 as 부서명 "
	SQL = SQL & " , a.행사소속 as 소속 "
	SQL = SQL & " , a.행사사번 as 직책 "
	SQL = SQL & " , a.회원과관계 as 고인과의관계 "
	SQL = SQL & " , a.현위치 "
	SQL = SQL & " , a.계약코드 "
	SQL = SQL & " , a.고인성명 as 고인명 "
	SQL = SQL & " , a.빈소 "
	SQL = SQL & " , g.장례식장 "
	SQL = SQL & " , isnull((select 상품명 from 행사진행물품 (nolock) where 행사번호 = a.행사번호 and 구분 = '자체' and 라인번호 = '1'),'') as 용품명 "
	SQL = SQL & " , isnull((select 수량 from 행사진행물품 (nolock) where 행사번호 = a.행사번호 and 구분 = '자체' and 라인번호 = '1'),'0') as 용품수량 "
	SQL = SQL & " , isnull(m.용품도착일시,'') as 용품도착일 "
	SQL = SQL & " , isnull(m.화환도착일시,'') as 화환도착일 "
	SQL = SQL & " , isnull(m.근조기설치,'') as 근조기설치일 "
	SQL = SQL & " , isnull(m.용품전달사항,'') as 용품전달사항 "
	SQL = SQL & " , isnull(m.화환전달사항,'') as 화환전달사항 "
	SQL = SQL & " , isnull(m.조기전달사항,'') as 조기전달사항 "
	SQL = SQL & " , isnull(m.근조리본,'') as 화환문구 "
	SQL = SQL & " , isnull(m.조기문구,'') as 조기문구 "
	SQL = SQL & " , isnull(m.용품인수자,'') as 용품인수자 "
	SQL = SQL & " , isnull(m.화환인수자,'') as 화환인수자 "
	SQL = SQL & " , isnull(m.조기인수자,'') as 조기인수자 "
	SQL = SQL & " from 행사마스터 a (nolock) "
	SQL = SQL & "	left outer join 행사단체 b (nolock) on a.행사단체 = b.단체코드 "	
	SQL = SQL & "	left outer join 행사의전팀장 c (nolock) on a.진행팀장 = c.코드 "				
	SQL = SQL & "	left outer join 행사계약마스터 f (nolock) on a.행사번호 = f.행사번호 "	
	SQL = SQL & "	left outer join 행사장례식장 g (nolock) on a.장례식장 = g.코드 "		
	SQL = SQL & "	left outer join 행사_기타정보 i (nolock) on a.행사번호 = i.행사번호 "
	SQL = SQL & "	left outer join 행사마스터_세부추가 m (nolock) on a.행사번호 = m.행사번호 "
	SQL = SQL & " where  a.행사번호 = dbo.fnDecryption('"& code &"','apluslife') "		


	'Response.write SQL
	Set Rs = ConnAplus.execute(SQL)	


	If Rs.EOF Then
		
	Else		
		
		input1 = Rs("의전팀장코드")
		input2 = Rs("단체")
		input3 = Rs("접수일시")		
		'input4 = Rs("진행상품")
		input5 = Rs("고인과의관계")		
		input8 = Rs("고인명")
		input9 = Rs("장례식장")	
        'input10 = Rs("지원서비스")	
		input11 = Trim(Rs("용품도착일"))
		input12 = Trim(Rs("화환도착일"))
		input13	= Trim(Rs("근조기설치일"))
		'input14	= Rs("서명")
		'input15	= Rs("서명일")
		input16	= Rs("직원명")
		input17	= Rs("직원연락처")
		input18	= Rs("부서명")
		input19	= Rs("소속")
		input20	= Rs("직책")
		input21	= Rs("빈소")
		input22	= Rs("의전팀장")
		input23	= Rs("의전팀장연락처")
		input24	= Rs("용품명")
		input25	= Rs("용품수량")
		input26	= Rs("용품전달사항")
		input27	= Rs("화환전달사항")
		input28	= Rs("조기전달사항")
		input29	= Rs("화환문구")
		input30	= Rs("조기문구")
		input31	= Rs("용품인수자")
		input32	= Rs("화환인수자")
		input33	= Rs("조기인수자")
		input34	= Rs("접수번호")
	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	


	op_min = "<option value='00'>00</option>"
	op_min_5 = "<option value='00'>00</option>"
	op_hour = "<option value='00'>00</option>"

	for i=1 to 59
		if i < 10 then
			op_min = op_min & "<option value='0"& i &"'>0"& i &"</option>"
		else
			op_min = op_min & "<option value='"& i &"'>"& i &"</option>"
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
			op_hour = op_hour & "<option value='0"& i &"'>0"& i &"</option>"
		else
			op_hour = op_hour & "<option value='"& i &"'>"& i &"</option>"
		end if
	next


	if input11 = "" Then
		input11_1 = Left(input3,10)
		input11_2 = "00"
		input11_3 = "00"
	else
		input11_1 = Left(input11,4) & "." & Right(Left(input11,6),2) & "." & Right(Left(input11,8),2)
		input11_2 = Right(Left(input11,10),2)
		input11_3 = Right(Left(input11,12),2)
	end if

	if input12 = "" then 
		input12_1 = Left(input3,10)
		input12_2 = "00"
		input12_3 = "00"
	else
		input12_1 = Left(input12,4) & "." & Right(Left(input12,6),2) & "." & Right(Left(input12,8),2)
		input12_2 = Right(Left(input12,10),2)
		input12_3 = Right(Left(input12,12),2)
	end if

	if input113 = "" Then
		input13_1 = Left(input3,10)
		input13_2 = "00"
		input13_3 = "00"	
	else
		input13_1 = Left(input13,4) & "." & Right(Left(input13,6),2) & "." & Right(Left(input13,8),2)
		input13_2 = Right(Left(input13,10),2)
		input13_3 = Right(Left(input13,12),2)
	end if


	If check = "0" Then
		If gubun = "1" Then
			p1 = input31
			p2 = input11_1
			p3 = input11_2
			p4 = input11_3
		ElseIf gubun = "2" Then
			p1 = input32
			p2 = input12_1
			p3 = input12_2
			p4 = input12_3
		ElseIf gubun = "3" Then
			p1 = input33
			p2 = input13_1
			p3 = input13_2
			p4 = input13_3
		End If		
	ElseIf check = "6" Then
		p1 = input31
		p2 = input11_1
		p3 = input11_2
		p4 = input11_3
	ElseIf check = "3" Then
		p1 = input31
		p2 = input11_1
		p3 = input11_2
		p4 = input11_3
	ElseIf check = "4" Then
		p1 = input31
		p2 = input11_1
		p3 = input11_2
		p4 = input11_3
	ElseIf check = "5" Then
		p1 = input32
		p2 = input12_1
		p3 = input12_2
		p4 = input12_3
	End If

%>

<div class="sub_wrap">
	<!--// Sub 상단 -->
<script src="/js/datepicker.js"></script>
<link rel="stylesheet" href="/css/datepicker.css">

<div class="stop_sec">

	<a href="javascript:void(0);" class="btn_hisbk"></a>
	<p class="pg_title">배송현황</p>

	
</div><!--// stop_sec -->
	<div id="prt">

		<form name="frm" id="frm" method="post" action="reception_ship_ok.asp">
			<input type="hidden" name="code" id="code" value="<%=code %>" />
			<input type="hidden" name="gubun" id="gubun" value="<%=gubun %>" />
			<input type="hidden" name="check" id="check" value="<%=check %>" />			
			<input type="hidden" name="input34" id="input34" value="<%=input34 %>" />
		

		<table class="table_ty verti">
		<!--<table class="form_ty">-->
			<caption>배송현황</caption>
			<colgroup>
				<col span="1" class="verti_w01"><col span="1" style="width:*%;"><col span="2" class="verti_w02">
			</colgroup>

				<tr>
					<th scope="row">단체</th>
					<td colspan="3"><%=input2 %></td>
				</tr>
				<tr>
					<th scope="row">접수일</th>
					<td colspan="3"><%=input3 %></td>
				</tr>
				<!--tr>
					<th scope="row">진행상품</th>
					<td colspan="3"><%=input4 %></td>
				</tr-->
				<tr>
					<th scope="row">직원명</th>
					<td colspan="3"><%=input16 %></td>
				</tr>
				<tr>
					<th scope="row">연락처</th>
					<td colspan="3"><a href="tel:<%=input17 %>" target="_blank" class="blt_tel">전화걸기</a><%=input17 %></td>
				</tr>
				<!--
				<tr>
					<th scope="row">부서명</th>
					<td colspan="3"><%=input18 %></td>
				</tr>
				<tr>
					<th scope="row">소속</th>
					<td colspan="3"><%=input19 %></td>
				</tr>
				<tr>
					<th scope="row">직책</th>
					<td colspan="3"><%=input20 %></td>
				</tr>
				-->
				<tr>
					<th scope="row">고인과의 관계</th>
					<td colspan="3"><%=input5 %></td>
				</tr>			
				<tr>
					<th scope="row">고인명</th>
					<td colspan="3"><%=input8 %></td>
				</tr>
				<tr>
					<th scope="row">장례식장</th>
					<td colspan="3"><%=input9 %> <%=input21%></td>
				</tr>
                <tr>
					<th scope="row">담당팀장</th>
					<td colspan="3"><%=input22 %> / <%=input23 %></td>
				</tr>				
		</table>
		<br>
		<table class="form_ty">
			<caption>배송현황</caption>
			<colgroup>
				<col span="1" class="verti_w01"><col span="1" style="width:*%;"><col span="2" class="verti_w02">
			</colgroup>
				<tr>
					<th scope="row">인수자</th>
					<td colspan="3"><input type="text" id="p1" name="p1" value="<%=p1 %>" class="input_ty w100"></td>
				</tr>				
				<tr>
					<th scope="row">도착일시<a href="javascript:void();" onclick="Reset('a');" class="btn_ico ico07">초기화</a></th>
					<td class="bdr"><span class="dp_box"><input type="text" id="p2" name="p2" value="<%=p2 %>" class="datepicker input_ty start-date w100" placeholder="도착일" readonly ></span></td>
					<td class="bdr">
						<select id="p3" name="p3" class="select_ty w100"><%=op_hour %></select>
					</td>
					<td>
						<select id="p4" name="p4" class="select_ty w100"><%=op_min_5 %></select>
					</td>
				</tr>
		</table>
		<br>
		<table class="form_ty">	
			<caption>배송현황</caption>
			<colgroup>
				<col span="1" class="verti_w01"><col span="1" style="width:*%;"><col span="2" class="verti_w02">
			</colgroup>
				<% If InStr(gubun, "1") > 0 Then %>
				<tr>
					<th scope="row">용품</th>
					<td colspan="3"><%=input24 %> / 수량: <%=input25 %></td>
				</tr>
				<tr>
					<th scope="row">용품전달사항</th>
					<td colspan="3"><%=input26 %></td>
				</tr>
				<tr>				
					<th scope="row" class="btnu">용품첨부파일<a href="javascript:void(0);" onclick="FileUpload('배송', '용품', '<%=input34 %>');" class="btn_ico ico05">첨부파일</a></th>
					<td colspan="3">
						<div id="img_list"></div>
					</td>
				</tr>
				<% End If %>
				<% If InStr(gubun, "2") > 0 Then %>
				<tr>
					<th scope="row">화환문구</th>
					<td colspan="3"><%=input29 %></td>
				</tr>
				<tr>
					<th scope="row">화환전달사항</th>
					<td colspan="3"><%=input27 %></td>
				</tr>
				<tr>				
					<th scope="row" class="btnu">화환첨부파일<a href="javascript:void(0);" onclick="FileUpload('배송', '화환', '<%=input34 %>');" class="btn_ico ico05">첨부파일</a></th>
					<td colspan="3">
						<div id="img_list_2"></div>
					</td>
				</tr>
				<% End If %>
				<% If InStr(gubun, "3") > 0 Then %>
				<tr>
					<th scope="row">근조기문구</th>
					<td colspan="3"><%=input30 %></td>
				</tr>
				<tr>
					<th scope="row">근조기전달사항</th>
					<td colspan="3"><%=input28 %></td>
				</tr>
				<tr>				
					<th scope="row" class="btnu">근조기첨부파일<a href="javascript:void(0);" onclick="FileUpload('배송', '조기', '<%=input34 %>');" class="btn_ico ico05">첨부파일</a></th>
					<td colspan="3">
						<div id="img_list_3"></div>
					</td>
				</tr>
				<% End If %>
		</table>	
		</form>

	<!--#include virtual="/common/layer_popup.asp"-->
	
	</div>	
	<div class="top_btns sort01">
		<a href="javascript:void(0);" class="btn_ty ty02 btn_b" onclick="Save();">저장</a>
	</div>
</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->
<script type="text/javascript" language="javascript" src="/js/reception.js"></script>
<script language="javascript" type="text/javascript">
	function ImgList(b_type1, b_type2, b_idx) {

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/file/img_list.asp", //요청을 보낼 서버의 URL
			data: { b_type1: b_type1, b_type2: b_type2, b_idx: b_idx }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)	
				if ( b_type2 == "용품")
				{
					$("#img_list").text("");
					$("#img_list").html(data);
				}
				if ( b_type2 == "화환")
				{
					$("#img_list_2").text("");
					$("#img_list_2").html(data);
				}
				if ( b_type2 == "조기")
				{
					$("#img_list_3").text("");
					$("#img_list_3").html(data);
				}

			}
		});

	}
	if ( '<%=InStr(gubun, "1")%>' > '0' )
	{
		ImgList('배송', '용품', '<%=input34 %>');
	} 

	if ( '<%=InStr(gubun, "2")%>' > '0' )
	{
		ImgList('배송', '화환', '<%=input34 %>');
	}

	if ( '<%=InStr(gubun, "3")%>' > '0' )
	{
		ImgList('배송', '조기', '<%=input34 %>');
	}

	function FileUpload(b_type1, b_type2, b_idx) {

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/file/upload.asp", //요청을 보낼 서버의 URL
			data: { b_type1: b_type1, b_type2: b_type2, b_idx: b_idx }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)
				$("#popupLayer").text("");
				$("#popupLayer").html(data);
				Open('사진첨부');
			}
		});

	}
	function Save() {
		if ($("#p1").val() == "") {
			alert('인수자 입력되지 않았습니다.');
			return false;
		}

		if ($("#p3 option:selected").val() == "00" && $("#p4 option:selected").val() == "00") {
			alert('도착일시 입력되지 않았습니다.');
			return false;
		}
		/*
		파일업로드체크
		if (!$("#p17").val()) {
		alert('필수항목이 입력되지 않았습니다.');
		return false;
		}
		*/
		if (!confirm('저장하시겠습니까?')) {
			return false;
		}
		document.frm.submit();
    }
    function Reset(type) {
        if(type == 'a'){
            $("#p2").val('<%=Left(input3,10)%>');
            $("#p3").val('00');
            $("#p4").val('00');
        }
    }
</script>

<script>	
	document.getElementById("p3").value = "<%=p3 %>";
	document.getElementById("p4").value = "<%=p4 %>";
</script>
