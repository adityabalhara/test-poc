resource "aws_ecr_lifecycle_policy" "testpolicy" {
  count = "${length(var.reponame)}"
  repository = "${var.reponame[count.index]}"
  
  policy = <<EOF
  
  {
  "rules": [
    {
      "action": {
        "type": "expire"
      },
      "selection": {
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 60,
        "tagStatus": "tagged",
        "tagPrefixList": [
          "test"
        ]
      },
      "description": "Delete images older than 60 days",
      "rulePriority": 10
    },
    {
      "rulePriority": 20,
      "description": "Keep last 20 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 20
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}
