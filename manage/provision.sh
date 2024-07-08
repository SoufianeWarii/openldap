#!/bin/bash

function addOrganizationUnitLdif
{
    local filename="ou.ldif"
    local ou=${1}
    local domain=${2}
    # Build replacement string using sed syntax
    local replace_str=""
    replace_str="${replace_str}s/\${OU}/${ou}/g;"
    replace_str="${replace_str}s/\${DOMAIN}/${domain}/g;"
    # Read the file and perform replacements using sed
    sed -e "$replace_str" "$filename" > tmp.file
    ldapadd -x -D $ADMIN_DN -w $PASSWORD -f tmp.file
}

function addOrganizationUnitLdif
{
    local filename="user.ldif"
    local ou=${1}
    local domain=${2}
    local uid=${3}
    # Build replacement string using sed syntax
    local replace_str=""
    replace_str="${replace_str}s/\${OU}/${ou}/g;"
    replace_str="${replace_str}s/\${DOMAIN}/${domain}/g;"
    replace_str="${replace_str}s/\${UID}/${domain}/g;"
    # Read the file and perform replacements using sed
    sed -e "$replace_str" "$filename" > tmp.file
    ldapadd -x -D $ADMIN_DN -w $PASSWORD -f tmp.file
}

function searchLdap 
{
    ldapsearch \
        -x \
        -LLL \
        -H $URL \
        -D $ADMIN_DN \
        -w $PASSWORD \
        -b $DOMAIN "${1}"
}

# Read YAML file
YAML_FILE="ldap_config.yaml"
echo "Reading ldap confile file from: $YAML_FILE"
# Load YAML values
HOST=$(yq --raw-output '.ldap_server.host' $YAML_FILE)
PORT=$(yq --raw-output '.ldap_server.port' $YAML_FILE)
DOMAIN=$(yq --raw-output '.ldap_server.domain' $YAML_FILE)
ADMIN=$(yq --raw-output '.ldap_server.admin' $YAML_FILE)
PASSWORD=$(yq --raw-output '.ldap_server.password' $YAML_FILE)

URL=ldap://$HOST:$PORT
ADMIN_DN="cn=$ADMIN,$DOMAIN"
echo "Connecting to LDAP server with URL: $URL and admin dn: $ADMIN_DN"
# Check LDAP server accessibility

RESULT=$(searchLdap "(objectClass=*)" 2>/dev/null)
if [ $? -ne 0 ]; then
    echo "Error: LDAP server is not accessible."
    exit 1
fi
echo "Connection successful"

# Add organizational units
echo "Processing Organization Units"
for ou in $(yq --raw-output '.organizational_units[].name' $YAML_FILE); do
    echo "ou: $ou"
    OU_SEARCH=$(searchLdap "(&(objectClass=organizationalUnit)(cn=test))" 2>/dev/null)
    if [ $? -ne 0 ]; 
    then
        addOrganizationUnitLdif $ou $DOMAIN
    else
        echo "Organization Unit already exists: $ou"
    fi
done





