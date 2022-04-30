SERVICE_NAME = rhub_framework_test
AWS_REGION = us-east-1  # Change to your region

aws-push:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(aws_account_id).dkr.ecr.$(AWS_REGION).amazonaws.com
	docker build -t rhubrecognize .
	docker tag rhubrecognize:latest $(aws_account_id).dkr.ecr.$(AWS_REGION).amazonaws.com/rhubrecognize:latest
	docker push $(aws_account_id).dkr.ecr.$(AWS_REGION).amazonaws.com/rhubrecognize:latest

aws-test:
	docker build -t rhubrecognize:latest .
	docker run -d -v ~/.aws-lambda-rie:/aws-lambda -p 9000:8080 \
  	--entrypoint /aws-lambda/aws-lambda-rie rhubrecognize:latest python3 -m awslambdaric app.handler