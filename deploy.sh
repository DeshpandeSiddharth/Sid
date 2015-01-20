#!/bin/bash
echo "Home directory is: $HOME"
echo "deploy.sh: directory = $PWD"

echo "TRAVIS_REPO_SLUG = $TRAVIS_REPO_SLUG"
echo "REPOSITORY_NAME = $(echo $TRAVIS_REPO_SLUG | gawk -F/ '{print $2}')"
shopt -s extglob

if [ $TRAVIS_PULL_REQUEST = false ]
then
    echo 'Branch: ' $TRAVIS_BRANCH
    git config --global user.email "auto-deploy@travis-ci.local"
    git config --global user.name "auto-deploy"
    isMaster=$(echo "$TRAVIS_BRANCH"|awk '{print match($0,"master")}');
    isDevelop=$(echo "$TRAVIS_BRANCH"|awk '{print match($0,"develop")}');
     if [ "$isMaster" = 1 ]
             then
             BRANCH_NAME=deploy-demo
         fi
         else if [ "$isDevelop" = 1 ]
             then
             BRANCH_NAME=deploy-dev
         fi
    doGitOperations $BRANCH_NAME
else
    echo 'No need to deploy.'
fi

doGitOperations(){
       echo "master branch: Starting deployment... "
       git clone https://$AUTH_TOKEN@github.com/$TRAVIS_REPO_SLUG.git $1
       cd $1
       git checkout $1
       # Delete everything except '.git' to ensure we commit deletes once the _release is copied across.
       rm -rf !(.git)
       cp -r ../_release/$REPOSITORY_NAME/. .
       git add -f --all .
       git commit -a -m "$COMMIT_MESSAGE  [ci skip]"
       git push -f --set-upstream origin $1
}