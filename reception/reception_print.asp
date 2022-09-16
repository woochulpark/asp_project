<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->
<%
	menu = "접수 - 회사지원서명"
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
	SQL = SQL & "  ,isnull(convert(varchar(16),i.용품도착일,120),'') as 용품도착일, isnull(convert(varchar(16),i.화환도착일,120),'') as 화환도착일 "
	SQL = SQL & "  ,isnull(convert(varchar(16),i.근조기설치일,120),'') as 근조기설치일, isnull(j.서명,'') as 서명, isnull(convert(varchar(16),j.등록일,120),'') as 서명일 "
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
	SQL = SQL & " where  a.행사번호 = '" & code & "' "	

	SQL2 = "select 사원명, convert(varchar(10),접수일,120) as 접수일, 일차, 출동일시, 종료일시 "
	SQL2 = SQL2 & " from 행사_회사지원 "
	SQL2 = SQL2 & " where 행사번호 = '"& code &"' "
	SQL2 = SQL2 & " order by 순번 asc "

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
	End If

	Set Rs = ConnAplus.execute(SQL2)

	If Rs.EOF Then
		rc = 0
	Else
		rc = Rs.RecordCount
		arrObj = Rs.GetRows(rc)
	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	

	' 의전팀장이 배정되지 않으면 기본정보로 보낸다.
	if input1 = "" then
		response.write "<script type='text/javascript'>"
		response.write "alert('의전팀장이 배정되지 않았습니다.');"
		response.write "location.replace('reception_info.asp?Code="& code &"');"
		response.write "</script>"
		response.End
	end if

	' 고인정보가 등록되지 않으면 고인정보로 보낸다.
	if input8 = "" then
		response.write "<script type='text/javascript'>"
		response.write "alert('고인정보가 등록되지 않았습니다.');"
		response.write "location.replace('reception_goin.asp?Code="& code &"');"
		response.write "</script>"
		response.End
	end if

	' 기타정보가 등록되지 않으면 기타정보로 보낸다.
	if input10 = "" then
		response.write "<script type='text/javascript'>"
		response.write "alert('기타정보가 등록되지 않았습니다.');"
		response.write "location.replace('reception_etc.asp?Code="& code &"');"
		response.write "</script>"
		response.End
	end if

	' 회사지원입력이 등록되지 않으면 회사지원입력으로 보낸다.
	if rc = 0 then
		response.write "<script type='text/javascript'>"
		response.write "alert('회사지원입력이 등록되지 않았습니다.');"
		response.write "location.replace('reception_support.asp?Code="& code &"');"
		response.write "</script>"
		response.End
	end if

	if input6 <> "" then
		input6_1 = Replace(Split(input6, " ")(0), "-", ".")
		input6_2 = Split(Split(input6, " ")(1), ":")(0)
		input6_3 = Split(Split(input6, " ")(1), ":")(1)
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

	if input113 <> "" then
		input13_1 = Replace(Split(input13, " ")(0), "-", ".")
		input13_2 = Split(Split(input13, " ")(1), ":")(0)
		input13_3 = Split(Split(input13, " ")(1), ":")(1)
	end if

	if input14 <> "" then
		SignChk = "Y"
	end if
%>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->

	<table class="table_ty verti">
		<caption>접수-배송외-회사지원서명</caption>
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
				<td class="bdr"><%=input6_1 %></td>
				<td class="bdr"><%=input6_2 %></td>
				<td><%=input6_3 %></td>
			</tr>
			<tr>
				<th scope="row">별세일시</th>
				<td class="bdr"><%=input7_1 %></td>
				<td class="bdr"><%=input7_2 %></td>
				<td><%=input7_3 %></td>
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
			<tr>
				<th scope="row">용품도착</th>
				<td class="bdr"><%=input11_1 %></td>
				<td class="bdr"><%=input11_2 %></td>
				<td><%=input11_3 %></td>
			</tr>
			<tr>
				<th scope="row">화환도착</th>
				<td class="bdr"><%=input12_1 %></td>
				<td class="bdr"><%=input12_2 %></td>
				<td><%=input12_3 %></td>
			</tr>
			<tr>
				<th scope="row">근조기설치</th>
				<td class="bdr"><%=input13_1 %></td>
				<td class="bdr"><%=input13_2 %></td>
				<td><%=input13_3 %></td>
			</tr>
			
	</table>

	<p class="sub_tit mt">인력지원</p>
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
	if rc = 0 then 
%>
				
<%
	else
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
	end if 
%>
		</tbody>
	</table>

	<p class="sub_tit mt">첨부파일</p>
	<div class="add_pic_sec">추후적용예정</div><!--// add_pic_sec -->
	<p class="ap_noti">위와 같이 서비스를 제공받았음을 확인합니다.</p>

<%	if input14 = "" then %>	
<%	else %>
	<div class="sign_sec">
		<img src="<%=input14 %>" />		
	</div>
	<p class="sign_noti">서명시간 : <span><%=input15 %></span></p>
<%	end if %>

	

</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->

<script for=window event=onload> 
    
    window.print();
 
</script>