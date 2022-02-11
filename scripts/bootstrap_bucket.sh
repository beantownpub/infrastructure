#!/bin/bash

FILE_PATH=${1}
FILE=${2}

aws-vault exec beantown -- aws s3 cp "${FILE_PATH}/${FILE}" s3://static.prod.beantownpub.com/img/logos/"${FILE}"
