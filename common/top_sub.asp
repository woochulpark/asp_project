<!--// Sub 상단 -->
<script src="/js/datepicker.js"></script>
<link rel="stylesheet" href="/css/datepicker.css">

<div class="stop_sec">
<%	if user_id <> "" then %>
	<a href="javascript:void(0);" onclick="window.history.back();" class="btn_hisbk">이전으로</a>
	<p class="pg_title"><%=menu %></p>
<% else %>
	<p class="pg_title full"><%=menu %></p>
<%	end if %>
	
</div><!--// stop_sec -->