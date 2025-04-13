#!/bin/bash
users = ("Nikol" "Jhon" "Vasia")
for user in "${users[@]}"; do
if [-d "/home/$user"]; do
echo "Каталог /home/$user вже існує. Пропускаю користувача $user."
continue
fi
mkdir "/home/user" || {echo "Помилка створення каталогу"; continue;}
useradd -d "/home/$user" "user" ||{
echo "Помилка додавання користувача $user. Видаляю користувача";
rm -rf "/home/$user";
continue;
}
chown "$user:$user" "/home/$user" || {echo "Помилка зміни власника"; continue;}
password=$(openssl rand -base64 12)
echo "$password" > "/home/$user/$user.password" || {echo "Помилка збереження паролю"; continue;}
chown "$user:$user" "/home/$user/$user.password"
echo "$user:$password" | chpasswd || {echo "Помилка встановлення паролю"; continue;}
su - "$user" -c "mkdir -p ~/.ssh && ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ''" || {echo "Помилка генерації ключа"; continue;}
echo "Користувая $user успішно створений. Пароль: /home/$user/$user.password"
done
