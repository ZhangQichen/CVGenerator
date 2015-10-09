<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=utf-8" import="java.util.*, cvGenerator.*"
    pageEncoding="utf-8"%>
<%
request.setCharacterEncoding("utf-8");
String method = request.getMethod();
System.out.println("index.jsp: method " + method);
if (method.equalsIgnoreCase("get"))
{
	out.print("<strong>正在查询请稍后...</strong>");
	Cookie[] cookies = request.getCookies();
	if (cookies == null || cookies.length == 0)
		response.sendRedirect("sheet.jsp");
	else
	{
		String id = "", name = "", gender = "", email = "";
		String cookieValue, cookieName;
		
		for(Cookie cookie : cookies)
		{
			cookieName = cookie.getName();
			cookieName = URLDecoder.decode(cookieName, "utf-8");
			cookieValue = cookie.getValue();
			if (cookieName.equals(Config.Keys.ID))
				id = cookieValue;
			if (cookieName.equals(Config.Keys.NAME))
				name = cookieValue;
			if (cookieName.equals(Config.Keys.GENDER))
				gender = cookieValue;
			if (cookieName.equals(Config.Keys.E_MAIL))
				email = cookieValue;
		}
		if (id == null || id == "")
		{
			response.sendRedirect("sheet.jsp");
			return;
		}
		String target = "", phoneNumber = "";
		// Retrieve data from DB synchronously.
		Person MyInfo = DBOperator.RetrievePersonInfo(id);
		target = MyInfo.Target;
		phoneNumber = MyInfo.PhoneNumber;
		if (target == null) target = "";
		if (phoneNumber == null) phoneNumber = "";
		// Store data into session.
		session.setAttribute(Config.Keys.PHONE_NUMBER, phoneNumber);
		session.setAttribute(Config.Keys.TARGET, target);
		response.sendRedirect(String.format("sheet.jsp?%s=%s&%s=%s&%s=%s&%s=%s&time=%d", Config.Keys.ID, id, Config.Keys.NAME, name, Config.Keys.GENDER, gender, Config.Keys.E_MAIL, email, System.nanoTime()));
	}
}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>个人简历生成</title>
</head>
<body>
</body>
</html>