<%@ CODEPAGE = 949 %>

<%

Response.CharSet="euc-kr"
Session.codepage="949"
Response.codepage="949"

%> 

<%
	Function URLDecode(Expression)
		Dim strSource, strTemp, strResult, strchr
		Dim lngPos, AddNum, IFKor

		strSource = Replace(Expression, "+", " ") 

		For lngPos = 1 To Len(strSource)    
			AddNum  = 2
			strTemp = Mid(strSource, lngPos, 1)        
			If strTemp = "%" Then 
				If lngPos + AddNum < Len(strSource) + 1 Then  
					strchr = CInt("&H" & Mid(strSource, lngPos + 1, AddNum))
					
					If strchr > 130 Then
						AddNum = 5
						IFKor = Mid(strSource, lngPos + 1, AddNum)
						IFKor = Replace(IFKor, "%", "")
						strchr = CInt("&H" & IFKor )
					End If

					strResult = strResult & Chr(strchr)
					lngPos    = lngPos + AddNum
				End If
			Else
				strResult = strResult & strTemp
			End If
		Next

		URLDecode = strResult
	End Function

	bankname = request("bankname")
	account = request("accountNo")
	account_Name = request("accountName")
	resp_Cd = request("respCd")
	'ret_msg = URLDecode(request("ret_msg"))
	company_Name = request("company_Name")
	RETURN_PAGE_URL = request("RETURN_PAGE_URL")
	realName = request("realName")

	response.write "����� : " & bankname & "<br><br>"
	response.write "���¹�ȣ : " & account & "<br><br>"
	response.write "�����ָ� : " & account_Name & "<br><br>"
	response.write "����ڵ� : " & resp_Cd & "<br><br>"
	'response.write "company_Name=" & company_Name & "<br><br>"
	'response.write "RETURN_PAGE_URL=" & RETURN_PAGE_URL & "<br><br>"
	'response.write "realName=" & realName & "<br><br>"
	response.write "��� �޽��� : " & request("ret_msg") & "<br><br>"

%>

<script>

	function writeBankInfo() {
		parent.document.frm_helper.bankck.value = 'Y';
		parent.document.frm_helper.banknock.value = '<%=trim(account)%>';
		parent.document.frm_helper.bankName.value = '<%=trim(account_Name)%>';
		parent.document.frm_helper.hi_mbankname.value = '<%=trim(account_Name)%>';
		parent.document.frm_helper.bankValid.value = 'Y';
	}
	
	if('<%=resp_Cd%>'!='0000'){
		alert('��ȿ�� ���¹�ȣ�� �ƴմϴ�');
		//alert('<%=bankname%>');
		//alert('<%=ret_msg%>');
		parent.document.frm_helper.bankck.value = 'S';
	}
	else {
		//alert('���¹�ȣ�� Ȯ�εǾ����ϴ�\n\n�����ָ� : <%=trim(account_Name)%>');
		//alert('<%=bankname%>');	
		//alert('<%=ret_msg%>');
		if ( parent.document.frm_helper.hi_mbankname.value == '<%=trim(account_Name)%>' || parent.document.frm_helper.hi_mbankname.value == '' )
		{
			alert('���¹�ȣ�� Ȯ�εǾ����ϴ�\n\n�����ָ� : <%=trim(account_Name)%>\n\n���¹�ȣ : <%=trim(account)%>');
			writeBankInfo();
		}
		else {
		    var confirm = confirm('���¹�ȣ�� Ȯ�εǾ����ϴ�\n\n�����ָ��� �ٸ��ϴ�.\n\n�����ָ� : <%=trim(account_Name)%>\n\n �ٲٽðڽ��ϱ�?');
			if(confirm) {
				writeBankInfo()
			} else {
				parent.document.frm_helper.bankck.value = 'S';
			}
		}
		//parent.document.form.bank_account.value = '<%=trim(account_Name)%>';
	}


</script>