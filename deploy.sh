#!/usr/bin/env sh

# abort on errors
set -e

# build
yarn build

# copy the cred file into the dist directory
cp google939391bba2e6061f.html .vuepress/dist/ 
cp naverb58fde12ce42ecaf7572240b15b502af.html .vuepress/dist/ 

# navigate into the build output directory
cd .vuepress/dist

# if you are deploying to a custom domain
# echo 'www.example.com' > CNAME

git init
git add -A
git commit -m 'deploy'

# if you are deploying to https://<USERNAME>.github.io
git push -f https://github.com/JonghunBok/JonghunBok.github.io.git master
# if you are deploying to https://<USERNAME>.github.io/<REPO>
# git push -f git@github.com:<USERNAME>/<REPO>.git master:gh-pages

cd -

rm -rf .vuepress/dist
