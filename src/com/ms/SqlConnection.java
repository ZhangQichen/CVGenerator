package com.ms;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class SqlConnection {
	private Connection conn;
	
	protected SqlConnection() {}
	
	public static SqlConnection OpenConnection()
	{
		SqlConnection sqlCon = new SqlConnection();
		sqlCon.connect();
		return sqlCon;
	}

	protected boolean connect() {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://202.116.76.22:3306/db12348151", "user", "123456");
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public void disconnect() {
		try {
			if (conn.isClosed())
				return;
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void ExcuteUpdate(String sqlSentence) {
		Statement stat;
		try {
			stat = conn.createStatement();
			stat.executeUpdate("SET SQL_SAFE_UPDATES=0");
			stat.executeUpdate(sqlSentence);
			stat.executeUpdate("SET SQL_SAFE_UPDATES=1");
			stat.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public ResultSet ExecuteQuery(String sqlSentence) {
		Statement stat;
		ResultSet rs = null;
		try {
			stat = conn.createStatement();
			rs = stat.executeQuery(sqlSentence);
		} catch (Exception e) {
		}
		return rs;
	}

}