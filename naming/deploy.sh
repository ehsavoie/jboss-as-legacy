#!/bin/sh

#mvn clean install
# -Dversion.jboss.legacy=5.1.0.GA ... eap build does not produce artifacts...
# -Dcheckstyle.skip=true - ... signed jars screw checkstyle
mvn clean install -Dmaven.repo.local=/home/ehsavoie/tmp/maven-local -Dversion.jboss.legacy=5.1.0.GA -Dcheckstyle.skip=true
#mvn clean install -Dversion.jboss.legacy=5.3.0-SNAPSHOT
if [ "x$JBOSS_HOME" = "x" ]; then
    # get the full path (without any relative bits)
    echo "Set ENV JBOSS_HOME!"
    return 1
fi

cp -Rf lib/target/module/org $JBOSS_HOME/modules/system/layers/base/
cp -Rf jnp/target/module/org $JBOSS_HOME/modules/system/layers/base/


echo "Edit configuration file - for instance $JBOSS_HOME/standalone/configuration/standalone.xml"

echo "To enable JNP:"
echo "1 Add extension definition in <extensions>."
echo "<extension module=\"org.jboss.legacy.naming.jnp\"/>"
echo
echo "2. Add sdubsystem definition"
echo "<subsystem xmlns=\"urn:jboss:domain:legacy-jnp:1.0\">"
echo "    <jnp-server/>"
echo "    <jnp-connector socket-binding=\"jnp\" rmi-socket-binding=\"rmi-jnp\" />"
echo "    <remoting socket-binding=\"legacy-remoting\"/>"
echo "</subsystem>"
echo 
echo "3. Define a socket-binding for the JNP Server using the 'jnp' name"
echo "<socket-binding name=\"jnp\" port=\"5599\"/>"
echo
echo "4. You can also define a RMI binding socket using the 'rmi-jnp' name (Optionnal if you don't have declared it in the jnp-connector)"
echo "<socket-binding name=\"rmi-jnp\" port=\"1099\"/>"
echo
echo "5. Define a socket-binding for the remoting using the 'legacy-remoting' name"
echo "<socket-binding name=\"legacy-remoting\" port=\"4873\"/>"
echo
echo "5. If you want to configure a HA JNDI JNP Server, you can add :"
echo "<distributed-cache cache-ref=\"default\" cache-container=\"singleton\"/>"
echo
echo
