package com.ms;

import java.sql.ResultSet;
import java.util.ArrayList;

import cvGenerator.EduExperience;

public class MySql_Edu {
	String msg = "";

	public boolean insert(int id, EduExperience edu) {
		Sql_c.connect();
		try {
			String sqlSentence = "select * from person_edu where person_id='" + id + "'";
			ResultSet rs = Sql_c.ExecuteQuery(sqlSentence);
			if (rs.next()) {
				sqlSentence = "update person_edu set school_name='" + edu.get(1) + "' where person_id='" + id +"'";
				Sql_c.ExcuteUpdate(sqlSentence);
				sqlSentence = "update person_edu set degree='" + edu.get(2) + "' where person_id='" + id +"'";
				Sql_c.ExcuteUpdate(sqlSentence);
				sqlSentence = "update person_edur set description='" + edu.get(3) + "' where person_id='" + id +"'";
				Sql_c.ExcuteUpdate(sqlSentence);
				sqlSentence = "update person_edu set time='" + edu.get(4) + "' where person_id='" + id +"'";
				Sql_c.ExcuteUpdate(sqlSentence);
				msg = "Update Succed!";
			} else {
				sqlSentence = "insert into person_edu(person_id, school_name, degree, description, time) values('" + id
						+ "','" + edu.get(1) + "','" + edu.get(2) + "','" + edu.get(3) + "','" + edu.get(4) + "')";
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

	public ArrayList<EduExperience> fetch(String condition) throws Exception {
		ArrayList<EduExperience> edus = new ArrayList<EduExperience>();
		Sql_c.connect();
		String sqlSentence = String.format("select * from person %s",
				(condition.isEmpty()) ? "" : " where " + condition);
		ResultSet rs = Sql_c.ExecuteQuery(sqlSentence);
		while (rs != null && rs.next()) {
			edus.add(new EduExperience(rs.getString("school_name"), rs.getString("degree"), rs.getString("description"),
					rs.getString("time")));
		}
		Sql_c.disconnect();
		return edus;
	}

	public String getMessage() {
		return msg;
	}
}
