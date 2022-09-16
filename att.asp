<!doctype html>
<html lang="ko">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
		<meta name="HandheldFriendly" content="true">
		<meta name="format-detection" content="telephone=no">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title>에이플러스라이프 의전관리시스템</title>
		
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


		<style type="text/css">
			.test_wrap {padding:20px;box-sizing:border-box;}
			.det_tit {margin:20px auto;font-size:20px;font-weight:700;text-align:center;}
			.test {border:solid 1px #000;}
			.test th, .test td {border-bottom:solid 1px #000;}

			.tlt td {position:relative;margin:-1px;}
		</style>

		<div class="test_wrap">
			<p class="det_tit">No Style</p>
			<table>
				<caption></caption>
				<colgroup>
					<col span="5" style="width:*%;">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">01</th><th scope="col">02</th><th scope="col">03</th><th scope="col">04</th><th scope="col">05</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>01</td><td>02</td><td>03</td><td>04</td><td>05</td>
					</tr>
				</tbody>
			</table>

			<p class="det_tit">Only Table Border</p>
			<table class="test">
				<caption></caption>
				<colgroup>
					<col span="5" style="width:*%;">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">01</th><th scope="col">02</th><th scope="col">03</th><th scope="col">04</th><th scope="col">05</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>01</td><td></td><td>03</td><td>04</td><td>05</td>
					</tr>
					<tr>
						<td>01</td><td>02</td><td>03</td><td>04</td><td>05</td>
					</tr>
				</tbody>
			</table>

			<p class="det_tit">Table_ty</p>
			<table class="table_ty">
				<caption></caption>
				<colgroup>
					<col span="5" style="width:*%;">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">01</th><th scope="col">02</th><th scope="col">03</th><th scope="col">04</th><th scope="col">05</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>01</td><td></td><td>03</td><td>04</td><td>05</td>
					</tr>
					<tr>
						<td>01</td><td>02</td><td>03</td><td>04</td><td>05</td>
					</tr>
				</tbody>
			</table>

			<p class="det_tit">Table_ty_Verti</p>
			<table class="table_ty verti">
				<caption></caption>
				<colgroup>
					<col span="1" style="width:30%;"><col span="1" style="width:*%;">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">01</th><td>01</td>
					</tr>
					<tr>
						<th scope="row">01</th><td></td>
					</tr>
				</tbody>
			</table>

			<p class="det_tit">Form_ty_Hori</p>
			<table class="form_ty hori">
				<caption></caption>
				<colgroup>
					<col span="5" style="width:*%;">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">01</th><th scope="col">02</th><th scope="col">03</th><th scope="col">04</th><th scope="col">05</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>01</td><td>02</td><td>03</td><td>04</td><td>05</td>
					</tr>
					<tr>
						<td>01</td><td></td><td>03</td><td>04</td><td>05</td>
					</tr>
				</tbody>
			</table>

			<p class="det_tit">Form_ty</p>
			<table class="form_ty">
				<caption></caption>
				<colgroup>
					<col span="1" style="width:30%;"><col span="1" style="width:*%;">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">01</th><td>01</td>
					</tr>
					<tr>
						<th scope="row">01</th><td></td>
					</tr>
				</tbody>
			</table>

			<p class="det_tit">List_ty</p>
			<table class="list_ty">
				<caption></caption>
				<colgroup>
					<col span="5" style="width:*%;">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">01</th><th scope="col">02</th><th scope="col">03</th><th scope="col">04</th><th scope="col">05</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>01</td><td>02</td><td>03</td><td>04</td><td>05</td>
					</tr>
					<tr>
						<td>01</td><td></td><td>03</td><td>04</td><td>05</td>
					</tr>
				</tbody>
			</table>

			<p class="det_tit">List_ty_Verti</p>
			<table class="list_ty verti">
				<caption></caption>
				<colgroup>
					<col span="1" style="width:30%;"><col span="1" style="width:*%;">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">01</th><td></td>
					</tr>
					<tr>
						<th scope="row">01</th><td>01</td>
					</tr>
				</tbody>
			</table>

			<p class="det_tit">TEST List_ty</p>
			<table class="list_ty tlt">
				<caption></caption>
				<colgroup>
					<col span="5" style="width:*%;">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">01</th><th scope="col">02</th><th scope="col">03</th><th scope="col">04</th><th scope="col">05</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>01</td><td>02</td><td>03</td><td>04</td><td>05</td>
					</tr>
					<tr>
						<td>01</td><td></td><td>03</td><td>04</td><td>05</td>
					</tr>
				</tbody>
			</table>

		</div><!--// test_wrap -->


	</body>
</html>