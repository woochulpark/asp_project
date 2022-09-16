<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%
	menu = "정산"
	menu_sub = "첨부파일"
	lnbh = "class='on'"

	code = Trim(request("Code"))

	if code = "" then
		response.End
	end if

	SQL = "select  행사시작일시, 행사종료일시, 장례식장 as 행사장소, "
	SQL = SQL & " isnull( "
	SQL = SQL & " 	(select 본부 + '/' + 센터 + '/' + 의전관명+'/'+연락처 from dbo.행사의전팀장 with (nolock) where (코드 = a.진행팀장)),  "
	SQL = SQL & " 	(select     a.진행팀장+space(1)+사원명+' '+휴대폰 from dbo.사원마스터 with (nolock) where (사원코드 = a.진행팀장)) "
	SQL = SQL & " ) as 의전관,  "
	SQL = SQL & " a.계약코드 as 회원번호, d.계약자명 as 회원명, d.계약자휴대폰 as 회원연락처, 상주 as 상주명, "
	SQL = SQL & " 상주휴대폰 as 상주연락처, 고인성명 as 고인명, a.회원과관계  as 회원관계, 입관일시, 발인일시, "
	SQL = SQL & " 장례형태, 장지, 고인성별 as 성별, 연령 as 나이, 종교, 부고사유 as 사망사유,  "
	SQL = SQL & " (select 사원명 + ' ' + 휴대폰 from dbo.사원마스터 where 사원코드 = d.모집사원코드) as 영업담당, "
	SQL = SQL & " (select 사원명 from dbo.행사사원마스터 where 사원코드 = a.장례예식사) AS 장례예식사, a.상품명, a.가입상품명, "
	SQL = SQL & " (select 단체명 from 행사단체 where 단체코드 = a.행사단체) as 단체명 "
	SQL = SQL & " from 행사마스터v as a inner join 상품코드 as b on a.상품코드 = b.상품코드 "
	SQL = SQL & " inner join 계약마스터 as d on a.계약코드 = d.계약코드 "
	SQL = SQL & " where  a.행사번호 = '" & code & "' "

	SQL = "exec p_행사조회 '" & code & "'"

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)

	If Rs.EOF Then

	Else
		sdate = Trim(Rs("행사시작일시"))
		edate = Trim(Rs("행사종료일시"))
		place = Rs("행사장소")
		tname = Rs("의전관")
		itemname = Rs("가입상품명")
		groupname = Rs("단체명")
		item = Rs("상품명")
		sales = Rs("영업담당")
		name = Rs("회원명")
		memberno = Rs("회원번호")
		resident = Rs("상주명")
		ceremonial = Rs("장례예식사")
		deceased = Rs("고인명")
		relation = Rs("회원관계")
		gender = Rs("성별")
		age = Rs("나이")
		religion = Rs("종교")
		deathreason = Rs("사망사유")
		hyeongtae = Rs("장례형태")
		jangji = Rs("장지")
		mphone = Rs("회원연락처")
		rphone = Rs("상주연락처")
		idate = Trim(Rs("입관일시"))
		odate = Trim(Rs("발인일시"))

		tname = Split(tname, "/")

		if UBound(tname) > 0 then
			tname_txt = "<li>"&tname(0)&"</li><li>"&tname(1)&"</li><li>"&tname(2)&"</li>"
		else
			tname_txt = ""
		end if

		if sdate <> "" then
			sdate = Split(sdate, " ")(0)
			'sdate = left(sdate,4)&"."&mid(sdate,5,2)&"."&mid(sdate,7,2)
		end if
		if edate <> "" then
			edate = Split(edate, " ")(0)
			'edate = left(edate,4)&"."&mid(edate,5,2)&"."&mid(edate,7,2)
		end if
		if idate <> "" then
			idate = left(idate,4)&"."&mid(idate,5,2)&"."&mid(idate,7,2)&"."&mid(idate,9,2)&":"&mid(idate,11,2)
		end if
		if odate <> "" then
			odate = left(odate,4)&"."&mid(odate,5,2)&"."&mid(odate,7,2)&"."&mid(odate,9,2)&":"&mid(odate,11,2)
		end if
		if hyeongtae <> "" then
			hyeongtae = "("& hyeongtae &")"
		end if

	End If

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing
%>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->
	<!--#include virtual="/common/lnb.asp"-->

	<div class="top_btns no_use"></div><!--// top_btns -->

	<table class="form_ty">
		<caption>정산-첨부파일</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="1" style="width:*%;">
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">첨부파일<a href="javascript:void(0);" onclick="FileUpload('<%=menu %>', '<%=menu_sub %>', '<%=code %>');" class="btn_ico ico05">첨부파일</a></th>
				<td><div id="img_list"></div></td>
			</tr>
		</tbody>
	</table><!--// form_ty -->

	<!--div class="btm_btns">
		<a href="#" class="btn_ty btn_b">저장</a>
	</div--><!--// btm_btns -->

	<!--#include virtual="/common/layer_popup.asp"-->

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
				$("#img_list").text("");
				$("#img_list").html(data);
			}
		});

	}
	ImgList('<%=menu %>', '<%=menu_sub %>', '<%=code %>');
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
</script>