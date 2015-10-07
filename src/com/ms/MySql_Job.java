package com.ms;

import java.sql.ResultSet;
import java.util.ArrayList;

import cvGenerator.Job;

public class MySql_Job {
	String msg = "";

	public boolean insert(int id, Job job) {
		Sql_c.connect();
		try {
			String sqlSentence = "select * from person_job where id='" + id + "'";
			ResultSet rs = Sql_c.ExecuteQuery(sqlSentence);
			if (rs.next()) {
				msg = "id exists!";
			} else {
				sqlSentence = "insert into person_job(person_id, company_name, time, position, description) values('"
						+ id + "','" + job.get(1) + "','" + job.get(2) + "','" + job.get(3) + "','" + job.get(4) + "')";
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

	public ArrayList<Job> fetch(String condition) throws Exception {
		ArrayList<Job> jobs = new ArrayList<Job>();
		Sql_c.connect();
		String sqlSentence = String.format("select * from person %s",
				(condition.isEmpty()) ? "" : " where " + condition);
		ResultSet rs = Sql_c.ExecuteQuery(sqlSentence);
		while (rs != null && rs.next()) {
			jobs.add(new Job(rs.getString("company_name"), rs.getString("position"), rs.getString("time"),
					rs.getString("description")));
		}
		Sql_c.disconnect();
		return jobs;
	}

	public String getMessage() {
		return msg;
	}
}
