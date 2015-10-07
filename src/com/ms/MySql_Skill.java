package com.ms;

import java.sql.ResultSet;
import java.util.ArrayList;

import cvGenerator.Skill;

public class MySql_Skill {
	String msg = "";

	public boolean insert(int id, Skill skill) {
		Sql_c.connect();
		try {
			String sqlSentence = "select * from person_skill where id='" + id + "'";
			ResultSet rs = Sql_c.ExecuteQuery(sqlSentence);
			if (rs.next()) {
				msg = "id exists!";
			} else {
				sqlSentence = "insert into person_skill(person_id, skill_name, level) values('"
						+ id + "','" + skill.get_name() + "','" + skill.get_level() + "')";
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

	public ArrayList<Skill> fetch(String condition) throws Exception {
		ArrayList<Skill> skills = new ArrayList<Skill>();
		Sql_c.connect();
		String sqlSentence = String.format("select * from person %s",
				(condition.isEmpty()) ? "" : " where " + condition);
		ResultSet rs = Sql_c.ExecuteQuery(sqlSentence);
		while (rs != null && rs.next()) {
			skills.add(new Skill(rs.getString("skill_name"), rs.getString("level")));
		}
		Sql_c.disconnect();
		return skills;
	}

	public String getMessage() {
		return msg;
	}
}
