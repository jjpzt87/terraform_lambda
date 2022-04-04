# terraform_lambda
Deploying a simple lambda function on AWS with terraform

## Creating your image
important link: [aws_doc](https://docs.aws.amazon.com/lambda/latest/dg/python-image.html)

- Create ECR repo
> `aws ecr get-login-password --region eu-west-1 --profile [your_aws_profile] | docker login --username AWS --password-stdin [account].dkr.ecr.[region].amazonaws.com`
> 
> `aws ecr create-repository --repository-name [imagePath/imageName] --image-scanning-configuration scanOnPush=true --image-tag-mutability MUTABLE`

- Push docker image to ECR
> `aws ecr get-login-password --region eu-west-1 --profile [your_aws_profile] | docker login --username AWS --password-stdin [account].dkr.ecr.[region].amazonaws.com`
>
> `docker build -t [imagePath/imageName] -f Dockerfile .`
>
> `docker tag [imagePath/imageName]:latest [account].dkr.ecr.[region].amazonaws.com/[imagePath/imageName]:latest`
>
> `docker push [account].dkr.ecr.[region].amazonaws.com/[imagePath/imageName]:latest`

- Execute only when a new lambda image is pushed to ECR
> `aws lambda update-function-code --region [region] --function-name [functionaName] --image-uri [account].dkr.ecr.[region].amazonaws.com/[imagePath/imageName]:latest --cli-connect-timeout 6000`
