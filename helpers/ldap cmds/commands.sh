ldapsearch -D "cn=admin,dc=example,dc=org" \
    -W \
    -p 389 \
    -h localhost \
    -b "dc=example,dc=org" \
    -s sub \
    -x "(objectclass=*)" cn dn memberof uniqueMember mail uid \


