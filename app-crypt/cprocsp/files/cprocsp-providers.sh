# Copyright 2026
# Distributed under the terms of the GNU General Public License v2
#
# KC1 and KC2 provider descriptions for CryptoPro CSP.
#
# Taken verbatim (apart from paths and output redirection) from the %post
# install scriptlets of lsb-cprocsp-kc1-64 and lsb-cprocsp-kc2-64 version
# 5.0.13003-7.  Sourced by cprocsp-postinst.sh; only the block whose
# provider library is installed is executed.

# --- KC1 provider (lsb-cprocsp-kc1), from its %post ---
if [[ -e "${CP_LIBDIR}/libcsp.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdrrndmbio_tui.so ${CP_LIBDIR}/librdrrndmbio_tui.so >/dev/null 2>&1
	cpconfig -ini '\config\apppath' -add string libcsp.so ${CP_LIBDIR}/libcsp.so >/dev/null 2>&1
	cpconfig -ini '\config\Random\Bio_tui' -add string DLL librdrrndmbio_tui.so >/dev/null 2>&1
	cpconfig -hardware reader -add hdimage -name 'HDD key storage' > /dev/null
	cpconfig -hardware rndm -add bio_tui -name 'Text bio random' -level 5 > /dev/null
	cpconfig -defprov -setdef -provtype 75 -provname 'Crypto-Pro GOST R 34.10-2001 KC1 CSP' >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 KC1 CSP' -add string 'Image Path' ${CP_LIBDIR}/libcsp.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 KC1 CSP' -add string 'Function Table Name' CPCSP_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 KC1 CSP' -add long Type 75 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider' -add string 'Image Path' ${CP_LIBDIR}/libcsp.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider' -add string 'Function Table Name' CPCSP_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider' -add long Type 75 >/dev/null 2>&1
	cpconfig -defprov -setdef -provtype 80 -provname 'Crypto-Pro GOST R 34.10-2012 KC1 CSP' >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC1 CSP' -add string 'Image Path' ${CP_LIBDIR}/libcsp.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC1 CSP' -add string 'Function Table Name' CPCSP_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC1 CSP' -add long Type 80 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Cryptographic Service Provider' -add string 'Image Path' ${CP_LIBDIR}/libcsp.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Cryptographic Service Provider' -add string 'Function Table Name' CPCSP_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Cryptographic Service Provider' -add long Type 80 >/dev/null 2>&1
	cpconfig -defprov -setdef -provtype 81 -provname 'Crypto-Pro GOST R 34.10-2012 KC1 Strong CSP' >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC1 Strong CSP' -add string 'Image Path' ${CP_LIBDIR}/libcsp.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC1 Strong CSP' -add string 'Function Table Name' CPCSP_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC1 Strong CSP' -add long Type 81 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Strong Cryptographic Service Provider' -add string 'Image Path' ${CP_LIBDIR}/libcsp.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Strong Cryptographic Service Provider' -add string 'Function Table Name' CPCSP_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Strong Cryptographic Service Provider' -add long Type 81 >/dev/null 2>&1
	cpconfig -defprov -setdef -provtype 1 -provname 'Crypto-Pro RSA Cryptographic Service Provider' >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro RSA Cryptographic Service Provider' -add string 'Image Path' ${CP_LIBDIR}/libcsp.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro RSA Cryptographic Service Provider' -add string 'Function Table Name' CPCSP_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro RSA Cryptographic Service Provider' -add long Type 1 >/dev/null 2>&1
	cpconfig -ini '\config\parameters\Crypto-Pro RSA Cryptographic Service Provider' -add long KeyTimeValidityControlMode 128 >/dev/null 2>&1
	cpconfig -defprov -setdef -provtype 16 -provname 'Crypto-Pro ECDSA and AES KC1 CSP' >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro ECDSA and AES KC1 CSP' -add string 'Image Path' ${CP_LIBDIR}/libcsp.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro ECDSA and AES KC1 CSP' -add string 'Function Table Name' CPCSP_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro ECDSA and AES KC1 CSP' -add long Type 16 >/dev/null 2>&1
	cpconfig -ini '\config\parameters\Crypto-Pro ECDSA and AES KC1 CSP' -add long KeyTimeValidityControlMode 128 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro ECDSA and AES CSP' -add string 'Image Path' ${CP_LIBDIR}/libcsp.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro ECDSA and AES CSP' -add string 'Function Table Name' CPCSP_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro ECDSA and AES CSP' -add long Type 16 >/dev/null 2>&1
	cpconfig -ini '\config\parameters\Crypto-Pro ECDSA and AES CSP' -add long KeyTimeValidityControlMode 128 >/dev/null 2>&1
	cpconfig -defprov -setdef -provtype 24 -provname 'Crypto-Pro Enhanced RSA and AES KC1 CSP' >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Enhanced RSA and AES KC1 CSP' -add string 'Image Path' ${CP_LIBDIR}/libcsp.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Enhanced RSA and AES KC1 CSP' -add string 'Function Table Name' CPCSP_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Enhanced RSA and AES KC1 CSP' -add long Type 24 >/dev/null 2>&1
	cpconfig -ini '\config\parameters\Crypto-Pro Enhanced RSA and AES KC1 CSP' -add long KeyTimeValidityControlMode 128 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Enhanced RSA and AES CSP' -add string 'Image Path' ${CP_LIBDIR}/libcsp.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Enhanced RSA and AES CSP' -add string 'Function Table Name' CPCSP_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Enhanced RSA and AES CSP' -add long Type 24 >/dev/null 2>&1
	cpconfig -ini '\config\parameters\Crypto-Pro Enhanced RSA and AES CSP' -add long KeyTimeValidityControlMode 128 >/dev/null 2>&1
	cpconfig -defprov -setdef -provtype 32 -provname 'Crypto-Pro Curve25519 and AES KC1 CSP' >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Curve25519 and AES KC1 CSP' -add string 'Image Path' ${CP_LIBDIR}/libcsp.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Curve25519 and AES KC1 CSP' -add string 'Function Table Name' CPCSP_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Curve25519 and AES KC1 CSP' -add long Type 32 >/dev/null 2>&1
	cpconfig -ini '\config\parameters\Crypto-Pro Curve25519 and AES KC1 CSP' -add long KeyTimeValidityControlMode 128 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Curve25519 and AES CSP' -add string 'Image Path' ${CP_LIBDIR}/libcsp.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Curve25519 and AES CSP' -add string 'Function Table Name' CPCSP_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Curve25519 and AES CSP' -add long Type 32 >/dev/null 2>&1
	cpconfig -ini '\config\parameters\Crypto-Pro Curve25519 and AES CSP' -add long KeyTimeValidityControlMode 128 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider Types\Type 075' -add string 'TypeName' "GOST R 34.10-2001 Signature with Diffie-Hellman Key Exchange" >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider Types\Type 080' -add string 'TypeName' "GOST R 34.10-2012 (256) Signature with Diffie-Hellman Key Exchange" >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider Types\Type 081' -add string 'TypeName' "GOST R 34.10-2012 (512) Signature with Diffie-Hellman Key Exchange" >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider Types\Type 001' -add string 'TypeName' "RSA Full (Signature and Key Exchange)" >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider Types\Type 016' -add string 'TypeName' "ECDSA Full and AES" >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider Types\Type 024' -add string 'TypeName' "RSA Full and AES" >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider Types\Type 032' -add string 'TypeName' "Curve25519 Full and AES" >/dev/null 2>&1
fi

# --- KC2 provider (lsb-cprocsp-kc2), from its %post ---
if [[ -e "${CP_LIBDIR}/libcspr.so" ]]; then
	cpconfig -ini '\config\apppath' -add string libcspr.so ${CP_LIBDIR}/libcspr.so >/dev/null 2>&1
	cpconfig -hardware reader -add hdimage -name 'HDD key storage' > /dev/null
	cpconfig -ini '\config\Services\CryptSrvKC2' -add string StartService cryptsrv >/dev/null 2>&1
	cpconfig -defprov -setdef -provtype 75 -provname 'Crypto-Pro GOST R 34.10-2001 KC2 CSP' >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 KC2 CSP' -add string 'Image Path' ${CP_LIBDIR}/libcspr.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 KC2 CSP' -add string 'Function Table Name' CPSRV_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 KC2 CSP' -add long Type 75 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 KC2 CSP' -add string Channel .cryptsrv >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider' -add string 'Image Path' ${CP_LIBDIR}/libcspr.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider' -add string 'Function Table Name' CPSRV_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider' -add long Type 75 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider' -add string Channel .cryptsrv >/dev/null 2>&1
	cpconfig -defprov -setdef -provtype 80 -provname 'Crypto-Pro GOST R 34.10-2012 KC2 CSP' >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC2 CSP' -add string 'Image Path' ${CP_LIBDIR}/libcspr.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC2 CSP' -add string 'Function Table Name' CPSRV_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC2 CSP' -add long Type 80 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC2 CSP' -add string Channel .cryptsrv >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Cryptographic Service Provider' -add string 'Image Path' ${CP_LIBDIR}/libcspr.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Cryptographic Service Provider' -add string 'Function Table Name' CPSRV_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Cryptographic Service Provider' -add long Type 80 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Cryptographic Service Provider' -add string Channel .cryptsrv >/dev/null 2>&1
	cpconfig -defprov -setdef -provtype 81 -provname 'Crypto-Pro GOST R 34.10-2012 KC2 Strong CSP' >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC2 Strong CSP' -add string 'Image Path' ${CP_LIBDIR}/libcspr.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC2 Strong CSP' -add string 'Function Table Name' CPSRV_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC2 Strong CSP' -add long Type 81 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC2 Strong CSP' -add string Channel .cryptsrv >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Strong Cryptographic Service Provider' -add string 'Image Path' ${CP_LIBDIR}/libcspr.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Strong Cryptographic Service Provider' -add string 'Function Table Name' CPSRV_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Strong Cryptographic Service Provider' -add long Type 81 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Strong Cryptographic Service Provider' -add string Channel .cryptsrv >/dev/null 2>&1
	cpconfig -defprov -setdef -provtype 1 -provname 'Crypto-Pro RSA Cryptographic Service Provider' >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro RSA Cryptographic Service Provider' -add string 'Image Path' ${CP_LIBDIR}/libcspr.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro RSA Cryptographic Service Provider' -add string 'Function Table Name' CPSRV_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro RSA Cryptographic Service Provider' -add long Type 1 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro RSA Cryptographic Service Provider' -add string Channel .cryptsrv >/dev/null 2>&1
	cpconfig -ini '\config\parameters\Crypto-Pro RSA Cryptographic Service Provider' -add long KeyTimeValidityControlMode 128 >/dev/null 2>&1
	cpconfig -defprov -setdef -provtype 16 -provname 'Crypto-Pro ECDSA and AES KC2 CSP' >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro ECDSA and AES KC2 CSP' -add string 'Image Path' ${CP_LIBDIR}/libcspr.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro ECDSA and AES KC2 CSP' -add string 'Function Table Name' CPSRV_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro ECDSA and AES KC2 CSP' -add long Type 16 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro ECDSA and AES KC2 CSP' -add string Channel .cryptsrv >/dev/null 2>&1
	cpconfig -ini '\config\parameters\Crypto-Pro ECDSA and AES KC2 CSP' -add long KeyTimeValidityControlMode 128 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro ECDSA and AES CSP' -add string 'Image Path' ${CP_LIBDIR}/libcspr.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro ECDSA and AES CSP' -add string 'Function Table Name' CPSRV_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro ECDSA and AES CSP' -add long Type 16 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro ECDSA and AES CSP' -add string Channel .cryptsrv >/dev/null 2>&1
	cpconfig -ini '\config\parameters\Crypto-Pro ECDSA and AES CSP' -add long KeyTimeValidityControlMode 128 >/dev/null 2>&1
	cpconfig -defprov -setdef -provtype 24 -provname 'Crypto-Pro Enhanced RSA and AES KC2 CSP' >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Enhanced RSA and AES KC2 CSP' -add string 'Image Path' ${CP_LIBDIR}/libcspr.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Enhanced RSA and AES KC2 CSP' -add string 'Function Table Name' CPSRV_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Enhanced RSA and AES KC2 CSP' -add long Type 24 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Enhanced RSA and AES KC2 CSP' -add string Channel .cryptsrv >/dev/null 2>&1
	cpconfig -ini '\config\parameters\Crypto-Pro Enhanced RSA and AES KC2 CSP' -add long KeyTimeValidityControlMode 128 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Enhanced RSA and AES CSP' -add string 'Image Path' ${CP_LIBDIR}/libcspr.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Enhanced RSA and AES CSP' -add string 'Function Table Name' CPSRV_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Enhanced RSA and AES CSP' -add long Type 24 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Enhanced RSA and AES CSP' -add string Channel .cryptsrv >/dev/null 2>&1
	cpconfig -ini '\config\parameters\Crypto-Pro Enhanced RSA and AES CSP' -add long KeyTimeValidityControlMode 128 >/dev/null 2>&1
	cpconfig -defprov -setdef -provtype 32 -provname 'Crypto-Pro Curve25519 and AES KC2 CSP' >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Curve25519 and AES KC2 CSP' -add string 'Image Path' ${CP_LIBDIR}/libcspr.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Curve25519 and AES KC2 CSP' -add string 'Function Table Name' CPSRV_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Curve25519 and AES KC2 CSP' -add long Type 32 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Curve25519 and AES KC2 CSP' -add string Channel .cryptsrv >/dev/null 2>&1
	cpconfig -ini '\config\parameters\Crypto-Pro Curve25519 and AES KC2 CSP' -add long KeyTimeValidityControlMode 128 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Curve25519 and AES CSP' -add string 'Image Path' ${CP_LIBDIR}/libcspr.so >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Curve25519 and AES CSP' -add string 'Function Table Name' CPSRV_GetFunctionTable >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Curve25519 and AES CSP' -add long Type 32 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Curve25519 and AES CSP' -add string Channel .cryptsrv >/dev/null 2>&1
	cpconfig -ini '\config\parameters\Crypto-Pro Curve25519 and AES CSP' -add long KeyTimeValidityControlMode 128 >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider Types\Type 075' -add string 'TypeName' "GOST R 34.10-2001 Signature with Diffie-Hellman Key Exchange" >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider Types\Type 080' -add string 'TypeName' "GOST R 34.10-2012 (256) Signature with Diffie-Hellman Key Exchange" >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider Types\Type 081' -add string 'TypeName' "GOST R 34.10-2012 (512) Signature with Diffie-Hellman Key Exchange" >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider Types\Type 001' -add string 'TypeName' "RSA Full (Signature and Key Exchange)" >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider Types\Type 016' -add string 'TypeName' "ECDSA Full and AES" >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider Types\Type 024' -add string 'TypeName' "RSA Full and AES" >/dev/null 2>&1
	cpconfig -ini '\cryptography\Defaults\Provider Types\Type 032' -add string 'TypeName' "Curve25519 Full and AES" >/dev/null 2>&1
fi

