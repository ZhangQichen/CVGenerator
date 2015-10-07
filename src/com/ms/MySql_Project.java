package com.ms;

import java.sql.ResultSet;
import java.util.ArrayList;

import cvGenerator.Project;

public class MySql_Project {
	String msg = "";

	public boolean insert(int id, Project project) {
		Sql_c.connect();
		try {
			String sqlSentence = "select * from person_project where person_id='" + id + "'";
			ResultSet rs = Sql_c.ExecuteQuery(sqlSentence);
			if (rs.next()) {
				sqlSentence = "update person_project set project_name='" + project.get_name() + "' where person_id='" + id +"'";
				Sql_c.ExcuteUpdate(sqlSentence);
				sqlSentence = "update person_project set time='" + project.get_time() + "' where person_id='" + id +"'";
				Sql_c.ExcuteUpdate(sqlSentence);
				sqlSentence = "update person_project set description='" + project.get_des() + "' where person_id='" + id +"'";
				Sql_c.ExcuteUpdate(sqlSentence);
				msg = "Update Succed!";
			} else {
				sqlSentence = "insert into person_project(person_id, project_name, time, description) values('" + id
						+ "','" + project.get_name() + "','" + project.get_time() + "','" + project.get_des() + "')";
				Sql_c.ExcuteUpdate(sqlSentence);
				msg = "Succeed!";
			}
			rs.close();
			Sql_c.disconnect();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		return false;
	}

	public ArrayList<Project> fetch(String condition) throws Exception {
		ArrayList<Project> projects = new ArrayList<Project>();
		Sql_c.connect();
		String sqlSentence = String.format("select * from person %s",
				(condition.isEmpty()) ? "" : " where " + condition);
		ResultSet rs = Sql_c.ExecuteQuery(sqlSentence);
		while (rs != null && rs.next()) {
			projects.add(new Project(rs.getString("project_name"), rs.getString("time"), rs.getString("description")));
		}
		Sql_c.disconnect();
		return projects;
	}

	public String getMessage() {
		return msg;
	}
}
