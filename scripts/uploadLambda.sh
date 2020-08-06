#!/usr/bin/env bash

while getopts v: option
do
case "${option}"
in
v) VERSION=${OPTARG};;
esac
done

npm run build

echo "zipping lambdas..."
cd build/
zip ../rssPoll.zip rssPoll.js
zip ../updateArticlesInDatabase.zip updateArticlesInDatabase.js
zip ../register.zip register.js
zip ../root.zip root.js

cd ..

echo "uploading lambda source to s3"

aws s3 cp rssPoll.zip s3://illiniboard/v${VERSION}/rssPoll.zip --profile burke02
aws s3 cp updateArticlesInDatabase.zip s3://illiniboard/v${VERSION}/updateArticlesInDatabase.zip --profile burke02
aws s3 cp register.zip s3://illiniboard/v${VERSION}/registerNewExtension.zip --profile burke02
aws s3 cp root.zip s3://illiniboard/v${VERSION}/root.zip --profile burke02