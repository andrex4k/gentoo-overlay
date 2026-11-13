# Copyright 2026
# Distributed under the terms of the GNU General Public License v2
#
# Smart card and token driver registrations for CryptoPro CSP.
#
# Generated from the %post install scriptlets of the cprocsp-rdr-* and
# lsb-cprocsp-rdr-* RPM packages, version 5.0.13003-7.  Every block is
# guarded by the driver library it configures, so the file can be sourced
# for any set of USE=readers_* flags.  Sourced by cprocsp-postinst.sh.
#
# The vendor also registers the ATR tables of app-crypt/ccid readers by
# patching Info.plist of the installed CCID driver; that is deliberately
# not done here, because the file belongs to app-crypt/ccid.

# --- readers_emv (cprocsp-rdr-emv) ---
if [[ -e "${CP_LIBDIR}/librdremv.so" ]]; then
	LIBNAME=librdremv.so
	cpconfig -ini '\config\apppath' -add string $LIBNAME ${CP_LIBDIR}/$LIBNAME
	cpconfig -ini "\config\KeyCarriers\\GEMALTO" -add string DLL $LIBNAME
	cpconfig -hardware media -add GEMALTO -name 'GEMALTO' > /dev/null
	cpconfig -hardware media -configure GEMALTO -add hex atr 3b7a9400008065a20101013d72d643
	cpconfig -hardware media -configure GEMALTO -add hex mask ffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure GEMALTO -add string folders 'SLOT#01\SLOT#02\SLOT#03\SLOT#04\SLOT#05\SLOT#06'
	cpconfig -hardware media -configure GEMALTO -connect GemSim1 -add hex atr 3b2a008065a20102013172d643
	cpconfig -hardware media -configure GEMALTO -connect GemSim1 -add hex mask ffffffffffffffffffffffffff
	cpconfig -hardware media -configure GEMALTO -connect GemSim1 -add string folders 'SLOT#01\SLOT#02\SLOT#03\SLOT#04\SLOT#05\SLOT#06'
	cpconfig -hardware media -configure GEMALTO -connect GemSim2 -add hex atr 3b7a9600008065a20101013d72d643
	cpconfig -hardware media -configure GEMALTO -connect GemSim2 -add hex mask ffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure GEMALTO -connect GemSim2 -add string folders 'SLOT#01\SLOT#02\SLOT#03\SLOT#04\SLOT#05\SLOT#06'
	cpconfig -hardware media -configure GEMALTO -connect Optelio -add hex atr 3b6a00008065a20101013d72d643
	cpconfig -hardware media -configure GEMALTO -connect Optelio -add hex mask ffffffffffffffffffffffffffff
	cpconfig -hardware media -configure GEMALTO -connect Optelio -add string folders 'SLOT#01\SLOT#02\SLOT#03\SLOT#04\SLOT#05\SLOT#06'
	cpconfig -hardware media -configure GEMALTO -connect OptelioNDef -add hex atr 3B6E000080318066B0000000000083009000
	cpconfig -hardware media -configure GEMALTO -connect OptelioNDef -add hex mask fffffffffffffffff00000000000ffffffff
	cpconfig -hardware media -configure GEMALTO -connect OptelioNDef -add string folders 'SLOT#01\SLOT#02\SLOT#03\SLOT#04\SLOT#05\SLOT#06'
	cpconfig -hardware media -configure GEMALTO -connect Native -add hex atr 3b2a008065a20101013d72d643
	cpconfig -hardware media -configure GEMALTO -connect Native -add hex mask ffffffffffffffffffffffffff
	cpconfig -hardware media -configure GEMALTO -connect Native -add string folders 'SLOT#01\SLOT#02\SLOT#03\SLOT#04\SLOT#05\SLOT#06'
fi

# --- readers_inpaspot (cprocsp-rdr-inpaspot) ---
if [[ -e "${CP_LIBDIR}/librdrinpaspot.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdrinpaspot.so ${CP_LIBDIR}/librdrinpaspot.so
	NAME=INPASPOT
	cpconfig -ini '\config\KeyCarriers\'$NAME -add string DLL librdrinpaspot.so
	cpconfig -hardware media -add $NAME -connect SCOneSeries -name 'ALIOTH, SCOne Series' > /dev/null
	cpconfig -hardware media -configure $NAME -connect SCOneSeries -add hex atr  3b6d000080318065495300000183079000
	cpconfig -hardware media -configure $NAME -connect SCOneSeries -add hex mask ffffffffffffffffffff0000ffffffffff
	cpconfig -hardware media -add $NAME -connect SCOneD80 -name 'ALIOTH, SCOne D80' > /dev/null
	cpconfig -hardware media -configure $NAME -connect SCOneD80 -add hex atr  3BFD130000100080318065495300000183079000
	cpconfig -hardware media -configure $NAME -connect SCOneD80 -add hex mask ffffffffffffffffffffffffff0000ffffffffff
	cpconfig -hardware media -add $NAME -connect SCOneV3 -name 'ALIOTH, SCOne V3' > /dev/null
	cpconfig -hardware media -configure $NAME -connect SCOneV3 -add hex atr  3b6900ff4a434f503234325232
	cpconfig -hardware media -configure $NAME -connect SCOneV3 -add hex mask ffffffffffffffffffffffffff
	cpconfig -hardware media -add $NAME -connect J3H081 -name 'ALIOTH, SCOne J3H081' > /dev/null
	cpconfig -hardware media -configure $NAME -connect J3H081 -add hex atr  3B6A00FF0031C173C84000009000
	cpconfig -hardware media -configure $NAME -connect J3H081 -add hex mask ffffffffffffffffffffffffffff
	cpconfig -hardware media -add $NAME -name 'ALIOTH, SCOne V4' > /dev/null
	cpconfig -hardware media -configure $NAME -add hex atr  3b6800ff4a434f5076323431
	cpconfig -hardware media -configure $NAME -add hex mask ffffffffffffffffffffffff
	cpconfig -hardware media -add $NAME -connect Goldpac -name 'ALIOTH, Goldpac' > /dev/null
	cpconfig -hardware media -configure $NAME -connect Goldpac -add hex atr  3B6A0000866500A758C055009000
	cpconfig -hardware media -configure $NAME -connect Goldpac -add hex mask ffffffffffffffffffffffffffff
	cpconfig -hardware media -add $NAME -connect Ubivelox -name 'ALIOTH, Ubivelox' > /dev/null
	cpconfig -hardware media -configure $NAME -connect Ubivelox -add hex atr  3B6800000073C84000009000
	cpconfig -hardware media -configure $NAME -connect Ubivelox -add hex mask ffffffffffffffffffffffff
	cpconfig -hardware media -add $NAME -connect RFPS89 -name 'ALIOTH, RFPS89' > /dev/null
	cpconfig -hardware media -configure $NAME -connect RFPS89 -add hex atr  3b6f000057694C4C55000B0000000020220128
	cpconfig -hardware media -configure $NAME -connect RFPS89 -add hex mask ffffffffffffffffffffffffffffffffffffff
	cpconfig -hardware media -add $NAME -connect RFPS89NFC -name 'ALIOTH, RFPS89 NFC' > /dev/null
	cpconfig -hardware media -configure $NAME -connect RFPS89NFC -add hex atr  3b8f800157694c4c55000B000000002022012845
	cpconfig -hardware media -configure $NAME -connect RFPS89NFC -add hex mask ffffffffffffffffffffffffffffffffffffffff
	cpconfig -hardware media -add $NAME -connect D20MIR -name 'ALIOTH, D20 MIR' > /dev/null
	cpconfig -hardware media -configure $NAME -connect D20MIR -add hex atr  3BF81300FF910131FE41534C4A263123020069
	cpconfig -hardware media -configure $NAME -connect D20MIR -add hex mask ffffffffffffffffffffffffffffffffffffff
	cpconfig -hardware media -add $NAME -connect D20MIRWarm -name 'ALIOTH, D20 MIR' > /dev/null
	cpconfig -hardware media -configure $NAME -connect D20MIRWarm -add hex atr  3BE800FF8131FE41534C4A26312302007B
	cpconfig -hardware media -configure $NAME -connect D20MIRWarm -add hex mask ffffffffffffffffffffffffffffffffff
	cpconfig -hardware media -add $NAME -connect D20MIRNFC -name 'ALIOTH, D20 MIR NFC' > /dev/null
	cpconfig -hardware media -configure $NAME -connect D20MIRNFC -add hex atr  3B8A80010031C173C8400000900090
	cpconfig -hardware media -configure $NAME -connect D20MIRNFC -add hex mask ffffffffffffffffffffffffffffff
	NAME=INPASPOT1
	cpconfig -ini '\config\KeyCarriers\'$NAME -add string DLL librdrinpaspot.so
	cpconfig -hardware media -add $NAME -name 'Inpaspot' > /dev/null
	cpconfig -hardware media -configure $NAME -add hex atr  3bfd130000108080318065b0831100ac83009000
	cpconfig -hardware media -configure $NAME -add hex mask ffffffffffffffffffffffffffffffffffffffff
	NAME=INPASPOT2
	cpconfig -ini '\config\KeyCarriers\'$NAME -add string DLL librdrinpaspot.so
	cpconfig -hardware media -add $NAME -name 'Inpaspot' > /dev/null
	cpconfig -hardware media -configure $NAME -add hex atr  3bfa130000108080318066b0840c016e01
	cpconfig -hardware media -configure $NAME -add hex mask ffffffffffffffffffffffffffffffffff
fi

# --- readers_kst (cprocsp-rdr-kst) ---
if [[ -e "${CP_LIBDIR}/librdrkst.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdrkst.so ${CP_LIBDIR}/librdrkst.so
	cpconfig -ini '\config\KeyCarriers\MORPHOKST' -add string DLL librdrkst.so
	cpconfig -hardware media -add MORPHOKST -name 'MorphoKST' > /dev/null
	cpconfig -hardware media -configure MORPHOKST -add hex atr 3b6800000073c84000009000
	cpconfig -hardware media -configure MORPHOKST -add hex mask ffffffffffffffffffffffff
	cpconfig -hardware media -configure MORPHOKST -add string Name 'MorphoKST'
fi

# --- readers_mskey (cprocsp-rdr-mskey) ---
if [[ -e "${CP_LIBDIR}/librdrmskey.so" ]]; then
	NAME=MSKEY
	cpconfig -ini '\config\apppath' -add string librdrmskey.so ${CP_LIBDIR}/librdrmskey.so
	cpconfig -ini "\config\KeyCarriers\\$NAME" -add string DLL librdrmskey.so
	cpconfig -hardware media -add $NAME -name $NAME > /dev/null
	cpconfig -hardware media -configure $NAME -add hex atr 3b9e00008031c0654d5300000072f7418107
	cpconfig -hardware media -configure $NAME -add hex mask ffff0000ffffffffffff300000ffffffffff
	cpconfig -hardware media -configure $NAME -add string Name 'Multisoft MSKey'
	cpconfig -hardware media -add $NAME -connect MskeyESMART -name 'Multisoft MSKey ESMART' > /dev/null
	cpconfig -hardware media -configure $NAME -connect MskeyESMART -add hex atr  3B9796008073F7C1808105
	cpconfig -hardware media -configure $NAME -connect MskeyESMART -add hex mask ffffffffffffffffffffff
fi

# --- readers_novacard (cprocsp-rdr-novacard) ---
if [[ -e "${CP_LIBDIR}/librdrnova.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdrnova.so ${CP_LIBDIR}/librdrnova.so
	cpconfig -ini '\config\KeyCarriers\NOVACARD' -add string DLL librdrnova.so
	cpconfig -hardware media -add NOVACARD -name 'NOVACARD' > /dev/null
	cpconfig -hardware media -configure NOVACARD -add hex atr 3b6f00000031c068435350454d560300009000
	cpconfig -hardware media -configure NOVACARD -add hex mask ffffffffffffffffffffffffffffffff00ffff
	cpconfig -hardware media -configure NOVACARD -add string folders "0B00\\0B10"
	cpconfig -hardware media -configure NOVACARD -add string Name 'Novacard'
	cpconfig -hardware media -configure NOVACARD -connect CF58 -add hex atr 3B6B00000031C06408440300009000
	cpconfig -hardware media -configure NOVACARD -connect CF58 -add hex mask ffffffffffffffffffffff0000ffff
	cpconfig -hardware media -configure NOVACARD -connect CF58 -add string folders "0B00\\0B10"
	cpconfig -hardware media -configure NOVACARD -connect CF60 -add hex atr 3B6B00000031C16408603200009000
	cpconfig -hardware media -configure NOVACARD -connect CF60 -add hex mask ffffffffffffffffffffff0000ffff
	cpconfig -hardware media -configure NOVACARD -connect CF60 -add string folders "0B00\\0B10"
	cpconfig -hardware media -configure NOVACARD -connect Bingma -add hex atr 3B6600004E4320423031
	cpconfig -hardware media -configure NOVACARD -connect Bingma -add hex mask FFFFFFFFFFFFFFFFFFFF
	cpconfig -hardware media -configure NOVACARD -connect Bingma -add string folders "0B00\\0B10"
	cpconfig -hardware media -configure NOVACARD -connect Castle -add hex atr 3B189657694C4C20200417
	cpconfig -hardware media -configure NOVACARD -connect Castle -add hex mask FFFFFFFFFFFFFFFFFFFFFF
	cpconfig -hardware media -configure NOVACARD -connect Castle -add string folders "0B00\\0B10"
	cpconfig -hardware media -configure NOVACARD -connect RainBW -add hex atr 3B6600004E43204B3032
	cpconfig -hardware media -configure NOVACARD -connect RainBW -add hex mask FFFFFFFFFFFFFFFFFFFF
	cpconfig -hardware media -configure NOVACARD -connect RainBW -add string folders "0B00\\0B10"
	cpconfig -hardware media -configure NOVACARD -connect CastleNFC -add hex atr 3B88800157694C4C2020041724
	cpconfig -hardware media -configure NOVACARD -connect CastleNFC -add hex mask FFFFFFFFFFFFFFFFFFFFFFFFFF
	cpconfig -hardware media -configure NOVACARD -connect CastleNFC -add string folders "0B00\\0B10"
	cpconfig -hardware media -configure NOVACARD -connect CastleNFC -add string Name "Novacard, Castle NFC"
	cpconfig -hardware media -configure NOVACARD -connect RainBWNFC -add hex atr 3B8680014E43204B303263
	cpconfig -hardware media -configure NOVACARD -connect RainBWNFC -add hex mask FFFFFFFFFFFFFFFFFFFFFF
	cpconfig -hardware media -configure NOVACARD -connect RainBWNFC -add string folders "0B00\\0B10"
	cpconfig -hardware media -configure NOVACARD -connect RainBWNFC -add string Name "Novacard, RainBW NFC"
fi

# --- readers_edoc (cprocsp-rdr-edoc) ---
if [[ -e "${CP_LIBDIR}/librdredoc.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdredoc.so ${CP_LIBDIR}/librdredoc.so
	cpconfig -ini '\config\KeyCarriers\EDOC' -add string DLL librdredoc.so
	cpconfig -hardware media -add EDOC -name 'Electronic Document' > /dev/null
	cpconfig -hardware media -configure EDOC -add hex atr 3B98958011FE8031C072F741810751
	cpconfig -hardware media -configure EDOC -add hex mask FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
fi

# --- readers_rutoken (cprocsp-rdr-rutoken) ---
if [[ -e "${CP_LIBDIR}/librdrrutoken.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdrrutoken.so ${CP_LIBDIR}/librdrrutoken.so
	cpconfig -ini '\config\KeyCarriers\RutokenECP' -add string DLL librdrrutoken.so
	cpconfig -hardware media -add RutokenECP -name 'Rutoken ECP' > /dev/null
	cpconfig -hardware media -configure RutokenECP -add hex atr 3b8b015275746f6b656e20445320c1
	cpconfig -hardware media -configure RutokenECP -add hex mask ffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure RutokenECP -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000\\1100\\1200\\1300\\1400\\1500\\1600\\1700\\1800"
	cpconfig -hardware media -configure RutokenECP -add long size_1 60
	cpconfig -hardware media -configure RutokenECP -add long size_2 70
	cpconfig -hardware media -configure RutokenECP -add long size_3 8
	cpconfig -hardware media -configure RutokenECP -add long size_4 60
	cpconfig -hardware media -configure RutokenECP -add long size_5 70
	cpconfig -hardware media -configure RutokenECP -add long size_6 300
	cpconfig -hardware media -configure RutokenECP -add long size_7 8
	cpconfig -ini '\config\KeyCarriers\RutokenFkcOld' -add string DLL librdrrutoken.so
	cpconfig -hardware media -add RutokenFkcOld -name 'CryptoPro Rutoken' > /dev/null
	cpconfig -hardware media -configure RutokenFkcOld -add hex atr 3b8b015275746f6b656e20454350a0
	cpconfig -hardware media -configure RutokenFkcOld -add hex mask ffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure RutokenFkcOld -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000\\1100\\1200\\1300\\1400\\1500\\1600\\1700\\1800"
	cpconfig -hardware media -configure RutokenFkcOld -add long size_1 60
	cpconfig -hardware media -configure RutokenFkcOld -add long size_2 70
	cpconfig -hardware media -configure RutokenFkcOld -add long size_3 8
	cpconfig -hardware media -configure RutokenFkcOld -add long size_4 60
	cpconfig -hardware media -configure RutokenFkcOld -add long size_5 70
	cpconfig -hardware media -configure RutokenFkcOld -add long size_6 300
	cpconfig -hardware media -configure RutokenFkcOld -add long size_7 8
	cpconfig -ini '\config\KeyCarriers\RutokenECPSC' -add string DLL librdrrutoken.so
	cpconfig -hardware media -add RutokenECPSC -name 'Rutoken ECP SC' > /dev/null
	cpconfig -hardware media -configure RutokenECPSC -add hex atr 3b9c96005275746f6b656e4543507363
	cpconfig -hardware media -configure RutokenECPSC -add hex mask ffffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure RutokenECPSC -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000\\1100\\1200\\1300\\1400\\1500\\1600\\1700\\1800"
	cpconfig -hardware media -configure RutokenECPSC -add long size_1 60
	cpconfig -hardware media -configure RutokenECPSC -add long size_2 70
	cpconfig -hardware media -configure RutokenECPSC -add long size_3 8
	cpconfig -hardware media -configure RutokenECPSC -add long size_4 60
	cpconfig -hardware media -configure RutokenECPSC -add long size_5 70
	cpconfig -hardware media -configure RutokenECPSC -add long size_6 300
	cpconfig -hardware media -configure RutokenECPSC -add long size_7 8
	cpconfig -ini '\config\KeyCarriers\RutokenLiteSC2' -add string DLL librdrrutoken.so
	cpconfig -hardware media -add RutokenLiteSC2 -name 'Rutoken Lite SC' > /dev/null
	cpconfig -hardware media -configure RutokenLiteSC2 -add hex atr 3b9e96005275746f6b656e4c697465534332
	cpconfig -hardware media -configure RutokenLiteSC2 -add hex mask ffffffffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure RutokenLiteSC2 -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000\\1100\\1200\\1300\\1400\\1500\\1600\\1700\\1800"
	cpconfig -hardware media -configure RutokenLiteSC2 -add long size_1 60
	cpconfig -hardware media -configure RutokenLiteSC2 -add long size_2 70
	cpconfig -hardware media -configure RutokenLiteSC2 -add long size_3 8
	cpconfig -hardware media -configure RutokenLiteSC2 -add long size_4 60
	cpconfig -hardware media -configure RutokenLiteSC2 -add long size_5 70
	cpconfig -hardware media -configure RutokenLiteSC2 -add long size_6 300
	cpconfig -hardware media -configure RutokenLiteSC2 -add long size_7 8
	cpconfig -ini '\config\KeyCarriers\RutokenLite' -add string DLL librdrrutoken.so
	cpconfig -hardware media -add RutokenLite -name 'Rutoken lite' > /dev/null
	cpconfig -hardware media -configure RutokenLite -add hex atr 3b8b015275746f6b656e6c697465c2
	cpconfig -hardware media -configure RutokenLite -add hex mask ffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure RutokenLite -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000\\1100\\1200\\1300\\1400\\1500\\1600\\1700\\1800"
	cpconfig -hardware media -configure RutokenLite -add long size_1 60
	cpconfig -hardware media -configure RutokenLite -add long size_2 70
	cpconfig -hardware media -configure RutokenLite -add long size_3 8
	cpconfig -hardware media -configure RutokenLite -add long size_4 60
	cpconfig -hardware media -configure RutokenLite -add long size_5 70
	cpconfig -hardware media -configure RutokenLite -add long size_6 300
	cpconfig -hardware media -configure RutokenLite -add long size_7 8
	cpconfig -ini '\config\KeyCarriers\Rutoken' -add string DLL librdrrutoken.so
	cpconfig -hardware media -add Rutoken -name 'Rutoken S' > /dev/null
	cpconfig -hardware media -configure Rutoken -add hex atr 3b6f00ff00567275546f6b6e73302000009000
	cpconfig -hardware media -configure Rutoken -add hex mask ffffffffffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure Rutoken -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000"
	cpconfig -hardware media -configure Rutoken -add long size_1 60
	cpconfig -hardware media -configure Rutoken -add long size_2 70
	cpconfig -hardware media -configure Rutoken -add long size_3 8
	cpconfig -hardware media -configure Rutoken -add long size_4 60
	cpconfig -hardware media -configure Rutoken -add long size_5 70
	cpconfig -hardware media -configure Rutoken -add long size_6 300
	cpconfig -hardware media -configure Rutoken -add long size_7 8
	cpconfig -ini '\config\KeyCarriers\RutokenPinpad' -add string DLL librdrrutoken.so
	cpconfig -hardware media -add RutokenPinpad -name 'Rutoken PinPad' > /dev/null
	cpconfig -hardware media -configure RutokenPinpad -add hex atr 3B8B01527450494E5061642020329C
	cpconfig -hardware media -configure RutokenPinpad -add hex mask ffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure RutokenPinpad -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000\\1100\\1200\\1300\\1400\\1500\\1600\\1700\\1800"
	cpconfig -ini '\config\KeyCarriers\RutokenECPM' -add string DLL librdrrutoken.so
	cpconfig -hardware media -add RutokenECPM -name 'Rutoken ECP 2151' > /dev/null
	cpconfig -hardware media -configure RutokenECPM -add hex atr 3B18967275746F6B656E6D
	cpconfig -hardware media -configure RutokenECPM -add hex mask ffffffffffffffffffffff
	cpconfig -hardware media -configure RutokenECPM -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000\\1100\\1200\\1300\\1400\\1500\\1600\\1700\\1800"
	cpconfig -hardware media -configure RutokenECPM -add long size_1 60
	cpconfig -hardware media -configure RutokenECPM -add long size_2 70
	cpconfig -hardware media -configure RutokenECPM -add long size_3 3072
	cpconfig -hardware media -configure RutokenECPM -add long size_4 60
	cpconfig -hardware media -configure RutokenECPM -add long size_5 70
	cpconfig -hardware media -configure RutokenECPM -add long size_6 300
	cpconfig -hardware media -configure RutokenECPM -add long size_7 8
	cpconfig -ini '\config\KeyCarriers\RutokenECPMSC' -add string DLL librdrrutoken.so
	cpconfig -hardware media -add RutokenECPMSC -name 'Rutoken ECP 2151 SC' > /dev/null
	cpconfig -hardware media -configure RutokenECPMSC -add hex atr 3B1A967275746F6B656E6D7363
	cpconfig -hardware media -configure RutokenECPMSC -add hex mask ffffffffffffffffffffffffff
	cpconfig -hardware media -configure RutokenECPMSC -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000\\1100\\1200\\1300\\1400\\1500\\1600\\1700\\1800"
	cpconfig -hardware media -configure RutokenECPMSC -add long size_1 60
	cpconfig -hardware media -configure RutokenECPMSC -add long size_2 70
	cpconfig -hardware media -configure RutokenECPMSC -add long size_3 3072
	cpconfig -hardware media -configure RutokenECPMSC -add long size_4 60
	cpconfig -hardware media -configure RutokenECPMSC -add long size_5 70
	cpconfig -hardware media -configure RutokenECPMSC -add long size_6 300
	cpconfig -hardware media -configure RutokenECPMSC -add long size_7 8
	cpconfig -ini '\config\KeyCarriers\RutokenNFC' -add string DLL librdrrutoken.so
	cpconfig -hardware media -add RutokenNFC -name 'Rutoken NFC' > /dev/null
	cpconfig -hardware media -configure RutokenNFC -connect Default -add hex atr 3B9C968011405275746F6B656E4543507363C0
	cpconfig -hardware media -configure RutokenNFC -connect Default -add hex mask fffffefffffffffffffffffffffffffffffffe
	cpconfig -hardware media -configure RutokenNFC -connect Default -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000\\1100\\1200\\1300\\1400\\1500\\1600\\1700\\1800"
	cpconfig -hardware media -configure RutokenNFC -connect Default -add long size_1 60
	cpconfig -hardware media -configure RutokenNFC -connect Default -add long size_2 70
	cpconfig -hardware media -configure RutokenNFC -connect Default -add long size_3 3072
	cpconfig -hardware media -configure RutokenNFC -connect Default -add long size_4 60
	cpconfig -hardware media -configure RutokenNFC -connect Default -add long size_5 70
	cpconfig -hardware media -configure RutokenNFC -connect Default -add long size_6 300
	cpconfig -hardware media -configure RutokenNFC -connect Default -add long size_7 8
fi

# --- readers_jacarta (cprocsp-rdr-jacarta) ---
if [[ -e "${CP_LIBDIR}/librdrjacarta.so" ]]; then
	LIBNAME=librdrjacarta
	cpconfig -ini '\config\apppath' -add string $LIBNAME.so ${CP_LIBDIR}/$LIBNAME.so
	NAME="jacarta"
	cpconfig -ini "\config\KeyCarriers\\$NAME" -add string DLL $LIBNAME.so
	cpconfig -hardware media -add $NAME -name 'Aladdin R.D. JaCarta' > /dev/null
	cpconfig -hardware media -configure $NAME -add hex atr 3bdc18ff8191fe1fc38073c821136601061159000128
	cpconfig -hardware media -configure $NAME -add hex mask ffffffffffffffffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure $NAME -add string folders 'CC00\CC01\CC02\CC03\CC04\CC05\CC06\CC07\CC08\CC09'
	NAME="jacarta_lt"
	cpconfig -ini "\config\KeyCarriers\\$NAME" -add string DLL $LIBNAME.so
	cpconfig -hardware media -add $NAME -name 'Aladdin R.D. JaCarta LT' > /dev/null
	cpconfig -hardware media -configure $NAME -add hex atr 3bdc18ff8111fe8073c82113660106013080018d
	cpconfig -hardware media -configure $NAME -add hex mask ffffffffffffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure $NAME -add string folders 'CC00\CC01\CC02\CC03\CC04\CC05\CC06\CC07\CC08\CC09'
	NAME="eToken_JAVA_10"
	cpconfig -ini "\config\KeyCarriers\\$NAME" -add string DLL $LIBNAME.so
	cpconfig -hardware media -add $NAME -name 'Aladdin R.D. eToken Java' > /dev/null
	cpconfig -hardware media -configure $NAME -add hex atr 3bd518008131fe7d8073c82110f4
	cpconfig -hardware media -configure $NAME -add hex mask ffffffffffffffffffffffffffff
	cpconfig -hardware media -configure $NAME -add string folders 'CC00\CC01\CC02\CC03\CC04\CC05\CC06\CC07\CC08\CC09'
	NAME="eToken_JAVA_10b"
	cpconfig -ini "\config\KeyCarriers\\$NAME" -add string DLL $LIBNAME.so
	cpconfig -hardware media -add $NAME -name 'Aladdin R.D. eToken Java' > /dev/null
	cpconfig -hardware media -configure $NAME -add hex atr 3bd5180081313a7d8073c8211030
	cpconfig -hardware media -configure $NAME -add hex mask ffffffffffffffffffffffffffff
	cpconfig -hardware media -configure $NAME -add string folders 'CC00\CC01\CC02\CC03\CC04\CC05\CC06\CC07\CC08\CC09'
	NAME="eToken_PRO16"
	cpconfig -ini "\config\KeyCarriers\\$NAME" -add string DLL $LIBNAME.so
	cpconfig -hardware media -add $NAME -name 'Aladdin R.D. eToken Pro 16K' > /dev/null
	cpconfig -hardware media -configure $NAME -add hex atr 3be200ffc11031fe55c8029c
	cpconfig -hardware media -configure $NAME -add hex mask ffffffffffffffffffffffff
	cpconfig -hardware media -configure $NAME -add string folders 'CC00\CC01\CC02\CC03\CC04\CC05\CC06\CC07\CC08\CC09'
	NAME="eToken_PRO32"
	cpconfig -ini "\config\KeyCarriers\\$NAME" -add string DLL $LIBNAME.so
	cpconfig -hardware media -add $NAME -name 'Aladdin R.D. eToken Pro 32K' > /dev/null
	cpconfig -hardware media -configure $NAME -add hex atr 3bf29800ffc11031fe55c80315
	cpconfig -hardware media -configure $NAME -add hex mask ffffffffffffffffffffffffff
	cpconfig -hardware media -configure $NAME -add string folders 'CC00\CC01\CC02\CC03\CC04\CC05\CC06\CC07\CC08\CC09'
	NAME="eToken_PRO_M420"
	cpconfig -ini "\config\KeyCarriers\\$NAME" -add string DLL $LIBNAME.so
	cpconfig -hardware media -add $NAME -name 'Aladdin R.D. eToken Pro M420' > /dev/null
	cpconfig -hardware media -configure $NAME -add hex atr 3bf2180000c10a31fe55c80600
	cpconfig -hardware media -configure $NAME -add hex mask ffffffff00ffffffffffffff00
	cpconfig -hardware media -configure $NAME -add string folders 'CC00\CC01\CC02\CC03\CC04\CC05\CC06\CC07\CC08\CC09'
	NAME="eToken_PRO_M420B"
	cpconfig -ini "\config\KeyCarriers\\$NAME" -add string DLL $LIBNAME.so
	cpconfig -hardware media -add $NAME -name 'Aladdin R.D. eToken Pro M420b' > /dev/null
	cpconfig -hardware media -configure $NAME -add hex atr 3bf2180002c10a31fe58c80975
	cpconfig -hardware media -configure $NAME -add hex mask ffffffffffffffffffffffffff
	cpconfig -hardware media -configure $NAME -add string folders 'CC00\CC01\CC02\CC03\CC04\CC05\CC06\CC07\CC08\CC09'
fi

# --- readers_cloud (cprocsp-rdr-cloud) ---
if [[ -e "${CP_LIBDIR}/librdrcloud.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdrcloud.so ${CP_LIBDIR}/librdrcloud.so
	cpconfig -ini '\config\KeyDevices\Cloud' -add string DLL librdrcloud.so
	cpconfig -ini '\config\KeyDevices\Cloud' -add string AuthApp ${CP_SBINDIR}/oauthapp
	cpconfig -hardware reader -add Cloud > /dev/null
	cpconfig -ini '\config\debug' -add long cloud 1
fi

# --- readers_cpfkc (cprocsp-rdr-cpfkc) ---
if [[ -e "${CP_LIBDIR}/librdrcpfkc.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdrcpfkc.so ${CP_LIBDIR}/librdrcpfkc.so
	cpconfig -ini '\config\KeyCarriers\rutokenfkc' -add string DLL librdrcpfkc.so
	cpconfig -ini '\config\KeyCarriers\rutokenfkc_nfc' -add string DLL librdrcpfkc.so
	cpconfig -ini '\config\KeyCarriers\smartparkfkc' -add string DLL librdrcpfkc.so
	cpconfig -hardware media -add rutokenfkc -name 'rutokenfkc' > /dev/null
	cpconfig -hardware media -configure rutokenfkc -connect Default -add hex atr 3b8b015275746f6b656e20445320c1
	cpconfig -hardware media -configure rutokenfkc -connect Default -add hex mask ffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure rutokenfkc -connect Default -add string Name 'Rutoken FKC'
	cpconfig -hardware media -add rutokenfkc_nfc -name 'rutokenfkc_nfc' > /dev/null
	cpconfig -hardware media -configure rutokenfkc_nfc -connect Default -add hex atr 3B88800152745343778183206A
	cpconfig -hardware media -configure rutokenfkc_nfc -connect Default -add hex mask ffffffffffffffffffffffffff
	cpconfig -hardware media -configure rutokenfkc_nfc -connect Default -add string Name 'Rutoken FKC NFC'
	cpconfig -hardware media -configure rutokenfkc_nfc -connect Contact -add hex atr 3B9C968011405275746F6B656E4543507363C0
	cpconfig -hardware media -configure rutokenfkc_nfc -connect Contact -add hex mask fffffefffffffffffffffffffffffffffffffe
	cpconfig -hardware media -configure rutokenfkc_nfc -connect Contact -add string Name 'Rutoken FKC NFC'
	cpconfig -hardware media -add smartparkfkc -name 'smartparkfkc' > /dev/null
	cpconfig -hardware media -configure smartparkfkc -connect Default -add hex atr 00000000534D4152545041524B20464B43
	cpconfig -hardware media -configure smartparkfkc -connect Default -add hex mask 00000000ffffffffffffffffffffffffff
	cpconfig -hardware media -configure smartparkfkc -connect Default -add string Name 'SmartPark FKC'
	cpconfig -hardware media -configure smartparkfkc -connect Combi -add hex atr 3B9E00008031C0654D4700000272F7418107
	cpconfig -hardware media -configure smartparkfkc -connect Combi -add hex mask FFFF0000FFFFFFFFFFFF300002FFFFFFFFFF
	cpconfig -hardware media -configure smartparkfkc -connect Combi -add string Name 'SmartPark FKC Combi'
fi

# --- readers_infocrypt (cprocsp-rdr-infocrypt) ---
if [[ -e "${CP_LIBDIR}/librdrinfocrypt.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdrinfocrypt.so ${CP_LIBDIR}/librdrinfocrypt.so
	cpconfig -ini '\config\KeyCarriers\TokenPlusPlusLite' -add string DLL librdrinfocrypt.so
	cpconfig -hardware media -add TokenPlusPlusLite -name 'TokenPlusPlusLite' > /dev/null
	cpconfig -hardware media -configure TokenPlusPlusLite -add hex atr 3bdf18008131fe670056496e666f43727330200000900054
	cpconfig -hardware media -configure TokenPlusPlusLite -add hex mask ffffffffffffffffffffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure TokenPlusPlusLite -add string Name 'InfoCrypt Token++ lite'
	cpconfig -hardware media -configure TokenPlusPlusLite -add string folders '2000\1FFF\1FFE\1FFD\1FFC\1FFB\1FFA\1FF9\1FF8\1FF7\1FF6\1FF5'
	cpconfig -ini '\config\KeyCarriers\TokenPlusPlusTls' -add string DLL librdrinfocrypt.so
	cpconfig -hardware media -add TokenPlusPlusTls -name 'TokenPlusPlusTls' > /dev/null
	cpconfig -hardware media -configure TokenPlusPlusTls -add hex atr 3bdf18008131fe67005c49434dd49147d279000038330057
	cpconfig -hardware media -configure TokenPlusPlusTls -add hex mask ffffffffffffffffffffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure TokenPlusPlusTls -add string Name 'InfoCrypt Token++ tls'
	cpconfig -ini '\config\KeyCarriers\VPNKEYTLS' -add string DLL librdrinfocrypt.so
	cpconfig -hardware media -add VPNKEYTLS -name 'VPNKEYTLS' > /dev/null
	cpconfig -hardware media -configure VPNKEYTLS -add hex atr 3bdf18008131fe67005c49434dd49147d276000038330058
	cpconfig -hardware media -configure VPNKEYTLS -add hex mask ffffffffffffffffffffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure VPNKEYTLS -add string Name 'InfoCrypt VPN-Key-TLS'
	cpconfig -ini '\config\KeyCarriers\TokenPlusPlus' -add string DLL librdrinfocrypt.so
	cpconfig -hardware media -add TokenPlusPlus -name 'TokenPlusPlus' > /dev/null
	cpconfig -hardware media -configure TokenPlusPlus -add hex atr 3bdf18008131fe67005c49434dd49147d277000038330059
	cpconfig -hardware media -configure TokenPlusPlus -add hex mask ffffffffffffffffffffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure TokenPlusPlus -add string Name 'InfoCrypt Token++'
fi

# --- readers_rosan (cprocsp-rdr-rosan) ---
if [[ -e "${CP_LIBDIR}/librdrrosan.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdrrosan.so ${CP_LIBDIR}/librdrrosan.so
	cpconfig -ini '\config\KeyCarriers\ROSAN' -add string DLL librdrrosan.so
	cpconfig -hardware media -add ROSAN -name 'Rosan' > /dev/null
	cpconfig -hardware media -configure ROSAN -add hex atr 3B6800000073C84000009000
	cpconfig -hardware media -configure ROSAN -add hex mask FFFFFFFFFFFFFFFF00FFFFFF
	cpconfig -hardware media -configure ROSAN -add string folders "D01\\D02\\D03\\D04\\D05"
	cpconfig -hardware media -add ROSAN -connect Rosan_GD -name 'Rosan' > /dev/null
	cpconfig -hardware media -configure ROSAN -connect Rosan_GD -add hex atr 3BFF9700008031FE450031C173C82110640000000000900000
	cpconfig -hardware media -configure ROSAN -connect Rosan_GD -add hex mask FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFF00
	cpconfig -hardware media -configure ROSAN -connect Rosan_GD -add string folders "D01\\D02\\D03\\D04\\D05"
	cpconfig -hardware media -add ROSAN -connect Rosan_GD1 -name 'Rosan' > /dev/null
	cpconfig -hardware media -configure ROSAN -connect Rosan_GD1 -add hex atr 3BFD9700008031FE450031C071C6644D35000001900000
	cpconfig -hardware media -configure ROSAN -connect Rosan_GD1 -add hex mask FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF00
	cpconfig -hardware media -configure ROSAN -connect Rosan_GD1 -add string folders "D01\\D02\\D03\\D04\\D05"
	cpconfig -hardware media -add ROSAN -connect Rosan_GD2 -name 'Rosan' > /dev/null
	cpconfig -hardware media -configure ROSAN -connect Rosan_GD2 -add hex atr 3BE800008131FE450073C840130090009B
	cpconfig -hardware media -configure ROSAN -connect Rosan_GD2 -add hex mask FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
	cpconfig -hardware media -configure ROSAN -connect Rosan_GD2 -add string folders "D01\\D02\\D03\\D04\\D05"
	cpconfig -hardware media -add ROSAN -connect Rosan_GD3 -name 'Rosan' > /dev/null
	cpconfig -hardware media -configure ROSAN -connect Rosan_GD3 -add hex atr 3B6D00000073C800136454000000009000
	cpconfig -hardware media -configure ROSAN -connect Rosan_GD3 -add hex mask FFFFFFFFFFFFFFFFFFFFFF000000FFFFFF
	cpconfig -hardware media -configure ROSAN -connect Rosan_GD3 -add string folders "D01\\D02\\D03\\D04\\D05"
	cpconfig -hardware media -add ROSAN -connect Rosan_GD4 -name 'Rosan' > /dev/null
	cpconfig -hardware media -configure ROSAN -connect Rosan_GD4 -add hex atr 3B7E9600000031C071C665740B041631019000
	cpconfig -hardware media -configure ROSAN -connect Rosan_GD4 -add hex mask FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
	cpconfig -hardware media -configure ROSAN -connect Rosan_GD4 -add string folders "D01\\D02\\D03\\D04\\D05"
	cpconfig -hardware media -add ROSAN -connect NXP_JCOP4 -name 'Rosan' > /dev/null
	cpconfig -hardware media -configure ROSAN -connect NXP_JCOP4 -add hex atr 3BD495FF8131FE450000000090
	cpconfig -hardware media -configure ROSAN -connect NXP_JCOP4 -add hex mask FFFFFFFFFFFFFFFF00000000F0
	cpconfig -hardware media -configure ROSAN -connect NXP_JCOP4 -add string folders "D01\\D02\\D03\\D04\\D05"
	cpconfig -hardware media -add ROSAN -connect Kona2 -name 'Rosan' > /dev/null
	cpconfig -hardware media -configure ROSAN -connect Kona2 -add hex atr 3BF813000010000073C84000009000
	cpconfig -hardware media -configure ROSAN -connect Kona2 -add hex mask FFFFFFFFFFFFFFFFFFFFFF00FFFFFF
	cpconfig -hardware media -configure ROSAN -connect Kona2 -add string folders "D01\\D02\\D03\\D04\\D05"
	cpconfig -hardware media -add ROSAN -connect RFWU89 -name 'Rosan' > /dev/null
	cpconfig -hardware media -configure ROSAN -connect RFWU89 -add hex atr 3B670000868850424F4333
	cpconfig -hardware media -configure ROSAN -connect RFWU89 -add hex mask FFFFFFFFFFFFFFFFFFFFFF
	cpconfig -hardware media -configure ROSAN -connect RFWU89 -add string folders "D01\\D02\\D03\\D04\\D05"
	cpconfig -hardware media -add ROSAN -connect RFWU89_NFC -name 'Rosan' > /dev/null
	cpconfig -hardware media -configure ROSAN -connect RFWU89_NFC -add hex atr 3B89800186884748F18A85AEA7FE
	cpconfig -hardware media -configure ROSAN -connect RFWU89_NFC -add hex mask FFFFFFFFFFFFFFFFFFFFFFFFFFFF
	cpconfig -hardware media -configure ROSAN -connect RFWU89_NFC -add string folders "D01\\D02\\D03\\D04\\D05"
fi

# --- readers_cryptoki (cprocsp-rdr-cryptoki) ---
if [[ -e "${CP_LIBDIR}/librdrcryptoki.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdrcryptoki.so ${CP_LIBDIR}/librdrcryptoki.so
	cpconfig -ini '\config\apppath' -add string librtpkcs11ecp.so librtpkcs11ecp.so
	cpconfig -ini '\config\apppath' -add string libisbc_pkcs11_main.so libisbc_pkcs11_main.so
	cpconfig -ini '\config\apppath' -add string libjcPKCS11-2.so libjcPKCS11-2.so
	cpconfig -ini '\config\KeyDevices\cryptoki_rutoken' -add long Group 1
	cpconfig -ini '\config\KeyDevices\cryptoki_rutoken' -add string DLL librdrcryptoki.so
	cpconfig -ini '\config\KeyDevices\cryptoki_rutoken\PNP cryptoki\Default' -add string pkcs11_dll librtpkcs11ecp.so
	cpconfig -ini '\config\KeyDevices\cryptoki_esmart' -add long Group 1
	cpconfig -ini '\config\KeyDevices\cryptoki_esmart' -add string DLL librdrcryptoki.so
	cpconfig -ini '\config\KeyDevices\cryptoki_esmart\PNP cryptoki\Default' -add string pkcs11_dll libisbc_pkcs11_main.so
	cpconfig -ini '\config\KeyDevices\cryptoki_jacarta' -add long Group 1
	cpconfig -ini '\config\KeyDevices\cryptoki_jacarta' -add string DLL librdrcryptoki.so
	cpconfig -ini '\config\KeyDevices\cryptoki_jacarta\PNP cryptoki\Default' -add string pkcs11_dll libjcPKCS11-2.so
	cpconfig -ini '\config\debug' -add long cryptoki 1
fi

# --- readers_rustoken (cprocsp-rdr-rustoken) ---
if [[ -e "${CP_LIBDIR}/librdrrustoken.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdrrustoken.so ${CP_LIBDIR}/librdrrustoken.so
	cpconfig -ini '\config\KeyCarriers\RUSTOKEN' -add string DLL librdrrustoken.so
	cpconfig -hardware media -add RUSTOKEN -name 'RUSTOKEN' > /dev/null
	cpconfig -hardware media -configure RUSTOKEN -add hex atr 3B0D01525553546F6B656E2D4C3101
	cpconfig -hardware media -configure RUSTOKEN -add hex mask FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
	cpconfig -hardware media -configure RUSTOKEN -add string folders "1\\2\\3\\4\\5\\6\\7\\8\\9\\A\\B\\C\\D\\E\\F"
	cpconfig -hardware media -configure RUSTOKEN -add string Name 'RUSToken'
fi

# --- readers_esmart (cprocsp-rdr-esmart) ---
if [[ -e "${CP_LIBDIR}/librdresmarttoken.so" ]]; then
	LIBNAME=librdresmarttoken
	NAME="esmarttoken"
	cpconfig -ini '\config\apppath' -add string $LIBNAME.so ${CP_LIBDIR}/$LIBNAME.so
	cpconfig -ini "\config\KeyCarriers\\$NAME" -add string DLL $LIBNAME.so
	cpconfig -hardware media -add $NAME -name $NAME > /dev/null
	cpconfig -hardware media -configure $NAME -add hex atr 3bbe1800004206110000000000000000009000
	cpconfig -hardware media -configure $NAME -add hex mask ffffffffffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure $NAME -add string folders 'F100\F200\F300\F400'
	cpconfig -hardware media -configure $NAME -add string Name 'ESMART Token 32K'
	cpconfig -hardware media -configure "$NAME" -connect $NAME'64' -add hex atr 3bbe9600004206210000000000000000009000
	cpconfig -hardware media -configure "$NAME" -connect $NAME'64' -add hex mask ffffffffffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure "$NAME" -connect $NAME'64' -add string folders 'F100\F200\F300\F400\F500\F600\F700\F800\F900'
	cpconfig -hardware media -configure "$NAME" -connect $NAME'64' -add string Name 'ESMART Token 64K'
	NAME="ESMARTToken192k"
	NAME_DUAL="ESMARTTokenDual192k"
	cpconfig -ini "\config\KeyCarriers\\$NAME" -add string DLL $LIBNAME.so
	cpconfig -hardware media -add $NAME -name $NAME > /dev/null
	cpconfig -hardware media -configure $NAME -add hex atr 3b9e960045534D4152543131000000000000
	cpconfig -hardware media -configure $NAME -add hex mask ffffffffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure $NAME -add string folders 'F100\F200\F300\F400\F500\F600\F700\F800'
	cpconfig -hardware media -configure $NAME -add string Name 'ESMART Token 192K'
	cpconfig -hardware media -configure "$NAME" -connect $NAME_DUAL -add hex atr 3b8e80010045534d4152543131000000000013
	cpconfig -hardware media -configure "$NAME" -connect $NAME_DUAL -add hex mask ffffffffffffffffffffffffffffffffffffff
	cpconfig -hardware media -configure "$NAME" -connect $NAME_DUAL -add string folders 'F100\F200\F300\F400\F500\F600\F700\F800'
	cpconfig -hardware media -configure "$NAME" -connect $NAME_DUAL -add string Name 'ESMART Token SC DUAL 192K'
	LIBNAME="librdresmarttokengost"
	NAME="ESMARTTokenGOST"
	cpconfig -ini '\config\apppath' -add string $LIBNAME.so ${CP_LIBDIR}/$LIBNAME.so
	cpconfig -ini "\config\KeyCarriers\\$NAME" -add string DLL $LIBNAME.so
	cpconfig -hardware media -add $NAME -name $NAME > /dev/null
	cpconfig -hardware media -configure $NAME -add hex atr 3B7C95000045534D415254474F53543130
	cpconfig -hardware media -configure $NAME -add hex mask FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
	cpconfig -hardware media -configure $NAME -add string folders 'F010\F020\F030\F040\F050\F060\F070\F080\F090\F0A0\F0B0\\F0C0\\F0D0\\F0E0\\F0F0\\F110\\F120\\F130\\F140\\F150\\F160\\F170\\F180\\F190'
	cpconfig -hardware media -configure $NAME -add string Name 'ESMART Token GOST'
	cpconfig -hardware media -configure "$NAME" -connect $NAME'_F' -add hex atr 3B7E130000805C45534D415254474F53543130
	cpconfig -hardware media -configure "$NAME" -connect $NAME'_F' -add hex mask FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
	cpconfig -hardware media -configure "$NAME" -connect $NAME'_F' -add string folders 'F010\F020\F030\F040\F050\F060\F070\F080\F090\F0A0\F0B0\\F0C0\\F0D0\\F0E0\\F0F0\\F110\\F120\\F130\\F140\\F150\\F160\\F170\\F180\\F190'
	cpconfig -hardware media -configure "$NAME" -connect $NAME'_F' -add string Name 'ESMART Token GOST (F)'
	cpconfig -hardware media -configure "$NAME" -connect $NAME'_S' -add hex atr 3B6E0000805C45534D415254474F53543130
	cpconfig -hardware media -configure "$NAME" -connect $NAME'_S' -add hex mask FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
	cpconfig -hardware media -configure "$NAME" -connect $NAME'_S' -add string folders 'F010\F020\F030\F040\F050\F060\F070\F080\F090\F0A0\F0B0\\F0C0\\F0D0\\F0E0\\F0F0\\F110\\F120\\F130\\F140\\F150\\F160\\F170\\F180\\F190'
	cpconfig -hardware media -configure "$NAME" -connect $NAME'_S' -add string Name 'ESMART Token GOST (S)'
fi

# --- readers_relay (cprocsp-rdr-relay) ---
if [[ -e "${CP_LIBDIR}/librdrrelay.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdrrelay.so ${CP_LIBDIR}/librdrrelay.so
	cpconfig -ini '\config\KeyDevices\Relay' -add string DLL librdrrelay.so
	cpconfig -hardware reader -add Relay > /dev/null
fi

# --- readers_ancud (lsb-cprocsp-rdr-ancud) ---
if [[ -e "${CP_LIBDIR}/librdrancud.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdrancud.so ${CP_LIBDIR}/librdrancud.so
	cpconfig -ini '\config\Random\ancud' -add string DLL librdrancud.so
	cpconfig -hardware rndm -add ancud -name 'Ancud SCR/RNG' >&-
fi

# --- readers_accord (lsb-cprocsp-rdr-accord) ---
if [[ -e "${CP_LIBDIR}/librdraccord.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdraccord.so ${CP_LIBDIR}/librdraccord.so
	cpconfig -ini '\config\apppath' -add string libtm.so ${CP_LIBDIR}/libtm.so
	cpconfig -ini '\config\Random\Accord5' -add string DLL librdraccord.so
	cpconfig -hardware rndm -add accord5 -name 'Accord 5 RNG' >/dev/null
fi

# --- readers_accord_ccid (lsb-cprocsp-rdr-accord-ccid) ---
if [[ -e "${CP_LIBDIR}/librdraccord_ccid.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdraccord_ccid.so ${CP_LIBDIR}/librdraccord_ccid.so
	cpconfig -ini '\config\random\accord_ccid' -add string DLL librdraccord_ccid.so
	cpconfig -hardware rndm -add accord_ccid -name 'Accord CCID' > /dev/null
fi

# --- readers_sobol (lsb-cprocsp-rdr-sobol) ---
if [[ -e "${CP_LIBDIR}/librdrsbl.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdrsbl.so ${CP_LIBDIR}/librdrsbl.so
	cpconfig -ini '\config\Random\Sable' -add string DLL librdrsbl.so
	cpconfig -hardware rndm -add Sable -name 'Sobol RNG' > /dev/null
	cpconfig -ini '\config\apppath' -add string librdrds.so ${CP_LIBDIR}/librdrds.so
	cpconfig -ini '\config\KeyDevices\Sable' -add string DLL librdrsbl.so
	cpconfig -ini '\config\KeyDevices\Sable\Default' -add string Name 'iButton'
	cpconfig -ini '\config\KeyDevices\Sable\Default\Name' -delparam
	cpconfig -ini '\config\KeyCarriers\DS199x' -add string DLL librdrds.so
	cpconfig -hardware media -add DS199x -name 'DS199x' > /dev/null
	cpconfig -hardware media -configure DS199x -connect Default -add long first_DS1993 0
	cpconfig -hardware media -configure DS199x -connect Default -add long first_DS1994 0
	cpconfig -hardware media -configure DS199x -connect Default -add long first_DS1995 0
	cpconfig -hardware media -configure DS199x -connect Default -add long first_DS1996 0
	cpconfig -hardware media -configure DS199x -connect Default -add long quant_DS1993 512
	cpconfig -hardware media -configure DS199x -connect Default -add long quant_DS1994 512
	cpconfig -hardware media -configure DS199x -connect Default -add long quant_DS1995 2048
	cpconfig -hardware media -configure DS199x -connect Default -add long quant_DS1996 8192
fi

# --- readers_vityaz (lsb-cprocsp-rdr-vityaz) ---
if [[ -e "${CP_LIBDIR}/librdrvityaz.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdrvityaz.so ${CP_LIBDIR}/librdrvityaz.so
	cpconfig -ini '\config\Random\vityaz' -add string DLL librdrvityaz.so
	cpconfig -hardware rndm -add vityaz -name 'Vityaz RNG' >&-
fi

# --- readers_maxim (lsb-cprocsp-rdr-maxim) ---
if [[ -e "${CP_LIBDIR}/librdrmaxim.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdrmaxim.so ${CP_LIBDIR}/librdrmaxim.so
	cpconfig -ini '\config\Random\maxim' -add string DLL librdrmaxim.so
	cpconfig -hardware rndm -add maxim -name 'Maxim RNG' >&-
fi

# --- readers_crypton (lsb-cprocsp-rdr-crypton) ---
if [[ -e "${CP_LIBDIR}/librdrcrypton.so" ]]; then
	cpconfig -ini '\config\apppath' -add string librdrcrypton.so ${CP_LIBDIR}/librdrcrypton.so
	cpconfig -ini '\config\Random\crypton' -add string DLL librdrcrypton.so
	cpconfig -hardware rndm -add crypton -name 'Crypton-Lock RNG' >&-
fi

