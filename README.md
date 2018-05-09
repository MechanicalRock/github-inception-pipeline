# Inception Pipeline

The source for the Inception Pipelines blog series!

1. [Seeds of Inception](https://mechanicalrock.github.io//aws/continuous/deployment/2018/03/01/inception-pipelines-pt1)
1. [Sprouts of Inception](https://mechanicalrock.github.io//aws/continuous/deployment/2018/04/01/inception-pipelines-pt2)


# Updating for Github

1. deploy the inception pipeline as is, deploying to codecommit
1. Add GitHub source:
    ```
    - InputArtifacts: []
                Name: Source-GH
                    Category: Source
                    Owner: ThirdParty
                    Version: '1'
                    Provider: GitHub
                OutputArtifacts:
                    - Name:  !Join ['', [!Ref RepositoryName, 'Source-GH']]
                Configuration:
                    Branch: 'master'
                    Owner: MechanicalRock
                    Repo: github-inception-pipeline
                    OAuthToken: 'invalid'
                RunOrder: 1
    ```
1. Push to origin - the pipeline will be updated, but GitHub source will fail (invalid OAuth token) 
1. Create GitHub repository and push (update to track github rather than codecommit):
    ```
    git remote add origin-gh git@github.com:MechanicalRock/github-inception-pipeline.git
    git push -u origin-gh master
    ```
1. Create [OAuth Token in GitHub](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) 
1. Update the OAuth token:
    * `aws codepipeline get-pipeline --name temyersGithubInceptionPipeline > /tmp/pipeline.json`
    * Edit the pipeline:
        * Replace `"OAuthToken": "****"` with `"OAuthToken": "MY_REAL_TOKEN_THIS_TIME"`
        * Delete the `metadata` key
    * `aws codepipeline update-pipeline --cli-input-json file:///tmp/pipeline.json`
1. The GitHub source now succeeds
1. [Update the pipeline to configure GitHub Webhook](https://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-webhooks.html)
    * Create webhook:
        ```
        export WEBHOOK_SECRET='secret'
        cp webhook.json /tmp/webhook.json
        sed -i "s/@@fill_me_in@@/$WEBHOOK_SECRET/" /tmp/webhook.json
        aws codepipeline put-webhook --cli-input-json file:///tmp/webhook.json --region ap-southeast-2
    * aws codepipeline register-webhook-with-third-party --webhook-name temyersGithubInceptionPipeline-webhook
--region region
1. Delete the CodeCommit repository source
1. Push to GitHub
1. If everything worked, the pipeline should be updated to delete the CodeCommit source - you're now running against GitHub (Failed :( - didn't update the source ref for administerPipeline)
1. Re-instate the CodeCommit source
1. Update the AdministerPipeline source to use GitHub 
    ```
    InputArtifacts:
                - Name: !Join ['', [!Ref RepositoryName, 'Source-GH']]
    ```
1. push to code commit & github: `git push && git push origin master`
1. pipeline fails for GH - credentials are now wrong - Update the OAuth token again (run `get-pipeline` step again to get updated pipeline)
1. Remove the CodeCommit source
1. Push to GitHub
1. If everything worked, the pipeline should be updated to delete the CodeCommit source - you're now running against GitHub (Failed :( - didn't update the source ref for administerPipeline)
