#!/usr/bin/env bash

while getopts v: option
do
case "${option}"
in
v) VERSION=${OPTARG};;
esac
done

rm -rf build/*

npm run build

echo "zipping lambdas..."
cd build/
mkdir zip

zip zip/rssPoll.zip rssPoll.js
zip zip/updateArticlesInDatabase.zip updateArticlesInDatabase.js
zip zip/register.zip register.js
zip zip/root.zip root.js
zip zip/articles.zip articles.js

cd zip/

echo "uploading lambda source to s3"

aws s3 cp rssPoll.zip s3://illiniboard/v${VERSION}/rssPoll.zip --profile burke02
aws s3 cp updateArticlesInDatabase.zip s3://illiniboard/v${VERSION}/updateArticlesInDatabase.zip --profile burke02
aws s3 cp register.zip s3://illiniboard/v${VERSION}/registerNewExtension.zip --profile burke02
aws s3 cp root.zip s3://illiniboard/v${VERSION}/root.zip --profile burke02
aws s3 cp articles.zip s3://illiniboard/v${VERSION}/articles.zip --profile burke02