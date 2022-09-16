<%
	SQL = "select 상태 from 행사_승인요청 (nolock) where 행사번호 = '"& code &"' "
	SQL_2 = "select 행사상태 from 행사마스터 (nolock) where 행사번호 = '"& code &"' "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ

	Set Rs = ConnAplus.execute(SQL)

	If Rs.EOF Then
		hangsa_stat = ""
	Else		
		hangsa_stat = Rs("상태")
	End If

	Rs.Close
	Set Rs = Nothing

	Set Rs2 = ConnAplus.execute(SQL_2)

	If Rs2.EOF Then
		hangsa_stat_2 = ""
	Else		
		hangsa_stat_2 = Rs2("행사상태")
	End If

	Rs2.Close
	Set Rs2 = Nothing

	ConnAplus.Close
	Set ConnAplus = Nothing

	if menu = "접수" then
		if user_type = "a" then '임직원
			if hangsa_stat = "진행승인요청" then
				top_btn = "e"
			Elseif hangsa_stat = "진행승인확인" Then
				top_btn = "a"
			else
				top_btn = "d"
			end if
		else '의전팀장
			if hangsa_stat = "진행승인요청" then
				if top_btn_save = "Y" then
					if SignChk = "Y" then
						top_btn = "a"
					else
						top_btn = "c"
					end if				
				else
					top_btn = "a"
				end if				
			elseif hangsa_stat = "진행승인확인" then
				top_btn = "a"
			else '진행승인요청전
				if top_btn_save = "Y" then
					if SignChk = "Y" then
						if lnbtype = "Y" then
							top_btn = "a"
						else
							top_btn = "b"
						end if
					else
						if lnbtype = "Y" then
							top_btn = "c"
						else
							top_btn = "d"
						end if					
					end if
				else
					if lnbtype = "Y" then
						top_btn = "a"
					else
						top_btn = "b"
					end if				
				end if		
			end if
		end if
	elseif menu = "진행" then
		if user_type = "a" then '임직원
			'If hangsa_stat_2 = "완료" Then
			'	top_btn = "a"
			'else
				if hangsa_stat = "완료승인요청" then
					top_btn = "h"
				ElseIf hangsa_stat = "완료승인확인" Then
					top_btn = "a"
				else
					top_btn = "j"
				end If
			'End if	
		else '의전팀장
			If hangsa_stat_2 = "완료" Then
				top_btn = "a"
			else
				if hangsa_stat = "완료승인요청" then
					if top_btn_save = "Y" then				
						top_btn = "c"					
					else
						top_btn = "a"
					end if				
				elseif hangsa_stat = "완료승인확인" then
					top_btn = "a"
				else '완료승인요청전
					if top_btn_save = "Y" then				
						top_btn = "g"				
					else
						top_btn = "f"					
					end if		
				end If
			End if	
		end if
	end if
%>

<!--// 
	상단 버튼 
	① 버튼 없을때 : no_use 클래스 추가
	② 요청/확인 버튼만 1개
	③ 저장 버튼만 1개 : sort01 클래스 추가
	④ 버튼 2개 : sort02 클래스 추가
-->

<%
if top_btn = "a" then
%>
<div class="top_btns no_use"></div>
<%
elseif top_btn = "b" then
%>
<div class="top_btns">
	<a href="javascript:void(0);" class="btn_ty btn_b" onclick="Approval('<%=code %>');">진행승인요청</a>
</div>
<%
elseif top_btn = "c" then
%>
<div class="top_btns sort01">
	<a href="javascript:void(0);" class="btn_ty ty02 btn_b" onclick="Save();">저장</a>
</div>
<%
elseif top_btn = "d" then
%>
<div class="top_btns sort02">
	<a href="javascript:void(0);" class="btn_ty btn_b" onclick="Approval('<%=code %>');">진행승인요청</a>
	<a href="javascript:void(0);" class="btn_ty ty02 btn_b" onclick="Save();">저장</a>
</div>
<%
elseif top_btn = "e" then
%>

<div class="top_btns sort03">
	<a href="javascript:void(0);" class="btn_ty btn_b" onclick="ApprovalOK('<%=code %>');">진행승인확인</a>
	<a href="javascript:void(0);" class="btn_ty ty02 btn_b" onclick="Approval('<%=code %>');">진행승인요청</a>
	<a href="javascript:void(0);" class="btn_ty ty02 btn_b" onclick="Save();">저장</a>
</div>
<!--
<div class="top_btns">
	<a href="javascript:void(0);" class="btn_ty btn_b" onclick="ApprovalOK('<%=code %>');">진행승인확인</a>
</div>
<div class="top_btns sort02">
	<a href="javascript:void(0);" class="btn_ty ty02 btn_b" onclick="Approval('<%=code %>');">진행승인요청</a>
	<a href="javascript:void(0);" class="btn_ty ty02 btn_b" onclick="Save();">저장</a>
</div>
-->
<%
elseif top_btn = "f" then
%>
<div class="top_btns">
	<a href="javascript:void(0);" class="btn_ty btn_b" onclick="Complete('<%=code %>');">완료승인요청</a>
</div>
<%
elseif top_btn = "g" then
%>
<div class="top_btns sort02">
	<a href="javascript:void(0);" class="btn_ty btn_b" onclick="Complete('<%=code %>');">완료승인요청</a>
	<a href="javascript:void(0);" class="btn_ty ty02 btn_b" onclick="Save();">저장</a>
</div>
<%
elseif top_btn = "h" then
%>
<div class="top_btns sort03">
	<a href="javascript:void(0);" class="btn_ty btn_b" onclick="CompleteOK('<%=code %>');">완료승인확인</a>
	<a href="javascript:void(0);" class="btn_ty ty02 btn_b" onclick="Complete('<%=code %>');">완료승인요청</a>
	<a href="javascript:void(0);" class="btn_ty ty02 btn_b" onclick="Save();">저장</a>
</div>
<%
elseif top_btn = "j" then
%>
<div class="top_btns sort01">
	<a href="javascript:void(0);" class="btn_ty ty02 btn_b" onclick="Save();">저장</a>
</div>
<%
end if
%>