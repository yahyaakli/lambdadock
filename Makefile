IMAGE_NAME = test-image
IMAGE_VERSION = latest
AWS_REGION = us-east-1
ENV = local

build:
	docker build -t ${IMAGE_NAME} .

auth:
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(aws_account_id).dkr.ecr.$(AWS_REGION).amazonaws.com

tag:
	docker tag ${IMAGE_NAME}:${IMAGE_VERSION} $(aws_account_id).dkr.ecr.$(AWS_REGION).amazonaws.com/${IMAGE_NAME}:${IMAGE_VERSION}

push:
	docker push $(aws_account_id).dkr.ecr.$(AWS_REGION).amazonaws.com/${IMAGE_NAME}:${IMAGE_VERSION}

aws-push: auth build tag push

aws-test:
	docker build -t ${IMAGE_NAME}:${IMAGE_VERSION} .
	docker run -d -v ~/.aws-lambda-rie:/aws-lambda -p 9000:8080 \
  	--entrypoint /aws-lambda/aws-lambda-rie ${IMAGE_NAME}:${IMAGE_VERSION} python3 -m awslambdaric app.handler

