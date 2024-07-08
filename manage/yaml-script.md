Below is a shell script that performs the tasks you've outlined for managing an OpenLDAP server. This script reads a YAML file containing LDAP server details and a tree structure of OUs, users, and GONs. It then binds to the LDAP server using an admin account to verify accessibility and adds the necessary entries if they don't exist.

### YAML File Structure
You can structure your YAML file as follows:

```yaml
---
ldap_server:
  host: ldap.example.com
  port: 389
  admin_dn: cn=admin,dc=example,dc=com
  admin_password: your_admin_password

organizational_units:
  - name: ou=Sales,dc=example,dc=com
  - name: ou=Marketing,dc=example,dc=com

users:
  - uid: john.doe
    cn: John Doe
    ou: ou=Sales,dc=example,dc=com
    user_password: secret123

group_of_names:
  - name: cn=SalesTeam,ou=Sales,dc=example,dc=com
    members:
      - uid=john.doe,ou=Sales,dc=example,dc=com
      # Add more members here
```

### Shell Script
Save the following script to a file (e.g., `ldap_management.sh`), make it executable (`chmod +x ldap_management.sh`), and run it to manage your OpenLDAP server:

```bash
#!/bin/bash

# Read YAML file
YAML_FILE="ldap_config.yaml"

# Load YAML values
LDAP_HOST=$(yq eval '.ldap_server.host' "$YAML_FILE")
LDAP_PORT=$(yq eval '.ldap_server.port' "$YAML_FILE")
ADMIN_DN=$(yq eval '.ldap_server.admin_dn' "$YAML_FILE")
ADMIN_PASSWORD=$(yq eval '.ldap_server.admin_password' "$YAML_FILE")

# Check LDAP server accessibility
ldapsearch -x -LLL -H "ldap://$LDAP_HOST:$LDAP_PORT" -D "$ADMIN_DN" -w "$ADMIN_PASSWORD" -b "" -s base "(objectClass=*)" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Error: LDAP server is not accessible."
    exit 1
fi

# Add organizational units
for ou in $(yq eval '.organizational_units[].name' "$YAML_FILE"); do
    ldapsearch -x -LLL -H "ldap://$LDAP_HOST:$LDAP_PORT" -D "$ADMIN_DN" -w "$ADMIN_PASSWORD" -b "$ou" "(objectClass=organizationalUnit)" 2>/dev/null
    if [ $? -ne 0 ]; then
        ldapadd -x -D "$ADMIN_DN" -w "$ADMIN_PASSWORD" -f <(echo -e "dn: $ou\nobjectClass: organizationalUnit\n$ou")
    fi
done

# Add users
for user in $(yq eval '.users[].uid' "$YAML_FILE"); do
    user_dn="uid=$user,$(yq eval '.users[] | select(.uid == "'$user'") | .ou' "$YAML_FILE")"
    ldapsearch -x -LLL -H "ldap://$LDAP_HOST:$LDAP_PORT" -D "$ADMIN_DN" -w "$ADMIN_PASSWORD" -b "$user_dn" "(objectClass=*)" 2>/dev/null
    if [ $? -ne 0 ]; then
        ldapadd -x -D "$ADMIN_DN" -w "$ADMIN_PASSWORD" -f <(yq eval '.users[] | select(.uid == "'$user'") | to_entries | map("dn: " + .value.ou + "," + .value.dn + "\nobjectClass: inetOrgPerson\nuid: " + .value.uid + "\ncn: " + .value.cn + "\nuserPassword: " + .value.user_password)' "$YAML_FILE")
    fi
done

# Add groupOfNames
for group in $(yq eval '.group_of_names[].name' "$YAML_FILE"); do
    group_dn="$group,$(yq eval '.group_of_names[] | select(.name == "'$group'") | .members[]' "$YAML_FILE")"
    ldapsearch -x -LLL -H "ldap://$LDAP_HOST:$LDAP_PORT" -D "$ADMIN_DN" -w "$ADMIN_PASSWORD" -b "$group_dn" "(objectClass=groupOfNames)" 2>/dev/null
    if [ $? -ne 0 ]; then
        ldapadd -x -D "$ADMIN_DN" -w "$ADMIN_PASSWORD" -f <(yq eval '.group_of_names[] | select(.name == "'$group'") | to_entries | map("dn: " + .value.name + "\nobjectClass: groupOfNames\nmember: " + .

Source: Conversation with Copilot, 7/7/2024
(1) OpenLDAP configuration using posixGroup and groupOfNames. https://stackoverflow.com/questions/60275276/openldap-configuration-using-posixgroup-and-groupofnames.
(2) ldap - OpenLDAP associate existing users to an organization unit (OU .... https://stackoverflow.com/questions/75058418/openldap-associate-existing-users-to-an-organization-unit-ou.
(3) LDAP: can an organizational unit be a member of a group?. https://stackoverflow.com/questions/10016744/ldap-can-an-organizational-unit-be-a-member-of-a-group.
(4) Add organisational unit (ou) to organisation (o) in OpenLDAP. https://unix.stackexchange.com/questions/534930/add-organisational-unit-ou-to-organisation-o-in-openldap.
(5) Chapter 9. Syncing Groups With LDAP - Red Hat Customer Portal. https://access.redhat.com/documentation/id-id/openshift_enterprise/3.1/html/installation_and_configuration/install-config-syncing-groups-with-ldap.
(6) undefined. https://devopsideas.com/openldap-linux-client-ldap-integration/.
(7) Powershell Script to create a new Group from a list of OU and then add .... https://stackoverflow.com/questions/10287243/powershell-script-to-create-a-new-group-from-a-list-of-ou-and-then-add-user-obje.
(8) active directory - Powershell add user to group - Stack Overflow. https://stackoverflow.com/questions/7463198/powershell-add-user-to-group.