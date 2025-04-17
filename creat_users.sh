#!/bin/bash
users=("Nikol" "Jhon" "Vasia")
for user in "${users[@]}"; do
if [ -d "/home/$user" ]; then
echo "Каталог /home/$user вже існує. Пропускаю користувача $user."
continue
fi
if ! useradd -m -s /bin/bash "$user"; then
echo "Помилка додавання користувача $user!"
continue
fi
password=$(openssl rand -base64 12 | head -c 16)
echo "$user:$password" | chpasswd || {
echo "Помилка встановлення паролю для $user"
userdel -r "$user" 2>/dev/null
continue
}
echo "$password" > "/home/$user/${user}_password.txt"
chown "$user:$user" "/home/$user/${user}_password.txt"
chmod 755 "/home/$user/${user}_password.txt"
sudo -u "$user" ssh-keygen -t rsa -b 4096 -f "/home/$user/.ssh/id_rsa" -q -N "" || {
echo "Помилка генерації SSH-ключа для $user"
continue
}
echo "Користувач $user успішно створений. Пароль збережено у /home/$user/${user}_password.txt"
done
