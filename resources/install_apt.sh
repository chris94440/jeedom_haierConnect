PROGRESS_FILE=/tmp/jeedom/haierConnect/dependency
if [ -n "$1" ]; then
	PROGRESS_FILE="$1"
fi
if [ -d ../../plugins/haierConnect ]; then
  cd ../../plugins/haierConnect
else
  echo "Ce script doit être appelé depuis .../core/data ChD"
  exit
fi
TMP_FILE=/tmp/jeedom/haierConnect/post-install_haierConnect_bashrc
export PYENV_ROOT="$(realpath resources)/venv"
PYENV_VERSION="3.11"

touch "$PROGRESS_FILE"
echo 0 > "$PROGRESS_FILE"
echo "********************************************************"
echo "*         Installation de pyenv          *"
echo "********************************************************"
date
if [ ! -d "$PYENV_ROOT" ]; then
  sudo -E -u www-data curl https://pyenv.run | bash
  echo 20 > "$PROGRESS_FILE"
fi
echo "****  Configuration de pyenv..."
grep -vi pyenv ~/.bashrc > "$TMP_FILE"
cat "$TMP_FILE" > ~/.bashrc
cat >> ~/.bashrc<< EOF
export PYENV_ROOT="$PYENV_ROOT"
command -v pyenv >/dev/null || export PATH="\$PYENV_ROOT/bin:\$PATH"
eval "\$(pyenv init -)"
EOF
sudo -E -u www-data grep -vi pyenv ~www-data/.bashrc > "$TMP_FILE"
cat "$TMP_FILE" > ~www-data/.bashrc
sudo -E -u www-data cat >> ~www-data/.bashrc<< EOF
export PYENV_ROOT="$PYENV_ROOT"
command -v pyenv >/dev/null || export PATH="\$PYENV_ROOT/bin:\$PATH"
eval "\$(pyenv init -)"
EOF
echo 30 > "$PROGRESS_FILE"
if [ ! -d "$PYENV_ROOT/versions/$PYENV_VERSION" ]; then
  echo "********************************************************"
  echo "*  Installation de pythaierConnect $PYENV_VERSION (dure longtemps)  *"
  echo "********************************************************"
  date
  chown -R www-data:www-data "$PYENV_ROOT"
  sudo -E -u www-data "$PYENV_ROOT"/bin/pyenv install "$PYENV_VERSION"
fi
echo 95 > "$PROGRESS_FILE"
echo "********************************************************"
echo "*    Configuration de pyenv avec pythaierConnect $PYENV_VERSION     *"
echo "********************************************************"
date
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
cd resources/haierConnect
chown -R www-data:www-data "$PYENV_ROOT"
sudo -E -u www-data "$PYENV_ROOT"/bin/pyenv local "$PYENV_VERSION"
sudo -E -u www-data "$PYENV_ROOT"/bin/pyenv exec pip install --upgrade pip setuptools
chown -R www-data:www-data "$PYENV_ROOT"
sudo -E -u www-data "$PYENV_ROOT"/bin/pyenv exec pip install --upgrade requests pyserial pyudev
chown -R www-data:www-data "$PYENV_ROOT"
sudo -E -u www-data "$PYENV_ROOT"/bin/pyenv exec pip install aiohttp
chown -R www-data:www-data "$PYENV_ROOT"
sudo -E -u www-data "$PYENV_ROOT"/bin/pyenv exec pip install pyhOn
chown -R www-data:www-data "$PYENV_ROOT"
echo 100 > "$PROGRESS_FILE"
rm "$PROGRESS_FILE"
rm "$TMP_FILE"
echo "********************************************************"
echo "*       Installation terminée          *"
echo "********************************************************"
date
