<%@page import="java.io.OutputStream"%>
<%@page import="com.sun.xml.internal.bind.v2.runtime.Name"%>
<%@page import="javafx.scene.control.Alert"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" import="java.util.ArrayList, cvGenerator.*, java.io.*"
    pageEncoding="UTF-8"%>
<%!
String method = "get";
String username = "";
String userId = "";
String gender = "female";
String phoneNumber = "";
String email = "";
String target = "";
%>
<%
request.setCharacterEncoding("utf-8");
method = request.getMethod();
System.out.println("sheet.jsp: method " + method);
if (method.equalsIgnoreCase("get"))
{
	userId = request.getParameter(Config.Keys.ID);
	//System.out.println(userId);
	if (userId == null || userId.length() == 0)
	{
	}
	else
	{
		// get parameters: the primary key of a user in DB.
		username = request.getParameter(Config.Keys.NAME);
		gender = request.getParameter(Config.Keys.GENDER);
		email = request.getParameter(Config.Keys.E_MAIL);
		
		// retrive data from session
		phoneNumber = (String)session.getAttribute(Config.Keys.PHONE_NUMBER);
		target = (String)session.getAttribute(Config.Keys.TARGET);
		//System.out.println("get Sheet.jsp?userid=xxx");
	}
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>个人简历生成</title>
	<link rel="stylesheet" href=".\CSS\styles.css" type="text/css"/>
	<style type="text/css">
	</style>
</head>
<script type="text/javascript">
var userId = <%=userId%>;
function removeElement(_element){
	var _parentElement = _element.parentNode;
	if(_parentElement){
       	_parentElement.removeChild(_element);
	}
}

function addEmpeySkillItem()
{
	addSkillItem("", "")
}

function addSkillItem(skill_name, skill_level)
{
	var li = document.createElement("li");
	
	var strong = document.createElement("strong");
	strong.appendChild(document.createTextNode("技能："));
	li.appendChild(strong);
	
	var input1 = document.createElement("input");
	input1.setAttribute("type", "text");
	input1.setAttribute("name", "SKILL_NAME");
	input1.setAttribute("value", skill_name);
	li.appendChild(input1);
	
	var strong2 = document.createElement("strong");
	strong.appendChild(document.createTextNode("程度："));
	li.appendChild(strong);
	
	var select = document.createElement("select");
	select.setAttribute("name", "SKILL_LEVEL");
	var opt1 = document.createElement("option");
	opt1.setAttribute("value", "familiar");
	opt1.appendChild(document.createTextNode("熟练"));
	var opt2 = document.createElement("option");
	opt2.setAttribute("value", "expert");
	opt2.appendChild(document.createTextNode("精通"));
	if (skill_level != null && skill_level == "expert") opt2.setAttribute("selected", "selected");
	else opt1.setAttribute("selected", "selected");
	select.appendChild(opt1); select.appendChild(opt2);
	li.appendChild(select);
	
	var button = document.createElement("button");
	button.setAttribute("class", "remove");
	button.setAttribute("onclick", "removeElement(this.parentNode)");
	button.appendChild(document.createTextNode("X"));
	li.appendChild(button);
	
	document.getElementById("ul_skills").appendChild(li);
}

function addEmpeyProjectItem()
{
	addProjectItem("", "", "");
}

function addProjectItem(project_name, project_timespan, project_description)
{
	var li = document.createElement("li");
	
	var strong = document.createElement("strong");
	strong.appendChild(document.createTextNode("项目名称："));
	li.appendChild(strong);
	
	var input1 = document.createElement("input");
	input1.setAttribute("type", "text");
	input1.setAttribute("name", "PROJECT_NAME");
	input1.setAttribute("value", project_name);
	li.appendChild(input1);
	
	var strong2 = document.createElement("strong");
	strong2.appendChild(document.createTextNode("项目时间："));
	li.appendChild(strong2);
	
	var input2 = document.createElement("input");
	input2.setAttribute("type", "text");
	input2.setAttribute("name", "PROJECT_TIMESPAN");
	input2.setAttribute("value", project_timespan);
	li.appendChild(input2);
	
	var button = document.createElement("button");
	button.setAttribute("class", "remove");
	button.setAttribute("onclick", "removeElement(this.parentNode)");
	button.appendChild(document.createTextNode("X"));
	li.appendChild(button);
	li.appendChild(document.createElement("br"));
	
	var strong3 = document.createElement("strong");
	strong3.appendChild(document.createTextNode("项目描述(项目内容、个人贡献等)："));
	li.appendChild(strong3);
	li.appendChild(document.createElement("br"));
	
	var textarea = document.createElement("textarea");
	textarea.setAttribute("name", "PROJECT_DESCRIPTION");
	textarea.setAttribute("rows", "5");
	textarea.setAttribute("cols", "58");
	textarea.appendChild(document.createTextNode(project_description));
	li.appendChild(textarea);
	
	document.getElementById("ul_proj").appendChild(li);
}

function addEmpeyJobItem()
{
	addJobItem("", "", "", "");
}

function addJobItem(company_name, position, timespan, description)
{
	var li = document.createElement("li");
	
	var strong = document.createElement("strong");
	strong.appendChild(document.createTextNode("公司名称："));
	li.appendChild(strong);
	
	var input1 = document.createElement("input");
	input1.setAttribute("type", "text");
	input1.setAttribute("name", "JOB_COMPANY_NAME");
	input1.setAttribute("value", company_name);
	li.appendChild(input1);
	
	var strong2 = document.createElement("strong");
	strong2.appendChild(document.createTextNode("担任职务："));
	li.appendChild(strong2);
	
	var input2 = document.createElement("input");
	input2.setAttribute("type", "text");
	input2.setAttribute("name", "JOB_POSITION");
	input2.setAttribute("value", position);
	li.appendChild(input2);
	
	var button = document.createElement("button");
	button.setAttribute("class", "remove");
	button.setAttribute("onclick", "removeElement(this.parentNode)");
	button.appendChild(document.createTextNode("X"));
	li.appendChild(button);
	li.appendChild(document.createElement("br"));
	
	var strong3 = document.createElement("strong");
	strong3.appendChild(document.createTextNode("工作时间："));
	li.appendChild(strong3);
	
	var input3 = document.createElement("input");
	input3.setAttribute("type", "text");
	input3.setAttribute("name", "JOB_TIMESPAN");
	input3.setAttribute("value", timespan);
	li.appendChild(input3);
	li.appendChild(document.createElement("br"));
	
	var strong4 = document.createElement("strong");
	strong4.appendChild(document.createTextNode("工作描述(工作内容、个人贡献等)："));
	li.appendChild(strong4);
	li.appendChild(document.createElement("br"));
	
	var textarea = document.createElement("textarea");
	textarea.setAttribute("name", "JOB_DESCRIPTION");
	textarea.setAttribute("rows", "5");
	textarea.setAttribute("cols", "58");
	textarea.appendChild(document.createTextNode(description));
	li.appendChild(textarea);
	
	document.getElementById("ul_job").appendChild(li);
}

function addEmptyEduItem()
{
	addEduItem("", "", "", "");
}

function addEduItem(school_name, graduation_time, degree, description)
{
	var li = document.createElement("li");
	
	var strong = document.createElement("strong");
	strong.appendChild(document.createTextNode("学校名称："));
	li.appendChild(strong);
	
	var input1 = document.createElement("input");
	input1.setAttribute("type", "text");
	input1.setAttribute("name", "EDU_SCHOOL_NAME");
	input1.setAttribute("value", school_name);
	li.appendChild(input1);
	
	var strong2 = document.createElement("strong");
	strong2.appendChild(document.createTextNode("毕业时间："));
	li.appendChild(strong2);
	
	var input2 = document.createElement("input");
	input2.setAttribute("type", "text");
	input2.setAttribute("name", "EDU_GRADUATION_TIME");
	input2.setAttribute("value", graduation_time);
	li.appendChild(input2);
	
	var button = document.createElement("button");
	button.setAttribute("class", "remove");
	button.setAttribute("onclick", "removeElement(this.parentNode)");
	button.appendChild(document.createTextNode("X"));
	li.appendChild(button);
	li.appendChild(document.createElement("br"));
	
	var strong3 = document.createElement("strong");
	strong3.appendChild(document.createTextNode("获得学位："));
	li.appendChild(strong3);
	
	var input3 = document.createElement("input");
	input3.setAttribute("type", "text");
	input3.setAttribute("name", "EDU_DEGREE");
	input3.setAttribute("value", degree);
	li.appendChild(input3);
	li.appendChild(document.createElement("br"));
	
	var strong4 = document.createElement("strong");
	strong4.appendChild(document.createTextNode("教育经历(所获奖项、担任职务等)："));
	li.appendChild(strong4);
	li.appendChild(document.createElement("br"));
	
	var textarea = document.createElement("textarea");
	textarea.setAttribute("name", "EDU_DESCRIPTION");
	textarea.setAttribute("rows", "5");
	textarea.setAttribute("cols", "58");
	textarea.appendChild(document.createTextNode(description));
	li.appendChild(textarea);
	
	document.getElementById("ul_edu").appendChild(li);
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
			return false;
		}
	else {return true}
	}
}

// After validate(thisForm), if if return false, the cursor should be placed on the topmost missed input.
// isFocusSet is to determine whether the cursor has been placed on the topmost missed input. 
isFocusSet = false;

function validate(thisForm)
{
	if (!isSubmit) return false;
	isSubmit = false;
	isSubmitAllowed = true;
	
	if (validate_required(thisForm.<%=Config.HtmlFormComponents.NAME%>) == false)
		{ isSubmitAllowed = false;}
	if (validate_required(thisForm.<%=Config.HtmlFormComponents.PHONE_NUMBER%>) == false)
		{ isSubmitAllowed = false;}
	if (validate_email(thisForm.<%=Config.HtmlFormComponents.E_MAIL%>) == false)
		{ isSubmitAllowed = false;}
	if (validate_required(thisForm.<%=Config.HtmlFormComponents.OBJECT%>) == false)
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

function loadData()
{
	var xmlHttp1, xmlHttp2, xmlHttp3, xmlHttp4;
	if (window.XMLHttpRequest)
		{
		xmlHttp1 = new XMLHttpRequest();
		xmlHttp2 = new XMLHttpRequest();
		xmlHttp3 = new XMLHttpRequest();
		xmlHttp4 = new XMLHttpRequest();
		}
	else
		{
		xmlHttp1=new ActiveXObject("Microsoft.XMLHTTP");
		xmlHttp2=new ActiveXObject("Microsoft.XMLHTTP");
		xmlHttp3=new ActiveXObject("Microsoft.XMLHTTP");
		xmlHttp4=new ActiveXObject("Microsoft.XMLHTTP");
		}
	xmlHttp1.onreadystatechange=function()
	{
		if (xmlHttp1.readyState == 4 && xmlHttp1.status == 200)
			{
				var jsonArray1 = JSON.parse(xmlHttp1.responseText);
				for(var i1 = 0; i1 < jsonArray1.length; ++i1)
					{
					addSkillItem(jsonArray1[i1].Name, jsonArray1[i1].Level);
					}
			}
	}
	xmlHttp2.onreadystatechange=function()
	{
		if (xmlHttp2.readyState == 4 && xmlHttp2.status == 200)
			{
				var jsonArray2 = JSON.parse(xmlHttp2.responseText);
				for(var i2 = 0; i2 < jsonArray2.length; ++i2)
					{
					addProjectItem(jsonArray2[i2].Name, jsonArray2[i2].TimeSpan, jsonArray2[i2].Description);
					}
			}
	}
	xmlHttp3.onreadystatechange=function()
	{
		if (xmlHttp3.readyState == 4 && xmlHttp3.status == 200)
			{
				var jsonArray3 = JSON.parse(xmlHttp3.responseText);
				for(var i3 = 0; i3 < jsonArray3.length; ++i3)
					{
					addJobItem(jsonArray3[i3].CompanyName, jsonArray3[i3].Position, jsonArray3[i3].TimeSpan, jsonArray3[i3].Description)
					}
			}
	}
	xmlHttp4.onreadystatechange=function()
	{
		if (xmlHttp4.readyState == 4 && xmlHttp4.status == 200)
			{
				var jsonArray4 = JSON.parse(xmlHttp4.responseText);
				for(var i4 = 0; i4 < jsonArray4.length; ++i4)
					{
					addEduItem(jsonArray4[i4].SchoolName, jsonArray4[i4].GraduationTime, jsonArray4[i4].Degree, jsonArray4[i4].Description)
					}
			}
	}
	//xmlHttp1.open("GET", String.format("getSkills.jsp?id=%s&time=%d", userId, System.nanoTime()), true);
	xmlHttp1.open("GET", "getSkills.jsp?id=" + userId, true);
	xmlHttp1.send();
	xmlHttp2.open("GET", "getProjects.jsp?id=" + userId, true);
	xmlHttp2.send();
	xmlHttp3.open("GET", "getJobs.jsp?id=" + userId, true);
	xmlHttp3.send();
	xmlHttp4.open("GET", "getEdu.jsp?id=" + userId, true);
	xmlHttp4.send();
}

window.onload = function() {
	loadData();
}
</script>
<body>
	<form action="Submit.jsp" method="post" onsubmit="return validate(this)">
		<div class="container" id="div_basic">
			<h1>基本信息</h1>
			<div>
				<table>
					<tr>
						<td><strong>*姓名 ：</strong></td>
						<td><input type="text" name="<%=Config.HtmlFormComponents.NAME%>" value="<%=username%>"/></td>
						<td><strong>性别：</strong></td>
						<td>
							<select name="<%=Config.HtmlFormComponents.GENDER%>">
								<option value="male" <%=gender.equalsIgnoreCase("male")?"selected":""%>>男</option>
								<option value="female" <%=gender.equalsIgnoreCase("female")?"selected":""%>>女</option>
							</select>
						</td>
					</tr>
					<tr>
						<td><strong>*手机号：</strong></td>
						<td><input type="text" name="<%=Config.HtmlFormComponents.PHONE_NUMBER%>" value="<%=phoneNumber%>"/></td>
					</tr>
					<tr>
						<td><strong>*邮箱：</strong></td>
						<td><input type="text" name="<%=Config.HtmlFormComponents.E_MAIL%>" value="<%=email%>"></td>
					</tr>
					<tr>
						<td><strong>*应聘职位：</strong></td>
						<td><input type="text" name="<%=Config.HtmlFormComponents.OBJECT%>" value="<%=target%>"/></td>
					</tr>
				</table>
			</div>
		</div>
		
		<div class="container" id="div_skills">
			<h1>技能</h1>
			<ul id="ul_skills">
			</ul>
			<button id="btn_add_skill" class="add" onclick="addEmpeySkillItem()">+</button>
		</div>

		<div class="container" id="div_proj">
			<h1>项目经历</h1>
			<ul id="ul_proj">
			</ul>
			<button id="btn_add_proj" onclick="addEmpeyProjectItem()" class="add">+</button>
		</div>
		
		<div class="container" id="div_jobs">
			<h1>工作经历</h1>
			<ul id="ul_job">
			</ul>
			<button id="btn_add_job" class="add" onclick="addEmpeyJobItem()">+</button>
		</div>
		
		<div class="container" id="div_edu">
			<h1>教育经历</h1>
			<ul id="ul_edu">
			</ul>
			<button id="btn_add_edu" class="add" onclick="addEmptyEduItem()">+</button>
		</div>
		
		<input type="submit" onclick="isSubmit = true" value="^_^ 生成并下载简历"/>
		<br/><br/>
	</form>
</body>
</html>