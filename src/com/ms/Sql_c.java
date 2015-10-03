package com.ms;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Sql_c {
	static private Connection conn;

	public static boolean connect() {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://202.116.76.22/db_cvgenerator", "user", "123456");
			return true;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		return false;
	}

	public static void disconnect() {
		try {
			if (conn.isClosed())
				return;
			conn.close();
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}

	public static void ExcuteUpdate(String sqlSentence) {
		Statement stat;
		try {
			stat = conn.createStatement();
			stat.executeUpdate(sqlSentence);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}

	public static ResultSet ExecuteQuery(String sqlSentence) {
		Statement stat;
		ResultSet rs = null;
		try {
			stat = conn.createStatement();
			rs = stat.executeQuery(sqlSentence);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		return rs;
	}

}