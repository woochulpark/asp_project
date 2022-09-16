<!--#include virtual="/common/header.asp"-->
<!--#include virtual="/common/session_check.asp"-->

<%	
	menu = "통계"

	sDate = request("sDate")
	eDate = request("eDate")
	sType1 = request("sType1")
	sType2 = request("sType2")

	If user_type = "b" Then
		sType1 = user_bunbu
	End If

	mDate = DateAdd("m",-1*user_boardmax,date())

	ToYear = Year(Date)
	ToMonth = Month(Date)
	FirstDay = DateSerial(ToYear, ToMonth, 1 )

	if sDate = "" then
		sDate = FirstDay
	end if
	if eDate = "" then
		eDate = date()		
	end if

	eDate2 = DateAdd("d",1,eDate)	

	SQL = " EXEC p_통계 '"& sDate &"', '"& eDate &"', '"& sType1 &"', '"& sType2 &"' "	

	SQL2 = " select 본부 "
	SQL2 = SQL2 & " from 행사마스터 a (nolock) "
	SQL2 = SQL2 & " where 본부 is not null "
	SQL2 = SQL2 & " and left(행사시작일시,8) between '"& replace(sDate,"-","") &"' and '"& replace(eDate,"-","") &"' "

	If user_type = "b" Then
		SQL2 = SQL2 & " and a.본부 = '"& user_bunbu &"' "
	End If
	
	SQL2 = SQL2 & " group by 본부 "
	SQL2 = SQL2 & " order by 본부 asc "

	SQL3 = " select distinct a.단체코드, a.단체명 "
	SQL3 = SQL3 & " from 행사단체 a (nolock) "
	SQL3 = SQL3 & " inner join 행사마스터 b (nolock) on a.단체코드 = b.행사단체 "
	SQL3 = SQL3 & " where left(b.행사시작일시,8) between '"& replace(sDate,"-","") &"' and '"& replace(eDate,"-","") &"' "
	If user_type = "b" Then
		SQL3 = SQL3 & " and b.본부 = '"& user_bunbu &"' "
	End If	
	SQL3 = SQL3 & " order by a.단체명 asc "

	Set ConnAplus = CreateObject("ADODB.Connection")
	ConnAplus.Open CONN_OBJ		
		
	Set Rs = ConnAplus.execute(SQL)

	If Rs.EOF Then
		
	Else
		a1	 = Rs("빈소1시간이내")
		a2	 = Rs("빈소1.5시간이내")
		a3	 = Rs("빈소2시간이내")
		a4	 = Rs("빈소3시간이내")
		a5	 = Rs("빈소3시간이후")
		b1	 = Rs("용품1시간이내")
		b2	 = Rs("용품1.5시간이내")
		b3	 = Rs("용품2시간이내")
		b4	 = Rs("용품3시간이내")
		b5	 = Rs("용품3시간이후")
		c1	 = Rs("화환1시간이내")
		c2	 = Rs("화환1.5시간이내")
		c3	 = Rs("화환2시간이내")
		c4	 = Rs("화환3시간이내")
		c5	 = Rs("화환3시간이후")
		d1	 = Rs("근조기1시간이내")
		d2	 = Rs("근조기1.5시간이내")
		d3	 = Rs("근조기2시간이내")
		d4	 = Rs("근조기3시간이내")
		d5	 = Rs("근조기3시간이후")
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

	Rs.Close
	Set Rs = Nothing
	ConnAplus.Close
	Set ConnAplus = Nothing	

	stype1_option = "<option value=''>본부선택</option>"
	stype2_option = "<option value=''>단체선택</option>"

	if rc = 0 then
	else
		for i=0 to UBound(arrObj,2)
			sType1_name	= arrObj(0,i)
			stype1_option = stype1_option & "<option value='"& sType1_name &"' "
			If sType1 = sType1_name Then 
				stype1_option = stype1_option & " selected "	
			End if 
			stype1_option = stype1_option & " >"& sType1_name &"</option>"
		next
	end if

	if rc2 = 0 then
	else
		for i=0 to UBound(arrObj2,2)
			sType2_code	= arrObj2(0,i)
			sType2_name	= arrObj2(1,i)
			stype2_option = stype2_option & "<option value='"& sType2_code &"' "
			If sType2 = sType2_code Then 
				stype2_option = stype2_option & " selected "	
			End if			
			stype2_option = stype2_option & " >"& sType2_name &"</option>"
		next
	end if

	a0 = a1 + a2 + a3 + a4 + a5
	b0 = b1 + b2 + b3 + b4 + b5
	c0 = c1 + c2 + c3 + c4 + c5
	d0 = d1 + d2 + d3 + d4 + d5

	if a0 > 0 then
		a1_1 = FormatNumber(a1/a0*100,1)
		a2_1 = FormatNumber(a2/a0*100,1)
		a3_1 = FormatNumber(a3/a0*100,1)
		a4_1 = FormatNumber(a4/a0*100,1)
		a5_1 = FormatNumber(a5/a0*100,1)
	else
		a1_1 = "0.0"
		a2_1 = "0.0"
		a3_1 = "0.0"
		a4_1 = "0.0"
		a5_1 = "0.0"
	end if

	if b0 > 0 then
		b1_1 = FormatNumber(b1/b0*100,1)
		b2_1 = FormatNumber(b2/b0*100,1)
		b3_1 = FormatNumber(b3/b0*100,1)
		b4_1 = FormatNumber(b4/b0*100,1)
		b5_1 = FormatNumber(b5/b0*100,1)
	else
		b1_1 = "0.0"
		b2_1 = "0.0"
		b3_1 = "0.0"
		b4_1 = "0.0"
		b5_1 = "0.0"
	end if

	if c0 > 0 then
		c1_1 = FormatNumber(c1/c0*100,1)
		c2_1 = FormatNumber(c2/c0*100,1)
		c3_1 = FormatNumber(c3/c0*100,1)
		c4_1 = FormatNumber(c4/c0*100,1)
		c5_1 = FormatNumber(c5/c0*100,1)
	else
		c1_1 = "0.0"
		c2_1 = "0.0"
		c3_1 = "0.0"
		c4_1 = "0.0"
		c5_1 = "0.0"
	end if
	
	if d0 > 0 then	
		d1_1 = FormatNumber(d1/d0*100,1)
		d2_1 = FormatNumber(d2/d0*100,1)
		d3_1 = FormatNumber(d3/d0*100,1)
		d4_1 = FormatNumber(d4/d0*100,1)
		d5_1 = FormatNumber(d5/d0*100,1)
	else
		d1_1 = "0.0"
		d2_1 = "0.0"
		d3_1 = "0.0"
		d4_1 = "0.0"
		d5_1 = "0.0"
	end if
%>

<div class="sub_wrap">
	<!--#include virtual="/common/top_sub.asp"-->
	<!--#include virtual="/common/menu.asp"-->
	<form name="frm" method="post" action="statis.asp">

	<div class="search_box">
		<ul class="sch_form">
			<li class="ty01">
				<span class="dp_box"><input type="text" id="sDate" name="sDate" value="<%=sDate %>" class="datepicker input_ty start-date w100" placeholder="접수일" readonly ></span> ~ 
				<span class="dp_box"><input type="text" id="eDate" name="eDate" value="<%=eDate %>" class="datepicker input_ty end-date w100" placeholder="접수일" readonly ></span>
			</li>
			<li class="ty02">
				<select name="sType1" id="sType1" class="select_ty">
					<%=stype1_option %>
				</select>
				<select name="sType2" id="sType2" class="select_ty">
					<%=stype2_option %>
				</select>
			</li>
		</ul>
		<a href="javascript:search();" class="btn_search">검색</a>
	</div><!--// search_box -->

	</form>

	<p class="sub_tit st_ico sti01 mt">빈소도착</p>
	<table class="table_ty">
		<caption>빈소도착</caption>
		<colgroup>
			<col span="1" class="verti_w02"><col span="5" style="width:*%;">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">발생건수</th>
				<th scope="col">1시간<br>이내</th>
				<th scope="col">1.5시간<br>이내</th>
				<th scope="col">2시간<br>이내</th>
				<th scope="col">3시간<br>이내</th>
				<th scope="col">3시간<br>이후</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="ht03"><%=a0 %></td>
				<td><%=a1 %></td>
				<td><%=a2 %></td>
				<td><%=a3 %></td>
				<td><%=a4 %></td>
				<td><%=a5 %></td>
			</tr>
			<tr>
				<td class="bg01 ht02">점유율(%)</td>
				<td><%=a1_1 %></td>
				<td><%=a2_1 %></td>
				<td><%=a3_1 %></td>
				<td><%=a4_1 %></td>
				<td><%=a5_1 %></td>
			</tr>
		</tbody>
	</table>

	<p class="sub_tit st_ico sti02 mt">용품도착</p>
	<table class="table_ty">
		<caption>용품도착</caption>
		<colgroup>
			<col span="1" class="verti_w02"><col span="5" style="width:*%;">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">발생건수</th>
				<th scope="col">1시간<br>이내</th>
				<th scope="col">1.5시간<br>이내</th>
				<th scope="col">2시간<br>이내</th>
				<th scope="col">3시간<br>이내</th>
				<th scope="col">3시간<br>이후</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="ht03"><%=b0 %></td>
				<td><%=b1 %></td>
				<td><%=b2 %></td>
				<td><%=b3 %></td>
				<td><%=b4 %></td>
				<td><%=b5 %></td>
			</tr>
			<tr>
				<td class="bg01 ht02">점유율(%)</td>
				<td><%=b1_1 %></td>
				<td><%=b2_1 %></td>
				<td><%=b3_1 %></td>
				<td><%=b4_1 %></td>
				<td><%=b5_1 %></td>
			</tr>
		</tbody>
	</table>

	<p class="sub_tit st_ico sti03 mt">화환도착</p>
	<table class="table_ty">
		<caption>화환도착</caption>
		<colgroup>
			<col span="1" class="verti_w02"><col span="5" style="width:*%;">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">발생건수</th>
				<th scope="col">1시간<br>이내</th>
				<th scope="col">1.5시간<br>이내</th>
				<th scope="col">2시간<br>이내</th>
				<th scope="col">3시간<br>이내</th>
				<th scope="col">3시간<br>이후</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="ht03"><%=c0 %></td>
				<td><%=c1 %></td>
				<td><%=c2 %></td>
				<td><%=c3 %></td>
				<td><%=c4 %></td>
				<td><%=c5 %></td>
			</tr>
			<tr>
				<td class="bg01 ht02">점유율(%)</td>
				<td><%=c1_1 %></td>
				<td><%=c2_1 %></td>
				<td><%=c3_1 %></td>
				<td><%=c4_1 %></td>
				<td><%=c5_1 %></td>
			</tr>
		</tbody>
	</table>

	<p class="sub_tit st_ico sti04 mt">근조기설치</p>
	<table class="table_ty">
		<caption>근조기설치</caption>
		<colgroup>
			<col span="1" class="verti_w02"><col span="5" style="width:*%;">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">발생건수</th>
				<th scope="col">1시간<br>이내</th>
				<th scope="col">1.5시간<br>이내</th>
				<th scope="col">2시간<br>이내</th>
				<th scope="col">3시간<br>이내</th>
				<th scope="col">3시간<br>이후</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="ht03"><%=d0 %></td>
				<td><%=d1 %></td>
				<td><%=d2 %></td>
				<td><%=d3 %></td>
				<td><%=d4 %></td>
				<td><%=d5 %></td>
			</tr>
			<tr>
				<td class="bg01 ht02">점유율(%)</td>
				<td><%=d1_1 %></td>
				<td><%=d2_1 %></td>
				<td><%=d3_1 %></td>
				<td><%=d4_1 %></td>
				<td><%=d5_1 %></td>
			</tr>
		</tbody>
	</table>


</div><!--// sub_wrap -->

<!--#include virtual="/common/footer.asp"-->

<script language="javascript" type="text/javascript">
	function search() {
		var frm = document.frm;		
		frm.submit();
	}	
</script>
<% if user_type = "a" then %>
<script language="javascript" type="text/javascript">
	document.getElementById("sType1").value = "<%=sType1 %>"
	document.getElementById("sType2").value = "<%=sType2 %>"
</script>
<% end if %>