set -eu

PAGES_BRANCH="publish"

_no_branch=false

if [[ -z `git branch -av | grep $PAGES_BRANCH` ]]; then
  _no_branch=true
  git checkout -b $PAGES_BRANCH
else
  git checkout $PAGES_BRANCH
fi

mv _site ../
mv .git ../

rm -rf * && rm -rf .[^.] .??*

mv ../_site/* .
mv ../.git .

git config --global user.name "GitHub Actions"
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"

git update-ref -d HEAD
git add -A
git commit -m "[Automation] Site update No.${GITHUB_RUN_NUMBER}"

if [[ $_no_branch = true ]]; then
  git push -u origin $PAGES_BRANCH
else
  git push -f
fi
