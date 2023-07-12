#!/bin/bash

function createUsco() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/usco.universidades.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/usco.universidades.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-usco --tls.certfiles "${PWD}/organizations/fabric-ca/usco/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-usco.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-usco.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-usco.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-usco.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/usco.universidades.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-usco --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/usco/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-usco --id.name dussan --id.secret k1079186609 --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/usco/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-usco --id.name uscoadmin --id.secret uscoadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/usco/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-usco -M "${PWD}/organizations/peerOrganizations/usco.universidades.com/peers/peer0.usco.universidades.com/msp" --csr.hosts peer0.usco.universidades.com --tls.certfiles "${PWD}/organizations/fabric-ca/usco/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/usco.universidades.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/usco.universidades.com/peers/peer0.usco.universidades.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-usco -M "${PWD}/organizations/peerOrganizations/usco.universidades.com/peers/peer0.usco.universidades.com/tls" --enrollment.profile tls --csr.hosts peer0.usco.universidades.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/usco/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/usco.universidades.com/peers/peer0.usco.universidades.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/usco.universidades.com/peers/peer0.usco.universidades.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/usco.universidades.com/peers/peer0.usco.universidades.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/usco.universidades.com/peers/peer0.usco.universidades.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/usco.universidades.com/peers/peer0.usco.universidades.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/usco.universidades.com/peers/peer0.usco.universidades.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/usco.universidades.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/usco.universidades.com/peers/peer0.usco.universidades.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/usco.universidades.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/usco.universidades.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/usco.universidades.com/peers/peer0.usco.universidades.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/usco.universidades.com/tlsca/tlsca.usco.universidades.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/usco.universidades.com/ca"
  cp "${PWD}/organizations/peerOrganizations/usco.universidades.com/peers/peer0.usco.universidades.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/usco.universidades.com/ca/ca.usco.universidades.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://dussan:k1079196609@localhost:7054 --caname ca-usco -M "${PWD}/organizations/peerOrganizations/usco.universidades.com/users/dussan@usco.universidades.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/usco/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/usco.universidades.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/usco.universidades.com/users/dussan@usco.universidades.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://uscoadmin:uscoadminpw@localhost:7054 --caname ca-usco -M "${PWD}/organizations/peerOrganizations/usco.universidades.com/users/Admin@usco.universidades.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/usco/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/usco.universidades.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/usco.universidades.com/users/Admin@usco.universidades.com/msp/config.yaml"
}

function createIebs() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/iebs.universidades.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/iebs.universidades.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-iebs --tls.certfiles "${PWD}/organizations/fabric-ca/iebs/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-iebs.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-iebs.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-iebs.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-iebs.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/iebs.universidades.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-iebs --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/iebs/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-iebs --id.name kevin --id.secret kevin1079186609 --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/iebs/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-iebs --id.name iebsadmin --id.secret iebsadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/iebs/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-iebs -M "${PWD}/organizations/peerOrganizations/iebs.universidades.com/peers/peer0.iebs.universidades.com/msp" --csr.hosts peer0.iebs.universidades.com --tls.certfiles "${PWD}/organizations/fabric-ca/iebs/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/iebs.universidades.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/iebs.universidades.com/peers/peer0.iebs.universidades.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-iebs -M "${PWD}/organizations/peerOrganizations/iebs.universidades.com/peers/peer0.iebs.universidades.com/tls" --enrollment.profile tls --csr.hosts peer0.iebs.universidades.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/iebs/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/iebs.universidades.com/peers/peer0.iebs.universidades.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/iebs.universidades.com/peers/peer0.iebs.universidades.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/iebs.universidades.com/peers/peer0.iebs.universidades.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/iebs.universidades.com/peers/peer0.iebs.universidades.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/iebs.universidades.com/peers/peer0.iebs.universidades.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/iebs.universidades.com/peers/peer0.iebs.universidades.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/iebs.universidades.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/iebs.universidades.com/peers/peer0.iebs.universidades.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/iebs.universidades.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/iebs.universidades.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/iebs.universidades.com/peers/peer0.iebs.universidades.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/iebs.universidades.com/tlsca/tlsca.iebs.universidades.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/iebs.universidades.com/ca"
  cp "${PWD}/organizations/peerOrganizations/iebs.universidades.com/peers/peer0.iebs.universidades.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/iebs.universidades.com/ca/ca.iebs.universidades.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://kevin:kevin109186609@localhost:8054 --caname ca-iebs -M "${PWD}/organizations/peerOrganizations/iebs.universidades.com/users/kevin@iebs.universidades.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/iebs/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/iebs.universidades.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/iebs.universidades.com/users/kevin@iebs.universidades.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://iebsadmin:iebsadminpw@localhost:8054 --caname ca-iebs -M "${PWD}/organizations/peerOrganizations/iebs.universidades.com/users/Admin@iebs.universidades.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/iebs/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/iebs.universidades.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/iebs.universidades.com/users/Admin@iebs.universidades.com/msp/config.yaml"
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/universidades.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/universidades.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/universidades.com/msp/config.yaml"

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/msp" --csr.hosts orderer.universidades.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/universidades.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/msp/config.yaml"

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/tls" --enrollment.profile tls --csr.hosts orderer.universidades.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/msp/tlscacerts/tlsca.universidades.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/universidades.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/universidades.com/msp/tlscacerts/tlsca.universidades.com-cert.pem"

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/universidades.com/users/Admin@universidades.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/universidades.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/universidades.com/users/Admin@universidades.com/msp/config.yaml"
}
