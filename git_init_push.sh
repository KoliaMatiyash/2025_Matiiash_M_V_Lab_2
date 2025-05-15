#!/bin/bash
if [ "$#" -ne 2 ]; then
echo "Потрібно вказати два параметри: шлях до каталогу та URL віддаленого репозиторію."
exit 1
fi
dir_path="$1"
https_url="$2"
if [[ "$https_url" =~ ^https://github\.com/([^/]+)/([^/]+)\.git$ ]]; then
github_user="${BASH_REMATCH[1]}"
repo_name="${BASH_REMATCH[2]}"
remote_url="git@github.com:${github_user}/${repo_name}.git"
else
echo "Неправильний формат HTTPS-URL"
exit 1
fi
echo "Папка: $dir_path"
echo "Використовується SSH URL: $remote_url"
if [ ! -d "$dir_path" ]; then
echo "Каталог $dir_path не існує"
exit 1
fi
cd "$dir_path" || exit 1
git init || { echo "Error: git init failed"; exit 1; }
git remote remove origin 2>/dev/null
git remote add origin "$remote_url" || { echo "Помилка додавання віддаленого репозиторію"; exit 1; }
git add . || { echo "Помилка додавання файлів"; exit 1; }
git commit -m "Initial commit" || { echo "Помилка створення коміту"; exit 1; }
git push -u origin main || { echo "Помилка відправки змін"; exit 1; }
echo "Успішно виконано!"
