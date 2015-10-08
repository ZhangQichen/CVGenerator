<%@page import="cvGenerator.*, com.google.gson.Gson"%>
<%@ page language="java" contentType="application/json; charset=utf-8"
    pageEncoding="utf-8" import="java.util.*"%>
<%
request.setCharacterEncoding("utf-8");
String id = request.getParameter("id");
System.out.println("getJobs.jsp?id=" + id);
if (id == null || id == "") return;
ArrayList<Job> jobs = DBOperator.RetrieveJobs(id);
System.out.println("jobnum: " + jobs.size());
Gson gson = new Gson();
gson.toJson(jobs, out);
%>