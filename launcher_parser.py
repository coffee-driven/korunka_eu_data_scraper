import csv
import gzip
import json
import subprocess

RESULT_FILE = 'result.csv'

RESULT_DICT = {
    str(): list(str())
}

next_page = True
page_number = -1


def process_data(data_content):
    for result in data_content:
        date = result['date']

        timestamp = str(date)
        lucky_numbers = list(result['numbers'])

        RESULT_DICT.update({timestamp: lucky_numbers})


def write_to_csv():
    with open(RESULT_FILE, 'w', newline='') as out:
        writer = csv.writer(out, dialect='excel')
        writer.writerow(['timestamp', 'lucky number'])

        for k, v in RESULT_DICT.items():
            for number in v:
                writer.writerow([k, number])

# Main
while next_page:
    print("Running..")
    page_number += 1
    print("Pulling data")
    subprocess.run(["./puller.sh", str(page_number)])
    file_name = "korunka_data_" + str(page_number) + ".json.gz"
    with gzip.open(file_name, 'rb') as f:
        print("Loading data")
        file_content = f.read()
        data = json.loads(file_content)

        if data['next']:
            next_page = True
        else:
            next_page = False

        data_content = data['content']

        print("Processing data...")
        process_data(data_content)

print("Writing data to file: " + RESULT_FILE)
write_to_csv()
