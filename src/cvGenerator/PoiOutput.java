package cvGenerator;

import java.io.FileOutputStream;
import java.io.OutputStream;
import java.math.BigInteger;
import java.util.*;
import java.util.Map;
import java.io.*;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.*;

import org.apache.poi.xwpf.usermodel.ParagraphAlignment;
import org.apache.poi.xwpf.usermodel.UnderlinePatterns;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableCell;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblBorders;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STBorder;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STMerge;

import cvGenerator.EduExperience;
import cvGenerator.Job;
import cvGenerator.Person;
import cvGenerator.Project;
import cvGenerator.Skill;

public class PoiOutput {
	private Person person;
	private EduExperience[] edus;
	private Job[] jobs;
	private Project[] projects;
	private Skill[] skills;

	private String edu = "";
	private String job = "";
	private String project = "";
	private String skill = "";
	private String outputPath;

	private final String headColor = "5f9ea0";
	private final String borderColor = "00578a";
	private final String titleColor = "638fba";

	public PoiOutput() {
	}

	public PoiOutput(Person person, EduExperience[] edus, Job[] jobs, Project[] projects, Skill[] skills, String filepath) {
		this.person = person;
		this.edus = edus;
		this.jobs = jobs;
		this.projects = projects;
		this.skills = skills;
		outputPath = filepath;
	}

	// Return the filepath of generated file.
	public String generate() {
		for (int i = 0; i < edus.length; i++) {
			edu += (edus[i].toString() + "\r");
		}
		for (int i = 0; i < jobs.length; i++)
			job += (jobs[i].toString() + '\n');
		for (int i = 0; i < projects.length; i++)
			project += (projects[i].toString() + '\n');
		for (int i = 0; i < skills.length; i++)
			skill += (skills[i].toString() + '\n');
		System.out.println("run");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("job", job);
		params.put("education", edu);
		params.put("project", project);
		params.put("skill", skill);
		XWPFDocument doc = createDoc();
		try {
			System.out.println("run");
			System.out.println("run");
			File file = new File(outputPath);
			if (!file.exists())
				file.mkdir();
			OutputStream os = new FileOutputStream(outputPath + "\\" +person.Name + ".docx");
			doc.write(os);
			os.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return outputPath + "\\" +person.Name + ".docx";
	}

	public XWPFTable createTable(XWPFDocument xdoc, int rowSize, int cellSize, boolean isSetColWidth, int[] colWidths) {
		XWPFTable table = xdoc.createTable(rowSize, cellSize);
		for (int i = 0; i < table.getNumberOfRows(); i++) {
			XWPFTableRow row = table.getRow(i);
			int numCells = row.getTableCells().size();
			for (int j = 0; j < numCells; j++) {
				XWPFTableCell cell = row.getCell(j);
				cell.getCTTc().addNewTcPr().addNewTcW().setW(BigInteger.valueOf(colWidths[j]));
			}
		}
		return table;
	}

	private XWPFDocument createDoc() {
		XWPFDocument doc = new XWPFDocument();
		XWPFParagraph para = doc.createParagraph();
		para.setAlignment(ParagraphAlignment.RIGHT);
		XWPFRun run = para.createRun();
		run.setText(person.PhoneNumber);
		run.addBreak();
		run.setText(person.Id);
		run.addBreak();
		run = para.createRun();
		run.setUnderline(UnderlinePatterns.SINGLE);
		run.setText(person.Email);
		run = para.createRun();
		
		int []colWidths = {1500, 4500};
/*		int extra = 0;
		if (edus.length == 0) extra ++;
		if (jobs.length == 0) extra ++;
		if (projects.length == 0) extra ++;
		if (skills.length == 0) extra ++;*/
		int height = edus.length + jobs.length + projects.length + skills.length + 1 + 1 ;		
	//	XWPFTable table = doc.createTable(height, 2);
		XWPFTable table = createTable(doc, height, 2, true, colWidths);
		table.setCellMargins(200, 20, 200, 80);
		CTTblWidth width = table.getCTTbl().addNewTblPr().addNewTblW();
		width.setType(STTblWidth.PCT);
		width.setW(BigInteger.valueOf(5000));

		CTTblBorders borders = table.getCTTbl().getTblPr().addNewTblBorders();
		org.openxmlformats.schemas.wordprocessingml.x2006.main.CTBorder hBorder = borders.addNewInsideH();
		hBorder.setVal(STBorder.Enum.forString("thick"));
		hBorder.setSz(new BigInteger("1"));
		hBorder.setColor(borderColor);

		org.openxmlformats.schemas.wordprocessingml.x2006.main.CTBorder vBorder = borders.addNewInsideV();
		vBorder.setVal(STBorder.Enum.forString("none"));
		vBorder.setSz(new BigInteger("1"));
		vBorder.setColor("00FF00");

		org.openxmlformats.schemas.wordprocessingml.x2006.main.CTBorder lBorder = borders.addNewLeft();
		lBorder.setVal(STBorder.Enum.forString("none"));
		lBorder.setSz(new BigInteger("1"));
		lBorder.setColor("3399FF");

		org.openxmlformats.schemas.wordprocessingml.x2006.main.CTBorder rBorder = borders.addNewRight();
		rBorder.setVal(STBorder.Enum.forString("none"));
		rBorder.setSz(new BigInteger("1"));
		rBorder.setColor("F2B11F");

		org.openxmlformats.schemas.wordprocessingml.x2006.main.CTBorder tBorder = borders.addNewTop();
		tBorder.setVal(STBorder.Enum.forString("none"));
		tBorder.setSz(new BigInteger("1"));
		tBorder.setColor("C3599D");

		org.openxmlformats.schemas.wordprocessingml.x2006.main.CTBorder bBorder = borders.addNewBottom();
		bBorder.setVal(STBorder.Enum.forString("none"));
		bBorder.setSz(new BigInteger("1"));
		bBorder.setColor("F7E415");

		mergeCellsHorizontal(table, 0, 0, 1);
		mergeCellsVertically(table, 0, 2, edus.length + 1);
		mergeCellsVertically(table, 0, 2 + edus.length, edus.length + jobs.length + 1);
		mergeCellsVertically(table, 0, 2 + edus.length + jobs.length, edus.length + jobs.length + projects.length + 1);
		mergeCellsVertically(table, 0, 2 + edus.length + jobs.length + projects.length,
				edus.length + jobs.length + projects.length + skills.length + 1);

		List<XWPFTableRow> rows = table.getRows();
		int rowIndex = 0;
		XWPFTableRow row = rows.get(rowIndex);

		para = new XWPFDocument().createParagraph();
		para.setAlignment(ParagraphAlignment.LEFT);
		para.setIndentFromLeft(200);
		run = para.createRun();
		run.setBold(true);
		run.setColor("ffffff");
		run.setFontSize(20);
		run.setText(person.Name);
		row = rows.get(rowIndex);
		XWPFTableCell cell = row.getCell(0);
		cell.setColor(titleColor);
		cell.setParagraph(para);
		rowIndex++;

		para = new XWPFDocument().createParagraph();
		para.setAlignment(ParagraphAlignment.RIGHT);
		para.setIndentFromRight(700);
		run = para.createRun();
		run.setBold(true);
		run.setColor(headColor);
		run.setText("Target");
		row = rows.get(rowIndex);
		cell = row.getCell(0);
		cell.setParagraph(para);
		row.getCell(1).setText(person.Target);
		rowIndex++;

		if (jobs.length == 0 && skills.length == 0 && edus.length == 0 && projects.length == 0) return doc;
		para = new XWPFDocument().createParagraph();
		para.setAlignment(ParagraphAlignment.RIGHT);
		para.setIndentFromRight(700);
		run.addBreak();
		run = para.createRun();
		run.setBold(true);
		run.setColor(headColor);
		run.setText("Education");
		row = rows.get(rowIndex);
		cell = row.getCell(0);
		cell.setParagraph(para);

		for (int i = 0; i < edus.length; i++) {
			para = new XWPFDocument().createParagraph();
			para.setAlignment(ParagraphAlignment.LEFT);
			String element[] = edus[i].toString().split("\n");
			for (int j = 0; j < element.length; j++) {
				run = para.createRun();
				String[] str = element[j].split(":");
				run.setBold(true);
				run.setText(str[0] + ":");
				run = para.createRun();
				if (str[0].equals("Description")) {
					run.addBreak();
					run.addTab();
				}
				run.setText(str[1]);
				if (j != element.length - 1)
					run.addBreak();
			}
			row = rows.get(rowIndex);
			rowIndex++;
			cell = row.getCell(1);
			cell.setParagraph(para);
		}

		if (jobs.length == 0 && skills.length == 0 && projects.length == 0) return doc;
		para = new XWPFDocument().createParagraph();
		para.setAlignment(ParagraphAlignment.RIGHT);
		para.setIndentFromRight(700);
		run = para.createRun();
		run.setBold(true);
		run.setColor(headColor);
		run.setText("Jobs");
		row = rows.get(rowIndex);
		cell = row.getCell(0);
		cell.setParagraph(para);
		for (int i = 0; i < jobs.length; i++) {
			para = new XWPFDocument().createParagraph();
			para.setAlignment(ParagraphAlignment.LEFT);
			String element[] = jobs[i].toString().split("\n");
			for (int j = 0; j < element.length; j++) {
				run = para.createRun();
				String[] str = element[j].split(":");
				run.setBold(true);

				run.setText(str[0] + ":");
				run = para.createRun();
				if (str[0].equals("Description")) {
					run.addBreak();
					run.addTab();
				}
				run.setText(str[1]);
				if (j != element.length - 1)
					run.addBreak();
			}
			row = rows.get(rowIndex);
			rowIndex++;
			cell = row.getCell(1);
			cell.setParagraph(para);
		}
		if (skills.length == 0 && projects.length == 0) return doc;
		para = new XWPFDocument().createParagraph();
		para.setAlignment(ParagraphAlignment.RIGHT);
		para.setIndentFromRight(700);
		run = para.createRun();
		run.setBold(true);
		run.setColor(headColor);
		run.setText("Project");
		row = rows.get(rowIndex);
		cell = row.getCell(0);
		cell.setParagraph(para);
		for (int i = 0; i < projects.length; i++) {
			para = new XWPFDocument().createParagraph();
			para.setAlignment(ParagraphAlignment.LEFT);
			String element[] = projects[i].toString().split("\n");
			for (int j = 0; j < element.length; j++) {
				run = para.createRun();
				String[] str = element[j].split(":");
				run.setBold(true);
				run.setText(str[0] + ":");
				run = para.createRun();
				if (str[0].equals("Description")) {
					run.addBreak();
					run.addTab();
				}
				run.setText(str[1]);
				if (j != element.length - 1)
					run.addBreak();
			}
			row = rows.get(rowIndex);
			rowIndex++;
			cell = row.getCell(1);
			cell.setParagraph(para);
		}

		if (skills.length == 0) return doc;
		para = new XWPFDocument().createParagraph();
		para.setAlignment(ParagraphAlignment.RIGHT);
		para.setIndentFromRight(700);
		run = para.createRun();
		run.setBold(true);
		run.setColor(headColor);
		run.setText("Skills");
		row = rows.get(rowIndex);
		cell = row.getCell(0);
		cell.setParagraph(para);
		for (int i = 0; i < skills.length; i++) {
			para = new XWPFDocument().createParagraph();
			para.setAlignment(ParagraphAlignment.LEFT);
			String element[] = skills[i].toString().split("\n");
			for (int j = 0; j < element.length; j++) {
				run = para.createRun();
				String[] str = element[j].split(":");
				run.setBold(true);
				run.setText(str[0] + ":");
				run = para.createRun();
				if (str[0].equals("Description")) {
					run.addBreak();
					run.addTab();
				}
				run.setText(str[1]);
				if (j != element.length - 1)
					run.addBreak();
			}
			row = rows.get(rowIndex);
			rowIndex++;
			cell = row.getCell(1);
			cell.setParagraph(para);
		}

		return doc;
	}

	public void mergeCellsVertically(XWPFTable table, int col, int fromRow, int toRow) {
		for (int rowIndex = fromRow; rowIndex <= toRow; rowIndex++) {
			XWPFTableCell cell = table.getRow(rowIndex).getCell(col);
			if (rowIndex == fromRow) {
				// The first merged cell is set with RESTART merge value
				cell.getCTTc().addNewTcPr().addNewVMerge().setVal(STMerge.RESTART);
			} else {
				// Cells which join (merge) the first one, are set with CONTINUE
				cell.getCTTc().addNewTcPr().addNewVMerge().setVal(STMerge.CONTINUE);
			}
		}
	}

	public void mergeCellsHorizontal(XWPFTable table, int row, int fromCell, int toCell) {
		for (int cellIndex = fromCell; cellIndex <= toCell; cellIndex++) {
			XWPFTableCell cell = table.getRow(row).getCell(cellIndex);
			if (cellIndex == fromCell) {
				// The first merged cell is set with RESTART merge value
				cell.getCTTc().addNewTcPr().addNewHMerge().setVal(STMerge.RESTART);
			} else {
				// Cells which join (merge) the first one, are set with CONTINUE
				cell.getCTTc().addNewTcPr().addNewHMerge().setVal(STMerge.CONTINUE);
			}
		}
	}
}
