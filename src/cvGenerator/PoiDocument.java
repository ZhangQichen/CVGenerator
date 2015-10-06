package cvGenerator;
import java.util.*;

public class PoiDocument {
	private String m_filepath = ""; 
	
	protected PoiDocument()
	{ }
	
	public void WriteBasicInformation(Person person)
	{
	}
	
	public void WriteSkills(List<Skill> skills)
	{
	}
	
	public void WriteProjects(List<Project> projects)
	{
	}
	
	public void WriteJobs(List<Job> jobs)
	{
	}
	
	public void WriteEduExperience(List<EduExperience> eduExperiences)
	{
	}
	
	public String CompleteDocument()
	{
		return m_filepath;
	}
	
	public static PoiDocument CreateNewDocument()
	{
		return new PoiDocument();
	}
}
