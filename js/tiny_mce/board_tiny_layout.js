	tinyMCE.init({   
		language:"ko",
		//mode: "exact",
		//elements: "<%=TxtContent.ClientID%>",
		
		mode: "textareas",
		editor_selector : "editor_holder2",
		  
        // 엔터시 br 버그있음 개행시 커서는 넘어가나 마우스포인터가 남아있다  
		force_br_newlines: false,
		force_p_newlines: true,
		theme: "advanced",
		//skin: "o2k7",
		//skin_variant: "silver",
		plugins: "autolink,lists,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,inlinepopups,autosave",
		theme_advanced_path: false,
		  
		//IE에서 한글입력 문제 해결을 위해서
		forced_root_block: false,
		//에디터 너비 높이 설정
		//height: "330",
		//width: "790", 
		  
		//에디터 버튼 예제 full.html을 보고 전부사용해두 되고 사용할꺼만 골라 쓰면 된다.
		theme_advanced_buttons1: "formatselect,fontselect,fontsizeselect,",
		theme_advanced_buttons2: "bold,italic,underline,strikethrough,forecolor,justifyleft,justifycenter,justifyright,justifyfull,imgUp,code",
		theme_advanced_buttons3 : "",
		theme_advanced_buttons4 : "",
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		//theme_advanced_statusbar_location : "bottom",
		theme_advanced_resizing : false,
		  
		// example 폴더 css에 있는 css파일을 갖다 쓴다.  
		// 에디터 폼않에 스타일을 설정하는 파일이다.   
		content_css: "/lib/tiny_mce/tiny_mce_3.5b1/css/content.css",
		  
		// Drop lists for link/image/media/template dialogs  
		template_external_list_url: "/lib/tiny_mce/tiny_mce_3.5b1/lists/template_list.js",  
		external_link_list_url: "/lib/tiny_mce/tiny_mce_3.5b1/lists/link_list.js",  
		external_image_list_url: "/lib/tiny_mce/tiny_mce_3.5b1/lists/image_list.js",  
		media_external_list_url: "/lib/tiny_mce/tiny_mce_3.5b1/lists/media_list.js",  
		  
		// Style formats  
		style_formats: [  
			{ title: 'Bold text', inline: 'b' },  
			{ title: 'Red text', inline: 'span', styles: { color: '#ff0000'} },  
			{ title: 'Red header', block: 'h1', styles: { color: '#ff0000'} },  
			{ title: 'Example 1', inline: 'span', classes: 'example1' },  
			{ title: 'Example 2', inline: 'span', classes: 'example2' },  
			{ title: 'Table styles' },  
			{ title: 'Table row 1', selector: 'tr', classes: 'tablerow1'}
		],  
		  
		//에디터에 사용할 폰트 지정   
		theme_advanced_fonts: "굴림=굴림;굴림체=굴림체;궁서=궁서;궁서체=궁서체;돋움=돋움;돋움체=돋움체;바탕=바탕;바탕체=바탕체;Arial=Arial; Comic Sans MS='Comic Sans MS';Courier New='Courier New';Tahoma=Tahoma;Times New Roman='Times New Roman';Verdana=Verdana",  
		  
		// Replace values for the template plugin  
		template_replace_values: {  
			//username: "Some User",  
			//staffid: "991234"  
		},  
		
		/*  
		setup : function(ed) {  
			// 이미지 업로드 창  
			ed.addButton('imgUp', {
				title : '이미지넣기',  
				image: '/lib/tiny_mce/tiny_mce_3.5b1/upload.gif',
				onclick : function() {  
					winOpen(400, 300, "board_image_upload.jsp", "imgPop");
					//$("#imageUploadDiv").show();
				}  
			});  
		  */
			// 수정시 에디터에 값넣기 setContent않에
			/*
			ed.onLoadContent.add(function (ed, o) {  
				ed.focus();  
				tinyMCE.activeEditor.setContent("");  
			});
			*/  
		/*
		} 
		*/  
	});  
		  
	/* 원하는 사이즈로 팝업열기 */  
	function winOpen(w, h, url, winName) {  
		var x = (screen.width - w) / 2 - 10;  
		var y = (screen.height - h) / 2 - 10;  
		var exp = "width=" + w + ", height=" + h + ", top=" + y + ",left=" + x + ", status=yes, resizable=no, toolbar=no, scrollbars=no , fullscreen=no ";  
		var wopen = window.open(url, winName, exp);  
		wopen.focus();  
		x = null, y = null, exp = null, wopen = null;  
	}  
		  
	/* 공백 검사 */  
	function isNull(s) {  
		if (s.replace(/(^\s*)|(\s*$)/g, "") && s != null) {  
			return false;  
		} else {  
			return true;  
		}  
	}  
		  
    /* 입력검사 */  
	function checkEdit() {  
		if (isNull(document.getElementById("<%=TxtSubject.ClientID%>").value) == true) {  
			alert("제목을 입력하세요!!");  
			document.getElementById("<%=TxtSubject.ClientID%>").focus();  
			return false;  
		}  
		  
		if (isNull(tinyMCE.get("<%=TxtContent.ClientID%>").getContent()) == true) {  
			alert("내용을 입력하세요!!");  
			tinyMCE.get("<%=TxtContent.ClientID%>").focus();  
			return false;  
		}  
		return true;  
	}

	//파일업로드 완료후 opener.editorImgUploadComplete함수호출 되는 방식 
	function editorImgUploadComplete(fileStr, dir){
		var strImg = "<br><img src='"+ dir + fileStr + "' border=0 class='edit_image' width='250' height='250'><br><br>";
		var contents = tinyMCE.activeEditor.getDoc().body.innerHTML;
		tinyMCE.activeEditor.setContent( contents + strImg );
	}
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
