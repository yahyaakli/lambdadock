# AWS lambda docker template

This repository contains a basic template of a ubuntu docker image that could be deployed to aws lambda.

The entrypoint uses a python script with a handler function.

## Manual push your code to aws lambda

1. First, if you have't already, download AWS CLI using this guide: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

2. Then run ``` aws configure ``` to configure your local CLI environment. 

3. you need to download RIE from Github. Run the following command on your project directory:

For x86-64 architecture
```
mkdir -p ~/.aws-lambda-rie && curl -Lo ~/.aws-lambda-rie/aws-lambda-rie \
https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie \
&& chmod +x ~/.aws-lambda-rie/aws-lambda-rie 
```

For arm64
```
mkdir -p ~/.aws-lambda-rie && curl -Lo ~/.aws-lambda-rie/aws-lambda-rie \
https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie64 \
&& chmod +x ~/.aws-lambda-rie/aws-lambda-rie
```


Please refer to https://docs.aws.amazon.com/lambda/latest/dg/images-test.html for more details

3. Run ```make aws-test``` to test your code locally.

4. Run curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}' to test that it is functional. Or use another tool of your preference

5. To push code to aws lambda, run ```make aws-push aws_account_id=your-id```. Check that your Makefile has the correct region setup.

## Automated push for CI/CD pipelines

To automate the push to your ECR registry, you can rely on the github workflow that triggers a deployment on push to main.
First, you need to go to your github action secrets and add the following keys:
```
AWS_ACCESS_KEY_ID
AWS_ACCOUNT_ID
AWS_SECRET_ACCESS_KEY
```
You can also change the region, the image/registry name, and the image version on the workflow file.

Once the setup is ready, you are good to go. The workflow will automatically push your image to your AWS ECR account everytime you push a change the the main branch
