#!/bin/bash
# Integrate Fortify ScanCentral Static AppSec Testing (SAST) into your OCI DevOps Project pipeline

# *** Configuration ***

# The following vault secrets  must be defined
	# FCLI_DEFAULT_FOD_URL
	# FCLI_DEFAULT_FOD_TENANT
    # FCLI_DEFAULT_FOD_USER
	# FCLI_DEFAULT_FOD_PASSWORD (PAT)
    # FOD_RELEASE_ID
	
# Local variables (modify as needed)
FCLI_VERSION=v2.4.0
FODUPLOAD_VERSION=5.4.1
SCANCENTRAL_VERSION=24.2.0
FCLI_URL=https://github.com/fortify-ps/fcli/releases/download/${FCLI_VERSION}/fcli-linux.tgz
FCLI_SIG_URL=${FCLI_URL}.rsa_sha256
FORTIFY_TOOLS_DIR="/root/.fortify/tools"	
FCLI_HOME=$FORTIFY_TOOLS_DIR/fcli
FODUPLOAD_HOME=$FORTIFY_TOOLS_DIR/FodUpload
SCANCENTRAL_HOME=$FORTIFY_TOOLS_DIR/ScanCentral	
fod_notes="Triggered by OCI DevOps Projects"

# *** Supported Functions ***
verifySig() {
  local src sig
  src="$1"; sig="$2"
  openssl dgst -sha256 -verify <(echo "-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArij9U9yJVNc53oEMFWYp
NrXUG1UoRZseDh/p34q1uywD70RGKKWZvXIcUAZZwbZtCu4i0UzsrKRJeUwqanbc
woJvYanp6lc3DccXUN1w1Y0WOHOaBxiiK3B1TtEIH1cK/X+ZzazPG5nX7TSGh8Tp
/uxQzUFli2mDVLqaP62/fB9uJ2joX9Gtw8sZfuPGNMRoc8IdhjagbFkhFT7WCZnk
FH/4Co007lmXLAe12lQQqR/pOTeHJv1sfda1xaHtj4/Tcrq04Kx0ZmGAd5D9lA92
8pdBbzoe/mI5/Sk+nIY3AHkLXB9YAaKJf//Wb1yiP1/hchtVkfXyIaGM+cVyn7AN
VQIDAQAB
-----END PUBLIC KEY-----") -signature "${sig}" "${src}"
}

installFcli() {
  local src sigSrc tgt tmpRoot tmpFile tmpDir
  src="$1"; sigSrc="$2"; tgt="$3"; 
  tmpRoot=$(mktemp -d); tmpFile="$tmpRoot/archive.tmp"; tmpDir="$tmpRoot/extracted"
  echo "Downloading file"
  wget -O $tmpFile $src
  echo "Verifying Signature..."
  verifySig "$tmpFile" <(curl -fsSL -o - "$sigSrc")
  echo "Unzipping: tar -zxf " + $tmpFile + " -C " + $tmpDir
  mkdir $tmpDir
  mkdir -p $tgt
  
  tar -zxf $tmpFile -C $tmpDir
  mv $tmpDir/* $tgt
  rm -rf $tmpRoot
  find $tgt -type f
}


# *** Execution ***
echo "Installing FCLI"
# Install FCLI
installFcli ${FCLI_URL} ${FCLI_SIG_URL} ${FCLI_HOME}/bin

fcli tool fod-uploader install -v ${FODUPLOAD_VERSION} -d ${FODUPLOAD_HOME}
fcli tool sc-client install -v ${SCANCENTRAL_VERSION} -d ${SCANCENTRAL_HOME}

export PATH=$FCLI_HOME/bin:$FODUPLOAD_HOME/bin:$SCANCENTRAL_HOME/bin:${PATH}

echo Setting connection with Fortify Platform
#Use --insecure switch if the SSL certificate is self generated.
fcli fod session login

echo "Scan starting.."
scancentral package -bt mvn -oss -o package.zip
fcli fod sast start --release=$FOD_RELEASE_ID --file=package.zip --remediation=NonRemediationScanOnly --notes="$FOD_NOTES" --store=Id

fcli fod sast wait-for ::Id:: --interval=30s

fcli fod issue list --release=$FOD_RELEASE_ID

fcli fod session logout
# *** Execution Completes ***

# *** EoF ***