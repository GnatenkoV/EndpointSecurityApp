#!/bin/bash  

if [ "$EUID" -ne 0 ]
then 
  echo "Please run as root"
  exit
fi

if pgrep -xq -- "EndpointSecurityApp"
then
  echo "Please quit EndpointSecurityApp"
  exit
fi

if [ -e "/Applications/EndpointSecurityApp.app" ]
then
  echo "VERIFIED: 'EndpointSecurityApp' is installed"
  sudo open -W /Applications/EndpointSecurityApp.app --args -uninstall
  
  if pgrep -x "com.apriorit.hnatenko.EndpointSecurityApp.Extension" > /dev/null
    then
      echo "Failed to uninstall the app extension"
      exit
  fi
  rm -rf "/Applications/EndpointSecurityApp.app"
  rm -rf "/Library/Application Support/com.apriorit.hnatenko.EndpointSecurityApp"
  echo "EndpointSecurityApp sucessfully uninstalled"
else
  echo "ERROR: 'EndpointSecurityApp' is not installed"
fi
