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

	@Override
	public String toString() {
		return String.format("Company: %s\nPosition: %s\nTime: %s\nDescription: %s\n", CompanyName, Position, TimeSpan,
				Description);
	}
}