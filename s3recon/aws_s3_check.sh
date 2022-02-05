#!/bin/bash


bucket_name() {
    # aws checks
    ## ls
    echo -e "aws s3 ls s3://$1"
    aws s3 ls s3://$1
    ## mv
    echo "aws s3 mv test.txt s3://$1"
    echo "test" > test.txt
    aws s3 mv test.txt s3://$1
}

bucket_file() {
    # aws checks on file containing bucket names
    cat $1 | while read bucket
    do
       echo -e "$bucket:ls"
       aws s3 ls s3://$bucket
       echo "test" > test.txt
       echo -e "$bucket: move"
       aws s3 mv test.txt s3://$bucket
   done
}

if [[ -f $1 ]]
then
    echo "file"
    bucket_file $1
elif [[ ! -f $1 ]]
then
    echo "data"
    bucket_name $1
fi

rm test.txt
