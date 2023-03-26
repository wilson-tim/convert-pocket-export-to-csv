import csv
import datetime
from bs4 import BeautifulSoup

def write_to_csv(csvfile, list_input):

	try:
		with open(csvfile, "a", newline='') as fopen:
			csv_writer = csv.writer(fopen, quoting=csv.QUOTE_ALL)
			csv_writer.writerow(list_input)

	except:
		return False

def extract(sourcefile, csvfile):

	try:
		with open(sourcefile, encoding='utf-8', errors='ignore') as fp:
			soup = BeautifulSoup(fp, "html.parser")

			links = soup.find_all("li")

			for link in links:
				href = link.find("a")["href"]
				time_added = int(link.find("a")["time_added"])
				time_added_conv = datetime.datetime.fromtimestamp(time_added).strftime('%Y-%m-%d %H:%M:%S')
				tags = link.find("a")["tags"].replace(",", "|")
				title = link.a.text
				write_to_csv(csvfile, [time_added_conv, title, tags, href])
		return True

	except Exception as e:
		return e

if __name__ == "__main__":
	sourcefile = "pocket_export.html"
	csvfile = "pocket_export.csv"
	file_to_delete = open(csvfile,'w')
	file_to_delete.close()
	result = extract(sourcefile, csvfile)
	if result == True:
		print("All done")
	else:
		print(f"Something went wrong - {result}")
