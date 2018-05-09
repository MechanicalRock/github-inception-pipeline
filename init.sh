reset

echo "Create the initial CloudFormation Stack"
aws cloudformation create-stack --stack-name "temyersGithubInceptionPipeline" --template-body file://aws_seed.yml --parameters file://aws_seed-cli-parameters.json --capabilities "CAPABILITY_NAMED_IAM" 
echo "Waiting for the CloudFormation stack to finish being created."
aws cloudformation wait stack-create-complete --stack-name "temyersGithubInceptionPipeline"
# Print out all the CloudFormation outputs.
aws cloudformation describe-stacks --stack-name "temyersGithubInceptionPipeline" --output table --query "Stacks[0].Outputs"

export CODECOMMIT_REPO=`aws --profile default cloudformation describe-stacks --stack-name "temyersGithubInceptionPipeline" --output text --query "Stacks[0].Outputs[?OutputKey=='CodeCommitRepositoryCloneUrlHttp'].OutputValue"`

echo "Initialising Git repository"
git init
echo "Adding the newly created CodeCommit repository as origin"
git remote add origin $CODECOMMIT_REPO
echo "Adding all files"
git add .
echo "CodeCommitting files"
git commit -m "Initial commit"
echo "Pushing to CodeCommit"
git push --set-upstream origin master
