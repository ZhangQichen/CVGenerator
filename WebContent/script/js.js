function removeElement(_element){
    	var _parentElement = _element.parentNode;
    	if(_parentElement){
           	_parentElement.removeChild(_element);
    	}
	}

	var skillItem;
	var projItem;
	var jobItem;
	var eduItem;

	function addSkillItem()
	{
		document.getElementById("ul_skills").appendChild(skillItem.cloneNode(true));
	}
	
	function addProjectItem()
	{
		document.getElementById("ul_proj").appendChild(projItem.cloneNode(true));
	}
	
	function addJobItem()
	{
		document.getElementById("ul_job").appendChild(jobItem.cloneNode(true));
	}
	
	function addEduItem()
	{
		document.getElementById("ul_edu").appendChild(eduItem.cloneNode(true));
	}
	
	function emphasize(element)
	{
		element.style.border = "red solid 2px";
		element.onchange = function(){this.style.border="grey solid 1px"};
	}
	
	function validate_required(field)
	{
		with(field)
		{
			if (value == null || value == "")
			{
				emphasize(field);
				//field.style.border = "red solid 2px";
				//field.onchange = function(){this.style.border="grey solid 1px"};
				if (isFocusSet == false)
					{field.focus(); isFocusSet = true;}
				return false;
			}
			else return true;
		}
	}
	
	function validate_email(field)
	{
		with (field)
		{
			apos=value.indexOf("@")
			dotpos=value.lastIndexOf(".")
			if (apos<1||dotpos-apos<2) 
	  		{
				emphasize(field);
				//field.style.border = "red solid 2px";
				//field.onchange = function(){this.style.border="grey solid 1px"};
				return false;
			}
		else {return true}
		}
	}
	
	// After validate(thisForm), if if return false, the cursor should be placed on the topmost missed input.
	// isFocusSet is to determined whether the cursor has been placed on the topmost missed input. 
	isFocusSet = false;
	
	function validate(thisForm)
	{
		if (!isSubmit) return false;
		isSubmit = false;
		isSubmitAllowed = true;
		
		if (validate_required(thisForm.yourName) == false)
			{ isSubmitAllowed = false;}
		if (validate_required(thisForm.phoneNumber) == false)
			{ isSubmitAllowed = false;}
		if (validate_email(thisForm.email) == false)
			{ isSubmitAllowed = false;}
		if (validate_required(thisForm.object) == false)
			{ isSubmitAllowed = false;}
		
		var inputs = document.getElementsByTagName("input");
		for (var i = 0; i < inputs.length; ++i)
		{
			if ( (inputs[i].type == "text") && (inputs[i].value == null || inputs[i].value == ""))
			{
				emphasize(inputs[i]);
				isSubmitAllowed = false;
			}
		}
		
		inputs = document.getElementsByTagName("textarea");
		for (var i = 0; i < inputs.length; ++i)
		{
			if (inputs[i].value == null || inputs[i].value == "")
			{
				emphasize(inputs[i]);
				isSubmitAllowed = false;
			}
		}
		
		isFocusSet = false;
		
		if (isSubmitAllowed == false)
			{alert("请将必填项填完！")}
		
		return isSubmitAllowed;
	}
	
	var isSubmit = false;
	
	window.onload = function()
	{
		var li = document.getElementsByTagName("li");
		var isSkillCloned = false;
		var isProjCloned = false;
		var isJobCloned = false;
		var isEduCloned = false;
		for (var i = 0; i < li.length; ++i)
		{
			if (li[i].className == "li_skill" && !isSkillCloned)
				{skillItem = li[i].cloneNode(true); isSkillCloned = true;}
			else if (li[i].className == "li_proj" && !isProjCloned)
				{projItem = li[i].cloneNode(true); isProjCloned = true;}
			else if (li[i].className == "li_job" && !isJobCloned)
				{jobItem = li[i].cloneNode(true); isJobCloned = true;}
			else if (li[i].className = "li_edu" && !isEduCloned)
				{eduItem = li[i].cloneNode(true); isEduCloned = true;}
		}
	}