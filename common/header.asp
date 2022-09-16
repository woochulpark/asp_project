<% @ CODEPAGE = 65001 %>
<% session.CodePage = "65001" %>
<% Response.Charset = "UTF-8" %>


<!doctype html>
<html lang="ko">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
		<meta name="HandheldFriendly" content="true">
		<meta name="format-detection" content="telephone=no">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title>A+라이프 의전시스템</title>
		
		<!--// 검색/등록 -->
		<meta name="title" content="" />
		<meta name="description" content="" />
		<meta name="keywords" content="" />

		<link rel="stylesheet" href="https://cdn.rawgit.com/theeluwin/NotoSansKR-Hestia/master/stylesheets/NotoSansKR-Hestia.css">
		<!--<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Noto+Sans+KR:400,500,700&display=swap">-->
		<script src="/js/jquery-1.11.3.min.js"></script>
		<script src="/js/jquery-ui.min.js"></script>
		<script src="/js/common.js"></script>
 
		<link rel="stylesheet" href="/css/style.css">
		<link rel="stylesheet" href="/css/media.css">
	</head>

	<body>
		<!--div class="wrap"><!--// Max 768 해상도 영역 -->
		<!--#include virtual="/common/protocol.asp"-->

	<%
		If protocol = "https://" Then
	%>
		<script>
			var httpUrl = 'http://hs.apluslife.co.kr' + '<%=Request.ServerVariables("URL")%>';
			if('<%=Request.QueryString%>' != '')
			{
				httpUrl += '?' + '<%=Request.QueryString%>'
			}
			location.replace(httpUrl);
		</script>
	<%
		End If 
	%>