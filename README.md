sszhao.github.io

How to start the server: 
bundle exec jekyll serve

How to stop the server: 
pkill -f jekyll


#commit changes 
echo "=== 🔍 CURRENT GIT STATUS ==="
git status

echo -e "\n=== 📊 CHANGED FILES SUMMARY ==="
git diff --stat

echo "=== 🚚 STAGING FILES ==="
git add "all the files that need to be committed" 

echo -e "\n=== 📸 CREATING COMMIT ==="
git commit -m "Update website files: xxx"

echo -e "\n=== 🚀 PUSH TO GITHUB ==="
git push origin main


