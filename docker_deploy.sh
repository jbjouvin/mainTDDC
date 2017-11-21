#!/bin/sh

if [ -z "$TRAVIS_PULL_REQUEST" ] || [ "$TRAVIS_PULL_REQUEST" == "false" ]
then

  if [ "$TRAVIS_BRANCH" == "staging" ]
  then

    JQ="jq --raw-output --exit-status"

    configure_aws_cli() {
        aws --version
        aws configure set default.region us-east-1
        aws configure set default.output json
        echo "AWS Configured!"
    }

    make_task_def() {
      task_template=$(cat ecs_taskdefinition.json)
      task_def=$(printf "$task_template" $AWS_ACCOUNT_ID $AWS_ACCOUNT_ID)
      echo "$task_def"
    }

    register_definition() {
      if revision=$(aws ecs register-task-definition --cli-input-json "$task_def" --family $family | $JQ '.taskDefinition.taskDefinitionArn'); then
        echo "Revision: $revision"
      else
        echo "Failed to register task definition"
        return 1
      fi
    }

    deploy_cluster() {
      family="testdriven-staging"
      make_task_def
      register_definition
    }

    configure_aws_cli
    deploy_cluster

  fi

fi