<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>
<!--#include virtual="/common/session_check.asp"-->

<%	
	dim sValue
	sValue = request("sValue")	
	sType = request("sType")	

	SQL = " select 대표명칭 from 공용코드 where 대표코드 =  '00255' "	
	SQL2 = " select 은행코드,은행명 from 은행코드 where 사용구분 =  'Y' "		

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

	<form name="frm_helper" id="Form1">
<% if sType = "" then %>
	<input type="hidden" id="popup_check_ag" value="HelperList" />
<% else %>
	<input type="hidden" id="popup_check_ag" value="HelperList3" />
<% end if %>
	<input type="hidden" id="sType_popup" value="<%=sType %>" />
	<input type="hidden" id="sValue_popup" value="<%=sValue %>" />
	<input type="hidden" name="juminCk" value='N' />
	<input type="hidden" name="nameCk" value='N' />
	<input type="hidden" name="bankValid" id="bankValid" value='N' />
	<input type="hidden" name="bankName" id="bankName" />
	<input type="hidden" name="bankck" id="bankck" />
	<input type="hidden" name="banknock" id="banknock" />

	<table class="form_ty no_l">
		<caption>도우미 신규등록</caption>
		<colgroup>
			<col span="1" class="verti_w01"><col span="1" style="width:*%;">
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">도우미구분</th>	
				<td>
					<select name="hi_mgubun" class="select_ty w100">
						<%=gubun_list %>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">도우미명</th>
				<td><input type="text" name="hi_mname" class="input_ty w100" onKeyup="this.value=this.value.replace(/[^\w\sㄱ-힣]|[\_]/g,'');" onChange="juminck_flag();"></td>
			</tr>
			<tr>
				<th scope="row">
					주민번호
				</th>
				<td><input type="text" name="hi_mjumin1" maxlength="6" class="input_ty w_c50" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" onchange='juminck_flag();'> - <input type="text" name="hi_mjumin2" maxlength="7" class="input_ty w_c50" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" onchange='juminck_flag();'>
				<button id='juminCheckBtn' type="button" onclick='juminCheck($(this));' class="btn_ty ty02 de_txt" style="display: inline; height:33px;">중복확인</button>
				<button id='niceNameCheck' type="button" onclick="requestNameCheck();" class="btn_ty ty02 de_txt" style="display: inline; height:33px;">실명확인</button>
				</td>
			</tr>
			<tr>
				<th scope="row">연락처</th>
				<td><input type="text" name="hi_mphone" class="input_ty w100" placeholder="숫자만 입력해주세요." onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"></td>
			</tr>
			<tr>
				<th scope="row">은행</th>
				<td>
					<select name="hi_mbank" class="select_ty w100">
						<%=bank_list %>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">계좌번호 <a href="javascript:void(0);" onclick='HelperBank($(this));' class="btn_ico ty02 ico01">검색</a> </th>
				<td><input name="hi_mbankno" type="text" class="input_ty w100" placeholder="숫자만 입력해주세요." onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"></td>
			</tr>
			<tr>
				<th scope="row">예금주명</th>
				<td><input name="hi_mbankname" type="text" class="input_ty w100" placeholder="계좌인증을 진행해 주세요." readOnly></td>
			</tr>
			<tr>
				<th scope="row" style="height: 100px;">메모</th>
				<td><textarea placeholder="최대 50자까지 입력가능합니다." name="hi_memo" onKeyup="textareaCheck();" style="height: 100px;" class="input_ty w100" ></textarea></td>
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

<form name="juminsearchform" method="post" target="jumin_search_frame" action="/reception/reception_helper_write_jumin_ok.asp">
<input type="hidden" name="name" />
<input type="hidden" name="jumin_1" value="test" />
<input type="hidden" name="jumin_2" />
</form>
<iframe src="" name="jumin_search_frame" style="display:none;" width=500 height=500></iframe>
<script>
	// Null 값 확인
	var isEmpty = function(value){
		if( value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length ) ){
			return true  
		}else{
			return false
		}  
	};

	function textareaCheck() {
		var textarea = document.frm_helper.hi_memo;
		if(textarea.value.length > 50) {
			alert("최대 50자까지 입력가능합니다.")
			textarea.value = textarea.value.substring(0, 51);
			textarea.focus();
		}
	}

    //bank_ck();

	// 주민번호 수정시 주민번호 확인 초기화
	function juminck_flag() {
		document.frm_helper.juminCk.value = "N";
		document.frm_helper.nameCk.value = "N";
		$("#niceNameCheck").attr("disabled", false);
	}

    // 계좌조회
    function HelperBank() {
        document.banksearchform.bankCd.value = document.frm_helper.hi_mbank.value;
        document.banksearchform.accountNo.value = document.frm_helper.hi_mbankno.value;
        document.banksearchform.submit();
    }

	// 주민번호 조회
	function juminCheck() {
		var checkjumin1 = document.frm_helper.hi_mjumin1.value;
		var checkjumin2 = document.frm_helper.hi_mjumin2.value;

		if(checkjumin1.length < 6 || checkjumin2.length < 7) {
			alert('정확한 주민등록번호를 입력해 주세요.\n\n확인후 등록해 주세요');
			return;
		}

		document.juminsearchform.name.value = document.frm_helper.hi_mname.value;
		document.juminsearchform.jumin_1.value = checkjumin1
		document.juminsearchform.jumin_2.value = checkjumin2;
        document.juminsearchform.submit();
	}

	function juminCheck_ch() {
		if(document.frm_helper.juminCk.value == "N") {
			alert('주민등록번호 확인이 완료되지 않았습니다.\n\n확인후 등록해 주세요');
		} else if(document.frm_helper.nameCk.value == "N") {
			alert('실명 확인이 완료되지 않았습니다.\n\n확인후 등록해 주세요');
		} else {
			HelperBank_ch();
		}
	}
	
	function HelperBank_ch() {
		
		if ( document.frm_helper.bankck.value == "Y" )
		{
			if ( document.frm_helper.banknock.value == document.frm_helper.hi_mbankno.value )
			{
				HelperInsert('<%=sType %>','<%=sValue %>','<%=code %>');
			}
			else {
				alert('인증계좌번호와 입력된 계좌번호가 일치하지 않습니다\n\n확인후 등록해 주세요');	
			}						
		}
		else {
			alert('계좌 인증이 완료되지 않았습니다\n\n확인후 등록해 주세요');
		}
	}

	function requestNameCheck() {
		var form = document.frm_helper;
		if(form.juminCk.value === 'N') {
			alert('중복체크 먼저 진행해 주세요.');
			return;
		}

		if(form.nameCk.value === 'Y') {
			alert('이미 실명인증되었습니다.');
			return;
		}

		var name = (form.hi_mname.value).trim();
		var jumin = (form.hi_mjumin1.value + frm_helper.hi_mjumin2.value).trim();

		if(isEmpty(name) || isEmpty(jumin) ) {
			alert("사원명 또는 주민등록번호를 입력해주세요");
			return;
		}

		$.ajax({
			type: "POST", 
			cache: false, 
			async: false,
			contentType: "application/x-www-form-urlencoded;charset=UTF-8",
			url: "https://api.apluslife.co.kr/api/nice/name_check",
			data: { name: form.hi_mname.value, jumin: jumin }, 
			success: function (data) { 
				var result_cd = data.result_cd;
				if(result_cd === '1' || result_cd === '3' || result_cd === '7') {
					form.nameCk.value = 'Y';
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
</script>

<div class="btm_btns">
	<a href="javascript:void(0);" onclick="juminCheck_ch();" class="btn_ty btn_b">도우미 등록</a>
</div>