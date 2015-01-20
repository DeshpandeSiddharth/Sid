#!/bin/bash

# Setup .netrc file (note the file starts with 'dot' and not 'underscore' on Linux)
# e.g. echo "machine github.com" >> ~/.netrc
# ...
# Now setup .npmrc file
echo "setting up npmrc and .netrc files"

npmPath=`npm config list | grep HOME`
npmHomeDirPath=${npmPath/*=/}
 echo "$AUTH_TOKEN"
 echo "$USER_EMAIL"
if [ -f ${npmHomeDirPath}/.netrc ]
then
 echo "${npmHomeDirPath}/.netrc found."
else
echo "${npmHomeDirPath}/.netrc"
 echo "machine github.com
  login $LOGIN
  password $AUTH_TOKEN
  protocol https" > ${npmHomeDirPath}/.netrc
 fi
 cat ${npmHomeDirPath}/.netrc

npm config set @osc:registry "http://osc-dev-npme-1.cloudapp.net/"
npm config set //osc-dev-npme-1.cloudapp.net/:_authToken $AUTH_TOKEN
git config --global user.email $USER_EMAIL
