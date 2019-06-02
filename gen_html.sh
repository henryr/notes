#!/bin/bash

for i in `find ./ -name *.org`; do
    git add $i
done

git diff-index HEAD --quiet --;

if [[ $? -eq 0 ]]; then
    echo "All done"
    exit 0
fi

for i in `find ./ -name *.org`; do
    /Applications/Emacs.app/Contents/MacOS/Emacs $i --batch -f org-html-export-to-html --kill
done

rm -f index.md

for i in `find ./ -name *.html`; do
    git add $i
    echo "* [$i]($i)" >> index.md
done

git diff-index HEAD --quiet --;

if [[ $? -ne 0 ]]; then
    git add index.md
    git commit -m"$(date)" && git push origin gh-pages
fi
