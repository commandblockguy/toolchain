// convpng
#include <stdint.h>
#include "logo_gfx.h"

uint16_t logo_gfx_pal[190] = {
 0xFFFF,  // 00 :: rgb(255,255,255)
 0xE821,  // 01 :: rgb(213,11,11)
 0x7E20,  // 02 :: rgb(251,139,2)
 0x7E20,  // 03 :: rgb(251,139,1)
 0xFFFF,  // 04 :: rgb(255,254,254)
 0xFFFF,  // 05 :: rgb(255,255,254)
 0x6800,  // 06 :: rgb(212,2,2)
 0x6800,  // 07 :: rgb(212,0,0)
 0x7E20,  // 08 :: rgb(251,139,0)
 0x7920,  // 09 :: rgb(244,72,0)
 0xFE20,  // 10 :: rgb(251,140,4)
 0xFFFF,  // 11 :: rgb(255,253,253)
 0xFFFF,  // 12 :: rgb(255,254,253)
 0xFECC,  // 13 :: rgb(252,182,97)
 0x7A90,  // 14 :: rgb(249,163,128)
 0x7FDC,  // 15 :: rgb(254,244,231)
 0xF985,  // 16 :: rgb(245,100,40)
 0x7F9A,  // 17 :: rgb(253,225,213)
 0x7FDD,  // 18 :: rgb(253,242,242)
 0x6D6B,  // 19 :: rgb(226,90,90)
 0xFFBC,  // 20 :: rgb(254,239,233)
 0xF921,  // 21 :: rgb(244,77,7)
 0x7EED,  // 22 :: rgb(252,187,107)
 0xFF99,  // 23 :: rgb(254,231,203)
 0xFFFE,  // 24 :: rgb(255,253,250)
 0xFF16,  // 25 :: rgb(251,199,177)
 0xF921,  // 26 :: rgb(244,78,8)
 0xFE87,  // 27 :: rgb(251,167,61)
 0xFFBA,  // 28 :: rgb(254,237,216)
 0x7F31,  // 29 :: rgb(253,204,143)
 0xFF76,  // 30 :: rgb(253,222,183)
 0x7B7B,  // 31 :: rgb(249,220,220)
 0xFAF7,  // 32 :: rgb(244,192,192)
 0x7FDD,  // 33 :: rgb(252,241,241)
 0xF18C,  // 34 :: rgb(229,102,102)
 0xFE87,  // 35 :: rgb(251,164,56)
 0x7B5A,  // 36 :: rgb(247,212,212)
 0xFF76,  // 37 :: rgb(253,221,181)
 0xF652,  // 38 :: rgb(237,151,151)
 0x7652,  // 39 :: rgb(236,145,145)
 0x6D29,  // 40 :: rgb(224,74,74)
 0xE800,  // 41 :: rgb(212,3,3)
 0x718C,  // 42 :: rgb(228,98,98)
 0xFF54,  // 43 :: rgb(253,214,165)
 0xFB7B,  // 44 :: rgb(250,224,224)
 0x7673,  // 45 :: rgb(237,153,153)
 0xFF32,  // 46 :: rgb(252,205,148)
 0x7EA8,  // 47 :: rgb(251,169,68)
 0x6CC6,  // 48 :: rgb(219,48,48)
 0x7FBA,  // 49 :: rgb(254,234,211)
 0xE842,  // 50 :: rgb(215,20,20)
 0xFF77,  // 51 :: rgb(253,224,187)
 0xF652,  // 52 :: rgb(237,149,149)
 0x7F75,  // 53 :: rgb(253,218,175)
 0x7FFE,  // 54 :: rgb(254,249,249)
 0x7EEC,  // 55 :: rgb(252,185,102)
 0x7FBD,  // 56 :: rgb(252,236,236)
 0xFFFF,  // 57 :: rgb(255,253,251)
 0x7EED,  // 58 :: rgb(252,188,109)
 0x7FFF,  // 59 :: rgb(254,252,252)
 0xFAF7,  // 60 :: rgb(243,189,189)
 0x7B9B,  // 61 :: rgb(250,225,225)
 0x7AD2,  // 62 :: rgb(250,179,149)
 0xED09,  // 63 :: rgb(224,70,70)
 0xECA5,  // 64 :: rgb(218,43,43)
 0xFAF4,  // 65 :: rgb(250,190,165)
 0x6D4A,  // 66 :: rgb(225,82,82)
 0xED08,  // 67 :: rgb(223,69,69)
 0x6D08,  // 68 :: rgb(222,63,63)
 0x76D6,  // 69 :: rgb(242,178,178)
 0xECC6,  // 70 :: rgb(220,51,51)
 0xF1AD,  // 71 :: rgb(229,109,109)
 0xFFDD,  // 72 :: rgb(254,246,235)
 0x718C,  // 73 :: rgb(228,97,97)
 0xFFBC,  // 74 :: rgb(254,239,234)
 0xFF77,  // 75 :: rgb(253,223,187)
 0x76D6,  // 76 :: rgb(242,179,179)
 0x6863,  // 77 :: rgb(216,26,26)
 0x7AB1,  // 78 :: rgb(249,169,136)
 0xE843,  // 79 :: rgb(215,21,21)
 0xFF9C,  // 80 :: rgb(251,230,230)
 0xF9A6,  // 81 :: rgb(245,108,51)
 0x7F97,  // 82 :: rgb(253,225,189)
 0x7942,  // 83 :: rgb(244,81,13)
 0x7FBA,  // 84 :: rgb(254,236,215)
 0xFE21,  // 85 :: rgb(251,143,11)
 0x7FBC,  // 86 :: rgb(251,234,234)
 0xFB18,  // 87 :: rgb(245,197,197)
 0x76D6,  // 88 :: rgb(242,177,177)
 0x71AD,  // 89 :: rgb(229,106,106)
 0xFAB2,  // 90 :: rgb(249,176,144)
 0x7F9A,  // 91 :: rgb(253,227,217)
 0x7FDD,  // 92 :: rgb(254,242,237)
 0x7FDE,  // 93 :: rgb(253,243,243)
 0x7AB1,  // 94 :: rgb(249,171,139)
 0xFFBB,  // 95 :: rgb(254,239,221)
 0xF694,  // 96 :: rgb(240,167,167)
 0x7AF3,  // 97 :: rgb(250,186,160)
 0xFF7A,  // 98 :: rgb(253,224,213)
 0x7F0E,  // 99 :: rgb(253,193,117)
 0xFA6F,  // 100 :: rgb(249,159,121)
 0x7FFE,  // 101 :: rgb(255,251,247)
 0xFEAA,  // 102 :: rgb(251,175,80)
 0x7694,  // 103 :: rgb(239,161,161)
 0xE801,  // 104 :: rgb(213,5,5)
 0xFA6F,  // 105 :: rgb(249,159,122)
 0x7FDB,  // 106 :: rgb(254,241,224)
 0xF920,  // 107 :: rgb(244,75,4)
 0x7A8F,  // 108 :: rgb(249,160,123)
 0x7694,  // 109 :: rgb(239,163,163)
 0xE822,  // 110 :: rgb(214,14,14)
 0x6D29,  // 111 :: rgb(223,71,71)
 0xFF55,  // 112 :: rgb(253,215,169)
 0x7A8F,  // 113 :: rgb(249,161,124)
 0xFF32,  // 114 :: rgb(253,207,151)
 0x7FBB,  // 115 :: rgb(253,233,224)
 0xF694,  // 116 :: rgb(239,165,165)
 0xFFBC,  // 117 :: rgb(254,238,231)
 0xFB39,  // 118 :: rgb(247,208,208)
 0x7B38,  // 119 :: rgb(246,201,201)
 0x6842,  // 120 :: rgb(214,16,16)
 0x7FFF,  // 121 :: rgb(254,251,251)
 0xFB7B,  // 122 :: rgb(250,223,223)
 0xF16C,  // 123 :: rgb(227,95,95)
 0x7672,  // 124 :: rgb(237,152,152)
 0x7631,  // 125 :: rgb(235,138,138)
 0xFE87,  // 126 :: rgb(251,165,60)
 0xFFDD,  // 127 :: rgb(254,245,240)
 0xFF33,  // 128 :: rgb(252,208,154)
 0x7F79,  // 129 :: rgb(252,220,207)
 0x7E41,  // 130 :: rgb(251,144,12)
 0x7E42,  // 131 :: rgb(251,146,19)
 0x7F36,  // 132 :: rgb(251,202,182)
 0x7FDC,  // 133 :: rgb(254,243,230)
 0x7963,  // 134 :: rgb(244,89,24)
 0x7F0E,  // 135 :: rgb(252,193,119)
 0xFE87,  // 136 :: rgb(251,164,57)
 0x7A2B,  // 137 :: rgb(247,138,92)
 0xFA6E,  // 138 :: rgb(249,157,119)
 0xFF9B,  // 139 :: rgb(253,229,219)
 0x7920,  // 140 :: rgb(244,74,3)
 0xFFDE,  // 141 :: rgb(254,246,243)
 0xF964,  // 142 :: rgb(245,95,32)
 0xF921,  // 143 :: rgb(244,76,6)
 0xFAD3,  // 144 :: rgb(250,183,155)
 0xFAD3,  // 145 :: rgb(250,182,154)
 0xF985,  // 146 :: rgb(245,103,44)
 0x7FFE,  // 147 :: rgb(255,252,250)
 0x7FFE,  // 148 :: rgb(255,251,250)
 0x6800,  // 149 :: rgb(212,1,1)
 0x7B18,  // 150 :: rgb(245,195,195)
 0x7AD2,  // 151 :: rgb(250,178,148)
 0x7ECB,  // 152 :: rgb(251,179,87)
 0x7EA8,  // 153 :: rgb(251,169,69)
 0xFEAA,  // 154 :: rgb(251,176,82)
 0x7652,  // 155 :: rgb(236,146,146)
 0xF942,  // 156 :: rgb(244,83,16)
 0xF9E9,  // 157 :: rgb(246,126,76)
 0xFFDD,  // 158 :: rgb(254,246,242)
 0x71EF,  // 159 :: rgb(231,120,120)
 0xFB39,  // 160 :: rgb(247,206,206)
 0xFF37,  // 161 :: rgb(252,208,190)
 0x6D08,  // 162 :: rgb(222,65,65)
 0x7FDE,  // 163 :: rgb(253,244,244)
 0x7A4D,  // 164 :: rgb(248,147,106)
 0xFB5A,  // 165 :: rgb(248,216,216)
 0x7F79,  // 166 :: rgb(253,220,206)
 0xFAD3,  // 167 :: rgb(250,181,153)
 0x7F15,  // 168 :: rgb(251,196,173)
 0x7F31,  // 169 :: rgb(252,201,137)
 0xF9C8,  // 170 :: rgb(246,116,62)
 0xFAB2,  // 171 :: rgb(250,176,145)
 0xFF10,  // 172 :: rgb(252,198,131)
 0x7A6E,  // 173 :: rgb(248,155,117)
 0xFF9B,  // 174 :: rgb(253,232,224)
 0xFFBB,  // 175 :: rgb(254,240,221)
 0x7920,  // 176 :: rgb(244,74,2)
 0x7FDC,  // 177 :: rgb(254,243,229)
 0xFE21,  // 178 :: rgb(251,141,6)
 0x7F53,  // 179 :: rgb(253,210,155)
 0xF9E9,  // 180 :: rgb(247,127,77)
 0xFF58,  // 181 :: rgb(252,213,197)
 0xFE87,  // 182 :: rgb(251,164,58)
 0xFF54,  // 183 :: rgb(253,213,164)
 0xFEA9,  // 184 :: rgb(251,174,78)
 0xFE21,  // 185 :: rgb(251,143,10)
 0x79E8,  // 186 :: rgb(246,120,67)
 0x7E87,  // 187 :: rgb(251,163,54)
 0xFFDD,  // 188 :: rgb(254,248,240)
 0x7F57,  // 189 :: rgb(252,210,193)
};