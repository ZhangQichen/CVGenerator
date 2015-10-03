package cvGenerator;

public class EduExperience {
	public String SchoolName;
	public String GraduationTime;
	public String Degree;
	public String Description;
	
	public EduExperience(String schoolName, String graduationTime, String degree, String description)
	{
		this.SchoolName = schoolName;
		this.GraduationTime = graduationTime;
		this.Degree = degree;
		this.Description = description;
	}
	
	public String get(int i) {
		switch(i) {
			case 1:
				return SchoolName;
			case 2:
				return Degree;
			case 3:
				return Description;
			case 4:
				return GraduationTime;
			default:
				break;
		}
		return "error!";
	}
	
	@Override
	public String toString()
	{
		return String.format("School name: %s\nGraduation time: %s\nDegree: %s\nDescription: %s", SchoolName, GraduationTime, Degree, Description);
	}
}
