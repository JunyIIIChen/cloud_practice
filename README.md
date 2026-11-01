# Cloud Practice API

A minimal FastAPI service for practicing AWS deployments.

## Endpoints

| Method | Path            | Description                          |
|--------|-----------------|--------------------------------------|
| GET    | `/`             | Hello message                        |
| GET    | `/health`       | Health check (use for ALB/ECS)       |
| GET    | `/info`         | Hostname, `APP_ENV`, server time     |
| GET    | `/items`        | List items (in-memory)               |
| POST   | `/items`        | Create item `{"name": "...", "description": "..."}` |
| GET    | `/items/{id}`   | Get item                             |
| DELETE | `/items/{id}`   | Delete item                          |
| GET    | `/docs`         | Swagger UI                           |

## Run locally

```bash
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

## Run with Docker

```bash
docker build -t cloud-practice-api .
docker run -p 8000:8000 -e APP_ENV=docker cloud-practice-api
```

> On Apple Silicon, build for AWS x86 hosts with:
> `docker build --platform linux/amd64 -t cloud-practice-api .`

## Push to ECR

```bash
AWS_REGION=us-east-1
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REPO=cloud-practice-api

aws ecr create-repository --repository-name $REPO --region $AWS_REGION
aws ecr get-login-password --region $AWS_REGION \
  | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

docker tag $REPO:latest $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO:latest
docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO:latest
```

From there, deploy the image with App Runner (easiest), ECS Fargate, or EC2.
Container port is `8000`; health check path is `/health`.
