#from azure.kusto.data.request import KustoClient
#from azure.kusto.data.helpers import dataframe_from_result_table
import pandas as pd
#import numpy as np
#import matplotlib.pyplot as plt
#from urllib.parse import urlparse
#from datetime import datetime
#import numpy as np
#import docx, sys, os, argparse
#import sendmail
import csv
import sys, os, argparse

# For this POC we only care about content under 'azure'
#url_prefix = 'https://docs.microsoft.com/en-us/azure/cognitive-services/luis'


def read_doc_with_csv(args):

    print(args.file);

    filename = "freshness.csv"

    with open(filename) as csv_file:
        csv_reader = csv.DictReader(csv_file)
        line_count = 0
        for row in csv_reader:
            if line_count == 0:
                print(f'Column names are {", ".join(row)}')
                line_count += 1
            print(f'\t{row["name"]} works in the {row["department"]} department, and was born in {row["birthday month"]}.')
            line_count += 1
        print(f'Processed {line_count} lines.')

def read_doc_with_pandas(args):

    print(args.file)
    with open(args.file) as f:
        print(f)
        df = pd.read_csv(f,encoding = f.encoding)
        print("got contents")

def main(args):
    print('begin')
    current_directory = os.path.dirname(os.path.realpath(__file__))
    print(current_directory)
    read_doc_with_pandas(args)

if __name__ == "__main__":

    try:
        parser = argparse.ArgumentParser()
        parser.add_argument('-f','--file')
        parser.add_argument('-o','--output')
        args = parser.parse_args()
        main(args)

    except Exception as ex:
        print("{0.__name__}: {1}".format(type(ex), ex))
        