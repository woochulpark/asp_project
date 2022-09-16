tinyMCE.init({
	//실제 textarea의 class명
	editor_selector : "editor_holder",  
	// General options
	mode : "textareas",
	theme : "advanced", 
	language : "ko",
	plugins : "safari,noneditable,advimage,fullpage",
	theme_advanced_path : false,
	//IE에서 한글입력 문제 해결을 위해서
	forced_root_block : false, 
	//에디터 너비 높이 설정
	//height : "330",
	//width : "830",
	
	// Theme options
	/*
	이건 각 버튼 영역이다 위의 그림을 보면 맨위에서부터 각각의 버튼 영역이 있다. 소스를 다운받으면 전체 버튼이 나오게 되는데
	그중 간단히 쓸것만 아래처럼 변경한것임. 
	샘플 그대로 사용해서 그중 자기가 필요한거를 넣거나 빼면된다.
	에디터상에 특정 아이콘을 이용해서 꾸미고싶다면. 아래 imagepop 을 참조해서 파일업로드해서 에디터에 넣는것을 추가했다.
	서버 특성상 각각의 파일업로드 처리 팝업을 만들었다고 가정하고 설명하겠다.  ('imagepop'은 기본에 없는 아이콘명)
	별도의 동영상이나 네이버 지도 API를 이용해서 넣거나 등등 이런경우 사용하면된다.
	*/
	 
	theme_advanced_buttons1 : "save,newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,fontselect,fontsizeselect",
	theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,imagepop,cleanup,|,insertdate,inserttime,preview,|,forecolor,backcolor",
	theme_advanced_buttons3 : "",
	theme_advanced_buttons4 : "",
	theme_advanced_toolbar_location : "top",
	theme_advanced_toolbar_align : "left",
	theme_advanced_statusbar_location : "bottom",
	theme_advanced_resizing : false,
	 
	// Example word content CSS (should be your site CSS) this one removes paragraph margins
	content_css : "/global/tiny_mce_3.5b1/css/content.css",
	 
	//에디터에 사용할 폰트 지정 
	theme_advanced_fonts : "굴림=굴림;굴림체=굴림체;궁서=궁서;궁서체=궁서체;돋움=돋움;돋움체=돋움체;바탕=바탕;바탕체=바탕체;Arial=Arial; Comic Sans MS='Comic Sans MS';Courier New='Courier New';Tahoma=Tahoma;Times New Roman='Times New Roman';Verdana=Verdana", 
	 
	// Drop lists for link/image/media/template dialogs
	template_external_list_url : "/global/tiny_mce_3.5b1/lists/template_list.js",
	external_link_list_url : "/global/tiny_mce_3.5b1/lists/link_list.js",
	external_image_list_url : "/global/tiny_mce_3.5b1/lists/image_list.js",
	media_external_list_url : "/global/tiny_mce_3.5b1/lists/media_list.js",
	  
	// Replace values for the template plugin
	template_replace_values : {
	},
	
	
	/*
	에디터 파일업로드 이미지및 스크립트 설정 
	위에서 설명한 에디터 아이콘명 추가. 사용할 아이콘명 아이콘 이미지 경로 클릭시 호출된 함수를 작성한다.
	*/
	setup : function(tinyMCE) {
		// Register youtube button
		tinyMCE.addButton('imagepop', {
			title : 'imagepop', 
			image : '/script/tiny_mce_3.5b1/image/common/ico_img.gif',
			onclick : function() {
			cmdImgUploadPop();
			}
		});
	}
});
