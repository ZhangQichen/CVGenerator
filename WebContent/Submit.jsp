<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=utf-8" import="java.util.ArrayList, cvGenerator.*, java.io.*"
    pageEncoding="utf-8"%>
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
	System.out.print("submit2");
	// Get id from DB for this user. Create one id if such user does not exist.
	userId = DBOperator.GetOrCreateId(username, gender, email);
	// Store the submited information to the DB asynchronously.
	Person newInfo = new Person();
	newInfo.Email = email; newInfo.Gender = gender;
	newInfo.Id = userId; newInfo.Name = username;
	newInfo.PhoneNumber = phoneNumber; newInfo.Target = target;
	DBOperator.AlterInfo(userId, newInfo);
	DBOperator.AlterSkills(userId, skills);
	DBOperator.AlterProjects(userId, projects);
	DBOperator.AlterJobs(userId, jobs);
	DBOperator.AlterEdu(userId, eduExperiences);
	System.out.print("submit333");
	// Store Cookies
	Cookie cookie_id = new Cookie(Config.Keys.ID, userId);
	cookie_id.setPath("/");
	cookie_id.setMaxAge(3600*5);
	response.addCookie(cookie_id);
	
	Cookie cookie_username = new Cookie(Config.Keys.NAME, URLEncoder.encode(username, "utf-8"));
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
	// Generate doc
	EduExperience[] e = new EduExperience[eduExperiences.size()];
	Job[] j = new Job[jobs.size()];
	Project[] p = new Project[projects.size()];
	Skill[] s = new Skill[skills.size()];
	eduExperiences.toArray(e);
	jobs.toArray(j);
	projects.toArray(p);
	skills.toArray(s);
	
	String filepath = application.getRealPath("/file");
	
	PoiOutput poiOutput = new PoiOutput(newInfo, e,j,p,s, filepath);
	filepath = poiOutput.generate();
	response.setHeader("Content-disposition", "attachment; filename=\"" + "CV.docx" + "\"");
	response.setHeader("Content-Encoding", "utf-8");
	WriteFile(response.getOutputStream(), filepath);
}
//response.sendRedirect("index.jsp?time=%d" + System.nanoTime());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>提交信息</title>
</head>
<body>

</body>
</html>