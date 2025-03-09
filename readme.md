# Github Actions - ECR

## 1. Github Actions Yaml 세팅

```yaml
---
name: Build and Push
on:
  push:
    branches: [ main ]
  jobs: 
    build-and-push:
      name: BUild and Push
      runs-on: ubuntu-latest
      stages:
      - name: Checkout
        users: actions/checkout@v2
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials#v1
        with: 
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ap-northeast-2
      
      - name: Login to Amazon EcR
        id: login-ecr
        users: aws-actions/amazon-ecr-login@v1

      - name: Build, Tag, and Push the Image to Amazon ECR
        id: build-image
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          ECR_REPOSITORY: 3-gh-actions-aws
          IMAGE_TAB: latest
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
```

## 2. ECR Repository 생성

## 3. IAM Policy 등록

### 3.1. IAM Policy 생성

- IAM Poclity 생성 
  - IAM - Policy - create Policy

```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "GetAuthorizationToken",
			"Effect": "Allow",
			"Action": [
			    "ecr:GetAuthorizationToken"
			],
			"Resource": "*"
		},
		{
			"Effect": "Allow",
			"Action": [
			    "ecr:BatchGetImage",
			    "ecr:BatchCheckLayerAvailability",
			    "ecr:CompleteLayerUpload",
			    "ecr:GetDownloadUrlForLayer",
			    "ecr:InitiateLayerUpload",
			    "ecr:PutImage",
			    "ecr:UploadLayerPart"
			],
			"Resource": [
			    "arn:aws:ecr:ap-northeast-2:039612876607:repository/3-github-actions"
			]
		}
	]
}
```

- User Groups 생성
- User 생성 for github actions
