package cvGenerator;

public class Skill {
	public String Name;
	public String Level;
	public Skill(String name, String level)
	{
		Name = name;
		Level = level;
	}
	
	@Override
	public String toString()
	{
		return String.format("Skill: %s\nLevel: %s\n", Name, Level);
	}
}