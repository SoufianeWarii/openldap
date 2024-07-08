#!/bin/bash

set -e

# Define a trap function to catch errors
trap 'catch' ERR

catch()
{
    echo "Terminating because of error at line: ${LINENO}"
}

echo "Executing LDAP search"

result=$(ldapsearch \
            -x \
            -LLL \
            -H ldap://localhost:389 \
            -D cn=admin,dc=example,dc=org \
            -w admin1 \
            -b dc=example,dc=org "(&(objectClass=organizationalUnit)(ou=SolutionEngineering))"
        )               

if echo "$result" | grep -q "ou: SolutionEngineering"; then
    echo "matched";
else
    echo "no match";
fi


