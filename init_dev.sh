# !/bin/bash
# Init Perfboard development environment
# Matainer: Thome
# UpdateTime: 2021-03-08
# License: Mozilla

# Install dependants
py3version=$(python3 -V 2>&1 | grep -Po '(?<=Python )(.+)')
if [[ -z "$py3version" ]]
then
    echo "No Python!" 
fi
python3 --version 
parsedVersion=$(echo "${py3version//./}")

if [[ "$parsedVersion" -gt "3600" && "$parsedVersion" -gt "270" ]]
then 
    echo "Valid Python Version"
else
    echo "Invalid Python Version"
fi

# Install and active env
python3 -m pip install -U virtualenv
virtualenv env
sudo chmod +x ./env/bin/activate
source ./env/bin/activate
pip install -U -r requirements.ini
# python3 -c 'import sys; print(sys.version_info)'
