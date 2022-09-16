<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	dim sValue
	sValue = request("sValue")	
	sType = request("sType")	
	code = request("code")
	popup_check_ag = "HelperList3"

	'popup 체크 값
	'참고 /js/layer_popup.asp > Close()
	If request("popup_check_ag") <> "" Then
		popup_check_ag = request("popup_check_ag")
	End If 

	SQL = " select 대표명칭 from 공용코드 where 대표코드 =  '00255' "	
	SQL2 = " select 은행코드,은행명 from 은행코드 where 사용구분 =  'Y' "		

	SQL3 = " select 사원명,사원구분,주민번호,isnull(휴대폰,' ') 휴대폰,은행코드,계좌번호,예금주명,검증,지역,메모 "
    SQL3 = SQL3 + " from 행사사원마스터  where 사원코드 = '"& code &"' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ		
		
	Set Rs = ConnAplus.execute(SQL)

	If Rs.EOF Then
		rc = 0		
	Else
		rc = Rs.RecordCount
		arrObj = Rs.GetRows(rc)
	End If

	Set Rs = ConnAplus.execute(SQL2)

	If Rs.EOF Then
		rc2 = 0		
	Else
		rc2 = Rs.RecordCount
		arrObj2 = Rs.GetRows(rc2)
	End If

	Set Rs = ConnAplus.execute(SQL3)
    if not(Rs.bof or Rs.eof) then
        hi_mcode		= code '도우미 사번
        hi_mgubun		= Rs("사원구분")
        hi_mname		= Rs("사원명")
        hi_mjumin1		= Left(Rs("주민번호") ,6)
		hi_mjumin2		= Right(Rs("주민번호") ,7)
        hi_mbank		= Rs("은행코드")
        hi_mbankno		= Rs("계좌번호")
        hi_mbankname	= Rs("예금주명")
		hi_bankValid	= Rs("검증")
        hi_mphone		= replace(trim(Rs("휴대폰")),"-","")
		hi_memo			= Rs("메모")
    end if

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	

	gubun_list = ""
	if rc <> 0 then	
		for i=0 to UBound(arrObj,2)
			gubun	= arrObj(0,i)
			gubun_list = gubun_list & "<option value='"& gubun &"'>"& gubun &"</option>"
		next
	end if

	bank_list = "<option value=''>== 은행선택==</option>"
	if rc2 <> 0 then	
		for i=0 to UBound(arrObj2,2)
			bankcode	= arrObj2(0,i)
			bankname	= arrObj2(1,i)
			bank_list = bank_list & "<option value='"& bankcode &"'>"& bankname &"</option>"
		next
	end if	
%>

<div class="lypB">	

	<form name="frm_helper" id="frm_helper">
	<input type="hidden" id="popup_check_ag" value="<%=popup_check_ag %>" />
	<input type="hidden" id="sType_popup" value="<%=sType %>" />
	<input type="hidden" id="sValue_popup" value="<%=sValue %>" />
	<input type="hidden" id="nameCk" value="N" />
	<input type="hidden" id="bankValid" name="bankValid" value="<%=hi_bankValid %>" />
	<input type="hidden" id="bankName" name="bankName"  />
	<input type="hidden" id="bankck" name="bankck" value="Y" />
	<input type="hidden" id="banknock" name="banknock" value="<%=hi_mbankno %>" />
	<table class="form_ty no_l">
		<caption>도우미 수정</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="1" style="width:*%;">
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">도우미구분</th>
				<td>
					<select name="hi_mgubun" id="hi_mgubun" class="select_ty w100"><%=gubun_list %></select>					
				</td>
			</tr>
			<tr>
				<th scope="row">도우미명</th>
				<td><input type="text" id="hi_mname" name="hi_mname" value="<%=hi_mname %>" onKeyup="this.value=this.value.replace(/[^\w\sㄱ-힣]|[\_]/g,'');" onchange='juminck_flag();' class="input_ty w100" placeholder="도우미명"></td>
			</tr>
			<tr>
				<th scope="row" style="diplay:flex; align-content:flex-start;"><div>주민번호</div></th>
				<td>
					<input type="text" id="hi_mjumin1" name="hi_mjumin1" value="<%=hi_mjumin1 %>" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" onchange='juminck_flag();' maxlength="6" class="input_ty w_c50" placeholder="000000" style="color:#858585;" readOnly> - 
					<input type="text" id="hi_mjumin2" name="hi_mjumin2" value="<%=hi_mjumin2 %>" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" onchange='juminck_flag();' maxlength="7" class="input_ty w_c50" placeholder="0000000" style="color:#858585;" readOnly>
					<button id='niceNameCheck' type="button" onclick="requestNameCheck();" class="btn_ty ty02 de_txt" style="margin-top:5px; height:33px;">실명확인</button>
				</td>
			</tr>
			<tr>
				<th scope="row">연락처</th>
				<td><input type="text" name="hi_mphone" value="<%=hi_mphone %>" class="input_ty w100" placeholder="숫자만 입력해주세요."></td>
			</tr>
			<tr>
				<th scope="row">은행</th>
				<td>
					<select name="hi_mbank" id="hi_mbank" onchange="bankChecking();" class="select_ty w100"><%=bank_list %></select>					
				</td>
			</tr>
			<tr>
				<th scope="row">계좌번호 <a href="javascript:void(0);" onclick='HelperBank($(this));' class="btn_ico ty02 ico01">검색</a></th>
				<td><input type="text" id="hi_mbankno" name="hi_mbankno" value="<%=hi_mbankno %>" onchange="bankChecking();" class="input_ty w100"></td>
			</tr>
			<tr>
				<th scope="row">예금주명</th>
				<td>
					<input type="text" id="hi_mbankname" name="hi_mbankname" value="<%=hi_mbankname %>" class="input_ty w100" readOnly>
					<button id='niceNameCheck' type="button" onclick="bankRecordView('', '<%=hi_mname%>', '<%=code%>');" class="btn_ty ty02 de_txt" style="margin-top:5px; height:33px;">변경내역</button>
				</td>
			</tr>
			<tr>
				<th scope="row">메모</th>
				<td style="height: 100px;">
					<textarea placeholder="최대 50자까지 입력가능합니다." name="hi_memo" onKeyup="textareaCheck();" style="height: 100px;" class="input_ty w100" ><%= hi_memo %></textarea>
				</td>
			</tr>
		</tbody>
	</table>
	</form>
</div>
<!--#include virtual="/common/protocol.asp"-->
<form name="banksearchform" method="post" target="bank_search_frame" action="https://van.sbsvc.online/servlet/NameSerMgrServlet2">
<input type="hidden" name="RETURN_PAGE_URL" value="<%=protocol%>hs.apluslife.co.kr/reception/reception_helper_bank_search_return.asp" /> <!-- 이 값은 기관에서 원하는 리턴값으로 변경하십시오.-->
<input type="hidden" name="ACT_TP" value="ACCOUNT_NAME_CONFIRM" />
<input type="hidden" name="corpId" value="20040035" />
<input type="hidden" name="ID" value="apluslife" />
<input type="hidden" name="ko_char" value="1" /> <!-- 1:euc-kr 2:utf-8 -->
<input type="hidden" name="bankCd" value="<%=bankCd%>" />
<input type="hidden" name="accountNo" value="<%=accountNo%>" />
</form>

<iframe src="" name="bank_search_frame" style="display:none;" width=500 height=500></iframe>
<script>
	// 계좌변경이력 리스트 창
	function bankRecordView(sType, sValue, code) {
		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "/reception/reception_helper_bank_record_ajax.asp", //요청을 보낼 서버의 URL
			data: { sValue: sValue, sType: sType, code: code}, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				$("#secondPopupLayer").text("");
				$("#secondPopupLayer").html(data);
				SecondOpen('계좌변경이력');
			}
		});
	}

	function bankChange(bankCode, accountNums, accountValid, accountValidName ) {
		$("#hi_mbank").val(bankCode).prop("selected", true);
		$("#hi_mbankno").val(accountNums);
		$("#hi_mbankname").val(accountValidName);
		$("#bankName").val(accountValidName);
		$("#bankValid").val(accountValid);
		$("#bankck").val('Y');
		$("#banknock").val(accountNums);
		SecondClose();
	}

	// 주민번호 수정시 주민번호 확인 초기화
	function juminck_flag() {
		$("#nameCk").val("N");
//		$("#niceNameCheck").attr("disabled", false);
	}
	
	function textareaCheck() {
		var textarea = document.frm_helper.hi_memo;
		if(textarea.value.length > 50) {
			alert("최대 50자까지 입력가능합니다.")
			textarea.value = textarea.value.substring(0, 51);
			textarea.focus();
		}
	}

	// Null 값 확인
	var isEmpty = function(value){
		if( value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length ) ){
			return true  
		}else{
			return false
		}  
	};

    //bank_ck();
	function bankChecking() {
		$("#bankck").val("N");
		$("#bankValid").val("N");
	}

    // 계좌조회
    function HelperBank() {
        document.banksearchform.bankCd.value = document.frm_helper.hi_mbank.value;
        document.banksearchform.accountNo.value = document.frm_helper.hi_mbankno.value;
        document.banksearchform.submit();
    }
	
	function HelperBank_ch() {
		//document.frm_helper.bankck.value = "N";
		/*
		if ( document.frm_helper.hi_mbank.value == '<%=hi_mbank %>' && document.frm_helper.hi_mbankno.value == '<%=hi_mbankno%>' && document.frm_helper.hi_mbankname.value == '<%=hi_mbankname%>' )
		{nameCk
			document.frm_helper.bankck.value = "Y";
			document.frm_helper.banknock.value = '<%=hi_mbankno%>';
		}
		*/

		if (document.frm_helper.nameCk.value == "N") {
			alert('실명 확인이 완료되지 않았습니다.\n\n확인후 수정해 주세요');
			return;
		}

		if (document.frm_helper.hi_mbankno.value == "") {
			document.frm_helper.bankck.value = "N";	
		}

		if ( document.frm_helper.bankck.value == "Y" ) {
			if ( document.frm_helper.banknock.value == document.frm_helper.hi_mbankno.value) {
				HelperUpdate('<%=sType %>','<%=sValue %>','<%=code %>');
			}
			else {
				alert('인증계좌번호와 입력된 계좌번호가 일치하지 않습니다\n\n확인후 등록해 주세요');	
			}						
		} else {
			alert('계좌 인증이 완료되지 않았습니다\n\n확인후 등록해 주세요');
		}
	}

	function requestNameCheck() {
		var name = $("#hi_mname").val();
		var jumin = ($("#hi_mjumin1").val() + $("#hi_mjumin2").val()).trim();
		console.log(name+", " + jumin); 
		if($("#nameCk").val() === 'Y') {
			alert('이미 실명인증되었습니다.');
			return;
		}

		if(isEmpty(name) || isEmpty(jumin) ) {
			alert("사원명 또는 주민등록번호를 확인해주세요");
			return;
		}

		
		$.ajax({
			type: "POST", 
			cache: false, 
			async: false,
			contentType: "application/x-www-form-urlencoded;charset=UTF-8",
			url: "/reception/name_check_ajax.asp",
			data: { name: name, jumin: jumin }, 
			success: function (data) { 
				var check = data.trim();
				if(check == "true") {
					$("#nameCk").val("Y");
					alert('실명인증된 주민번호입니다. 계속 진행해주세요.');
					return;
				}
			},
			error: function (error) {
				console.log(error);
			}
		});
		
		if($("#nameCk").val() == 'N') {
			$.ajax({
				type: "POST", 
				cache: false, 
				async: false,
				contentType: "application/x-www-form-urlencoded;charset=UTF-8",
				url: "https://api.apluslife.co.kr/api/nice/name_check",
				data: { name: name, jumin: jumin }, 
				success: function (data) { 
					var result_cd = data.result_cd;
					//console.log(result_cd);
					if(result_cd === '1' || result_cd === '3') {
						$("#nameCk").val("Y");
						alert('실명확인 되었습니다.');
					} else {
						alert('다시 한번 확인해주십시오. [' + data.result_msg  + ']');
					}
				},
				error: function (error) {
					console.log(error);
				}
			});
		}
	}
</script>

<div class="btm_btns">
		<a href="javascript:void(0);" onclick="HelperBank_ch();" class="btn_ty btn_b">도우미 수정</a>
</div>	

<script>
	document.getElementById("hi_mgubun").value = "<%=hi_mgubun %>";
	document.getElementById("hi_mbank").value = "<%=hi_mbank %>";
</script>