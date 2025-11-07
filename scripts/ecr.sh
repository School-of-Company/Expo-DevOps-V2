#!/bin/bash

# Create an ECR repository named expo-ecr
aws ecr create-repository \
  --repository-name expo-ecr \
  --image-tag-mutability MUTABLE \
  --image-scanning-configuration scanOnPush=true


# Create a Lifecycle Policy JSON file
cat > lifecycle-policy.json <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire untagged images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF


# Apply the Lifecycle Policy to the ECR repository
aws ecr put-lifecycle-policy \
  --repository-name expo-ecr \
  --lifecycle-policy-text file://lifecycle-policy.json

# Set KMS Key After create the ECR repository