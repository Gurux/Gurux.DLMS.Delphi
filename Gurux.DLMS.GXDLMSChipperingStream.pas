//
// --------------------------------------------------------------------------
//  Gurux Ltd
// 
//
//
// Filename:        $HeadURL$
//
// Version:         $Revision$,
//                  $Date$
//                  $Author$
//
// Copyright (c) Gurux Ltd
//
//---------------------------------------------------------------------------
//
//  DESCRIPTION
//
// This file is a part of Gurux Device Framework.
//
// Gurux Device Framework is Open Source software; you can redistribute it
// and/or modify it under the terms of the GNU General Public License 
// as published by the Free Software Foundation; version 2 of the License.
// Gurux Device Framework is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of 
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
// See the GNU General Public License for more details.
//
// This code is licensed under the GNU General Public License v2. 
// Full text may be retrieved at http://www.gnu.org/licenses/gpl-2.0.txt
//---------------------------------------------------------------------------

unit Gurux.DLMS.GXDLMSChipperingStream;

interface

uses SysUtils, GXCommon, Gurux.DLMS.Security, Math, Gurux.DLMS.GXDLMSException,
GXByteBuffer;

const
//Key schedule Vector (powers of x).
rcon : array [0..29] of byte = ($01, $02, $04, $08, $10, $20, $40, $80, $1b, $36, $6c, $d8, $ab, $4d, $9a,
			$2f, $5e, $bc, $63, $c6, $97, $35, $6a, $d4, $b3, $7d, $fa, $ef, $c5, $91);

// S box
SBox : array [0..255] of byte =($63, $7C, $77, $7B, $F2, $6B, $6F, $C5, $30, $01, $67, $2B,
            $FE, $D7, $AB, $76, $CA, $82, $C9, $7D, $FA, $59, $47, $F0,
            $AD, $D4, $A2, $AF, $9C, $A4, $72, $C0, $B7, $FD, $93, $26,
            $36, $3F, $F7, $CC, $34, $A5, $E5, $F1, $71, $D8, $31, $15,
            $04, $C7, $23, $C3, $18, $96, $05, $9A, $07, $12, $80, $E2,
            $EB, $27, $B2, $75, $09, $83, $2C, $1A, $1B, $6E, $5A, $A0,
            $52, $3B, $D6, $B3, $29, $E3, $2F, $84, $53, $D1, $00, $ED,
            $20, $FC, $B1, $5B, $6A, $CB, $BE, $39, $4A, $4C, $58, $CF,
            $D0, $EF, $AA, $FB, $43, $4D, $33, $85, $45, $F9, $02, $7F,
            $50, $3C, $9F, $A8, $51, $A3, $40, $8F, $92, $9D, $38, $F5,
            $BC, $B6, $DA, $21, $10, $FF, $F3, $D2, $CD, $0C, $13, $EC,
            $5F, $97, $44, $17, $C4, $A7, $7E, $3D, $64, $5D, $19, $73,
            $60, $81, $4F, $DC, $22, $2A, $90, $88, $46, $EE, $B8, $14,
            $DE, $5E, $0B, $DB, $E0, $32, $3A, $0A, $49, $06, $24, $5C,
            $C2, $D3, $AC, $62, $91, $95, $E4, $79, $E7, $C8, $37, $6D,
            $8D, $D5, $4E, $A9, $6C, $56, $F4, $EA, $65, $7A, $AE, $08,
            $BA, $78, $25, $2E, $1C, $A6, $B4, $C6, $E8, $DD, $74, $1F,
            $4B, $BD, $8B, $8A, $70, $3E, $B5, $66, $48, $03, $F6, $0E,
            $61, $35, $57, $B9, $86, $C1, $1D, $9E, $E1, $F8, $98, $11,
            $69, $D9, $8E, $94, $9B, $1E, $87, $E9, $CE, $55, $28, $DF,
            $8C, $A1, $89, $0D, $BF, $E6, $42, $68, $41, $99, $2D, $0F,
            $B0, $54, $BB, $16);

// The inverse S-box.
SBoxInverse : array [0..255] of byte =($52, $09, $6A, $D5, $30, $36, $A5, $38, $BF, $40, $A3, $9E,
            $81, $F3, $D7, $FB, $7C, $E3, $39, $82, $9B, $2F, $FF, $87,
            $34, $8E, $43, $44, $C4, $DE, $E9, $CB, $54, $7B, $94, $32,
            $A6, $C2, $23, $3D, $EE, $4C, $95, $0B, $42, $FA, $C3, $4E,
            $08, $2E, $A1, $66, $28, $D9, $24, $B2, $76, $5B, $A2, $49,
            $6D, $8B, $D1, $25, $72, $F8, $F6, $64, $86, $68, $98, $16,
            $D4, $A4, $5C, $CC, $5D, $65, $B6, $92, $6C, $70, $48, $50,
            $FD, $ED, $B9, $DA, $5E, $15, $46, $57, $A7, $8D, $9D, $84,
            $90, $D8, $AB, $00, $8C, $BC, $D3, $0A, $F7, $E4, $58, $05,
            $B8, $B3, $45, $06, $D0, $2C, $1E, $8F, $CA, $3F, $0F, $02,
            $C1, $AF, $BD, $03, $01, $13, $8A, $6B, $3A, $91, $11, $41,
            $4F, $67, $DC, $EA, $97, $F2, $CF, $CE, $F0, $B4, $E6, $73,
            $96, $AC, $74, $22, $E7, $AD, $35, $85, $E2, $F9, $37, $E8,
            $1C, $75, $DF, $6E, $47, $F1, $1A, $71, $1D, $29, $C5, $89,
            $6F, $B7, $62, $0E, $AA, $18, $BE, $1B, $FC, $56, $3E, $4B,
            $C6, $D2, $79, $20, $9A, $DB, $C0, $FE, $78, $CD, $5A, $F4,
            $1F, $DD, $A8, $33, $88, $07, $C7, $31, $B1, $12, $10, $59,
            $27, $80, $EC, $5F, $60, $51, $7F, $A9, $19, $B5, $4A, $0D,
            $2D, $E5, $7A, $9F, $93, $C9, $9C, $EF, $A0, $E0, $3B, $4D,
            $AE, $2A, $F5, $B0, $C8, $EB, $BB, $3C, $83, $53, $99, $61,
            $17, $2B, $04, $7E, $BA, $77, $D6, $26, $E1, $69, $14, $63,
            $55, $21, $0C, $7D);

//Rijndael (AES) Encryption fast table.
AES1 : array [0..255] of LongWord = ($a56363c6, $847c7cf8, $997777ee, $8d7b7bf6, $0df2f2ff,
			$bd6b6bd6, $b16f6fde, $54c5c591, $50303060, $03010102,
			$a96767ce, $7d2b2b56, $19fefee7, $62d7d7b5, $e6abab4d,
			$9a7676ec, $45caca8f, $9d82821f, $40c9c989, $877d7dfa,
			$15fafaef, $eb5959b2, $c947478e, $0bf0f0fb, $ecadad41,
			$67d4d4b3, $fda2a25f, $eaafaf45, $bf9c9c23, $f7a4a453,
			$967272e4, $5bc0c09b, $c2b7b775, $1cfdfde1, $ae93933d,
			$6a26264c, $5a36366c, $413f3f7e, $02f7f7f5, $4fcccc83,
			$5c343468, $f4a5a551, $34e5e5d1, $08f1f1f9, $937171e2,
			$73d8d8ab, $53313162, $3f15152a, $0c040408, $52c7c795,
			$65232346, $5ec3c39d, $28181830, $a1969637, $0f05050a,
			$b59a9a2f, $0907070e, $36121224, $9b80801b, $3de2e2df,
			$26ebebcd, $6927274e, $cdb2b27f, $9f7575ea, $1b090912,
			$9e83831d, $742c2c58, $2e1a1a34, $2d1b1b36, $b26e6edc,
			$ee5a5ab4, $fba0a05b, $f65252a4, $4d3b3b76, $61d6d6b7,
			$ceb3b37d, $7b292952, $3ee3e3dd, $712f2f5e, $97848413,
			$f55353a6, $68d1d1b9, $00000000, $2cededc1, $60202040,
			$1ffcfce3, $c8b1b179, $ed5b5bb6, $be6a6ad4, $46cbcb8d,
			$d9bebe67, $4b393972, $de4a4a94, $d44c4c98, $e85858b0,
			$4acfcf85, $6bd0d0bb, $2aefefc5, $e5aaaa4f, $16fbfbed,
			$c5434386, $d74d4d9a, $55333366, $94858511, $cf45458a,
			$10f9f9e9, $06020204, $817f7ffe, $f05050a0, $443c3c78,
			$ba9f9f25, $e3a8a84b, $f35151a2, $fea3a35d, $c0404080,
			$8a8f8f05, $ad92923f, $bc9d9d21, $48383870, $04f5f5f1,
			$dfbcbc63, $c1b6b677, $75dadaaf, $63212142, $30101020,
			$1affffe5, $0ef3f3fd, $6dd2d2bf, $4ccdcd81, $140c0c18,
			$35131326, $2fececc3, $e15f5fbe, $a2979735, $cc444488,
			$3917172e, $57c4c493, $f2a7a755, $827e7efc, $473d3d7a,
			$ac6464c8, $e75d5dba, $2b191932, $957373e6, $a06060c0,
			$98818119, $d14f4f9e, $7fdcdca3, $66222244, $7e2a2a54,
			$ab90903b, $8388880b, $ca46468c, $29eeeec7, $d3b8b86b,
			$3c141428, $79dedea7, $e25e5ebc, $1d0b0b16, $76dbdbad,
			$3be0e0db, $56323264, $4e3a3a74, $1e0a0a14, $db494992,
			$0a06060c, $6c242448, $e45c5cb8, $5dc2c29f, $6ed3d3bd,
			$efacac43, $a66262c4, $a8919139, $a4959531, $37e4e4d3,
			$8b7979f2, $32e7e7d5, $43c8c88b, $5937376e, $b76d6dda,
			$8c8d8d01, $64d5d5b1, $d24e4e9c, $e0a9a949, $b46c6cd8,
			$fa5656ac, $07f4f4f3, $25eaeacf, $af6565ca, $8e7a7af4,
			$e9aeae47, $18080810, $d5baba6f, $887878f0, $6f25254a,
			$722e2e5c, $241c1c38, $f1a6a657, $c7b4b473, $51c6c697,
			$23e8e8cb, $7cdddda1, $9c7474e8, $211f1f3e, $dd4b4b96,
			$dcbdbd61, $868b8b0d, $858a8a0f, $907070e0, $423e3e7c,
			$c4b5b571, $aa6666cc, $d8484890, $05030306, $01f6f6f7,
			$120e0e1c, $a36161c2, $5f35356a, $f95757ae, $d0b9b969,
			$91868617, $58c1c199, $271d1d3a, $b99e9e27, $38e1e1d9,
			$13f8f8eb, $b398982b, $33111122, $bb6969d2, $70d9d9a9,
			$898e8e07, $a7949433, $b69b9b2d, $221e1e3c, $92878715,
			$20e9e9c9, $49cece87, $ff5555aa, $78282850, $7adfdfa5,
			$8f8c8c03, $f8a1a159, $80898909, $170d0d1a, $dabfbf65,
			$31e6e6d7, $c6424284, $b86868d0, $c3414182, $b0999929,
			$772d2d5a, $110f0f1e, $cbb0b07b, $fc5454a8, $d6bbbb6d,
			$3a16162c);

//Rijndael (AES) Encryption fast table 2.
AES2 : array [0..255] of LongWord = ($6363c6a5, $7c7cf884, $7777ee99, $7b7bf68d, $f2f2ff0d,
			$6b6bd6bd, $6f6fdeb1, $c5c59154, $30306050, $01010203,
			$6767cea9, $2b2b567d, $fefee719, $d7d7b562, $abab4de6,
			$7676ec9a, $caca8f45, $82821f9d, $c9c98940, $7d7dfa87,
			$fafaef15, $5959b2eb, $47478ec9, $f0f0fb0b, $adad41ec,
			$d4d4b367, $a2a25ffd, $afaf45ea, $9c9c23bf, $a4a453f7,
			$7272e496, $c0c09b5b, $b7b775c2, $fdfde11c, $93933dae,
			$26264c6a, $36366c5a, $3f3f7e41, $f7f7f502, $cccc834f,
			$3434685c, $a5a551f4, $e5e5d134, $f1f1f908, $7171e293,
			$d8d8ab73, $31316253, $15152a3f, $0404080c, $c7c79552,
			$23234665, $c3c39d5e, $18183028, $969637a1, $05050a0f,
			$9a9a2fb5, $07070e09, $12122436, $80801b9b, $e2e2df3d,
			$ebebcd26, $27274e69, $b2b27fcd, $7575ea9f, $0909121b,
			$83831d9e, $2c2c5874, $1a1a342e, $1b1b362d, $6e6edcb2,
			$5a5ab4ee, $a0a05bfb, $5252a4f6, $3b3b764d, $d6d6b761,
			$b3b37dce, $2929527b, $e3e3dd3e, $2f2f5e71, $84841397,
			$5353a6f5, $d1d1b968, $00000000, $ededc12c, $20204060,
			$fcfce31f, $b1b179c8, $5b5bb6ed, $6a6ad4be, $cbcb8d46,
			$bebe67d9, $3939724b, $4a4a94de, $4c4c98d4, $5858b0e8,
			$cfcf854a, $d0d0bb6b, $efefc52a, $aaaa4fe5, $fbfbed16,
			$434386c5, $4d4d9ad7, $33336655, $85851194, $45458acf,
			$f9f9e910, $02020406, $7f7ffe81, $5050a0f0, $3c3c7844,
			$9f9f25ba, $a8a84be3, $5151a2f3, $a3a35dfe, $404080c0,
			$8f8f058a, $92923fad, $9d9d21bc, $38387048, $f5f5f104,
			$bcbc63df, $b6b677c1, $dadaaf75, $21214263, $10102030,
			$ffffe51a, $f3f3fd0e, $d2d2bf6d, $cdcd814c, $0c0c1814,
			$13132635, $ececc32f, $5f5fbee1, $979735a2, $444488cc,
			$17172e39, $c4c49357, $a7a755f2, $7e7efc82, $3d3d7a47,
			$6464c8ac, $5d5dbae7, $1919322b, $7373e695, $6060c0a0,
			$81811998, $4f4f9ed1, $dcdca37f, $22224466, $2a2a547e,
			$90903bab, $88880b83, $46468cca, $eeeec729, $b8b86bd3,
			$1414283c, $dedea779, $5e5ebce2, $0b0b161d, $dbdbad76,
			$e0e0db3b, $32326456, $3a3a744e, $0a0a141e, $494992db,
			$06060c0a, $2424486c, $5c5cb8e4, $c2c29f5d, $d3d3bd6e,
			$acac43ef, $6262c4a6, $919139a8, $959531a4, $e4e4d337,
			$7979f28b, $e7e7d532, $c8c88b43, $37376e59, $6d6ddab7,
			$8d8d018c, $d5d5b164, $4e4e9cd2, $a9a949e0, $6c6cd8b4,
			$5656acfa, $f4f4f307, $eaeacf25, $6565caaf, $7a7af48e,
			$aeae47e9, $08081018, $baba6fd5, $7878f088, $25254a6f,
			$2e2e5c72, $1c1c3824, $a6a657f1, $b4b473c7, $c6c69751,
			$e8e8cb23, $dddda17c, $7474e89c, $1f1f3e21, $4b4b96dd,
			$bdbd61dc, $8b8b0d86, $8a8a0f85, $7070e090, $3e3e7c42,
			$b5b571c4, $6666ccaa, $484890d8, $03030605, $f6f6f701,
			$0e0e1c12, $6161c2a3, $35356a5f, $5757aef9, $b9b969d0,
			$86861791, $c1c19958, $1d1d3a27, $9e9e27b9, $e1e1d938,
			$f8f8eb13, $98982bb3, $11112233, $6969d2bb, $d9d9a970,
			$8e8e0789, $949433a7, $9b9b2db6, $1e1e3c22, $87871592,
			$e9e9c920, $cece8749, $5555aaff, $28285078, $dfdfa57a,
			$8c8c038f, $a1a159f8, $89890980, $0d0d1a17, $bfbf65da,
			$e6e6d731, $424284c6, $6868d0b8, $414182c3, $999929b0,
			$2d2d5a77, $0f0f1e11, $b0b07bcb, $5454a8fc, $bbbb6dd6,
			$16162c3a);

//Rijndael (AES) Encryption fast table 3.
AES3 : array [0..255] of LongWord = ($63c6a563, $7cf8847c, $77ee9977, $7bf68d7b, $f2ff0df2,
			$6bd6bd6b, $6fdeb16f, $c59154c5, $30605030, $01020301,
			$67cea967, $2b567d2b, $fee719fe, $d7b562d7, $ab4de6ab,
			$76ec9a76, $ca8f45ca, $821f9d82, $c98940c9, $7dfa877d,
			$faef15fa, $59b2eb59, $478ec947, $f0fb0bf0, $ad41ecad,
			$d4b367d4, $a25ffda2, $af45eaaf, $9c23bf9c, $a453f7a4,
			$72e49672, $c09b5bc0, $b775c2b7, $fde11cfd, $933dae93,
			$264c6a26, $366c5a36, $3f7e413f, $f7f502f7, $cc834fcc,
			$34685c34, $a551f4a5, $e5d134e5, $f1f908f1, $71e29371,
			$d8ab73d8, $31625331, $152a3f15, $04080c04, $c79552c7,
			$23466523, $c39d5ec3, $18302818, $9637a196, $050a0f05,
			$9a2fb59a, $070e0907, $12243612, $801b9b80, $e2df3de2,
			$ebcd26eb, $274e6927, $b27fcdb2, $75ea9f75, $09121b09,
			$831d9e83, $2c58742c, $1a342e1a, $1b362d1b, $6edcb26e,
			$5ab4ee5a, $a05bfba0, $52a4f652, $3b764d3b, $d6b761d6,
			$b37dceb3, $29527b29, $e3dd3ee3, $2f5e712f, $84139784,
			$53a6f553, $d1b968d1, $00000000, $edc12ced, $20406020,
			$fce31ffc, $b179c8b1, $5bb6ed5b, $6ad4be6a, $cb8d46cb,
			$be67d9be, $39724b39, $4a94de4a, $4c98d44c, $58b0e858,
			$cf854acf, $d0bb6bd0, $efc52aef, $aa4fe5aa, $fbed16fb,
			$4386c543, $4d9ad74d, $33665533, $85119485, $458acf45,
			$f9e910f9, $02040602, $7ffe817f, $50a0f050, $3c78443c,
			$9f25ba9f, $a84be3a8, $51a2f351, $a35dfea3, $4080c040,
			$8f058a8f, $923fad92, $9d21bc9d, $38704838, $f5f104f5,
			$bc63dfbc, $b677c1b6, $daaf75da, $21426321, $10203010,
			$ffe51aff, $f3fd0ef3, $d2bf6dd2, $cd814ccd, $0c18140c,
			$13263513, $ecc32fec, $5fbee15f, $9735a297, $4488cc44,
			$172e3917, $c49357c4, $a755f2a7, $7efc827e, $3d7a473d,
			$64c8ac64, $5dbae75d, $19322b19, $73e69573, $60c0a060,
			$81199881, $4f9ed14f, $dca37fdc, $22446622, $2a547e2a,
			$903bab90, $880b8388, $468cca46, $eec729ee, $b86bd3b8,
			$14283c14, $dea779de, $5ebce25e, $0b161d0b, $dbad76db,
			$e0db3be0, $32645632, $3a744e3a, $0a141e0a, $4992db49,
			$060c0a06, $24486c24, $5cb8e45c, $c29f5dc2, $d3bd6ed3,
			$ac43efac, $62c4a662, $9139a891, $9531a495, $e4d337e4,
			$79f28b79, $e7d532e7, $c88b43c8, $376e5937, $6ddab76d,
			$8d018c8d, $d5b164d5, $4e9cd24e, $a949e0a9, $6cd8b46c,
			$56acfa56, $f4f307f4, $eacf25ea, $65caaf65, $7af48e7a,
			$ae47e9ae, $08101808, $ba6fd5ba, $78f08878, $254a6f25,
			$2e5c722e, $1c38241c, $a657f1a6, $b473c7b4, $c69751c6,
			$e8cb23e8, $dda17cdd, $74e89c74, $1f3e211f, $4b96dd4b,
			$bd61dcbd, $8b0d868b, $8a0f858a, $70e09070, $3e7c423e,
			$b571c4b5, $66ccaa66, $4890d848, $03060503, $f6f701f6,
			$0e1c120e, $61c2a361, $356a5f35, $57aef957, $b969d0b9,
			$86179186, $c19958c1, $1d3a271d, $9e27b99e, $e1d938e1,
			$f8eb13f8, $982bb398, $11223311, $69d2bb69, $d9a970d9,
			$8e07898e, $9433a794, $9b2db69b, $1e3c221e, $87159287,
			$e9c920e9, $ce8749ce, $55aaff55, $28507828, $dfa57adf,
			$8c038f8c, $a159f8a1, $89098089, $0d1a170d, $bf65dabf,
			$e6d731e6, $4284c642, $68d0b868, $4182c341, $9929b099,
			$2d5a772d, $0f1e110f, $b07bcbb0, $54a8fc54, $bb6dd6bb,
			$162c3a16);

//Rijndael (AES) Encryption fast table 4.
AES4 : array [0..255] of LongWord = ($c6a56363, $f8847c7c, $ee997777, $f68d7b7b, $ff0df2f2,
			$d6bd6b6b, $deb16f6f, $9154c5c5, $60503030, $02030101,
			$cea96767, $567d2b2b, $e719fefe, $b562d7d7, $4de6abab,
			$ec9a7676, $8f45caca, $1f9d8282, $8940c9c9, $fa877d7d,
			$ef15fafa, $b2eb5959, $8ec94747, $fb0bf0f0, $41ecadad,
			$b367d4d4, $5ffda2a2, $45eaafaf, $23bf9c9c, $53f7a4a4,
			$e4967272, $9b5bc0c0, $75c2b7b7, $e11cfdfd, $3dae9393,
			$4c6a2626, $6c5a3636, $7e413f3f, $f502f7f7, $834fcccc,
			$685c3434, $51f4a5a5, $d134e5e5, $f908f1f1, $e2937171,
			$ab73d8d8, $62533131, $2a3f1515, $080c0404, $9552c7c7,
			$46652323, $9d5ec3c3, $30281818, $37a19696, $0a0f0505,
			$2fb59a9a, $0e090707, $24361212, $1b9b8080, $df3de2e2,
			$cd26ebeb, $4e692727, $7fcdb2b2, $ea9f7575, $121b0909,
			$1d9e8383, $58742c2c, $342e1a1a, $362d1b1b, $dcb26e6e,
			$b4ee5a5a, $5bfba0a0, $a4f65252, $764d3b3b, $b761d6d6,
			$7dceb3b3, $527b2929, $dd3ee3e3, $5e712f2f, $13978484,
			$a6f55353, $b968d1d1, $00000000, $c12ceded, $40602020,
			$e31ffcfc, $79c8b1b1, $b6ed5b5b, $d4be6a6a, $8d46cbcb,
			$67d9bebe, $724b3939, $94de4a4a, $98d44c4c, $b0e85858,
			$854acfcf, $bb6bd0d0, $c52aefef, $4fe5aaaa, $ed16fbfb,
			$86c54343, $9ad74d4d, $66553333, $11948585, $8acf4545,
			$e910f9f9, $04060202, $fe817f7f, $a0f05050, $78443c3c,
			$25ba9f9f, $4be3a8a8, $a2f35151, $5dfea3a3, $80c04040,
			$058a8f8f, $3fad9292, $21bc9d9d, $70483838, $f104f5f5,
			$63dfbcbc, $77c1b6b6, $af75dada, $42632121, $20301010,
			$e51affff, $fd0ef3f3, $bf6dd2d2, $814ccdcd, $18140c0c,
			$26351313, $c32fecec, $bee15f5f, $35a29797, $88cc4444,
			$2e391717, $9357c4c4, $55f2a7a7, $fc827e7e, $7a473d3d,
			$c8ac6464, $bae75d5d, $322b1919, $e6957373, $c0a06060,
			$19988181, $9ed14f4f, $a37fdcdc, $44662222, $547e2a2a,
			$3bab9090, $0b838888, $8cca4646, $c729eeee, $6bd3b8b8,
			$283c1414, $a779dede, $bce25e5e, $161d0b0b, $ad76dbdb,
			$db3be0e0, $64563232, $744e3a3a, $141e0a0a, $92db4949,
			$0c0a0606, $486c2424, $b8e45c5c, $9f5dc2c2, $bd6ed3d3,
			$43efacac, $c4a66262, $39a89191, $31a49595, $d337e4e4,
			$f28b7979, $d532e7e7, $8b43c8c8, $6e593737, $dab76d6d,
			$018c8d8d, $b164d5d5, $9cd24e4e, $49e0a9a9, $d8b46c6c,
			$acfa5656, $f307f4f4, $cf25eaea, $caaf6565, $f48e7a7a,
			$47e9aeae, $10180808, $6fd5baba, $f0887878, $4a6f2525,
			$5c722e2e, $38241c1c, $57f1a6a6, $73c7b4b4, $9751c6c6,
			$cb23e8e8, $a17cdddd, $e89c7474, $3e211f1f, $96dd4b4b,
			$61dcbdbd, $0d868b8b, $0f858a8a, $e0907070, $7c423e3e,
			$71c4b5b5, $ccaa6666, $90d84848, $06050303, $f701f6f6,
			$1c120e0e, $c2a36161, $6a5f3535, $aef95757, $69d0b9b9,
			$17918686, $9958c1c1, $3a271d1d, $27b99e9e, $d938e1e1,
			$eb13f8f8, $2bb39898, $22331111, $d2bb6969, $a970d9d9,
			$07898e8e, $33a79494, $2db69b9b, $3c221e1e, $15928787,
			$c920e9e9, $8749cece, $aaff5555, $50782828, $a57adfdf,
			$038f8c8c, $59f8a1a1, $09808989, $1a170d0d, $65dabfbf,
			$d731e6e6, $84c64242, $d0b86868, $82c34141, $29b09999,
			$5a772d2d, $1e110f0f, $7bcbb0b0, $a8fc5454, $6dd6bbbb,
			$2c3a1616);
type

TLongWordArray = array of LongWord;
TArrayOfLongWordArray = array of TLongWordArray;
TArrayOfArrayOfLongWordArray = array of TArrayOfLongWordArray;

TGXDLMSChipperingStream = class
  strict private
    FOutput: TGXByteBuffer;
    FBlockSize: Integer;
    FSecurity: TSecurity;
    //3D array.
    FM: TArrayOfArrayOfLongWordArray;
    FtotalLength: Integer;
    FZeroes: TBytes;
    FS: TBytes;
    Fcounter: TBytes;
    FAad: TBytes;
    FJ0: TBytes;
    FBytesRemaining: Integer;
    FH: TBytes;
    FbufBlock: TBytes;
    FTag: TBytes;
    FRounds: Integer;
    FWorkingKey: TArrayOfLongWordArray ;
    FC0: Cardinal;
    FC1: Cardinal;
    FC2: Cardinal;
    FC3: Cardinal;
    FEncrypt: Boolean;
    procedure Init(H : TBytes);
    function GetGHash(b : TBytes) : TBytes;
    function StarX(value : LongWord) : LongWord;
    function ImixCol(x : LongWord) : LongWord;
    class procedure GetUInt32(value : LongWord; data : TBytes; offset : Integer);
    procedure UnPackBlock(bytes : TBytes; offset : Integer);
    procedure PackBlock(bytes : TBytes; offset : Integer);
    procedure EncryptBlock(key : TArrayOfLongWordArray);
    class procedure ShiftRight(block : TLongWordArray; count : Integer);static;
    class procedure MultiplyP(x : TLongWordArray);static;
    class function GetUint128(buff : TBytes) : TLongWordArray;static;
    class procedure InnerXor(block : TBytes; value : TBytes); overload;static;
    class procedure InnerXor(block : TLongWordArray; value : TLongWordArray);overload;static;
    class procedure MultiplyP8(x : TLongWordArray);static;
    procedure MultiplyH(value : TBytes);
    class procedure UInt32_To_BE(value : LongWord; buff : TBytes; offset : Integer);static;
    procedure gCTRBlock(buf : TBytes; bufCount : Integer);
    class procedure SetPackLength(length : UInt64; buff : TBytes; offset : Integer);static;
    procedure Reset();
    class function GaloisMultiply(value: Byte):Byte;


  public
    destructor Destroy; override;

    class procedure Aes1Encrypt(buff: TGXByteBuffer; offset: WORD; secret: TGXByteBuffer);

   class function TagsEquals(tag1 : TBytes; tag2 : TBytes) : Boolean;static;
    function FlushFinalBlock() : TBytes;
    procedure Write(input : TBytes);
   function GenerateKey(encrypt : Boolean; key : TBytes) : TArrayOfLongWordArray ;
    function ProcessBlock(input: TBytes; inOffset: Integer; output: TBytes;
      outOffset: Integer): Integer;
    constructor Create(security: TSecurity; encrypt: Boolean; blockCipherKey: TBytes;
      aad: TBytes; iv: TBytes; tag: TBytes);
    function GetTag: TBytes; virtual;
  strict private
    class function ToUInt32(value: TBytes; offset: Integer): cardinal;static;
    class function SubWord(value: Cardinal): cardinal;static;
    function Shift(value: cardinal; shift: Integer): cardinal;

  protected
    class function BEToUInt32(buff: TBytes; offset: Integer): LongWord;static;
  end;

implementation

destructor TGXDLMSChipperingStream.Destroy;
begin
  inherited;
  FreeAndNil(FOutput);
end;

constructor TGXDLMSChipperingStream.Create(security: TSecurity; encrypt: Boolean;
  blockCipherKey: TBytes; aad: TBytes; iv: TBytes; tag: TBytes);
var
  bufLength: Integer;
begin
  inherited Create;
  SetLength(FM, 32);
  FBlockSize := 16;
  SetLength(FZeroes, FBlockSize);
  FOutput := TGXByteBuffer.Create();
  FSecurity := security;
  FTag := tag;
  if (FTag = nil) then
    SetLength(FTag, 12)
  else
    if (Length(FTag) <> 12) then
      raise Exception.Create('Invalid tag.');
  FEncrypt := encrypt;
  FWorkingKey := GenerateKey(True, blockCipherKey);
  if Encrypt then
    bufLength := FBlockSize
   else
    bufLength := FBlockSize + $10;
  SetLength(FbufBlock, bufLength);
  FAad := aad;
  SetLength(FH, FBlockSize);
  ProcessBlock(FH, 0, FH, 0);
  Init(FH);
  SetLength(FJ0, 16);
  System.Move(iv[0], FJ0[0], Length(iv));
  FJ0[15] := 1;
  FS := GetGHash(FAad);
  Fcounter := Copy(FJ0);
  FBytesRemaining := 0;
  FtotalLength := 0;
end;

function TGXDLMSChipperingStream.GetTag: TBytes;
begin
  Result := FTag;
end;

class function TGXDLMSChipperingStream.ToUInt32(value: TBytes; offset: Integer): cardinal;
begin
  Result := value[offset] or value[offset + 1] Shl 8 or
            value[offset + 2] Shl 16 or value[offset + 3] Shl 24;
end;

class function TGXDLMSChipperingStream.SubWord(value: Cardinal): cardinal;
begin
  Result := SBox[value and $FF] or (SBox[(value Shr 8) and $FF] Shl 8) or
        (SBox[(value Shr 16) and $FF] Shl 16) or (SBox[(value Shr 24) and $FF] Shl 24);
end;

function TGXDLMSChipperingStream.Shift(value: cardinal; shift: Integer): cardinal;
begin
Result := (value Shr shift) or (value Shl (32 - shift));
end;

//Initialise the key schedule from the user supplied key.
function TGXDLMSChipperingStream.StarX(value : LongWord) : LongWord;
const
  m1 = $80808080;
  m2 = $7f7f7f7f;
  m3 = $0000001b;
begin
  Result := ((value and m2) Shl 1) xor (((value and m1) Shr 7) * m3);
end;

function TGXDLMSChipperingStream.ImixCol(x : LongWord) : LongWord;
var
  f2, f4, f8, f9 : LongWord;
begin
  f2 := StarX(x);
  f4 := StarX(f2);
  f8 := StarX(f4);
  f9 := x xor f8;
  Result := f2 xor f4 xor f8 xor Shift(f2 xor f9, 8) xor
            Shift(f4 xor f9, 16) xor Shift(f9, 24);
end;

// Get bytes from UIn32.
class procedure TGXDLMSChipperingStream.GetUInt32(value : LongWord; data : TBytes; offset : Integer);
begin
  data[offset] := byte(value);
  data[offset + 1] := byte(value Shr 8);
  data[offset + 2 ] := byte(value Shr 16);
  data[offset + 3] := byte(value Shr 24);
end;

procedure TGXDLMSChipperingStream.UnPackBlock(bytes : TBytes; offset : Integer);
begin
  FC0 := ToUInt32(bytes, offset);
  FC1 := ToUInt32(bytes, offset + 4);
  FC2 := ToUInt32(bytes, offset + 8);
  FC3 := ToUInt32(bytes, offset + 12);
end;

procedure TGXDLMSChipperingStream.PackBlock(bytes : TBytes; offset : Integer);
begin
  GetUInt32(FC0, bytes, offset);
  GetUInt32(FC1, bytes, offset + 4);
  GetUInt32(FC2, bytes, offset + 8);
  GetUInt32(FC3, bytes, offset + 12);
end;

// Encrypt data block.
procedure TGXDLMSChipperingStream.EncryptBlock(key : TArrayOfLongWordArray);
var
  r : Integer;
  r0, r1, r2, r3 : LongWord;
begin
    FC0 := FC0 xor key[0, 0];
    FC1 := FC1 xor key[0, 1];
    FC2 := FC2 xor key[0, 2];
    FC3 := FC3 xor key[0, 3];
    r := 1;
    while r < FRounds - 1 do
    begin
        r0 := AES1[FC0 and $FF] xor AES2[(FC1 Shr 8) and $FF] xor AES3[(FC2 Shr 16) and $FF] xor AES4[FC3 Shr 24] xor key[r, 0];
        r1 := AES1[FC1 and $FF] xor AES2[(FC2 Shr 8) and $FF] xor AES3[(FC3 Shr 16) and $FF] xor AES4[FC0 Shr 24] xor key[r, 1];
        r2 := AES1[FC2 and $FF] xor AES2[(FC3 Shr 8) and $FF] xor AES3[(FC0 Shr 16) and $FF] xor AES4[FC1 Shr 24] xor key[r, 2];
        r3 := AES1[FC3 and $FF] xor AES2[(FC0 Shr 8) and $FF] xor AES3[(FC1 Shr 16) and $FF] xor AES4[FC2 Shr 24] xor key[r, 3];
        r := r + 1;
        FC0 :=  AES1[r0 and $FF] xor AES2[(r1 Shr 8) and $FF] xor AES3[(r2 Shr 16) and $FF] xor AES4[r3 Shr 24] xor key[r, 0];
        FC1 := AES1[r1 and $FF] xor AES2[(r2 Shr 8) and $FF] xor AES3[(r3 Shr 16) and $FF] xor AES4[r0 Shr 24] xor key[r, 1];
        FC2 := AES1[r2 and $FF] xor AES2[(r3 Shr 8) and $FF] xor AES3[(r0 Shr 16) and $FF] xor AES4[r1 Shr 24] xor key[r, 2];
        FC3 := AES1[r3 and $FF] xor AES2[(r0 Shr 8) and $FF] xor AES3[(r1 Shr 16) and $FF] xor AES4[r2 Shr 24] xor key[r, 3];
        r := r + 1;
    end;
    r0 := AES1[FC0 and $FF] xor AES2[(FC1 Shr 8) and $FF] xor AES3[(FC2 Shr 16) and $FF] xor AES4[FC3 Shr 24] xor key[r, 0];
    r1 := AES1[FC1 and $FF] xor AES2[(FC2 Shr 8) and $FF] xor AES3[(FC3 Shr 16) and $FF] xor AES4[FC0 Shr 24] xor key[r, 1];
    r2 := AES1[FC2 and $FF] xor AES2[(FC3 Shr 8) and $FF] xor AES3[(FC0 Shr 16) and $FF] xor AES4[FC1 Shr 24] xor key[r, 2];
    r3 := AES1[FC3 and $FF] xor AES2[(FC0 Shr 8) and $FF] xor AES3[(FC1 Shr 16) and $FF] xor AES4[FC2 Shr 24] xor key[r, 3];
    r := r + 1;

    FC0 := SBox[r0 and $FF] xor ((SBox[(r1 Shr 8) and $FF]) Shl 8) xor ((SBox[(r2 Shr 16) and $FF]) Shl 16) xor ((SBox[r3 Shr 24]) Shl 24) xor key[r, 0];
    FC1 := SBox[r1 and $FF] xor ((SBox[(r2 Shr 8) and $FF]) Shl 8) xor ((SBox[(r3 Shr 16) and $FF]) Shl 16) xor ((SBox[r0 Shr 24]) Shl 24) xor key[r, 1];
    FC2 := SBox[r2 and $FF] xor ((SBox[(r3 Shr 8) and $FF]) Shl 8) xor ((SBox[(r0 Shr 16) and $FF]) Shl 16) xor ((SBox[r1 Shr 24]) Shl 24) xor key[r, 2];
    FC3 := SBox[r3 and $FF] xor ((SBox[(r0 Shr 8) and $FF]) Shl 8) xor ((SBox[(r1 Shr 16) and $FF]) Shl 16) xor ((SBox[r2 Shr 24]) Shl 24) xor key[r, 3];
end;

function TGXDLMSChipperingStream.ProcessBlock(input: TBytes; inOffset: Integer; output: TBytes; outOffset: Integer): Integer;
begin
  if ((inOffset + (32 / 2)) > Length(input)) then
    raise Exception.Create('input buffer too short');

  if ((outOffset + (32 / 2)) > Length(output)) then
    raise Exception.Create('output buffer too short');

  UnPackBlock(input, inOffset);
  EncryptBlock(FWorkingKey);
  PackBlock(output, outOffset);
  Result := FBlockSize;
end;

//Convert Big Endian byte array to Little Endian UInt 32.
class function TGXDLMSChipperingStream.BEToUInt32(buff: TBytes; offset: Integer): LongWord;
begin
  Result := ((buff[offset] Shl 24) or buff[offset + 1] Shl 16 or (buff[offset + 2] Shl 8) or buff[offset + 3]);
end;

// Shift block to right.
class procedure TGXDLMSChipperingStream.ShiftRight(block : TLongWordArray; count : Integer);
var
  bit, b : LongWord;
  i : Integer;
begin
    bit := 0;
    for i := 0 to 4 - 1 do
    begin
        b := block[i];
        block[i] := (b Shr count) or bit;
        bit := b Shl (32 - count);
    end;
end;

class procedure TGXDLMSChipperingStream.MultiplyP(x : TLongWordArray);
var
  lsb : Boolean;
begin
  lsb := (x[3] and 1) <> 0;
  ShiftRight(x, 1);
  if lsb then
    x[0] := x[0] xor $e1000000;
end;

// Get Uint 128 as array of cardinals.
class function TGXDLMSChipperingStream.GetUint128(buff : TBytes) : TLongWordArray;
var
  us : TLongWordArray;
begin
  SetLength(us, 4);
  us[0] := BEToUInt32(buff, 0);
  us[1] := BEToUInt32(buff, 4);
  us[2] := BEToUInt32(buff, 8);
  us[3] := BEToUInt32(buff, 12);
  Result := us;
end;

/// <summary>
/// Make Xor for 128 bits.
/// </summary>
/// <param name="block">block.</param>
/// <param name="val"></param>
class procedure TGXDLMSChipperingStream.InnerXor(block : TBytes; value : TBytes);
var
  pos : Integer;
begin
  for pos := 0 to 16 - 1 do
    block[pos] := block[pos] xor value[pos];
end;

/// <summary>
/// Make Xor for 128 bits.
/// </summary>
/// <param name="block">block.</param>
/// <param name="val"></param>
class procedure TGXDLMSChipperingStream.InnerXor(block : TLongWordArray; value : TLongWordArray);
var
  pos : Integer;
begin
  for pos := 0 to 3 do
    block[pos] := block[pos] xor value[pos];
end;

class procedure TGXDLMSChipperingStream.MultiplyP8(x : TLongWordArray);
var
   lsw : LongWord;
   pos : Integer;
begin
    lsw := x[3];
    ShiftRight(x, 8);
    for pos := 0 to 7 do
    begin
        if (lsw and (1 Shl pos)) <> 0 then
            x[0] := x[0] xor ($e1000000 Shr (7 - pos));
    end;
end;

// The GF(2128) field used is defined by the polynomial xxorbegin128end;+xxor7+xxor2+x+1.
// The authentication tag is constructed by feeding blocks of data into the GHASH function,
// and encrypting the result.
function TGXDLMSChipperingStream.GetGHash(b : TBytes) : TBytes;
var
  Y, X : TBytes;
  pos, cnt : Integer;
begin
  pos := 0;
  SetLength(Y, 16);
  SetLength(X, 16);
  while pos < Length(b) do
  begin
    FillChar(X[0], 16, 0);
    cnt := Min(Length(b) - pos, 16);
    Move(b[pos], X[0], cnt);
    InnerXor(Y, X);
    MultiplyH(Y);
    pos := pos + 16;
  end;
  Result := Y;
end;

class procedure TGXDLMSChipperingStream.UInt32_To_BE(value : LongWord; buff : TBytes; offset : Integer);
begin
  buff[offset] := Byte(value Shr 24);
  buff[offset + 1] := Byte(value Shr 16);
  buff[offset + 2] := Byte(value Shr 8);
  buff[offset + 3] := Byte(value);
end;

procedure TGXDLMSChipperingStream.MultiplyH(value : TBytes);
var
  tmp : array[0..3] of LongWord;
  pos : Integer;
  m : TLongWordArray;
begin
  tmp[0] := 0;
  tmp[1] := 0;
  tmp[2] := 0;
  tmp[3] := 0;
  for pos := 0 to 15 do
  begin
      m := TLongWordArray(FM[pos + pos, (value[pos] and $0f)]);
      tmp[0] := tmp[0] xor m[0];
      tmp[1] := tmp[1] xor m[1];
      tmp[2] := tmp[2] xor m[2];
      tmp[3] := tmp[3] xor m[3];
      m := TLongWordArray(FM[pos + pos + 1][(value[pos] and $f0) Shr 4]);
      tmp[0] := tmp[0] xor m[0];
      tmp[1] := tmp[1] xor m[1];
      tmp[2] := tmp[2] xor m[2];
      tmp[3] := tmp[3] xor m[3];
  end;

  UInt32_To_BE(tmp[0], value, 0);
  UInt32_To_BE(tmp[1], value, 4);
  UInt32_To_BE(tmp[2], value, 8);
  UInt32_To_BE(tmp[3], value, 12);
end;

procedure TGXDLMSChipperingStream.Init(H : TBytes);
var
  tmp: TLongWordArray;
  pos, pos1, pos2, k : Integer;
begin
    SetLength(FM[0], 16);
    SetLength(FM[1], 16);
    SetLength(FM[0, 0], 4);
    SetLength(FM[1, 0], 4);
    FM[1, 8] := GetUint128(H);
    pos := 4;
    while pos > 0 do
    begin
        tmp := Copy(FM[1][pos + pos]);
        MultiplyP(tmp);
        FM[1][pos] := tmp;
        pos := pos Shr 1;
    end;
    tmp := Copy(FM[1][1]);
    MultiplyP(tmp);
    FM[0][8] := tmp;

    pos := 4;
    while pos >= 1 do
    begin
        tmp := Copy(FM[0][pos + pos]);
        MultiplyP(tmp);
        FM[0][pos] := tmp;
        pos := pos Shr 1;
    end;
    pos1 := 0;
    while True do
    begin
        pos2 := 2;
        while pos2 < 16 do
        begin
            for k := 1 to pos2 - 1 do
            begin
                tmp := Copy(FM[pos1][pos2]);
                InnerXor(tmp, FM[pos1][k]);
                FM[pos1][pos2 + k] := tmp;
            end;
            pos2 := 2 * pos2;
        end;

        pos1 := pos1 + 1;
        if pos1 = 32 then
          Exit;

        if pos1 > 1 then
        begin
            SetLength(FM[pos1], 16);
            SetLength(FM[pos1, 0], 4);
            pos := 8;
            while pos > 0 do
            begin
                tmp := Copy(FM[pos1 - 2][pos]);
                MultiplyP8(tmp);
                FM[pos1][pos] := tmp;
                pos := pos Shr 1;
            end;
        end;
    end;
end;

procedure TGXDLMSChipperingStream.gCTRBlock(buf : TBytes; bufCount : Integer);
var
  i, pos : Integer;
  tmp, hashBytes : TBytes;
begin
    i := 15;
    while i >= 12 do
    begin
        Fcounter[i] := ++Fcounter[i] + 1;
        if Fcounter[i] <> 0 then
          break;
    end;

    SetLength(tmp, FBlockSize);
    ProcessBlock(Fcounter, 0, tmp, 0);
    if FEncrypt then
    begin
        if FBlockSize <> bufCount then
          Move(FZeroes[bufCount], tmp[bufCount], FBlockSize - bufCount);
        hashBytes := tmp;
    end
    else
    begin
        hashBytes := buf;
    end;
    for pos := 0 to bufCount - 1 do
    begin
        tmp[pos] := tmp[pos] xor buf[pos];
        FOutput.SetUInt8(tmp[pos]);
    end;
    InnerXor(FS, hashBytes);
    MultiplyH(FS);
    FtotalLength := FtotalLength + bufCount;
end;

// Set packet length to byte array.
class procedure TGXDLMSChipperingStream.SetPackLength(length : UInt64; buff : TBytes; offset : Integer);
begin
  UInt32_To_BE((length Shr 32), buff, offset);
  UInt32_To_BE(length and $FFFF, buff, offset + 4);
end;

// Reset
procedure TGXDLMSChipperingStream.Reset();
begin
  FS := GetGHash(FAad);
  Fcounter := Copy(FJ0);
  FBytesRemaining := 0;
  FtotalLength := 0;
end;

// Are tags equals.
class function TGXDLMSChipperingStream.TagsEquals(tag1 : TBytes; tag2 : TBytes) : Boolean;
var
  pos : Integer;
begin
    for pos := 0 to 11 do
    begin
        if tag1[pos] <> tag2[pos] then
          begin
            Result := False;
            Exit;
          end;
    end;
    Result := True;
end;

// Write bytes to decrypt/encrypt.
procedure TGXDLMSChipperingStream.Write(input : TBytes);
var
  it : byte;
begin
    for it in input do
    begin
        FbufBlock[FBytesRemaining] := it;
        FBytesRemaining := FBytesRemaining + 1;
        if FBytesRemaining = FBlockSize then
        begin
            gCTRBlock(FbufBlock, FBlockSize);
            if Not FEncrypt then
              Move(FbufBlock[FBlockSize], FbufBlock, Length(FTag));

            FBytesRemaining := 0;
        end;
    end;
end;

// Process encrypting/decrypting.
function TGXDLMSChipperingStream.FlushFinalBlock() : TBytes;
var
  tmp, X, tag : TBytes;
begin
  //Crypt/Uncrypt remaining bytes.
  if FBytesRemaining > 0 then
  begin
    SetLength(tmp, FBlockSize);
    Move(FbufBlock[0], tmp[0], FBytesRemaining);
    gCTRBlock(tmp, FBytesRemaining);
  end;
  //If tag is not needed.
  if FSecurity = TSecurity.Encryption then
  begin
    Reset();
    Result := FOutput.ToArray;
    Exit;
  end;
  //Count HASH.
  SetLength(X, 16);
  SetPackLength(Length(FAad)  * 8, X, 0);
  SetPackLength(FtotalLength * 8, X, 8);

  InnerXor(FS, X);
  MultiplyH(FS);
  SetLength(tag, FBlockSize);
  ProcessBlock(FJ0, 0, tag, 0);
  InnerXor(tag, FS);
  if Not FEncrypt then
  begin
    if TagsEquals(FTag, tag) = False then
    begin
      raise TGXDLMSException.Create('Decrypt failed. Invalid tag.');
    end;
  end
  else
  begin
    //Tag size is 12 bytes.
    Move(tag[0], FTag[0], 12);
  end;
  Reset();
  Result := FOutput.ToArray;
end;

// multiply by 2 in the Galois field
class function TGXDLMSChipperingStream.GaloisMultiply(value: Byte):Byte;
begin
  if (value shr 7) <> 0 Then
  begin
    value := (value shl 1);
    Result := (value xor $1b);
  end
  else
    Result := (value shl 1);
end;

class procedure TGXDLMSChipperingStream.Aes1Encrypt(buff: TGXByteBuffer; offset: WORD; secret: TGXByteBuffer);
var
  buf1, buf2, buf3, buf4, round, i: Byte;
  key, data: PByte;
begin
  key := @secret.GetData()[0];
  data := @buff.GetData()[0];
  for round := 0 to 9 do
  begin
      for i := 0 to 15 do
        data[i + offset] := SBox[(data[i + offset] xor  key[i]) and $FF];

      // cip_shift rows
      buf1 := data[1 + offset];
      data[1 + offset] := data[5 + offset];
      data[5 + offset] := data[9 + offset];
      data[9 + offset] := data[13 + offset];
      data[13 + offset] := buf1;

      buf1 := data[2 + offset];
      buf2 := data[6 + offset];
      data[2 + offset] := data[10 + offset];
      data[6 + offset] := data[14 + offset];
      data[10 + offset] := buf1;
      data[14 + offset] := buf2;

      buf1 := data[15 + offset];
      data[15 + offset] := data[11 + offset];
      data[11 + offset] := data[7 + offset];
      data[7 + offset] := data[3 + offset];
      data[3 + offset] := buf1;

      if round < 9 Then
      begin
          for i := 0 to 3 do
          begin
              buf4 := (i shl 2);
              buf1 := (data[buf4 + offset] xor  data[buf4 + 1 + offset]
                  xor  data[buf4 + 2 + offset]
                  xor  data[buf4 + 3 + offset]);
              buf2 := data[buf4 + offset];
              buf3 := (data[buf4 + offset]
                  xor  data[buf4 + 1 + offset]);
              buf3 := GaloisMultiply(buf3);
              data[buf4 + offset] :=
                  (data[buf4 + offset] xor  buf3 xor  buf1);
              buf3 := (data[buf4 + 1 + offset]
                  xor  data[buf4 + 2 + offset]);
              buf3 := GaloisMultiply(buf3);
              data[buf4 + 1 + offset] :=
                  (data[buf4 + 1 + offset] xor  buf3 xor  buf1);
              buf3 := (data[buf4 + 2 + offset]
                  xor  data[buf4 + 3 + offset]);
              buf3 := GaloisMultiply(buf3);
              data[buf4 + 2 + offset] := (data[buf4 + 2 + offset] xor  buf3 xor  buf1);
              buf3 := (data[buf4 + 3 + offset] xor  buf2);
              buf3 := GaloisMultiply(buf3);
              data[buf4 + 3 + offset] := (data[buf4 + 3 + offset] xor  buf3 xor  buf1);
          end;
      end;

      key[0] := (SBox[key[13] and $FF] xor  key[0] xor rcon[round]);
      key[1] := (SBox[key[14] and $FF] xor  key[1]);
      key[2] := (SBox[key[15] and $FF] xor  key[2]);
      key[3] := (SBox[key[12] and $FF] xor  key[3]);
      for i := 4 to 15 do
        key[i] := (key[i] xor  key[i - 4]);

  end;

  for i := 0 to 15 do
    data[i + offset] := (data[i + offset] xor key[i]);
end;


// Generate AES keys.
function TGXDLMSChipperingStream.GenerateKey(encrypt : Boolean; key : TBytes) : TArrayOfLongWordArray;
var
  keyLen : Integer;
  t, i, k, j : Integer;
  W : TArrayOfLongWordArray;
  temp : LongWord;
begin
  // Key length in words.
  keyLen := Round(Length(key) / 4);
  FRounds := keyLen + 6;
  // 4 words make one block.
  SetLength(W, FRounds + 1);
  for i := 0 to FRounds do
    SetLength(W[i], 4);

  // Copy the key into the round key array.
  t := 0;
  i := 0;
  //for i := 0 to Length(key) -1 do
  while i < Length(key) do
  begin
    W[t Shr 2, t and 3] := ToUInt32(key, i);
    i := i + 4;
    t := t + 1;
  end;
  // while not enough round key material calculated calculate new values.
  k := (FRounds + 1) Shl 2;
  for i := keyLen to k - 1 do
  begin
    temp := W[(i - 1) Shr 2, (i - 1) and 3];
    if (i Mod keyLen) = 0 then
    begin
      temp := SubWord(Shift(temp, 8)) xor rcon[Round(i / keyLen) - 1];
    end
    else if (keyLen > 6) and ((i mod keyLen) = 4) then
    begin
      temp := SubWord(temp);
    end;

    W[i Shr 2, i and 3] := W[(i - keyLen) Shr 2, (i - keyLen) and 3] xor temp;
  end;

  if not encrypt then
  begin
    for j := 1 to FRounds - 1 do
    begin
      for i := 0 to 3 do
      begin
        W[j, i] := ImixCol(W[j, i]);
      end;
    end;
  end;
  Result := W;
end;

end.
