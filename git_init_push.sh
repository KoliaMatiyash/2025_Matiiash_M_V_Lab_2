#!/bin/bash
if [ "$#" -ne 2 ]; then
echo "Потрібно вказати два параметри: шлях до каталогу та URL віддаленого репозиторію."
exit 1
fi
dir_path="$1"
echo "$dir_path"
remote_url="$2"
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
git push -u origin HEAD || { echo "Помилка відправки змін"; exit 1; }
echo "Успішно виконано!"
