#!/bin/bash
users=("Nikol" "Jhon" "Vasia")
for user in "${users[@]}"; do
if id "$user" &>/dev/null; then
echo "Користувач $user вже існує"
else
if useradd -m -s /bin/bash "$user"; then
echo "Користувача $user створено."
else
echo "Помилка створення користувача $user. Пропускаю інші дії."
continue
fi
fi
password_file="/home/$user/${user}_password.txt"
if [ ! -f "$password_file" ]; then
password=$(openssl rand -base64 12 | head -c 16)
echo "$user:$password" | chpasswd
echo "$password" > "$password_file"
chmod 700 "$password_file"
chown "$user:$user" "$password_file"
echo "Пароль для $user збережено в $password_file"
else
echo "Пароль вже існує для $user. Пропускаємо генерацію."
fi
ssh_dir="/home/$user/.ssh"
if [ ! -d "$ssh_dir" ]; then
mkdir -p "$ssh_dir"
chown "$user:$user" "$ssh_dir"
chmod 700 "$ssh_dir"
echo "Каталог $ssh_dir створено."
else
echo "Каталог $ssh_dir вже існує."
fi
if [ ! -f "$ssh_dir/id_rsa" ]; then
sudo -u "$user" ssh-keygen -t rsa -b 4096 -f "$ssh_dir/id_rsa" -q -N ""
echo "SSH ключі для $user створено."
else
echo "SSH ключі для $user вже існують."
fi
echo "Користувач $user успішно створений."
done
