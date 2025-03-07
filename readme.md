

This is a guide to configure an openldap environment for testing or demo purpose

The environment will run on docker with the following images:

+ openldap
+ phpldapadmin


## Docker

[docker-compose.yaml](docker-compose.yaml)



## LDAP Tree

This is the tree that will be implemented

+ dc=example,dc=org
    + ou=Solution Engineering
        + uid=user1
        + uid=user2
        + cn=user3
    + ou=Customer Sucess
        + uid=user4
        + uid=user5
        + uid=user6
    + ou=groups
        + cn=admin
            + uid=user1     
        + cn=poweruser
            + uid=user2
            + uid=user3    
        + cn=analyst
            + uid=user4
            + uid=user5
            + uid=user6

### openldap

#### configuration

+ url
+ admin password
+ certificates
+ domain

### phpldapadmin

+ url
+ credentials:
    + openldap admin user
    + openldaps admin password
+ add a user


## LDAP Commands used

1. **Create Organizational Units (OUs)**:
   - Create an LDIF file (e.g., `ou.ldif`) with the following content:
     ```ldif
     dn: ou=MyOrganizationalUnit,dc=mydomain,dc=com
     objectClass: organizationalUnit
     ou: MyOrganizationalUnit
     ```
   - Replace `MyOrganizationalUnit`, `dc=mydomain,dc=com` with your desired OU name and domain components.
   - Use the `ldapadd` command to add the OU:
     ```bash
     ldapadd -x -D "cn=admin,dc=mydomain,dc=com" -W -f ou.ldif
     ```

2. **Create Users**:
   - Create an LDIF file (e.g., `user.ldif`) with the following content:
     ```ldif
     dn: uid=myuser,ou=MyOrganizationalUnit,dc=mydomain,dc=com
     objectClass: top
     objectClass: person
     objectClass: organizationalPerson
     objectClass: inetOrgPerson
     uid: myuser
     cn: My User
     sn: User
     userPassword: mypassword
     ```
   - Replace `myuser`, `MyOrganizationalUnit`, `dc=mydomain,dc=com`, and `mypassword` with actual values.
   - Use the `ldapadd` command to add the user:
     ```bash
     ldapadd -x -D "cn=admin,dc=mydomain,dc=com" -W -f user.ldif
     ```

3. **Create GroupOfNames with Users as Members**:
   - Create an LDIF file (e.g., `group.ldif`) with the following content:
     ```ldif
     dn: cn=MyGroup,ou=MyOrganizationalUnit,dc=mydomain,dc=com
     objectClass: top
     objectClass: groupOfNames
     cn: MyGroup
     member: uid=myuser,ou=MyOrganizationalUnit,dc=mydomain,dc=com
     ```
   
   - Use the `ldapadd` command to add the group:
     ```bash
     ldapadd -x -D "cn=admin,dc=mydomain,dc=com" -W -f group.ldif
     ```
4. **Search for a User**:
