<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->
<!-- #include virtual="/nice/json2.asp" -->
<%
	name = request("name")
	jumin1 = request("jumin_1")
	jumin2 = request("jumin_2")
	jumin3 = jumin1 & jumin2
	
	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	SQL = "select 사원명, 주민번호 "
	SQL = SQL & "from 행사사원마스터 "
	SQL = SQL & "where 주민번호 = '" & jumin3 &"' and 활성 = 'Y'"

	Set rs = ConnAplus.execute(SQL)
	
	' 데이터 존재 유무
	' rs.bof Or rs.eof ==> 데이터 없음
	' 데이터 있다면 false
	If rs.bof Or rs.eof Then        
	    check = "true"
    Else
		overlapName = rs("사원명")
		check = "false"
	End If

	SQL_NAME = "select * "
	SQL_NAME = SQL_NAME & "from 개인실명확인이력 "
	SQL_NAME = SQL_NAME & "where 주민번호 = '" & jumin3 & "' and 이름 = '" & name & "' and 결과코드 in ('1', '3') "
	
	Set rs_name = ConnAplus.execute(SQL_NAME)

	' 데이터 존재 == 실명확인 인증됨
	' bof Or eof 면 데이터가 없다 = 실명확인이 되지 않음
	If rs_name.bof Or rs_name.eof Then        
		nameCheck = "false"
    Else
	    nameCheck = "true"
	End If

	ConnAplus.Close
	Set ConnAplus = Nothing	

%>

<script>
	function check_jumin() {	
		var flag = true;
		var msg = '이미 등록된 도우미입니다. 등록이 불가능합니다. \n\n';
		if('<%=check%>'!= 'true'){
			msg += '중복된 도우미명: <%=overlapName %>';
			alert(msg);
			flag = false;
		}
		
		if(flag) {
			parent.document.frm_helper.juminCk.value = 'Y';

			var msg = '등록 가능한 주민번호입니다. \n\n';
			if('<%= nameCheck %>' === 'true'){
//				console.log('<%=nameCheck%>');
				parent.document.frm_helper.nameCk.value = 'Y';
				parent.document.getElementById('niceNameCheck').disabled = true;
				msg = msg + '해당 도우미은 실명확인되었습니다.';
			} else {
				msg = msg + '실명확인 되지 않았습니다. 실명확인을 해 주십시오.';
			}
			alert(msg);
		}
	}

	check_jumin();

</script>