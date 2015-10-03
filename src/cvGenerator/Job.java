package cvGenerator;

public class Job {
	public String CompanyName;
	public String Position;
	public String TimeSpan;
	public String Description;

	public Job(String companyName, String position, String timespan, String description) {
		this.CompanyName = companyName;
		this.Position = position;
		this.TimeSpan = timespan;
		this.Description = description;
	}

	public String get(int i) {
		switch (i) {
		case 1:
			return CompanyName;
		case 2:
			return TimeSpan;
		case 3:
			return Position;
		case 4:
			return Description;
		default:
			break;
		}
		return "error!";
	}

	@Override
	public String toString() {
		return String.format("Company: %s\nPosition: %s\nTime: %s\nDescription: %s\n", CompanyName, Position, TimeSpan,
				Description);
	}
}