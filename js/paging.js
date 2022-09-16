<!--

	/************************************************************
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'	GSG Admin 공통 페이징
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	*************************************************************/
	function GSGAdminPaging(totalCnt, pageSize, readPage, movieFunc)
	{

		var l_readPage = readPage

		var innerHTML = "";
		var pagingSize = 5
		//innerHTML += "<div class='pagingarea clearFix'>";
		
		// step 1. 총페이지수를 얻는다.
		var l_totalPage = create_totalPage(totalCnt, pageSize)
		// step 2. 페이징 데이타를 얻는다.
		var pagingDATA = create_paging("", "", "", pagingSize, l_totalPage, l_readPage);
		
		// step 3. split 한다.
		var pagingArray = pagingDATA.split(",");
		
		// step 4. 페이징을 만든다.		
		for(var index = 0; index < pagingArray.length - 1; index++)
		{
			if(index == 0)								// 첫블럭의 첫페이지
			{
				if(l_readPage > pagingSize) { 
					innerHTML += "<a href='javascript:void(0);' title='첫 페이지' class='arr_pg pg_first' onclick='"+movieFunc+"("+pagingArray[index]+")'><span>맨 처음 페이지로 이동</span></a>";
				}
			}
			else if(index == 1)							// 이전 블럭의 첫페이지
			{
				if(l_readPage > pagingSize) {
					innerHTML += "<a href='javascript:void(0);' title='이전 페이지' class='arr_pg pg_prev' onclick='"+movieFunc+"("+pagingArray[index]+")'><span>이전페이지로 이동</span></a>";
				}
			}
			else if(index == pagingArray.length - 4)	// 마지막 페이지
			{
				if(l_readPage == pagingArray[pagingArray.length-2] || l_readPage == pagingArray[index])
				{					
					innerHTML += "<a href='javascript:void(0);' title='"+pagingArray[index]+" 페이지' class='on'><span>"+pagingArray[index]+"</span></a>";
				}
				else
				{					
					innerHTML += "<a href='javascript:void(0);' title='"+pagingArray[index]+" 페이지' onclick='"+movieFunc+"("+pagingArray[index]+")'><span>"+pagingArray[index]+"</span></a>";
				}
			}
			else if(index == pagingArray.length - 3)	// 다음 블럭의 첫 페이지
			{
				if(l_totalPage > pagingSize && l_readPage < l_totalPage) {
					innerHTML += "<a href='javascript:void(0);' title='다음 페이지' class='arr_pg pg_next' onclick='"+movieFunc+"("+pagingArray[index]+")'><span>다음 페이지로 이동</span></a>";					
				}
			}
			else if(index == pagingArray.length - 2)	// 최종블럭의 마지막 페이지
			{
				if(l_totalPage > pagingSize && l_readPage < l_totalPage) {
					innerHTML += "<a href='javascript:void(0);' title='마지막 페이지' class='arr_pg pg_last' onclick='"+movieFunc+"("+pagingArray[index]+")'><span>맨 마지막 페이지로 이동</span></a>";
				}
			}
			else										// 기본페이지
			{
				if(pagingArray[index] == l_readPage)
				{
					innerHTML += "<a href='javascript:void(0);' title='"+pagingArray[index]+" 페이지' class='on'><span>"+pagingArray[index]+"</span></a>";
				}
				else
				{
					innerHTML += "<a href='javascript:void(0);' title='"+pagingArray[index]+" 페이지' onclick='"+movieFunc+"("+pagingArray[index]+")'><span>"+pagingArray[index]+"</span></a>";
				}
			}			
		}		

		if(document.getElementById("Paging") != null)
		{
			document.getElementById("Paging").innerHTML = innerHTML;
		}
	}

	/************************************************************
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'	경로를 생성한다.							'
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	*************************************************************/
	function create_link(url, boardKind, subjectKind, pageNumber)
	{
		var p_url;
		var p_boardKind;
		var p_subjectKind;
		var p_pageNumber;

		var l_url = '';

		p_url = url;
		p_boardKind = boardKind
		p_subjectKind = subjectKind
		p_pageNumber = pageNumber;
		
		l_url = '';
		l_url = p_pageNumber + ',';
		
		/*
		l_url += '<a href="' + url;
		l_url += '?board_kind=' + p_boardKind;
		l_url += '&subject_kind=' + p_subjectKind;
		l_url += '&pageNumber=' + p_pageNumber;
		l_url += '">';
		l_url += p_pageNumber;
		l_url += '</a>';
		*/

		return l_url;
	}

	/************************************************************
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'	첫블럭의 시작 페이지 번호					'
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	*************************************************************/
	function create_firstBlock_start_pageNumber(url, boardKind, subjectKind, pageBlockSize, pageBlock)
	{
		var p_url;
		var p_boardKind;
		var p_subjectKind;
		var p_pageBlockSize;
		var p_pageBlock;

		var l_url;

		p_url = url;
		p_boardKind = boardKind;
		p_subjectKind = subjectKind;
		p_pageBlockSize = pageBlockSize;
		p_pageBlock = pageBlock;
		
		l_url = create_link(p_url, p_boardKind, p_subjectKind, 1);

		return l_url;
	}
	
	/************************************************************
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'	마지막 블록의 끝 페이지 번호				'
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	*************************************************************/
	function create_finalBlock_end_pageNumber(url, boardKind, subjectKind, pageNumber)
	{
		var p_url;
		var p_boardKind;
		var p_subjectKind;
		var p_pageNumber;

		var l_url;

		p_url = url;
		p_boardKind = boardKind
		p_subjectKind = subjectKind
		p_pageNumber = pageNumber;
		
		l_url = create_link(p_url, p_boardKind, p_subjectKind, p_pageNumber);

		return l_url;
	}

	/************************************************************
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'	페이지가 현재 어떤 블록에 속해 있는지 파악.	'
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	*************************************************************/
	function create_pageBlock(pageBlockSize, pageNumber)
	{
		var p_pageBlockSize
		var p_pageNumber;

		var l_pageBlock;

		p_pageBlockSize = parseInt(pageBlockSize);
		p_pageNumber = parseInt(pageNumber);
		
		l_pageBlock = "";

		if(p_pageNumber % p_pageBlockSize == 0)
		{
			l_pageBlock = parseInt(p_pageNumber / p_pageBlockSize);
		}
		else
		{
			l_pageBlock = parseInt(p_pageNumber/ p_pageBlockSize) + 1;
		}

		return l_pageBlock;
	}

	/************************************************************
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'	이전 블록의 시작 페이지 번호				'
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	*************************************************************/
	function create_beforeBlock_start_pageNumber(url, boardKind, subjectKind, pageBlockSize, totalPage, pageNumber)
	{
		var p_url;
		var p_boardKind;
		var p_subjectKind;
		var p_pageBlockSize;
		var p_totalPage;
		var p_pageNumber;
		var p_pageBlock;

		var l_pageNumber;
		var l_url;

		p_url = url;
		p_boardKind = boardKind
		p_subjectKind = subjectKind
		p_pageBlockSize = parseInt(pageBlockSize);
		p_totalPage = parseInt(totalPage);
		p_pageNumber = parseInt(pageNumber);
		p_pageBlock = create_pageBlock(p_pageBlockSize, p_pageNumber);

		l_url = "";
		l_pageNumber = "";

		if(p_totalPage <= p_pageBlockSize)
		{
			l_pageNumber = 1;
		}
		else
		{
			l_pageNumber = (p_pageBlock - 2 ) * p_pageBlockSize + 1;
			if(l_pageNumber <= 1) l_pageNumber = 1
		}

		l_url = create_link(p_url, p_boardKind, p_subjectKind, l_pageNumber);
		
		return l_url;
	}
	
	/************************************************************
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'	이후 블록의 시작 페이지 번호				'
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	*************************************************************/
	function create_afterBlock_start_pageNumber(url, boardKind, subjectKind, pageBlockSize, totalPage, pageNumber)
	{
		var p_url;
		var p_boardKind;
		var p_subjectKind;
		var p_pageBlockSize;
		var p_totalPage;
		var p_pageNumber;
		var p_pageBlock

		var l_pageNumber;
		var l_url;

		p_url = url;
		p_boardKind = boardKind
		p_subjectKind = subjectKind
		p_pageBlockSize = parseInt(pageBlockSize);
		p_totalPage = parseInt(totalPage);
		p_pageNumber = parseInt(pageNumber);
		p_pageBlock = create_pageBlock(p_pageBlockSize, p_pageNumber);

		l_url = "";
		l_pageNumber = "";
		l_pageNumber = 1 + (p_pageBlockSize * (p_pageBlock * 1));
		
		if(p_totalPage <= l_pageNumber)
		{
			l_pageNumber = p_totalPage;
		}
		else
		{			
			if(l_pageNumber > p_totalPage) l_pageNumber = p_pageBlockSize * p_pageBlock - (p_pageBlockSize - 1);
		}

		l_url = create_link(p_url, p_boardKind, p_subjectKind, l_pageNumber);
		
		return l_url;
	}

	/************************************************************
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'	페이지 총 갯수.							'
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	*************************************************************/
	function create_totalPage(totalCnt, pageSize)
	{		
		var totalPage;

		totalPage = Math.ceil(totalCnt/pageSize);

		return totalPage;
	}
	
	/************************************************************
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'	이후 블록의 시작 페이지 번호				'
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	*************************************************************/
	function create_paging(url, boardKind, subjectKind, pageBlockSize, totalPage, pageNumber)
	{
		var p_url;
		var p_boardKind;
		var p_subjectKind;
		var p_pageBlockSize;
		var p_totalPage;
		var p_pageNumber;
		var p_pageBlock;

		var l_firstBlock_start_pageNumber;
		var l_finalBlock_end_pageNumber;
		var l_beforeBlock_start_pageNumber;
		var l_afterBlock_start_pageNumber;
		var l_paging;

		p_url = url;
		p_boardKind = boardKind;
		p_subjectKind = subjectKind;
		p_pageBlockSize = pageBlockSize;
		p_totalPage = totalPage;
		p_pageNumber = pageNumber;
		p_pageBlock = create_pageBlock(p_pageBlockSize, p_pageNumber);

		l_firstBlock_start_pageNumber = create_firstBlock_start_pageNumber
		(
			p_url, 
			p_boardKind, 
			p_subjectKind, 
			p_pageBlockSize, 
			p_pageBlock
		);
		
		l_beforeBlock_start_pageNumber = create_beforeBlock_start_pageNumber
		(
			p_url, 
			p_boardKind, 
			p_subjectKind, 
			p_pageBlockSize, 
			p_totalPage, 
			p_pageNumber
		);
		
		l_afterBlock_start_pageNumber = create_afterBlock_start_pageNumber
		(
			p_url, 
			p_boardKind, 
			p_subjectKind, 
			p_pageBlockSize, 
			p_totalPage, 
			p_pageNumber
		);
		
		l_finalBlock_end_pageNumber = create_finalBlock_end_pageNumber
		(
			p_url, 
			p_boardKind, 
			p_subjectKind, 
			p_totalPage
		);

		l_paging = "";
		/*
		l_paging += "[최초:" + l_firstBlock_start_pageNumber + "]";
		l_paging += "[이전:" + l_beforeBlock_start_pageNumber + "]";
		*/
		l_paging += l_firstBlock_start_pageNumber;
		l_paging += l_beforeBlock_start_pageNumber;

		for
		(
			var number = p_pageBlockSize * p_pageBlock - (p_pageBlockSize - 1); 
			number <= p_pageBlockSize * p_pageBlock; 
			number++
		)
		{
			if(number > p_totalPage) break;

			l_paging += "" + create_link
			(
				p_url, 
				p_boardKind, 
				p_subjectKind, 
				number
			) + ""
		}

		/*
		l_paging += "[이후:" + l_afterBlock_start_pageNumber + "]";
		l_paging += "[최후:" + l_finalBlock_end_pageNumber + "]";
		*/
		l_paging += l_afterBlock_start_pageNumber;
		l_paging += l_finalBlock_end_pageNumber;

		return l_paging;
	}

//-->