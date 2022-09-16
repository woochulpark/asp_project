<!--// Gate & Login 상단 -->
<script type="text/javascript">
	$(function(){
		function SecHt(){
			var Dh = $(document).innerHeight();
			$(".gate_sec").css("height", Dh);
			$(".login_sec").css("height", Dh);
		}

		$(window).load(function(){
			SecHt();
		});

		$(window).resize(function(){
			SecHt();
		});
	});
</script>

<dl class="top_gl">
	<dt><a href="javascript:void(0);">A+라이프</a></dt>
	<dd>
		<a href="http://www.apluslife.co.kr" target="_blank"><span>에이플러스라이프</span></a>
		<a href="http://www.hyodamlifecare.co.kr/" target="_blank"><span>A+효담라이프케어<br>(어르신 돌봄서비스)</span></a>
        <!--<a href="intent://addshortcut?url=https://hs.apluslife.co.kr&amp;icon=https://hs.apluslife.co.kr/images/iicon_and.png&amp;title=A&dagger;라이프 의전관리시스템&oq=%ED%8C%A8%EC%85%98%ED%92%80&amp;serviceCode=sports&amp;version=7#Intent;scheme=naversearchapp;action=android.intent.action.VIEW;category=android.intent.category.BROWSABLE;package=com.nhn.android.search;end" onclick="nclk(this,'fot.shorcut','','',event);" class="u_sc"><span>바로가기 다운로드</span></a>-->
	</dd>    
</dl><!--// top_gl -->