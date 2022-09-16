<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->
<%
	menu = "진행"
	lnbtype = "N" '배송여부
	lnbe = "class='on'"	
	top_btn_save = "N"

	code = Trim(request("Code"))
	
	if code = "" then 
		response.End
	end if

	SQL = "select b.단체명 as 단체 "
	SQL = SQL & " , a.행사번호 as 접수번호 "
	SQL = SQL & " , left(a.행사시작일시,4) +'.'+ right(left(a.행사시작일시,6),2) +'.'+ right(left(a.행사시작일시,8),2) +' '+ right(left(a.행사시작일시,10),2) +':'+ right(left(a.행사시작일시,12),2) as 접수일시 "
	SQL = SQL & " , a.진행팀장 as 의전팀장코드 "
	SQL = SQL & " , c.성함 as 의전팀장 "
	SQL = SQL & " , c.연락처 as 의전팀장연락처 "
	SQL = SQL & " , case when a.일반단체구분 in ('용품배송', '근조화환배송', '용품+화환배송', '화환배송') then '배송' else '장례' end as 행사구분 "
	SQL = SQL & " , d.상품명 as 진행상품 "
	SQL = SQL & " , isnull((select sum(입금액) from 수납마스터 (nolock) where 계약코드 = a.계약코드),0) as 납입부금 "
	SQL = SQL & " , left(e.계약일자,4) +'-'+ right(left(e.계약일자,6),2) +'-'+ right(left(e.계약일자,8),2) as 계약일자 "
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
	SQL = SQL & " , convert(varchar(16),h.빈소도착,120) as 빈소도착, convert(varchar(16),h.별세일시,120) as 별세일시, isnull(h.고인명,'') as 고인명, h.장례식장명, isnull(i.지원서비스,'') as 지원서비스 "
	SQL = SQL & " , isnull(convert(varchar(16),i.용품도착일,120),'') as 용품도착일, isnull(convert(varchar(16),i.화환도착일,120),'') as 화환도착일 "
	SQL = SQL & " , isnull(convert(varchar(16),i.근조기설치일,120),'') as 근조기설치일, isnull(j.서명,'') as 서명, isnull(convert(varchar(16),j.등록일,120),'') as 서명일 "
	SQL = SQL & " , isnull(k.지원내용, '') 지원내용 "
	SQL = SQL & " from 행사마스터 a (nolock) "
	SQL = SQL & "	left outer join 행사단체 b (nolock) on a.행사단체 = b.단체코드 "	
	SQL = SQL & "	left outer join 행사의전팀장 c (nolock) on a.진행팀장 = c.코드 "	
	SQL = SQL & "	left outer join 상품코드 d (nolock) on a.상품코드 = d.상품코드 "	
	SQL = SQL & "	left outer join 계약마스터 e (nolock) on a.계약코드 = e.계약코드 "	
	SQL = SQL & "	left outer join 행사계약마스터 f (nolock) on a.행사번호 = f.행사번호 "	
	SQL = SQL & "	left outer join 행사장례식장 g (nolock) on a.장례식장 = g.코드 "	
	SQL = SQL & "	left outer join 행사_고인정보 h on a.행사번호 = h.행사번호 "
	SQL = SQL & "	left outer join 행사_기타정보 i on a.행사번호 = i.행사번호 "
	SQL = SQL & "	left outer join 행사_회사지원서명 j on a.행사번호 = j.행사번호 "
	SQL = SQL & "	left outer join 행사마스터_세부추가 k (nolock) on a.행사번호 = k.행사번호 "
	SQL = SQL & " where  a.행사번호 = '" & code & "' "	

	SQL2 = "select 사원명, convert(varchar(10),접수일,120) as 접수일, 일차, 출동일시, 종료일시 "
	SQL2 = SQL2 & " from 행사_회사지원 "
	SQL2 = SQL2 & " where 행사번호 = '"& code &"' "
	SQL2 = SQL2 & " order by 순번 asc "

	SQL3 = " select 파일명, 파일경로 "
	SQL3 = SQL3 & " from 파일저장 "
	SQL3 = SQL3 & " where 게시판종류 = '행사' and 게시판종류2 = '회사지원입력' and 게시판인덱스 = '"& code &"' "
	SQL3 = SQL3 & " order by 인덱스 asc "

	SQL3_1 = " select 파일명, 파일경로 "
	SQL3_1 = SQL3_1 & " from 파일저장 (nolock) "
	SQL3_1 = SQL3_1 & " where 게시판종류 = '배송' and 게시판종류2 = '용품' and 게시판인덱스 = '"& code &"' "
	SQL3_1 = SQL3_1 & " order by 인덱스 asc "

	SQL3_2 = " select 파일명, 파일경로 "
	SQL3_2 = SQL3_2 & " from 파일저장 (nolock) "
	SQL3_2 = SQL3_2 & " where 게시판종류 = '배송' and 게시판종류2 = '화환' and 게시판인덱스 = '"& code &"' "
	SQL3_2 = SQL3_2 & " order by 인덱스 asc "

	SQL3_3 = " select 파일명, 파일경로 "
	SQL3_3 = SQL3_3 & " from 파일저장 (nolock) "
	SQL3_3 = SQL3_3 & " where 게시판종류 = '배송' and 게시판종류2 = '조기' and 게시판인덱스 = '"& code &"' "
	SQL3_3 = SQL3_3 & " order by 인덱스 asc "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)	

	If Rs.EOF Then
		
	Else		
		input1 = Rs("의전팀장코드")
		input2 = Rs("단체")
		input3 = Rs("접수일시")		
		input4 = Rs("진행상품")
		input5 = Rs("고인과의관계")
		input6 = Rs("빈소도착")
		input7 = Rs("별세일시")
		input8 = Rs("고인명")
		input9 = Rs("장례식장명")
		input10 = Rs("지원서비스")
		input11 = Rs("용품도착일")
		input12 = Rs("화환도착일")
		input13	= Rs("근조기설치일")		
		input14	= Rs("서명")
		input15	= Rs("서명일")
		input16	= Rs("직원명")
		input17	= Rs("직원연락처")
		input18	= Rs("부서명")
		input19	= Rs("소속")
		input20	= Rs("직책")
		input21	= Rs("지원내용")
	End If

	Set Rs = ConnAplus.execute(SQL2)

	If Rs.EOF Then
		rc = 0
	Else
		rc = Rs.RecordCount
		arrObj = Rs.GetRows(rc)
	End If

	Set Rs = ConnAplus.execute(SQL3)

	If Rs.EOF Then
		rc2 = 0
	Else
		rc2 = Rs.RecordCount
		arrObj2 = Rs.GetRows(rc2)
	End If

	Set Rs = ConnAplus.execute(SQL3_1)

	If Rs.EOF Then
		rc2_1 = 0
	Else
		rc2_1 = Rs.RecordCount
		arrObj2_1 = Rs.GetRows(rc2_1)
	End If

	Set Rs = ConnAplus.execute(SQL3_2)

	If Rs.EOF Then
		rc2_2 = 0
	Else
		rc2_2 = Rs.RecordCount
		arrObj2_2 = Rs.GetRows(rc2_2)
	End If

	Set Rs = ConnAplus.execute(SQL3_3)

	If Rs.EOF Then
		rc2_3 = 0
	Else
		rc2_3 = Rs.RecordCount
		arrObj2_3 = Rs.GetRows(rc2_3)
	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing		

	if input6 <> "" then
		input6_1 = Replace(Split(input6, " ")(0), "-", ".")
		input6_2 = Split(Split(input6, " ")(1), ":")(0)
		input6_3 = Split(Split(input6, " ")(1), ":")(1)
	end if

	if input7 <> "" then
		input7_1 = Replace(Split(input7, " ")(0), "-", ".")
		input7_2 = Split(Split(input7, " ")(1), ":")(0)
		input7_3 = Split(Split(input7, " ")(1), ":")(1)
	end if

	if input11 <> "" then
		input11_1 = Replace(Split(input11, " ")(0), "-", ".")
		input11_2 = Split(Split(input11, " ")(1), ":")(0)
		input11_3 = Split(Split(input11, " ")(1), ":")(1)
	end if

	if input12 <> "" then 
		input12_1 = Replace(Split(input12, " ")(0), "-", ".")
		input12_2 = Split(Split(input12, " ")(1), ":")(0)
		input12_3 = Split(Split(input12, " ")(1), ":")(1)
	end if

	if input13 <> "" then
		input13_1 = Replace(Split(input13, " ")(0), "-", ".")
		input13_2 = Split(Split(input13, " ")(1), ":")(0)
		input13_3 = Split(Split(input13, " ")(1), ":")(1)
	end if
%>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->
<%	if user_type = "a" or user_type = "b" then %>
	<!--#include virtual="/common/lnb.asp"-->
	<!--#include virtual="/common/top_btns.asp"-->	
<%	end if %>

	<div id="prt">

		<table class="table_ty verti">
			<caption>진행-회사지원서명</caption>
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
				<tr>
					<th scope="row">진행상품</th>
					<td colspan="3"><%=input4 %></td>
				</tr>
				<tr>
					<th scope="row">직원명</th>
					<td colspan="3"><%=input16 %></td>
				</tr>
				<tr>
					<th scope="row">연락처</th>
					<td colspan="3"><a href="tel:<%=input17 %>" target="_blank" class="blt_tel">전화걸기</a><%=input17 %></td>
				</tr>
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
				<tr>
					<th scope="row">고인과의 관계</th>
					<td colspan="3"><%=input5 %></td>
				</tr>
				<tr>
					<th scope="row">빈소도착</th>
					<!--
					<td class="bdr"><%=input6_1 %></td>
					<td class="bdr"><%=input6_2 %></td>
					<td><%=input6_3 %></td>
					-->
					<td colspan="3"> <%=input6_1 %>&nbsp;&nbsp;<%=input6_2 %>:<%=input6_3 %></td>
				</tr>
				<tr>
					<th scope="row">별세일시</th>
					<!--
					<td class="bdr"><%=input7_1 %></td>
					<td class="bdr"><%=input7_2 %></td>
					<td><%=input7_3 %></td>
					-->
					<td colspan="3"> <%=input7_1 %>&nbsp;&nbsp;<%=input7_2 %>:<%=input7_3 %></td>
				</tr>
				<tr>
					<th scope="row">고인명</th>
					<td colspan="3"><%=input8 %></td>
				</tr>
				<tr>
					<th scope="row">장례식장</th>
					<td colspan="3"><%=input9 %></td>
				</tr>
				<tr>
					<th scope="row">지원서비스</th>
					<td colspan="3"><%=input10 %></td>
				</tr>
				<% if input21 <> "" then %>
				<tr>
					<th scope="row">지원내용</th>
					<td colspan="3"><%=input21 %></td>
				</tr>
				<% end if%>
				<% if input11_1 <> "" then %>
				<tr>
					<th scope="row">용품도착</th>
					<!--
					<td class="bdr"><%=input11_1 %></td>
					<td class="bdr"><%=input11_2 %></td>
					<td><%=input11_3 %></td>
					-->
					<td colspan="3"> <%=input11_1 %>&nbsp;&nbsp;<%=input11_2 %>:<%=input11_3 %></td>
				</tr>
				<% end if%>
				<% if input12_1 <> "" then %>				
				<tr>
					<th scope="row">화환도착</th>
					<!--
					<td class="bdr"><%=input12_1 %></td>
					<td class="bdr"><%=input12_2 %></td>
					<td><%=input12_3 %></td>
					-->
					<td colspan="3"> <%=input12_1 %>&nbsp;&nbsp;<%=input12_2 %>:<%=input12_3 %></td>
				</tr>
				<% end if%>
				<% if input13_1 <> "" then %>				
				<tr>
					<th scope="row">근조기설치</th>
					<!--
					<td class="bdr"><%=input13_1 %></td>
					<td class="bdr"><%=input13_2 %></td>
					<td><%=input13_3 %></td>
					-->
					<td colspan="3"> <%=input13_1 %>&nbsp;&nbsp;<%=input13_2 %>:<%=input13_3 %></td>
				</tr>
				<% end if%>
			
		</table>

		<p class="sub_tit mt">인력지원 <a href="#" class="btn_ico ico01" onclick="support('<%=code%>');">인력지원 수정</a></p>
	<%
		if rc = 0 then 
	%>
		
		<a href="javascript:void(0);" onclick="SaveERP();" class="btn_ty btn_b ty05">인력지원 수정</a>
		
	<%
		else
	%>
		
		<table class="table_ty">
			<caption>인력지원</caption>
			<colgroup>
				<col span="1" class="verti_w02"><col span="1" class="verti_w01"><col span="1" style="width:*%;"><col span="2" class="verti_w02">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">구분</th>
					<th scope="col">일자</th>
					<th scope="col">일차</th>
					<th scope="col">출동일시</th>
					<th scope="col">종료일시</th>
				</tr>
			</thead>
			<tbody>
	
	<%
			for i=0 to UBound(arrObj,2)
				input_1	= arrObj(0,i)
				input_2	= Replace(arrObj(1,i), "-", ".")
				input_3	= arrObj(2,i)
				input_4	= arrObj(3,i)
				input_5	= arrObj(4,i)
	%>				
				<tr>
					<td><%=input_1 %></td>
					<td><%=input_2 %></td>
					<td><%=input_3 %></td>
					<td><%=input_4 %></td>
					<td><%=input_5 %></td>
				</tr>
	<%
			next
	%>
			</tbody>
		</table>
	<%
		end if 
	%>

	<%
		if rc2_1 < 0 then 
	%>
		<p class="sub_tit mt">용품첨부파일</p>
		<div class="add_pic_sec">
			<ul>				
	<%		
			for i=0 to UBound(arrObj2_1,2)
				file_name	= arrObj2_1(0,i)				
				file_path	= arrObj2_1(1,i)				
	%>				
				<li><img src="<%=file_path & file_name %>" onclick="FileView('<%=file_path & file_name %>');"></li>				
	<%
			Next
	%>
			</ul>
		</div><!--// add_pic_sec -->
	<%
		end if 
	%>				

	<%
		if rc2_2 < 0 then 
	%>
		<p class="sub_tit mt">화환첨부파일</p>
		<div class="add_pic_sec">
			<ul>				
	<%		
			for i=0 to UBound(arrObj2_2,2)
				file_name	= arrObj2_2(0,i)				
				file_path	= arrObj2_2(1,i)				
	%>				
				<li><img src="<%=file_path & file_name %>" onclick="FileView('<%=file_path & file_name %>');"></li>				
	<%
			Next
	%>
			</ul>
		</div><!--// add_pic_sec -->
	<%
		end if 
	%>	

	<%
		if rc2_3 < 0 then 
	%>
		<p class="sub_tit mt">근조기첨부파일</p>
		<div class="add_pic_sec">
			<ul>				
	<%		
			for i=0 to UBound(arrObj2_3,2)
				file_name	= arrObj2_3(0,i)				
				file_path	= arrObj2_3(1,i)				
	%>				
				<li><img src="<%=file_path & file_name %>" onclick="FileView('<%=file_path & file_name %>');"></li>				
	<%
			Next
	%>
			</ul>
		</div><!--// add_pic_sec -->
	<%
		end if 
	%>

	<%
		if rc2 < 0 then 
	%>
		<p class="sub_tit mt">첨부파일</p>
		<div class="add_pic_sec">
			<ul>				
	<%
		
			for i=0 to UBound(arrObj2,2)
				file_name	= arrObj2(0,i)				
				file_path	= arrObj2(1,i)				
	%>				
				<li><img src="<%=file_path & file_name %>" onclick="FileView('<%=file_path & file_name %>');"></li>				
	<%
			Next
	%>
			</ul>
		</div><!--// add_pic_sec -->	
	<%
		end if 
	%>	

	<!--#include virtual="/common/layer_popup.asp"-->

		<p class="ap_noti">위와 같이 서비스를 제공받았음을 확인합니다.</p>
		<table class="table_ty verti">
			<caption>접수-배송외-회사지원서명</caption>
			<colgroup>
				<col span="1" class="verti_w01"><col span="1" style="width:*%;"><col span="2" class="verti_w02">
			</colgroup>

				<tr>
					<th scope="row">인수자</th>
					<td colspan="3"><%=input22 %></td>
				</tr>
		</table>
		<div class="sign_sec">
			<img src="<%=input14 %>" />
		</div>
		<p class="sign_noti">서명시간 : <span><%=input15 %></span></p>	

	</div>

	<div class="btm_btns sort03" style="display:none;" id="printbtn">
		<a href="javascript:void(0);" onclick="PrintDiv();" class="btn_ty ty05 btn_b btn_print">출력</a>
	</div>

</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->

<script type="text/javascript" language="javascript" src="/js/reception.js"></script>
<script language="javascript" type="text/javascript">

	function support(code) {		
		location.href = '/progression/progression_support.asp?Code=' + code;
	}


	var printDiv;
	var initBody;

	function PrintDiv() {
		printDiv = document.getElementById("prt");

		window.onbeforeprint = beforePrint;
		window.onafterprint = afterPrint;

		window.print();
	}
	function beforePrint() {
		initBody = document.body.innerHTML;
		document.body.innerHTML = printDiv.innerHTML;
	}
	function afterPrint() {
		location.reload();
		//document.body.innerHTML = initBody;
	}
	function device_check() {
		// 디바이스 종류 설정
		var pc_device = "win16|win32|win64|mac|macintel";

		// 접속한 디바이스 환경
		var this_device = navigator.platform;

		if (this_device) {

			if (pc_device.indexOf(navigator.platform.toLowerCase()) < 0) {
				//MOBILE
			} else {
				//PC
				document.getElementById("printbtn").style.display = "block";
			}

		}
	}
	device_check();
</script>