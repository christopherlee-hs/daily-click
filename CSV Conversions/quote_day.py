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
    return [year, month, day]



with open(outpath, "r") as jsonfile:
    data = json.loads(jsonfile.read())
    dates = data.keys()
    lastday = dates[len(dates) - 1]
    temp = lastday.split(" ")
    lastdayformat = [int(temp[0]), int(temp[1]), ord(temp[2])-64]
    day = lastdayformat
    try:
        start = quotes.index(data[lastday][0]) + 1
        pass
    except:
        start = 0
        pass
    
    length = len(quotes)
    for i in range(start, length):
        day = nextday(day)
        daystring = str(day[0]) + " " + str(day[1]) + " " + chr(day[2]+64)
        data[daystring] = [quotes[i], people[i]]
    jsonout = json.dumps(data, sort_keys=True, indent=2)

with open(outpath, "w") as jsonfile:
    jsonfile.write(jsonout)
    
    
