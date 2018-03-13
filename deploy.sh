hugo
mkdir /tmp/hugo-deploy
cp -R public/* /tmp/hugo-deploy
cd /tmp/hugo-deploy
git init
git remote add origin git@github.com:gycggd/gycggd.github.io.git
git add -A .
git commit -m "Deploy blog"
git push -f origin master:master
cd ..
rm -rf /tmp/hugo-deploy
echo "Deploy Done"
