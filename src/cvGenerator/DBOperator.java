package cvGenerator;
import java.util.*;

public class DBOperator {
	public static void OpenDB()
	{
		
	}
	
	public static void CloseDB()
	{
		
	}
	
	public static String GetOrCreateId(String name, String gender, String email)
	{
		String id = "";
		return id;
	}
	
	public static Person RetrievePersonInfo(String person_id)
	{
		Person result = new Person();
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
