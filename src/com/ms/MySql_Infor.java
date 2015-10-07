package com.ms;

import java.sql.ResultSet;
import java.util.ArrayList;

import cvGenerator.Infor;

public class MySql_Infor {
	String msg = "";

	public boolean insert(int id, Infor infor) {
		Sql_c.connect();
		try {
			String sqlSentence = "select * from person where id='" + id + "'";
			ResultSet rs = Sql_c.ExecuteQuery(sqlSentence);
			if (rs.next()) {
				sqlSentence = "update person set name='" + infor.get(1) + "' where id='" + id +"'";
				Sql_c.ExcuteUpdate(sqlSentence);
				sqlSentence = "update person set gender='" + infor.get(2) + "' where id='" + id +"'";
				Sql_c.ExcuteUpdate(sqlSentence);
				sqlSentence = "update person set email='" + infor.get(3) + "' where id='" + id +"'";
				Sql_c.ExcuteUpdate(sqlSentence);
				sqlSentence = "update person set target='" + infor.get(4) + "' where id='" + id +"'";
				Sql_c.ExcuteUpdate(sqlSentence);
				sqlSentence = "update person set phone_number='" + infor.get(5) + "' where id='" + id +"'";
				Sql_c.ExcuteUpdate(sqlSentence);
				msg = "Update Succed!";
			} else {
				sqlSentence = "insert into person(name, gender, email, target, phone_number) values('" + infor.get(1)
						+ "','" + infor.get(2) + "','" + infor.get(3) + "','" + infor.get(4) + "','" + infor.get(5)
						+ "')";
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

	public ArrayList<Infor> fetch(String condition) throws Exception {
		ArrayList<Infor> infors = new ArrayList<Infor>();
		Sql_c.connect();
		String sqlSentence = String.format("select * from person %s",
				(condition.isEmpty()) ? "" : " where " + condition);
		ResultSet rs = Sql_c.ExecuteQuery(sqlSentence);
		while (rs != null && rs.next()) {
			infors.add(new Infor(rs.getString("name"), rs.getString("gender"), rs.getString("eamil"),
					rs.getString("target"), rs.getString("phone_number")));
		}
		Sql_c.disconnect();
		return infors;
	}

	public String getMessage() {
		return msg;
	}
}
