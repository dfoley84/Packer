#!/bin/bash

# Define the CATALINA_HOME variable
CATALINA_HOME=/usr/local/tomcat

# Remove unnecessary webapps
echo "Removing unnecessary webapps"
rm -rf $CATALINA_HOME/webapps/docs
rm -rf $CATALINA_HOME/webapps/examples
rm -rf $CATALINA_HOME/webapps/ROOT
rm -rf $CATALINA_HOME/webapps/host-manager
rm -rf $CATALINA_HOME/webapps/manager
echo "Unnecessary webapps removed"
