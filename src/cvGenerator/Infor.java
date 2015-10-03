package cvGenerator;

public class Infor {
	private String name;
	private String gender;
	private String email;
	private String target;
	private String phone_num;

	public Infor(String name, String gender, String email, String target, String phone_num) {
		this.name = name;
		this.gender = gender;
		this.email = email;
		this.target = target;
		this.phone_num = phone_num;
	}

	public String get(int i) {
		switch (i) {
		case 1:
			return name;
		case 2:
			return gender;
		case 3:
			return email;
		case 4:
			return target;
		case 5:
			return phone_num;
		default:
			break;
		}
		return ("error!");
	}
}
