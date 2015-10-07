<%@page import="java.io.OutputStream"%>
<%@page import="com.sun.xml.internal.bind.v2.runtime.Name"%>
<%@page import="javafx.scene.control.Alert"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" import="java.util.ArrayList, cvGenerator.*, java.io.*"
    pageEncoding="UTF-8"%>
<%!
String username = "";
String userId = "";
String gender = "female";
String phoneNumber = "";
String email = "";
String target = "";
String method = "get";

ArrayList<Skill> skills;
ArrayList<Project> projects;
ArrayList<Job> jobs;
ArrayList<EduExperience> eduExperiences;

void ReadBasicInfo(HttpServletRequest request)
{
	username = request.getParameter(Config.HtmlFormComponents.NAME);
	gender = request.getParameter(Config.HtmlFormComponents.GENDER);
	phoneNumber = request.getParameter(Config.HtmlFormComponents.PHONE_NUMBER);
	email = request.getParameter(Config.HtmlFormComponents.E_MAIL);
	target = request.getParameter(Config.HtmlFormComponents.OBJECT);
}

void ReadSkills(HttpServletRequest request)
{
	skills = new ArrayList<Skill>();
	String[] skillNames = request.getParameterValues(Config.HtmlFormComponents.SKILL_NAME);
	if (skillNames == null) return;
	String[] skillLevel = request.getParameterValues(Config.HtmlFormComponents.SKILL_LEVEL);
	for (int i = 0; i < skillNames.length; ++i)
	{
		skills.add(new Skill(skillNames[i], skillLevel[i]));
	}
}

void ReadProjects(HttpServletRequest request)
{
	projects = new ArrayList<Project>();
	String[] projNames = request.getParameterValues(Config.HtmlFormComponents.PROJECT_NAME);
	if (projNames == null) return;
	String[] projTimeSpan = request.getParameterValues(Config.HtmlFormComponents.PROJECT_TIMESPAN);
	String[] projDescription = request.getParameterValues(Config.HtmlFormComponents.PROJECT_DESCRIPTION);
	for(int i = 0; i < projNames.length; ++i)
	{
		projects.add(new Project(projNames[i], projTimeSpan[i], projDescription[i]));
	}
}

void ReadJobs(HttpServletRequest request)
{
	jobs = new ArrayList<Job>();
	String[] jobCompanyName = request.getParameterValues(Config.HtmlFormComponents.JOB_COMPANY_NAME);
	if (jobCompanyName == null) return;
	String[] jobPosition = request.getParameterValues(Config.HtmlFormComponents.JOB_POSITION);
	String[] jobTimeSpan = request.getParameterValues(Config.HtmlFormComponents.JOB_TIMESPAN);
	String[] jobDescription = request.getParameterValues(Config.HtmlFormComponents.JOB_DESCRIPTION);
	for(int i = 0; i < jobCompanyName.length; ++i)
		jobs.add(new Job(jobCompanyName[i], jobPosition[i], jobTimeSpan[i], jobDescription[i]));
}

void ReadEdu(HttpServletRequest request)
{
	eduExperiences = new ArrayList<EduExperience>();
	String[] eduSchoolName = request.getParameterValues(Config.HtmlFormComponents.EDU_SCHOOL_NAME);
	if (eduSchoolName == null) return;
	String[] eduGraduationTime = request.getParameterValues(Config.HtmlFormComponents.EDU_GRADUATION_TIME);
	String[] eduDegree = request.getParameterValues(Config.HtmlFormComponents.EDU_DEGREE);
	String[] eduDescription = request.getParameterValues(Config.HtmlFormComponents.EDU_DESCRIPTION);
	for(int i = 0; i < eduSchoolName.length; ++i)
	{
		eduExperiences.add(new EduExperience(eduSchoolName[i], eduGraduationTime[i], eduDegree[i], eduDescription[i]));
	}
}

void WriteFile(OutputStream oStream, String filepath)
{
   try {
      FileInputStream in = new FileInputStream(filepath);
      int bytesRead = 0;
      byte buf[]=new byte[2048];
      while((bytesRead = in.read(buf)) != -1){
        oStream.write(buf, 0, bytesRead);
      }
      in.close();
      oStream.close();
   }
   catch(Exception e){
   }
}
%>
<%
request.setCharacterEncoding("utf-8");
method = request.getMethod();
if (method.equalsIgnoreCase("post"))
{
	ReadBasicInfo(request);
	ReadSkills(request);
	ReadProjects(request);
	ReadJobs(request);
	ReadEdu(request);
	
	DBOperator.OpenDB();
	// Get id from DB for this user. Create one id if such user does not exist.
	userId = DBOperator.GetOrCreateId(username, gender, email);
	// Store the submited information to the DB asynchronously.
	DBOperator.AlterTarget(userId, target);
	DBOperator.AlterPhoneNumber(userId, phoneNumber);
	DBOperator.AlterSkills(userId, skills);
	DBOperator.AlterProjects(userId, projects);
	DBOperator.AlterJobs(userId, jobs);
	DBOperator.AlterEdu(userId, eduExperiences);
	DBOperator.CloseDB();
	
	// Store Cookies
	Cookie cookie_id = new Cookie(Config.Keys.ID, userId);
	cookie_id.setPath("/");
	cookie_id.setMaxAge(3600*5);
	response.addCookie(cookie_id);
	Cookie cookie_username = new Cookie(Config.Keys.NAME, username);
	cookie_username.setPath("/");
	cookie_username.setMaxAge(3600*5);
	response.addCookie(cookie_username);
	Cookie cookie_gender = new Cookie(Config.Keys.GENDER, gender);
	cookie_gender.setPath("/");
	cookie_gender.setMaxAge(3600*5);
	response.addCookie(cookie_gender);
	Cookie cookie_email = new Cookie(Config.Keys.E_MAIL, email);
	cookie_email.setPath("/");
	cookie_email.setMaxAge(3600*5);
	response.addCookie(cookie_email);
	
	// Generate Microsoft Word file and return it to the client.
	Person myInfo = new Person();
	myInfo.Email = email;
	myInfo.Gender = gender;
	myInfo.Id = userId;
	myInfo.Name = username;
	myInfo.PhoneNumber = phoneNumber;
	myInfo.Target = target;
	PoiDocument document = PoiDocument.CreateNewDocument();
	document.WriteBasicInformation(myInfo);
	document.WriteEduExperience(eduExperiences);
	document.WriteJobs(jobs);
	document.WriteProjects(projects);
	document.WriteSkills(skills);
	String filepath = document.CompleteDocument();
	response.setHeader("Content-disposition", "attachment; filename=\""+filepath+"\"");
	WriteFile(response.getOutputStream(), filepath);
	/*
	for(Skill skill : skills)
		out.println(skill.toString());
	for(Project project : projects)
		out.println(project.toString());
	for(Job job : jobs)
		out.println(job.toString());
	for(EduExperience eduExperience : eduExperiences)
		out.println(eduExperience.toString());*/
}
else
{
	userId = request.getParameter(Config.Keys.ID);
	if (userId == null || userId.length() == 0)
	{
		// no parameters, do nothing
		skills = new ArrayList<>();
		projects = new ArrayList<>();
		jobs = new ArrayList<>();
		eduExperiences = new ArrayList<>();
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
		skills = (ArrayList<Skill>)session.getAttribute(Config.Keys.SKILLS);
		projects = (ArrayList<Project>)session.getAttribute(Config.Keys.PROJECTS);
		jobs = (ArrayList<Job>)session.getAttribute(Config.Keys.JOBS);
		eduExperiences = (ArrayList<EduExperience>)session.getAttribute(Config.Keys.EDUCATION);
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
	input1.setAttribute("name", "<%=Config.HtmlFormComponents.SKILL_NAME%>");
	input1.setAttribute("value", skill_name);
	li.appendChild(input1);
	
	var strong2 = document.createElement("strong");
	strong.appendChild(document.createTextNode("程度："));
	li.appendChild(strong);
	
	var select = document.createElement("select");
	select.setAttribute("name", "<%=Config.HtmlFormComponents.SKILL_LEVEL%>");
	var opt1 = document.createElement("option");
	opt1.setAttribute("value", "familiar");
	opt1.appendChild(document.createTextNode("熟练"));
	var opt2 = document.createElement("option");
	opt1.setAttribute("value", "expert");
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
	input1.setAttribute("name", "<%=Config.HtmlFormComponents.PROJECT_NAME%>");
	input1.setAttribute("value", project_name);
	li.appendChild(input1);
	
	var strong2 = document.createElement("strong");
	strong2.appendChild(document.createTextNode("项目时间："));
	li.appendChild(strong2);
	
	var input2 = document.createElement("input");
	input2.setAttribute("type", "text");
	input2.setAttribute("name", "<%=Config.HtmlFormComponents.PROJECT_TIMESPAN%>");
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
	textarea.setAttribute("name", "<%=Config.HtmlFormComponents.PROJECT_DESCRIPTION%>");
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
	input1.setAttribute("name", "<%=Config.HtmlFormComponents.JOB_COMPANY_NAME%>");
	input1.setAttribute("value", company_name);
	li.appendChild(input1);
	
	var strong2 = document.createElement("strong");
	strong2.appendChild(document.createTextNode("担任职务："));
	li.appendChild(strong2);
	
	var input2 = document.createElement("input");
	input2.setAttribute("type", "text");
	input2.setAttribute("name", "<%=Config.HtmlFormComponents.JOB_POSITION%>");
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
	input3.setAttribute("name", "<%=Config.HtmlFormComponents.JOB_TIMESPAN%>");
	input3.setAttribute("value", timespan);
	li.appendChild(input3);
	li.appendChild(document.createElement("br"));
	
	var strong4 = document.createElement("strong");
	strong4.appendChild(document.createTextNode("工作描述(工作内容、个人贡献等)："));
	li.appendChild(strong4);
	li.appendChild(document.createElement("br"));
	
	var textarea = document.createElement("textarea");
	textarea.setAttribute("name", "<%=Config.HtmlFormComponents.JOB_DESCRIPTION%>");
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
	input1.setAttribute("name", "<%=Config.HtmlFormComponents.EDU_SCHOOL_NAME%>");
	input1.setAttribute("value", school_name);
	li.appendChild(input1);
	
	var strong2 = document.createElement("strong");
	strong2.appendChild(document.createTextNode("毕业时间："));
	li.appendChild(strong2);
	
	var input2 = document.createElement("input");
	input2.setAttribute("type", "text");
	input2.setAttribute("name", "<%=Config.HtmlFormComponents.EDU_GRADUATION_TIME%>");
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
	input3.setAttribute("name", "<%=Config.HtmlFormComponents.EDU_DEGREE%>");
	input3.setAttribute("value", degree);
	li.appendChild(input3);
	li.appendChild(document.createElement("br"));
	
	var strong4 = document.createElement("strong");
	strong4.appendChild(document.createTextNode("教育经历(所获奖项、担任职务等)："));
	li.appendChild(strong4);
	li.appendChild(document.createElement("br"));
	
	var textarea = document.createElement("textarea");
	textarea.setAttribute("name", "<%=Config.HtmlFormComponents.EDU_DESCRIPTION%>");
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

function displayData()
{
	<%
	//skills.add(new Skill("C++", "expert"));
	//projects.add(new Project("MFC", "2015-2016", "PM"));
	//jobs.add(new Job("MS", "PM", "2015-2016", "GOOD"));
	//eduExperiences.add(new EduExperience("SYSU", "2012-2016", "Bachelor", "GPA=3.8"));
	%>
	<%for (int i = 0; i < skills.size(); ++i)
	{%>
		addSkillItem("<%=skills.get(i).Name%>", "<%=skills.get(i).Level%>");
	<%}%>
	<%for (int i = 0; i < projects.size(); ++i)
	{%>
		addProjectItem("<%=projects.get(i).Name%>", "<%=projects.get(i).TimeSpan%>", "<%=projects.get(i).Description%>");
	<%}%>
	<%for (int i = 0; i < jobs.size(); ++i)
	{%>
		addJobItem("<%=jobs.get(i).CompanyName%>", "<%=jobs.get(i).Position%>", "<%=jobs.get(i).TimeSpan%>", "<%=jobs.get(i).Description%>");
	<%}%>
	<%for (int i = 0; i < eduExperiences.size(); ++i)
	{%>
		addEduItem("<%=eduExperiences.get(i).SchoolName%>", "<%=eduExperiences.get(i).GraduationTime%>", "<%=eduExperiences.get(i).Degree%>", "<%=eduExperiences.get(i).Description%>");
	<%}%>
}

window.onload = function()
{
	var li = document.getElementsByTagName("li");
	var isSkillCloned = false;
	var isProjCloned = false;
	var isJobCloned = false;
	var isEduCloned = false;
	
	/*
	addSkillItem("Coding", "expert");
	addProjectItem("C++", "2014-2015", "Good!");
	addJobItem("C++ programmer", "CTO", "2014-2015", "Good!");
	addEduItem("SYSU", "2016", "Bachelor", "Good!");
	*/
	displayData();
}

</script>
<body>
	<form action="sheet.jsp" method="post" onsubmit="return validate(this)">
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