#!/bin/bash
# source of references https://github.com/openrewrite/rewrite-migrate-java/blob/main/src/main/resources/META-INF/rewrite/jakarta-ee-9.yml
SRC_DIR=src/main/java

# Map of javax → jakarta replacements
declare -A PKG_MAP=(
  ["javax.activation"]="jakarta.activation"
  ["javax.annotation"]="jakarta.annotation"
  ["javax.batch"]="jakarta.batch"
  ["javax.decorator"]="jakarta.decorator"
  ["javax.ejb"]="jakarta.ejb"
  ["javax.el"]="jakarta.el"
  ["javax.enterprise"]="jakarta.enterprise"
  ["javax.faces"]="jakarta.faces"
  ["javax.inject"]="jakarta.inject"
  ["javax.interceptor"]="jakarta.interceptor"
  ["javax.jms"]="jakarta.jms"
  ["javax.json"]="jakarta.json"
  ["javax.json.bind"]="jakarta.json.bind"
  ["javax.jws"]="jakarta.jws"
  ["javax.mail"]="jakarta.mail"
  ["javax.persistence"]="jakarta.persistence"
  ["javax.resource"]="jakarta.resource"
  ["javax.security.auth.message"]="jakarta.security.auth.message"
  ["javax.security.enterprise"]="jakarta.security.enterprise"
  ["javax.servlet"]="jakarta.servlet"
  ["javax.servlet.jsp"]="jakarta.servlet.jsp"
  ["javax.servlet.jsp.jstl"]="jakarta.servlet.jsp.jstl"
  ["javax.transaction"]="jakarta.transaction"
  ["javax.validation"]="jakarta.validation"
  ["javax.websocket"]="jakarta.websocket"
  ["javax.ws.rs"]="jakarta.ws.rs"
  ["javax.xml.bind"]="jakarta.xml.bind"
  ["javax.xml.soap"]="jakarta.xml.soap"
  ["javax.xml.ws"]="jakarta.xml.ws"
)

for javax in "${!PKG_MAP[@]}"; do
  jakarta=${PKG_MAP[$javax]}
  echo "Replacing $javax → $jakarta"
  find "$SRC_DIR" -type f -name "*.java" -exec sed -i "s|$javax|$jakarta|g" {} +
done