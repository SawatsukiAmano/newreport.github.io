hexo c && hexo g && hexo s
hexo c && hexo g && hexo d
git add . && git commit -m '.' && git push

lint-md */* --fix
hexo clean && hexo g && hexo d &&  git add . && git commit -m '.' && git push

