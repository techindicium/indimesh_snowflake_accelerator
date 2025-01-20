# Bitbucket Pipelines Documentation

When merging to the ```master``` branch, a step is executed that updates the repository tags. This step performs the following steps:

1. Install JQ on the image used.
2. Configure Git with a generic name and email.
3. Extract the ID of the last PR merged to the ```master``` branch.
4. Use this ID to extract the name of the PR author.
5. Configure Git with the author's name.
6. Update the repository tag with the author's name.

> Note: You must have the BITBUCKET_TOKEN variable saved in the variable repository with a token that gives read access to the workspace repositories.