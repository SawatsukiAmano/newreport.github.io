hexo clean && hexo g && hexo s
hexo clean && hexo g && hexo d
git add . && git commit -m '.' && git push

 lint-md source/_posts/* --fix
hexo clean && hexo g && hexo d &&  git add . && git commit -m '.' && git push