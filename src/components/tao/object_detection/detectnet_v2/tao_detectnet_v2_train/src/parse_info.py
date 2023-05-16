# Copyright (c) 2017-2020, NVIDIA CORPORATION.  All rights reserved.
import argparse
import re
import mlflow

def parse_args(args=None):
    """parse the arguments."""
    parser = argparse.ArgumentParser(description='Tool to get parameters and variables from train logfile and upload them as AzureML metrics')

    parser.add_argument(
        "--logfile",
        type=str,
        required=True,
        help="Full path to train logfile"
    )

    parser.add_argument(
        "--class_list",
        type=str,
        required=True,
        help="Comma separated list of classes."
    )

    parser.add_argument(
        "--num_epochs",
        type=int,
        required=True,
        help="Total Number of Epochs."
    )

    return parser.parse_args(args)

def buildRegExs(class_list,num_epochs):
    epochpattern = 'Epoch (?P<current_epoch>\d+)/{}: loss: (?P<loss>\d+\.\d+) learning rate: (?P<learning_rate>\d+\.\d+) '.format(num_epochs)
    meanavgprecpattern = 'Mean average_precision \(in %\): (?P<mean_average_precision>\d+\.\d+)'
    class_list = class_list.replace(',','|')
    classpattern = '(?P<class>{})\s+\|\s+(?P<class_precision>\d+\.\d+) '.format(class_list)
    return epochpattern, meanavgprecpattern, classpattern

def getEpochInfo(epochpattern,line,current_epoch):
    matches = re.finditer(epochpattern, line)
    for match in matches:
        current_epoch = int(match.groupdict()['current_epoch'])
        loss = float(match.groupdict()['loss'])
        mlflow.log_metric('loss', loss, step=current_epoch)
        learning_rate = float(match.groupdict()['learning_rate'])
        mlflow.log_metric('learning_rate', learning_rate, step=current_epoch)
    return current_epoch

def getClassInfo(classpattern,line,current_epoch):
    matches = re.finditer(classpattern, line)
    for match in matches:
        classs = match.groupdict()['class']
        class_precision = float(match.groupdict()['class_precision'])
        mlflow.log_metric('{}_precision'.format(classs), class_precision, step=current_epoch+1)
    return

def getAveragePrecisionInfo(meanavgprecpattern ,line,current_epoch):
    matches = re.finditer(meanavgprecpattern, line)
    for match in matches:
        mean_average_precision = float(match.groupdict()['mean_average_precision'])
        mlflow.log_metric('mean_average_precision', mean_average_precision, step=current_epoch+1)
    return

def logMetrics(logfile,class_list,num_epochs):
    epochpattern, meanavgprecpattern, classpattern = buildRegExs(class_list,num_epochs)
    logfile = open(logfile, 'r')
    lines = logfile.readlines()
    current_epoch = 0
    for line in lines:
        current_epoch = getEpochInfo(epochpattern,line,current_epoch)
        getAveragePrecisionInfo(meanavgprecpattern,line,current_epoch)
        getClassInfo(classpattern,line,current_epoch)
    return

def main(args=None):    
    args = parse_args(args)
    logfile = args.logfile
    class_list = args.class_list
    num_epochs = args.num_epochs
    logMetrics(logfile,class_list,num_epochs)

if __name__ == "__main__":
    main()