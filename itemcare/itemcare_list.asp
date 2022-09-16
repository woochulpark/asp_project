<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%	
	menu = "재고관리"
	
    search = request("search")

	page = request("page")
	sPage = 10
	
	sTypeA = request("sTypeA")
	sTypeB = request("sTypeB")	
	sTypeD = request("sTypeD")

	if page = "" then
		page = 1
	end if	

    if search = "Y" then 

        SQL		= " exec P_재고관리_현재_페이징 '"& user_typeame &"', '"& sTypeD &"', '"& sTypeA &"', '"& sTypeB &"', '"& ((page - 1) * sPage) + 1 &"', '"& page * sPage &"' "
        SQL_CNT = " exec P_재고관리_현재_페이징_카운트 '"& user_typeame &"', '"& sTypeD &"', '"& sTypeA &"', '"& sTypeB &"' "

        Set ConnAplus = CreateObject("ADODB.Connection")
        ConnAplus.Open CONN_OBJ	

        Set Rs = ConnAplus.execute(SQL_CNT)

        tCnt = Rs("count")	
            
        Set Rs = ConnAplus.execute(SQL)

        If Rs.EOF Then
            rc = 0		
        Else
            rc = Rs.RecordCount
            arrObj = Rs.GetRows(sPage)		
        End If	

        Rs.Close
        Set Rs = Nothing
        ConnAplus.Close
        Set ConnAplus = Nothing		
    
    else
        rc = 0
    end if
	
	'response.Write SQL & "<br>" & SQL_CNT
%>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->

	<form name="frm" method="post" action="itemcare_list.asp">
	<input type="hidden" id="page" name="page" value="<%=page %>" />
    <input type="hidden" id="search" name="search" value="<%=search %>" />

	<div class="search_box">
		<ul class="sch_form">
			<li class="ty02">
				<span id="categorya"></span>
				<span id="categoryb"></span>
			</li>
			<%	if user_type = "a" then %>
			<li class="ty02">
				<span id="categoryd"></span>
			</li>
			<%	end if %>
		</ul>
		<a href="javascript:search();" class="btn_search">검색</a>
	</div><!--// search_box -->

	</form>
<%	if user_type = "a" then %>
	<table class="list_ty">
		<caption>재고관리(임직원) 리스트</caption>
		<colgroup>
			<col span="1" class="list_w01"><col span="2" class="list_w02"><col span="1" class="list_w00"><col span="1" class="list_w02"><col span="1" class="list_w01">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">본부</th>
				<th scope="col">상품코드</th>
				<th scope="col">대분류</th>
				<th scope="col">중분류</th>
				<th scope="col">소분류</th>
				<th scope="col">재고</th>
			</tr>
		</thead>
		<tbody>
<%
		if rc = 0 then 
%>						
			<tr><td colspan="6">일치하는 검색결과가 없습니다.</td></tr>
<%
		else
			for i=0 to UBound(arrObj,2)
				Code		= arrObj(3,i)
				Catecory1	= arrObj(4,i)
				Catecory2	= arrObj(5,i)
				Catecory3	= arrObj(6,i)
				count		= arrObj(7,i)
				bonbu		= arrObj(1,i)			
%>
			<tr>
				<td><%=bonbu %></td>
				<td><%=Code %></td>
				<td><%=Catecory1 %></td>
				<td><%=Catecory2 %></td>
				<td><%=Catecory3 %></td>
				<td><%=count %></td>
			</tr>		
<%
			next
		end if 
%>			
		</tbody>
	</table><!--// list_ty -->
<%	else %>
	<table class="list_ty">
		<caption>재고관리(의전팀장) 리스트</caption>
		<colgroup>
			<col span="2" class="list_w02"><col span="1" class="list_w00"><col span="1" class="list_w02"><col span="1" class="list_w01">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">상품코드</th>
				<th scope="col">대분류</th>
				<th scope="col">중분류</th>
				<th scope="col">소분류</th>
				<th scope="col">재고</th>
			</tr>
		</thead>
		<tbody>
<%
		if rc = 0 then 
%>						
						<tr><td colspan="5">등록된 상품이 없습니다.</td></tr>
<%
		else
			for i=0 to UBound(arrObj,2)
				Code		= arrObj(3,i)
				Catecory1	= arrObj(4,i)
				Catecory2	= arrObj(5,i)
				Catecory3	= arrObj(6,i)
				count		= arrObj(7,i)
%>
			<tr>						
				<td><%=Code %></td>
				<td><%=Catecory1 %></td>
				<td><%=Catecory2 %></td>
				<td><%=Catecory3 %></td>
				<td><%=count %></td>
			</tr>		
<%
			next
		end if 	
%>
			</tr>
		</tbody>
	</table><!--// list_ty -->
<%	end if %>
	<div class="paging" id="Paging"></div>

</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->

<script type="text/javascript" language="javascript" src="/js/paging.js"></script>	
<script language="javascript" type="text/javascript">
	function search() {
		var frm = document.frm;
        frm.page.value = "1";
        frm.search.value = "Y";
		frm.submit();
	}
	function goPage(page) {
		var frm = document.frm;
		frm.page.value = page;
		frm.submit();
	}
	function CategoryChange(type, categorya, categoryb, categoryc, categoryd) {

		$.ajax({
			type: "POST", //데이터 전송타입 (POST,GET)
			cache: false, //캐시 사용여부(true,false)
			url: "itemcare_category" + type + "_ajax.asp", //요청을 보낼 서버의 URL
			data: { categorya: categorya, categoryb: categoryb, categoryc: categoryc, categoryd: categoryd }, //서버로 보내지는 데이터
			datatype: "html", //응답 결과의 형태 (xml,html,script,json,jsonp,text)
			success: function (data, textStatus) { //응답객체 data:응답 결과, textStatus:성공여부 (성공일 경우만 success 문자열로 입력)					
				$("#category" + type).html("");
				$("#category" + type).html(data);

				if (type == "a") {
					document.getElementById("sTypeA").value = categorya;
				} else if (type == "b") {
					document.getElementById("sTypeB").value = categoryb;
				} else if (type == "d") {
					document.getElementById("sTypeD").value = categoryd;
				}
			}
		});
	}

	CategoryChange("a", "<%=sTypeA %>", '', '');
	CategoryChange("b", "<%=sTypeA %>", "<%=sTypeB %>", '');
	//CategoryChange("c", "", "<%=sTypeB %>", "<%=sTypeC %>");
</script>
<%	if user_type = "a" then %>
<script language="javascript" type="text/javascript">
	CategoryChange("d", "", "", "", "<%=sTypeD %>");
</script>
<%	end if %>
<% if rc <> 0 then %>
<script language="javascript" type="text/javascript">
<!--
	GSGAdminPaging("<%=tCnt %>", "<%=sPage %>", "<%=page %>", "goPage")
//-->
</script>
<% end if %>