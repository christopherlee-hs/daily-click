import json
import csv

filename = "Quote_Word_Person_Fact of the Day Ideas - Quotes.csv"
path = "CSVs/" + filename

quotes = []
people = []

with open(path, "r") as csvfile:
    csvreader = csv.DictReader(csvfile)
    for row in csvreader:
        quotes.append(row["Quote"])
        people.append(row["Person"])

jsonfile = "quote_day.json"
outpath = "../" + jsonfile

def nextday(date):
    monthlengths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    if date[2] == monthlengths[date[1] - 1]:
        if (date[1] == 12):
            year = date[0] + 1
            month = 1
            day = 1
        else:
            year = date[0]
            month = date[1] + 1
            day = 1
    else:
        year = date[0]
        month = date[1]
        day = date[2] + 1
    return (year, month, day)

with open(outpath, "r") as jsonfile:
    data = json.loads(jsonfile.read())
    dates = data.keys()
    lastday = dates[len(dates) - 1]
    temp = lastday.split(" ")
    lastdayformat = [int(temp[0]), int(temp[1]), int(temp[2])]
    print(nextday([2018, 2, 28]))
    
