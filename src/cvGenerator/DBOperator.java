package cvGenerator;
import java.util.*;
import com.ms.*;
import java.sql.*;

public class DBOperator {
	
	public static String GetOrCreateId(String name, String gender, String email)
	{
		String id = "";
		SqlConnection connection = SqlConnection.OpenConnection();
		ResultSet rSet = connection.ExecuteQuery(String.format("select id from person where name = '%s' and gender = '%s' and email = '%s'", name, gender, email));
		try {
			if (rSet.next())
			{
				id = rSet.getString("id");
				connection.disconnect();
			}
			else
			{
				connection.ExcuteUpdate(String.format("insert into person(name, gender, email) values('%s','%s','%s')", name, gender, email));
				rSet = connection.ExecuteQuery(String.format("select id from person where name = '%s' and gender = '%s' and email = '%s'", name, gender, email));
				rSet.next();
				id = rSet.getString("id");
				connection.disconnect();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		connection.disconnect();
		return id;
	}
	
	public static Person RetrievePersonInfo(String person_id)
	{
		if (person_id == null || person_id == "") return new Person();
		Person result = new Person();
		result.Id = person_id;
		SqlConnection connection = SqlConnection.OpenConnection();
		ResultSet rSet = connection.ExecuteQuery(String.format("select * from person where id = %s", person_id));
		try {
			if (rSet.next());
			{
				result.Email = rSet.getString("email");
				result.Gender = rSet.getString("gender");
				result.Name = rSet.getString("name");
				result.PhoneNumber = rSet.getString("phone_number");
				result.Target = rSet.getString("target");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		connection.disconnect();
		return result;
	}
	
	public static ArrayList<Skill> RetrieveSkills(String person_id)
	{
		ArrayList<Skill> result = new ArrayList<>();
		SqlConnection connection = SqlConnection.OpenConnection();
		try {
			ResultSet rSet = connection.ExecuteQuery(String.format("select * from person_skill where person_id=%s", person_id));
			while (rSet.next())
			{
				result.add(new Skill(rSet.getString("skill_name"), rSet.getString("level")));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		connection.disconnect();;
		return result;
	}
	
	public static ArrayList<Project> RetrieveProjects(String person_id)
	{
		ArrayList<Project> result = new ArrayList<>();
		SqlConnection connection = SqlConnection.OpenConnection();
		try {
			ResultSet rSet = connection.ExecuteQuery(String.format("select * from person_project where person_id=%s", person_id));
			while (rSet.next())
			{
				result.add(new Project(rSet.getString("project_name"), rSet.getString("time"), rSet.getString("description")));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		connection.disconnect();;
		return result;
	}
	
	public static ArrayList<Job> RetrieveJobs(String person_id)
	{
		ArrayList<Job> result = new ArrayList<>();
		SqlConnection connection = SqlConnection.OpenConnection();
		try {
			ResultSet rSet = connection.ExecuteQuery(String.format("select * from person_job where person_id=%s", person_id));
			while (rSet.next())
			{
				result.add(new Job(rSet.getString("company_name"), rSet.getString("position"), rSet.getString("time"), rSet.getString("description")));
				System.out.println(result.get(result.size()-1).toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		connection.disconnect();;
		return result;
	}
	
	public static ArrayList<EduExperience> RetrieveEduExperiences(String person_id)
	{
		ArrayList<EduExperience> result = new ArrayList<>();
		SqlConnection connection = SqlConnection.OpenConnection();
		try {
			ResultSet rSet = connection.ExecuteQuery(String.format("select * from person_edu where person_id=%s", person_id));
			while (rSet.next())
			{
				result.add(new EduExperience(rSet.getString("school_name"), rSet.getString("time"), rSet.getString("degree"), rSet.getString("description")));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		connection.disconnect();
		return result;
	}
	
	public static void AlterInfo(String person_id, Person newInfo)
	{
		System.out.println(person_id);
		SqlConnection connection = SqlConnection.OpenConnection();
		System.out.println("Connected to DB");
		connection.ExcuteUpdate(String.format("update person set name ='%s', gender='%s', email='%s', target='%s', phone_number='%s' where id=%s", newInfo.Name, newInfo.Gender, newInfo.Email, newInfo.Target, newInfo.PhoneNumber, person_id));
		System.out.println("Complete Query");
		connection.disconnect();
		System.out.println("Disconnected to DB");
	}
	
	public static void AlterSkills(String person_id, List<Skill> skills)
	{
		SqlConnection connection = SqlConnection.OpenConnection();
		connection.ExcuteUpdate(String.format("delete from person_skill where person_id = %s", person_id));
		for (Skill skill : skills) {
			connection.ExcuteUpdate(String.format("insert into person_skill(person_id, skill_name, level) values(%s,'%s','%s')", person_id, skill.Name, skill.Level));
		}
		connection.disconnect();
	}
	
	public static void AlterProjects(String person_id, List<Project> projects)
	{
		SqlConnection connection = SqlConnection.OpenConnection();
		connection.ExcuteUpdate(String.format("delete from person_project where person_id = %s", person_id));
		for (Project project : projects) {
			connection.ExcuteUpdate(String.format("insert into person_project(person_id, project_name, time, description) values(%s,'%s','%s','%s')", person_id, project.Name, project.TimeSpan, project.Description));
		}
		connection.disconnect();
	}
	
	public static void AlterJobs(String person_id, List<Job> jobs)
	{
		SqlConnection connection = SqlConnection.OpenConnection();
		connection.ExcuteUpdate(String.format("delete from person_job where person_id = %s", person_id));
		for (Job job : jobs) {
			connection.ExcuteUpdate(String.format("insert into person_job(person_id, company_name, time, position, description) values(%s,'%s','%s','%s','%s')", person_id, job.CompanyName, job.TimeSpan, job.Position, job.Description));
		}
		connection.disconnect();
	}
	
	public static void AlterEdu(String person_id, List<EduExperience> eduExperiences)
	{
		SqlConnection connection = SqlConnection.OpenConnection();
		connection.ExcuteUpdate(String.format("delete from person_edu where person_id = %s", person_id));
		for (EduExperience eduExperience : eduExperiences) {
			connection.ExcuteUpdate(String.format("insert into person_edu(person_id, school_name, degree, description, time) values(%s,'%s','%s','%s','%s')", person_id, eduExperience.SchoolName, eduExperience.Degree, eduExperience.Description, eduExperience.GraduationTime));
		}
		connection.disconnect();
	}
}
