To manage an LDAP server and perform tasks like adding organizational units, users, and groups with users as members, you can create a shell script. Below, I'll provide an example of how you can achieve this using LDIF (LDAP Data Interchange Format) files and the `ldapadd` command.

1. **Create Organizational Units (OUs)**:
   - First, create an LDIF file (e.g., `ou.ldif`) with the following content:
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
   - Replace `MyGroup`, `myuser`, `MyOrganizationalUnit`, and `dc=mydomain,dc=com` with actual values.
   - Use the `ldapadd` command to add the group:
     ```bash
     ldapadd -x -D "cn=admin,dc=mydomain,dc=com" -W -f group.ldif
     ```

Remember to adjust the LDIF files and commands according to your specific LDAP server configuration. Additionally, ensure that you have the necessary permissions to perform these operations (e.g., using the `cn=admin` account). If you're using a different LDAP server (e.g., OpenLDAP), adapt the LDIF content accordingly⁵⁷. Let me know if you need further assistance! 😊
