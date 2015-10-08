<%@page import="cvGenerator.*, com.google.gson.Gson"%>
<%@ page language="java" contentType="application/json; charset=utf-8"
    pageEncoding="utf-8" import="java.util.*"%>
<%
request.setCharacterEncoding("utf-8");
String id = request.getParameter("id");
System.out.println("getEdus.jsp?id=" + id);
if (id == null || id == "") return;
ArrayList<EduExperience> eduExperiences = DBOperator.RetrieveEduExperiences(id);
System.out.println("edunum: " + eduExperiences.size());
Gson gson = new Gson();
gson.toJson(eduExperiences, out);
%>