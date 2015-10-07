package cvGenerator;
import java.util.*;
import com.ms.*;
import java.sql.*;

public class DBOperator {
	public static void OpenDB()
	{
		//
	}
	
	public static void CloseDB()
	{
		//
	}
	
	public static String GetOrCreateId(String name, String gender, String email)
	{
		String id = "";
		ResultSet rSet = Sql_c.ExecuteQuery(String.format("select id from person where name = '%s' and gender = '%s' and email = '%s'", name, gender, email));
		try {
			if (rSet.next())
			{
				return rSet.getString("id");
			}
			else
			{
				Sql_c.ExcuteUpdate(String.format("insert into person(name, gender, email) values(%s,%s,%s)", name, gender, email));
				rSet = Sql_c.ExecuteQuery(String.format("select id from person where name = '%s' and gender = '%s' and email = '%s'", name, gender, email));
				rSet.next();
				return rSet.getString("id");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return id;
	}
	
	public static Person RetrievePersonInfo(String person_id)
	{
		Person result = new Person();
		/*
		ResultSet rSet = Sql_c.ExecuteQuery(String.format("select * from person where id=%s", person_id));
		try {
			rSet.next();
			result.Id = person_id;
			result.Email = rSet.getString("email");
			result.Gender = rSet.getString("gender");
			result.Name = rSet.getString("name");
			result.PhoneNumber = rSet.getString("phone_number");
			result.Target = rSet.getString("target");
		} catch (SQLException e) {
			e.printStackTrace();
		}*/
		
		return result;
	}
	
	public static ArrayList<Skill> RetrieveSkills(String person_id)
	{
		ArrayList<Skill> result = new ArrayList<>();
		
		return result;
	}
	
	public static ArrayList<Project> RetrieveProjects(String person_id)
	{
		ArrayList<Project> result = new ArrayList<>();
		return result;
	}
	
	public static ArrayList<Job> RetrieveJobs(String person_id)
	{
		ArrayList<Job> result = new ArrayList<>();
		return result;
	}
	
	public static ArrayList<EduExperience> RetrieveEduExperiences(String person_id)
	{
		ArrayList<EduExperience> result = new ArrayList<>();
		return result;
	}
	
	public static void AlterTarget(String person_id, String newTarget)
	{
		
	}
	
	public static void AlterPhoneNumber(String person_id, String newPhoneNumber)
	{
		
	}
	
	public static void AlterSkills(String person_id, List<Skill> skills)
	{
		
	}
	
	public static void AlterProjects(String person_id, List<Project> projects)
	{
		
	}
	
	public static void AlterJobs(String person_id, List<Job> jobs)
	{
		
	}
	
	public static void AlterEdu(String person_id, List<EduExperience> eduExperiences)
	{
		
	}
}
