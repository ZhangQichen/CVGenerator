package cvGenerator;

public class Project {
	public String Name;
	public String TimeSpan;
	public String Description;
	
	public Project(String name, String timespan, String description)
	{
		this.Name = name;
		this.TimeSpan = timespan;
		this.Description = description;
	}
	
	@Override
	public String toString()
	{
		return String.format("Project name: %s\nTime: %s\nDescription:%s", Name, TimeSpan, Description);
	}
}
