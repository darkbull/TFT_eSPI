// This is a Processing sketch, see https://processing.org/ to download the IDE

// Select the font, size and character ranges in the user configuration section
// of this sketch, which starts at line 120. Instructions start at line 50.


/*
Software License Agreement (FreeBSD License)
 
 Copyright (c) 2018 Bodmer (https://github.com/Bodmer)
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 The views and conclusions contained in the software and documentation are those
 of the authors and should not be interpreted as representing official policies,
 either expressed or implied, of the FreeBSD Project.
 */

////////////////////////////////////////////////////////////////////////////////////////////////

// This is a processing sketch to create font files for the TFT_eSPI library:

// https://github.com/Bodmer/TFT_eSPI

// Coded by Bodmer January 2018, updated 10/2/19
// Version 0.8

// >>>>>>>>>>>>>>>>>>>>             INSTRUCTIONS             <<<<<<<<<<<<<<<<<<<<

// See comments below in code for specifying the font parameters (point size,
// unicode blocks to include etc). Ranges of characters (glyphs) and specific
// individual glyphs can be included in the created "*.vlw" font file.

// Created fonts are saved in the sketches "FontFiles" folder. Press Ctrl+K to
// see that folder location.

// 16 bit Unicode point codes in the range 0x0000 - 0xFFFF are supported.
// Codes 0-31 are control codes such as "tab" and "carraige return" etc.
// and 32 is a "space", these should NOT be included.

// The sketch will convert True Type (a .ttf or .otf file) file stored in the
// sketches "Data" folder as well as your computers' system fonts.

// To maximise rendering performance and the memory consumed only include the characters
// you will use. Characters at the start of the file will render faster than those at
// the end due to the buffering and file seeking overhead.

// The inclusion of "non-existant" characters in a font may give unpredicatable results
// when rendering with the TFT_eSPI library. The Processing sketch window that pops up
// to show the font characters will print "boxes" (also known as Tofu!) for non existant
// characters.

// Once created the files must be loaded into the ESP32 or ESP8266 SPIFFS memory
// using the Arduino IDE plugin detailed here:
// https://github.com/esp8266/arduino-esp8266fs-plugin
// https://github.com/me-no-dev/arduino-esp32fs-plugin

// When the sketch is run it will generate a file called "System_Font_List.txt" in the
// sketch "FontFiles" folder, press Ctrl+K to see it. Open the file in a text editor to
// view it. This list provides the font reference number needed below to locate that
// font on your system.

// The sketch also lists all the available system fonts to the console, you can increase
// the console line count (in preferences.txt) to stop some fonts scrolling out of view.
// See link in File>Preferences to locate "preferences.txt" file. You must close
// Processing then edit the file lines. If Processing is not closed first then the
// edits will be overwritten by defaults! Edit "preferences.txt" as follows for
// 3000 lines, then save, then run Processing again:

//     console.length=3000;             // Line 4 in file
//     console.scrollback.lines=3000;   // Line 7 in file


// Useful links:
/*

 https://en.wikipedia.org/wiki/Unicode_font
 
 https://www.gnu.org/software/freefont/
 https://www.gnu.org/software/freefont/sources/
 https://www.gnu.org/software/freefont/ranges/
 http://savannah.gnu.org/projects/freefont/
 
 http://www.google.com/get/noto/
 
 https://github.com/Bodmer/TFT_eSPI
 https://github.com/esp8266/arduino-esp8266fs-plugin
 https://github.com/me-no-dev/arduino-esp32fs-plugin
 
   >>>>>>>>>>>>>>>>>>>>         END OF INSTRUCTIONS         <<<<<<<<<<<<<<<<<<<< */


import java.awt.Desktop; // Required to allow sketch to open file windows


////////////////////////////////////////////////////////////////////////////////////////////////

//                       >>>>>>>>>> USER CONFIGURED PARAMETERS START HERE <<<<<<<<<<

// Use font number or name, -1 for fontNumber means use fontName below, a value >=0 means use system font number from list.
// When the sketch is run it will generate a file called "systemFontList.txt" in the sketch folder, press Ctrl+K to see it.
// Open the "systemFontList.txt" in a text editor to view the font files and reference numbers for your system.

int fontNumber = -1; // << Use [Number] in brackets from the fonts listed.

// OR use font name for ttf files placed in the "Data" folder or the font number seen in IDE Console for system fonts
//                                                  the font numbers are listed when the sketch is run.
//                |         1         2     |       Maximum filename size for SPIFFS is 31 including leading /
//                 1234567890123456789012345        and added point size and .vlw extension, so max is 25
String fontName = "wqy-MicroHei";  // Manually crop the filename length later after creation if needed
                                     // Note: SPIFFS does NOT accept underscore in a filename!
String fontType = ".ttf";
// String fontType = ".otf";


// Define the font size in points for the TFT_eSPI font file
int  fontSize = 16;

// Font size to use in the Processing sketch display window that pops up (can be different to above)
int displayFontSize = 24;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Next we specify which unicode blocks from the the Basic Multilingual Plane (BMP) are included in the final font file. //
// Note: The ttf/otf font file MAY NOT contain all possible Unicode characters, refer to the fonts online documentation. //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

static final int[] unicodeBlocks = {
  // The list below has been created from the table here: https://en.wikipedia.org/wiki/Unicode_block
  // Remove // at start of lines below to include that unicode block, different code ranges can also be specified by
  // editting the start and end-of-range values. Multiple lines from the list below can be included, limited only by
  // the final font file size!

  // Block range,   //Block name, Code points, Assigned characters, Scripts
  // First, last,   //Range is inclusive of first and last codes
  // 0x0021, 0x007E, //Basic Latin, 128, 128, Latin (52 characters), Common (76 characters)
  //0x0080, 0x00FF, //Latin-1 Supplement, 128, 128, Latin (64 characters), Common (64 characters)
  //0x0100, 0x017F, //Latin Extended-A, 128, 128, Latin
  //0x0180, 0x024F, //Latin Extended-B, 208, 208, Latin
  //0x0250, 0x02AF, //IPA Extensions, 96, 96, Latin
  //0x02B0, 0x02FF, //Spacing Modifier Letters, 80, 80, Bopomofo (2 characters), Latin (14 characters), Common (64 characters)
  //0x0300, 0x036F, //Combining Diacritical Marks, 112, 112, Inherited
  //0x0370, 0x03FF, //Greek and Coptic, 144, 135, Coptic (14 characters), Greek (117 characters), Common (4 characters)
  //0x0400, 0x04FF, //Cyrillic, 256, 256, Cyrillic (254 characters), Inherited (2 characters)
  //0x0500, 0x052F, //Cyrillic Supplement, 48, 48, Cyrillic
  //0x0530, 0x058F, //Armenian, 96, 89, Armenian (88 characters), Common (1 character)
  //0x0590, 0x05FF, //Hebrew, 112, 87, Hebrew
  //0x0600, 0x06FF, //Arabic, 256, 255, Arabic (237 characters), Common (6 characters), Inherited (12 characters)
  //0x0700, 0x074F, //Syriac, 80, 77, Syriac
  //0x0750, 0x077F, //Arabic Supplement, 48, 48, Arabic
  //0x0780, 0x07BF, //Thaana, 64, 50, Thaana
  //0x07C0, 0x07FF, //NKo, 64, 59, Nko
  //0x0800, 0x083F, //Samaritan, 64, 61, Samaritan
  //0x0840, 0x085F, //Mandaic, 32, 29, Mandaic
  //0x0860, 0x086F, //Syriac Supplement, 16, 11, Syriac
  //0x08A0, 0x08FF, //Arabic Extended-A, 96, 73, Arabic (72 characters), Common (1 character)
  //0x0900, 0x097F, //Devanagari, 128, 128, Devanagari (124 characters), Common (2 characters), Inherited (2 characters)
  //0x0980, 0x09FF, //Bengali, 128, 95, Bengali
  //0x0A00, 0x0A7F, //Gurmukhi, 128, 79, Gurmukhi
  //0x0A80, 0x0AFF, //Gujarati, 128, 91, Gujarati
  //0x0B00, 0x0B7F, //Oriya, 128, 90, Oriya
  //0x0B80, 0x0BFF, //Tamil, 128, 72, Tamil
  //0x0C00, 0x0C7F, //Telugu, 128, 96, Telugu
  //0x0C80, 0x0CFF, //Kannada, 128, 88, Kannada
  //0x0D00, 0x0D7F, //Malayalam, 128, 117, Malayalam
  //0x0D80, 0x0DFF, //Sinhala, 128, 90, Sinhala
  //0x0E00, 0x0E7F, //Thai, 128, 87, Thai (86 characters), Common (1 character)
  //0x0E80, 0x0EFF, //Lao, 128, 67, Lao
  //0x0F00, 0x0FFF, //Tibetan, 256, 211, Tibetan (207 characters), Common (4 characters)
  //0x1000, 0x109F, //Myanmar, 160, 160, Myanmar
  //0x10A0, 0x10FF, //Georgian, 96, 88, Georgian (87 characters), Common (1 character)
  //0x1100, 0x11FF, //Hangul Jamo, 256, 256, Hangul
  //0x1200, 0x137F, //Ethiopic, 384, 358, Ethiopic
  //0x1380, 0x139F, //Ethiopic Supplement, 32, 26, Ethiopic
  //0x13A0, 0x13FF, //Cherokee, 96, 92, Cherokee
  //0x1400, 0x167F, //Unified Canadian Aboriginal Syllabics, 640, 640, Canadian Aboriginal
  //0x1680, 0x169F, //Ogham, 32, 29, Ogham
  //0x16A0, 0x16FF, //Runic, 96, 89, Runic (86 characters), Common (3 characters)
  //0x1700, 0x171F, //Tagalog, 32, 20, Tagalog
  //0x1720, 0x173F, //Hanunoo, 32, 23, Hanunoo (21 characters), Common (2 characters)
  //0x1740, 0x175F, //Buhid, 32, 20, Buhid
  //0x1760, 0x177F, //Tagbanwa, 32, 18, Tagbanwa
  //0x1780, 0x17FF, //Khmer, 128, 114, Khmer
  //0x1800, 0x18AF, //Mongolian, 176, 156, Mongolian (153 characters), Common (3 characters)
  //0x18B0, 0x18FF, //Unified Canadian Aboriginal Syllabics Extended, 80, 70, Canadian Aboriginal
  //0x1900, 0x194F, //Limbu, 80, 68, Limbu
  //0x1950, 0x197F, //Tai Le, 48, 35, Tai Le
  //0x1980, 0x19DF, //New Tai Lue, 96, 83, New Tai Lue
  //0x19E0, 0x19FF, //Khmer Symbols, 32, 32, Khmer
  //0x1A00, 0x1A1F, //Buginese, 32, 30, Buginese
  //0x1A20, 0x1AAF, //Tai Tham, 144, 127, Tai Tham
  //0x1AB0, 0x1AFF, //Combining Diacritical Marks Extended, 80, 15, Inherited
  //0x1B00, 0x1B7F, //Balinese, 128, 121, Balinese
  //0x1B80, 0x1BBF, //Sundanese, 64, 64, Sundanese
  //0x1BC0, 0x1BFF, //Batak, 64, 56, Batak
  //0x1C00, 0x1C4F, //Lepcha, 80, 74, Lepcha
  //0x1C50, 0x1C7F, //Ol Chiki, 48, 48, Ol Chiki
  //0x1C80, 0x1C8F, //Cyrillic Extended-C, 16, 9, Cyrillic
  //0x1CC0, 0x1CCF, //Sundanese Supplement, 16, 8, Sundanese
  //0x1CD0, 0x1CFF, //Vedic Extensions, 48, 42, Common (15 characters), Inherited (27 characters)
  //0x1D00, 0x1D7F, //Phonetic Extensions, 128, 128, Cyrillic (2 characters), Greek (15 characters), Latin (111 characters)
  //0x1D80, 0x1DBF, //Phonetic Extensions Supplement, 64, 64, Greek (1 character), Latin (63 characters)
  //0x1DC0, 0x1DFF, //Combining Diacritical Marks Supplement, 64, 63, Inherited
  //0x1E00, 0x1EFF, //Latin Extended Additional, 256, 256, Latin
  //0x1F00, 0x1FFF, //Greek Extended, 256, 233, Greek
  //0x2000, 0x206F, //General Punctuation, 112, 111, Common (109 characters), Inherited (2 characters)
  //0x2070, 0x209F, //Superscripts and Subscripts, 48, 42, Latin (15 characters), Common (27 characters)
  //0x20A0, 0x20CF, //Currency Symbols, 48, 32, Common
  //0x20D0, 0x20FF, //Combining Diacritical Marks for Symbols, 48, 33, Inherited
  //0x2100, 0x214F, //Letterlike Symbols, 80, 80, Greek (1 character), Latin (4 characters), Common (75 characters)
  //0x2150, 0x218F, //Number Forms, 64, 60, Latin (41 characters), Common (19 characters)
  //0x2190, 0x21FF, //Arrows, 112, 112, Common
  //0x2200, 0x22FF, //Mathematical Operators, 256, 256, Common
  //0x2300, 0x23FF, //Miscellaneous Technical, 256, 256, Common
  //0x2400, 0x243F, //Control Pictures, 64, 39, Common
  //0x2440, 0x245F, //Optical Character Recognition, 32, 11, Common
  //0x2460, 0x24FF, //Enclosed Alphanumerics, 160, 160, Common
  //0x2500, 0x257F, //Box Drawing, 128, 128, Common
  //0x2580, 0x259F, //Block Elements, 32, 32, Common
  //0x25A0, 0x25FF, //Geometric Shapes, 96, 96, Common
  //0x2600, 0x26FF, //Miscellaneous Symbols, 256, 256, Common
  //0x2700, 0x27BF, //Dingbats, 192, 192, Common
  //0x27C0, 0x27EF, //Miscellaneous Mathematical Symbols-A, 48, 48, Common
  //0x27F0, 0x27FF, //Supplemental Arrows-A, 16, 16, Common
  //0x2800, 0x28FF, //Braille Patterns, 256, 256, Braille
  //0x2900, 0x297F, //Supplemental Arrows-B, 128, 128, Common
  //0x2980, 0x29FF, //Miscellaneous Mathematical Symbols-B, 128, 128, Common
  //0x2A00, 0x2AFF, //Supplemental Mathematical Operators, 256, 256, Common
  //0x2B00, 0x2BFF, //Miscellaneous Symbols and Arrows, 256, 207, Common
  //0x2C00, 0x2C5F, //Glagolitic, 96, 94, Glagolitic
  //0x2C60, 0x2C7F, //Latin Extended-C, 32, 32, Latin
  //0x2C80, 0x2CFF, //Coptic, 128, 123, Coptic
  //0x2D00, 0x2D2F, //Georgian Supplement, 48, 40, Georgian
  //0x2D30, 0x2D7F, //Tifinagh, 80, 59, Tifinagh
  //0x2D80, 0x2DDF, //Ethiopic Extended, 96, 79, Ethiopic
  //0x2DE0, 0x2DFF, //Cyrillic Extended-A, 32, 32, Cyrillic
  //0x2E00, 0x2E7F, //Supplemental Punctuation, 128, 74, Common
  //0x2E80, 0x2EFF, //CJK Radicals Supplement, 128, 115, Han
  //0x2F00, 0x2FDF, //Kangxi Radicals, 224, 214, Han
  //0x2FF0, 0x2FFF, //Ideographic Description Characters, 16, 12, Common
  //0x3000, 0x303F, //CJK Symbols and Punctuation, 64, 64, Han (15 characters), Hangul (2 characters), Common (43 characters), Inherited (4 characters)
  //0x3040, 0x309F, //Hiragana, 96, 93, Hiragana (89 characters), Common (2 characters), Inherited (2 characters)
  //0x30A0, 0x30FF, //Katakana, 96, 96, Katakana (93 characters), Common (3 characters)
  //0x3100, 0x312F, //Bopomofo, 48, 42, Bopomofo
  //0x3130, 0x318F, //Hangul Compatibility Jamo, 96, 94, Hangul
  //0x3190, 0x319F, //Kanbun, 16, 16, Common
  //0x31A0, 0x31BF, //Bopomofo Extended, 32, 27, Bopomofo
  //0x31C0, 0x31EF, //CJK Strokes, 48, 36, Common
  //0x31F0, 0x31FF, //Katakana Phonetic Extensions, 16, 16, Katakana
  //0x3200, 0x32FF, //Enclosed CJK Letters and Months, 256, 254, Hangul (62 characters), Katakana (47 characters), Common (145 characters)
  //0x3300, 0x33FF, //CJK Compatibility, 256, 256, Katakana (88 characters), Common (168 characters)
  //0x3400, 0x4DBF, //CJK Unified Ideographs Extension A, 6,592, 6,582, Han
  //0x4DC0, 0x4DFF, //Yijing Hexagram Symbols, 64, 64, Common
  // 0x4E00, 0x9FFF, //CJK Unified Ideographs, 20,992, 20,971, Han
  //0xA000, 0xA48F, //Yi Syllables, 1,168, 1,165, Yi
  //0xA490, 0xA4CF, //Yi Radicals, 64, 55, Yi
  //0xA4D0, 0xA4FF, //Lisu, 48, 48, Lisu
  //0xA500, 0xA63F, //Vai, 320, 300, Vai
  //0xA640, 0xA69F, //Cyrillic Extended-B, 96, 96, Cyrillic
  //0xA6A0, 0xA6FF, //Bamum, 96, 88, Bamum
  //0xA700, 0xA71F, //Modifier Tone Letters, 32, 32, Common
  //0xA720, 0xA7FF, //Latin Extended-D, 224, 160, Latin (155 characters), Common (5 characters)
  //0xA800, 0xA82F, //Syloti Nagri, 48, 44, Syloti Nagri
  //0xA830, 0xA83F, //Common Indic Number Forms, 16, 10, Common
  //0xA840, 0xA87F, //Phags-pa, 64, 56, Phags Pa
  //0xA880, 0xA8DF, //Saurashtra, 96, 82, Saurashtra
  //0xA8E0, 0xA8FF, //Devanagari Extended, 32, 30, Devanagari
  //0xA900, 0xA92F, //Kayah Li, 48, 48, Kayah Li (47 characters), Common (1 character)
  //0xA930, 0xA95F, //Rejang, 48, 37, Rejang
  //0xA960, 0xA97F, //Hangul Jamo Extended-A, 32, 29, Hangul
  //0xA980, 0xA9DF, //Javanese, 96, 91, Javanese (90 characters), Common (1 character)
  //0xA9E0, 0xA9FF, //Myanmar Extended-B, 32, 31, Myanmar
  //0xAA00, 0xAA5F, //Cham, 96, 83, Cham
  //0xAA60, 0xAA7F, //Myanmar Extended-A, 32, 32, Myanmar
  //0xAA80, 0xAADF, //Tai Viet, 96, 72, Tai Viet
  //0xAAE0, 0xAAFF, //Meetei Mayek Extensions, 32, 23, Meetei Mayek
  //0xAB00, 0xAB2F, //Ethiopic Extended-A, 48, 32, Ethiopic
  //0xAB30, 0xAB6F, //Latin Extended-E, 64, 54, Latin (52 characters), Greek (1 character), Common (1 character)
  //0xAB70, 0xABBF, //Cherokee Supplement, 80, 80, Cherokee
  //0xABC0, 0xABFF, //Meetei Mayek, 64, 56, Meetei Mayek
  //0xAC00, 0xD7AF, //Hangul Syllables, 11,184, 11,172, Hangul
  //0xD7B0, 0xD7FF, //Hangul Jamo Extended-B, 80, 72, Hangul
  //0xD800, 0xDB7F, //High Surrogates, 896, 0, Unknown
  //0xDB80, 0xDBFF, //High Private Use Surrogates, 128, 0, Unknown
  //0xDC00, 0xDFFF, //Low Surrogates, 1,024, 0, Unknown
  //0xE000, 0xF8FF, //Private Use Area, 6,400, 6,400, Unknown
  //0xF900, 0xFAFF, //CJK Compatibility Ideographs, 512, 472, Han
  //0xFB00, 0xFB4F, //Alphabetic Presentation Forms, 80, 58, Armenian (5 characters), Hebrew (46 characters), Latin (7 characters)
  //0xFB50, 0xFDFF, //Arabic Presentation Forms-A, 688, 611, Arabic (609 characters), Common (2 characters)
  //0xFE00, 0xFE0F, //Variation Selectors, 16, 16, Inherited
  //0xFE10, 0xFE1F, //Vertical Forms, 16, 10, Common
  //0xFE20, 0xFE2F, //Combining Half Marks, 16, 16, Cyrillic (2 characters), Inherited (14 characters)
  //0xFE30, 0xFE4F, //CJK Compatibility Forms, 32, 32, Common
  //0xFE50, 0xFE6F, //Small Form Variants, 32, 26, Common
  //0xFE70, 0xFEFF, //Arabic Presentation Forms-B, 144, 141, Arabic (140 characters), Common (1 character)
  //0xFF00, 0xFFEF, //Halfwidth and Fullwidth Forms, 240, 225, Hangul (52 characters), Katakana (55 characters), Latin (52 characters), Common (66 characters)
  //0xFFF0, 0xFFFF, //Specials, 16, 5, Common

  //0x0030, 0x0039, //Example custom range (numbers 0-9)
  //0x0041, 0x005A, //Example custom range (Upper case A-Z)
  //0x0061, 0x007A, //Example custom range (Lower case a-z)

32, 126, 19968, 19969, 19971, 19971, 19975, 19979, 19981, 19982, 19985, 19985, 19987, 19988, 19990, 19990, 19992, 19997, 20002, 20002, 20004, 20005, 20007, 20007, 20010, 20011, 20013, 20013, 20016, 20016, 20018, 20018, 20020, 20020, 20024, 20027, 20029, 20030, 20035, 20035, 20037, 20037, 20040, 20041, 20043, 20048, 20050, 20052, 20054, 20054, 20056, 20057, 20061, 20065, 20070, 20070, 20080, 20081, 20083, 20083, 20094, 20094, 20102, 20102, 20104, 20105, 20107, 20108, 20110, 20111, 20113, 20114, 20116, 20117, 20122, 20123, 20129, 20130, 20132, 20137, 20139, 20142, 20146, 20146, 20154, 20154, 20159, 20161, 20165, 20167, 20170, 20171, 20173, 20174, 20177, 20177, 20179, 20185, 20191, 20191, 20195, 20197, 20202, 20202, 20204, 20204, 20208, 20208, 20210, 20210, 20214, 20215, 20219, 20219, 20221, 20221, 20223, 20223, 20225, 20225, 20234, 20234, 20237, 20241, 20247, 20250, 20254, 20256, 20260, 20260, 20262, 20262, 20266, 20266, 20271, 20272, 20276, 20276, 20278, 20278, 20280, 20280, 20282, 20282, 20284, 20284, 20291, 20291, 20294, 20294, 20301, 20305, 20307, 20307, 20309, 20309, 20313, 20313, 20315, 20316, 20320, 20320, 20323, 20323, 20329, 20329, 20332, 20332, 20335, 20336, 20339, 20339, 20351, 20351, 20356, 20356, 20360, 20360, 20363, 20363, 20365, 20365, 20375, 20375, 20379, 20379, 20381, 20381, 20384, 20384, 20387, 20387, 20389, 20393, 20398, 20399, 20405, 20405, 20415, 20415, 20419, 20420, 20426, 20426, 20431, 20432, 20439, 20440, 20445, 20446, 20449, 20449, 20457, 20457, 20461, 20463, 20465, 20465, 20474, 20474, 20493, 20493, 20498, 20498, 20500, 20500, 20504, 20506, 20511, 20511, 20513, 20513, 20518, 20518, 20522, 20522, 20538, 20538, 20540, 20540, 20542, 20542, 20551, 20551, 20559, 20559, 20570, 20570, 20572, 20572, 20581, 20581, 20598, 20599, 20607, 20608, 20613, 20613, 20616, 20616, 20621, 20621, 20643, 20643, 20648, 20648, 20652, 20652, 20658, 20658, 20667, 20667, 20687, 20687, 20698, 20698, 20711, 20711, 20723, 20723, 20725, 20725, 20731, 20731, 20754, 20754, 20769, 20769, 20799, 20799, 20801, 20801, 20803, 20806, 20808, 20809, 20811, 20811, 20813, 20813, 20817, 20817, 20820, 20820, 20826, 20826, 20828, 20828, 20834, 20834, 20837, 20837, 20840, 20840, 20843, 20845, 20848, 20849, 20851, 20857, 20859, 20861, 20864, 20864, 20869, 20869, 20872, 20873, 20876, 20877, 20882, 20882, 20885, 20885, 20887, 20887, 20889, 20889, 20891, 20892, 20896, 20896, 20900, 20900, 20908, 20908, 20911, 20912, 20914, 20915, 20917, 20919, 20923, 20923, 20928, 20928, 20932, 20932, 20934, 20934, 20937, 20937, 20939, 20940, 20943, 20943, 20945, 20945, 20955, 20955, 20957, 20957, 20960, 20961, 20964, 20964, 20973, 20973, 20975, 20976, 20979, 20979, 20982, 20982, 20984, 20987, 20989, 20989, 20991, 20993, 20995, 20995, 20998, 20999, 21002, 21002, 21009, 21010, 21015, 21019, 21021, 21021, 21024, 21024, 21028, 21028, 21032, 21033, 21035, 21035, 21038, 21038, 21040, 21040, 21046, 21051, 21053, 21053, 21057, 21059, 21066, 21066, 21069, 21069, 21072, 21073, 21076, 21076, 21078, 21078, 21093, 21093, 21095, 21095, 21097, 21098, 21103, 21103, 21106, 21106, 21119, 21119, 21128, 21128, 21147, 21147, 21149, 21153, 21155, 21155, 21160, 21163, 21169, 21171, 21183, 21183, 21187, 21187, 21191, 21191, 21193, 21193, 21195, 21195, 21202, 21202, 21208, 21208, 21215, 21215, 21220, 21220, 21242, 21242, 21246, 21248, 21253, 21254, 21256, 21256, 21270, 21271, 21273, 21273, 21277, 21277, 21280, 21281, 21283, 21283, 21290, 21290, 21305, 21307, 21311, 21311, 21313, 21313, 21315, 21315, 21319, 21322, 21326, 21327, 21329, 21331, 21333, 21335, 21338, 21338, 21340, 21340, 21342, 21342, 21344, 21346, 21348, 21348, 21351, 21351, 21355, 21355, 21359, 21361, 21363, 21365, 21367, 21368, 21375, 21375, 21378, 21378, 21380, 21382, 21385, 21385, 21387, 21388, 21397, 21397, 21400, 21400, 21402, 21402, 21407, 21407, 21410, 21410, 21414, 21414, 21416, 21417, 21435, 21435, 21439, 21439, 21441, 21442, 21448, 21453, 21457, 21457, 21460, 21460, 21462, 21465, 21467, 21467, 21472, 21472, 21475, 21478, 21482, 21488, 21490, 21491, 21494, 21497, 21500, 21500, 21505, 21505, 21507, 21508, 21512, 21514, 21516, 21521, 21523, 21523, 21525, 21525, 21527, 21527, 21531, 21531, 21533, 21536, 21542, 21545, 21547, 21551, 21553, 21553, 21556, 21557, 21560, 21561, 21563, 21564, 21566, 21566, 21568, 21568, 21574, 21574, 21576, 21576, 21578, 21578, 21584, 21584, 21589, 21589, 21592, 21592, 21595, 21596, 21602, 21602, 21608, 21608, 21619, 21619, 21621, 21621, 21624, 21624, 21627, 21629, 21632, 21632, 21638, 21638, 21643, 21644, 21646, 21648, 21650, 21650, 21653, 21654, 21657, 21657, 21672, 21672, 21676, 21676, 21679, 21679, 21681, 21681, 21683, 21683, 21688, 21688, 21693, 21693, 21696, 21697, 21700, 21700, 21702, 21705, 21709, 21710, 21713, 21713, 21719, 21719, 21727, 21727, 21733, 21734, 21736, 21738, 21741, 21742, 21746, 21746, 21754, 21754, 21756, 21756, 21761, 21761, 21766, 21767, 21769, 21769, 21776, 21776, 21796, 21796, 21804, 21804, 21806, 21807, 21809, 21809, 21822, 21822, 21827, 21828, 21830, 21830, 21834, 21834, 21857, 21857, 21860, 21862, 21866, 21866, 21870, 21870, 21880, 21880, 21884, 21884, 21888, 21888, 21890, 21890, 21892, 21892, 21895, 21895, 21897, 21898, 21912, 21912, 21916, 21917, 21927, 21927, 21939, 21939, 21943, 21943, 21947, 21947, 21957, 21957, 21971, 21971, 21980, 21980, 21985, 21985, 21987, 21987, 22013, 22013, 22025, 22025, 22030, 22030, 22040, 22040, 22043, 22043, 22065, 22066, 22068, 22068, 22070, 22070, 22075, 22075, 22079, 22079, 22094, 22094, 22120, 22120, 22122, 22122, 22124, 22124, 22134, 22134, 22158, 22159, 22179, 22179, 22199, 22199, 22204, 22204, 22218, 22218, 22234, 22235, 22238, 22238, 22240, 22240, 22242, 22242, 22244, 22244, 22253, 22253, 22256, 22257, 22260, 22260, 22266, 22266, 22269, 22270, 22275, 22275, 22278, 22278, 22280, 22280, 22303, 22303, 22307, 22307, 22312, 22312, 22317, 22317, 22320, 22320, 22330, 22330, 22334, 22334, 22336, 22336, 22343, 22343, 22346, 22346, 22349, 22353, 22359, 22359, 22362, 22363, 22365, 22369, 22372, 22372, 22374, 22374, 22378, 22378, 22383, 22383, 22391, 22391, 22402, 22404, 22411, 22411, 22418, 22418, 22427, 22427, 22434, 22435, 22438, 22438, 22443, 22443, 22446, 22446, 22466, 22467, 22475, 22475, 22478, 22478, 22484, 22484, 22495, 22496, 22521, 22522, 22530, 22530, 22534, 22534, 22545, 22545, 22549, 22549, 22561, 22561, 22564, 22564, 22570, 22570, 22576, 22576, 22581, 22581, 22604, 22604, 22609, 22609, 22612, 22612, 22616, 22616, 22622, 22622, 22635, 22635, 22659, 22659, 22661, 22661, 22674, 22675, 22681, 22681, 22686, 22687, 22696, 22697, 22721, 22721, 22741, 22741, 22756, 22756, 22763, 22764, 22766, 22766, 22768, 22768, 22771, 22771, 22774, 22774, 22777, 22777, 22788, 22788, 22791, 22791, 22797, 22797, 22799, 22799, 22805, 22806, 22810, 22810, 22812, 22812, 22815, 22815, 22823, 22823, 22825, 22827, 22830, 22831, 22833, 22833, 22836, 22836, 22839, 22842, 22852, 22852, 22855, 22857, 22859, 22859, 22862, 22863, 22865, 22865, 22868, 22868, 22870, 22871, 22880, 22880, 22882, 22882, 22885, 22885, 22899, 22900, 22902, 22902, 22904, 22905, 22909, 22909, 22914, 22914, 22916, 22916, 22918, 22920, 22922, 22922, 22930, 22931, 22934, 22934, 22937, 22937, 22949, 22949, 22952, 22952, 22958, 22958, 22969, 22969, 22971, 22971, 22982, 22982, 22987, 22987, 22992, 22993, 22995, 22996, 23002, 23002, 23004, 23004, 23013, 23013, 23016, 23016, 23020, 23020, 23035, 23035, 23039, 23039, 23041, 23041, 23043, 23044, 23047, 23047, 23064, 23064, 23068, 23068, 23071, 23072, 23077, 23077, 23081, 23081, 23089, 23089, 23094, 23094, 23110, 23110, 23113, 23113, 23130, 23130, 23146, 23146, 23156, 23156, 23158, 23158, 23167, 23167, 23186, 23186, 23194, 23194, 23219, 23219, 23233, 23234, 23241, 23241, 23244, 23244, 23265, 23265, 23273, 23273, 23376, 23376, 23380, 23381, 23383, 23385, 23388, 23389, 23391, 23391, 23395, 23396, 23398, 23398, 23401, 23402, 23408, 23408, 23413, 23413, 23418, 23418, 23421, 23421, 23425, 23425, 23427, 23427, 23429, 23429, 23431, 23433, 23435, 23436, 23439, 23439, 23447, 23454, 23456, 23460, 23462, 23462, 23466, 23467, 23472, 23472, 23475, 23478, 23481, 23481, 23485, 23487, 23490, 23490, 23492, 23495, 23500, 23500, 23504, 23504, 23506, 23507, 23517, 23519, 23521, 23521, 23525, 23525, 23528, 23528, 23544, 23548, 23551, 23551, 23553, 23553, 23556, 23556, 23558, 23558, 23561, 23562, 23567, 23567, 23569, 23569, 23572, 23572, 23574, 23574, 23576, 23576, 23578, 23578, 23581, 23581, 23588, 23588, 23591, 23591, 23601, 23601, 23608, 23610, 23612, 23618, 23621, 23621, 23624, 23627, 23630, 23631, 23633, 23633, 23637, 23637, 23646, 23646, 23648, 23649, 23653, 23653, 23663, 23663, 23665, 23665, 23673, 23673, 23679, 23679, 23681, 23682, 23700, 23700, 23703, 23703, 23707, 23707, 23721, 23721, 23725, 23725, 23731, 23731, 23736, 23736, 23743, 23743, 23769, 23769, 23777, 23777, 23782, 23782, 23784, 23784, 23786, 23786, 23789, 23789, 23792, 23792, 23803, 23803, 23815, 23815, 23822, 23822, 23828, 23828, 23830, 23830, 23849, 23849, 23853, 23853, 23884, 23884, 24013, 24013, 24029, 24030, 24033, 24034, 24037, 24041, 24043, 24043, 24046, 24046, 24049, 24052, 24055, 24055, 24062, 24062, 24065, 24067, 24069, 24070, 24072, 24072, 24076, 24076, 24080, 24080, 24085, 24086, 24088, 24088, 24090, 24093, 24102, 24103, 24109, 24110, 24120, 24120, 24125, 24125, 24130, 24130, 24133, 24133, 24140, 24140, 24149, 24149, 24162, 24162, 24178, 24180, 24182, 24182, 24184, 24184, 24187, 24189, 24191, 24191, 24196, 24196, 24198, 24199, 24202, 24202, 24207, 24208, 24211, 24213, 24215, 24215, 24217, 24218, 24220, 24220, 24222, 24223, 24230, 24231, 24237, 24237, 24246, 24248, 24265, 24266, 24275, 24275, 24278, 24278, 24310, 24311, 24314, 24314, 24320, 24320, 24322, 24324, 24330, 24330, 24335, 24335, 24339, 24339, 24341, 24341, 24343, 24344, 24347, 24347, 24351, 24352, 24357, 24359, 24367, 24367, 24369, 24369, 24377, 24378, 24402, 24403, 24405, 24405, 24413, 24413, 24418, 24418, 24420, 24420, 24422, 24422, 24425, 24426, 24428, 24429, 24432, 24433, 24441, 24441, 24443, 24444, 24448, 24449, 24452, 24453, 24456, 24456, 24458, 24459, 24464, 24464, 24466, 24466, 24471, 24472, 24481, 24481, 24490, 24490, 24494, 24494, 24503, 24503, 24509, 24509, 24515, 24515, 24517, 24518, 24524, 24525, 24535, 24537, 24544, 24544, 24551, 24551, 24555, 24555, 24561, 24561, 24565, 24565, 24571, 24571, 24573, 24573, 24575, 24578, 24590, 24590, 24594, 24594, 24596, 24598, 24604, 24605, 24608, 24608, 24613, 24613, 24615, 24616, 24618, 24618, 24623, 24623, 24635, 24635, 24643, 24643, 24651, 24651, 24653, 24653, 24656, 24656, 24658, 24658, 24661, 24661, 24674, 24674, 24676, 24676, 24680, 24681, 24683, 24685, 24687, 24688, 24691, 24691, 24694, 24694, 24700, 24700, 24703, 24703, 24708, 24708, 24713, 24713, 24717, 24717, 24724, 24724, 24735, 24736, 24739, 24739, 24742, 24742, 24744, 24744, 24748, 24748, 24751, 24751, 24754, 24754, 24760, 24760, 24764, 24764, 24773, 24773, 24778, 24779, 24785, 24785, 24789, 24789, 24796, 24796, 24799, 24800, 24806, 24809, 24811, 24811, 24813, 24816, 24819, 24819, 24822, 24822, 24825, 24826, 24833, 24833, 24840, 24841, 24847, 24847, 24858, 24858, 24863, 24863, 24868, 24868, 24871, 24871, 24895, 24895, 24904, 24904, 24908, 24908, 24910, 24910, 24913, 24913, 24917, 24917, 24930, 24930, 24935, 24936, 24944, 24944, 24951, 24951, 24971, 24971, 24974, 24974, 25000, 25000, 25022, 25022, 25026, 25026, 25032, 25032, 25034, 25034, 25042, 25042, 25062, 25062, 25096, 25096, 25098, 25098, 25100, 25106, 25110, 25110, 25112, 25112, 25114, 25114, 25130, 25130, 25134, 25134, 25139, 25140, 25143, 25143, 25151, 25153, 25159, 25159, 25163, 25163, 25165, 25166, 25169, 25172, 25176, 25176, 25179, 25179, 25187, 25187, 25190, 25191, 25193, 25193, 25195, 25200, 25203, 25203, 25206, 25206, 25209, 25209, 25212, 25212, 25214, 25216, 25220, 25220, 25225, 25226, 25233, 25235, 25237, 25240, 25242, 25243, 25248, 25250, 25252, 25253, 25256, 25256, 25259, 25260, 25265, 25265, 25269, 25269, 25273, 25273, 25276, 25277, 25279, 25279, 25282, 25282, 25284, 25289, 25292, 25294, 25296, 25296, 25298, 25300, 25302, 25302, 25304, 25305, 25307, 25308, 25311, 25311, 25314, 25315, 25317, 25321, 25324, 25325, 25327, 25327, 25329, 25329, 25331, 25332, 25335, 25335, 25340, 25343, 25345, 25346, 25351, 25351, 25353, 25353, 25358, 25358, 25361, 25361, 25366, 25366, 25370, 25371, 25373, 25377, 25379, 25381, 25384, 25384, 25386, 25387, 25391, 25391, 25402, 25402, 25405, 25405, 25410, 25410, 25413, 25414, 25417, 25417, 25420, 25424, 25429, 25429, 25438, 25439, 25441, 25443, 25447, 25447, 25454, 25454, 25462, 25463, 25467, 25467, 25472, 25472, 25474, 25474, 25479, 25481, 25484, 25484, 25487, 25488, 25490, 25490, 25494, 25494, 25496, 25496, 25504, 25504, 25506, 25507, 25509, 25509, 25511, 25514, 25523, 25523, 25527, 25528, 25530, 25530, 25545, 25545, 25549, 25549, 25551, 25552, 25554, 25554, 25558, 25558, 25569, 25569, 25571, 25571, 25577, 25578, 25581, 25581, 25588, 25588, 25597, 25597, 25600, 25602, 25605, 25605, 25615, 25616, 25619, 25620, 25628, 25628, 25630, 25630, 25642, 25642, 25644, 25645, 25658, 25658, 25661, 25661, 25668, 25668, 25670, 25672, 25674, 25674, 25684, 25684, 25688, 25688, 25703, 25703, 25705, 25705, 25720, 25721, 25730, 25730, 25733, 25733, 25735, 25735, 25745, 25746, 25749, 25749, 25758, 25758, 25764, 25764, 25769, 25769, 25772, 25774, 25776, 25776, 25781, 25781, 25788, 25788, 25794, 25794, 25797, 25797, 25805, 25806, 25810, 25810, 25822, 25822, 25830, 25830, 25856, 25856, 25874, 25874, 25880, 25880, 25899, 25899, 25903, 25903, 25910, 25910, 25913, 25913, 25915, 25915, 25918, 25919, 25925, 25925, 25928, 25928, 25932, 25932, 25935, 25935, 25937, 25937, 25942, 25942, 25945, 25945, 25947, 25947, 25949, 25950, 25954, 25955, 25958, 25958, 25964, 25964, 25968, 25968, 25970, 25970, 25972, 25972, 25975, 25975, 25991, 25991, 25995, 25996, 26001, 26001, 26007, 26007, 26009, 26009, 26012, 26012, 26015, 26015, 26017, 26017, 26020, 26021, 26023, 26023, 26025, 26025, 26029, 26029, 26031, 26032, 26041, 26041, 26045, 26045, 26049, 26049, 26053, 26053, 26059, 26059, 26063, 26063, 26071, 26071, 26080, 26080, 26082, 26082, 26085, 26089, 26092, 26093, 26097, 26097, 26102, 26103, 26106, 26106, 26114, 26114, 26118, 26118, 26124, 26124, 26126, 26127, 26131, 26132, 26143, 26144, 26149, 26149, 26151, 26152, 26157, 26157, 26159, 26159, 26172, 26172, 26174, 26174, 26179, 26179, 26187, 26188, 26194, 26195, 26197, 26197, 26202, 26202, 26212, 26212, 26214, 26214, 26216, 26216, 26222, 26224, 26228, 26228, 26230, 26230, 26234, 26234, 26238, 26238, 26242, 26242, 26247, 26247, 26257, 26257, 26262, 26263, 26286, 26286, 26292, 26292, 26329, 26329, 26333, 26333, 26352, 26352, 26354, 26356, 26361, 26361, 26364, 26364, 26366, 26368, 26376, 26377, 26379, 26379, 26381, 26381, 26388, 26388, 26391, 26391, 26395, 26395, 26397, 26397, 26399, 26399, 26408, 26408, 26410, 26413, 26415, 26415, 26417, 26417, 26420, 26421, 26426, 26426, 26429, 26429, 26432, 26432, 26434, 26435, 26438, 26438, 26441, 26441, 26446, 26449, 26454, 26454, 26460, 26460, 26463, 26465, 26469, 26469, 26472, 26472, 26477, 26477, 26479, 26480, 26494, 26495, 26497, 26497, 26500, 26500, 26505, 26505, 26512, 26512, 26517, 26517, 26519, 26519, 26522, 26522, 26524, 26525, 26530, 26531, 26538, 26539, 26543, 26543, 26550, 26551, 26564, 26564, 26575, 26580, 26588, 26588, 26590, 26590, 26592, 26592, 26597, 26597, 26604, 26604, 26607, 26607, 26609, 26609, 26611, 26612, 26623, 26623, 26629, 26629, 26631, 26632, 26635, 26635, 26639, 26639, 26641, 26641, 26643, 26643, 26646, 26647, 26657, 26657, 26666, 26666, 26679, 26681, 26684, 26685, 26690, 26691, 26693, 26694, 26696, 26696, 26700, 26700, 26704, 26705, 26707, 26708, 26723, 26723, 26725, 26725, 26728, 26729, 26742, 26742, 26753, 26753, 26757, 26758, 26775, 26775, 26786, 26786, 26790, 26792, 26797, 26797, 26799, 26800, 26803, 26803, 26816, 26816, 26825, 26825, 26827, 26827, 26829, 26829, 26834, 26834, 26837, 26837, 26840, 26840, 26842, 26842, 26848, 26848, 26862, 26862, 26865, 26865, 26869, 26869, 26874, 26874, 26885, 26885, 26893, 26894, 26898, 26898, 26925, 26925, 26928, 26928, 26941, 26941, 26943, 26943, 26964, 26964, 26970, 26970, 26974, 26974, 26999, 26999, 27004, 27004, 27010, 27010, 27014, 27014, 27028, 27028, 27036, 27036, 27048, 27048, 27060, 27060, 27063, 27063, 27088, 27088, 27099, 27099, 27133, 27133, 27146, 27146, 27167, 27167, 27169, 27169, 27178, 27178, 27185, 27185, 27207, 27207, 27225, 27225, 27233, 27233, 27249, 27249, 27264, 27264, 27268, 27268, 27308, 27308, 27424, 27427, 27431, 27431, 27442, 27442, 27450, 27450, 27454, 27454, 27463, 27463, 27465, 27465, 27468, 27468, 27490, 27495, 27498, 27498, 27513, 27513, 27515, 27516, 27523, 27523, 27526, 27526, 27529, 27531, 27542, 27542, 27572, 27573, 27575, 27575, 27583, 27583, 27585, 27585, 27589, 27589, 27595, 27595, 27597, 27597, 27599, 27599, 27602, 27602, 27604, 27607, 27609, 27609, 27611, 27611, 27617, 27617, 27627, 27627, 27631, 27631, 27663, 27663, 27665, 27665, 27667, 27668, 27670, 27670, 27675, 27675, 27679, 27679, 27682, 27682, 27686, 27688, 27694, 27696, 27700, 27700, 27704, 27704, 27712, 27714, 27719, 27719, 27721, 27721, 27728, 27728, 27733, 27733, 27735, 27735, 27739, 27739, 27741, 27745, 27748, 27748, 27754, 27754, 27760, 27760, 27762, 27762, 27769, 27769, 27773, 27774, 27777, 27779, 27784, 27785, 27791, 27791, 27801, 27801, 27803, 27803, 27807, 27807, 27809, 27809, 27812, 27815, 27818, 27819, 27822, 27822, 27827, 27827, 27832, 27833, 27835, 27839, 27844, 27845, 27849, 27850, 27852, 27852, 27861, 27861, 27867, 27867, 27870, 27870, 27873, 27875, 27877, 27877, 27880, 27880, 27882, 27882, 27888, 27888, 27891, 27891, 27893, 27893, 27899, 27901, 27905, 27905, 27915, 27915, 27922, 27922, 27927, 27927, 27931, 27931, 27934, 27934, 27941, 27941, 27946, 27946, 27953, 27954, 27963, 27966, 27969, 27969, 27973, 27975, 27978, 27979, 27982, 27982, 27985, 27985, 27987, 27987, 27993, 27994, 28006, 28006, 28009, 28010, 28014, 28014, 28020, 28020, 28023, 28024, 28034, 28034, 28037, 28037, 28040, 28041, 28044, 28044, 28046, 28046, 28053, 28053, 28059, 28059, 28061, 28061, 28063, 28063, 28065, 28065, 28067, 28068, 28070, 28074, 28079, 28079, 28082, 28082, 28085, 28085, 28088, 28088, 28096, 28096, 28100, 28100, 28102, 28102, 28107, 28108, 28113, 28113, 28118, 28118, 28120, 28120, 28129, 28129, 28132, 28132, 28139, 28140, 28142, 28142, 28145, 28145, 28147, 28147, 28151, 28151, 28153, 28153, 28155, 28155, 28165, 28165, 28170, 28170, 28173, 28173, 28176, 28176, 28180, 28180, 28183, 28183, 28189, 28189, 28192, 28193, 28195, 28196, 28201, 28201, 28205, 28205, 28207, 28207, 28212, 28212, 28216, 28216, 28218, 28218, 28227, 28227, 28237, 28237, 28246, 28246, 28248, 28248, 28251, 28251, 28286, 28287, 28291, 28291, 28293, 28293, 28297, 28297, 28304, 28304, 28316, 28316, 28322, 28322, 28330, 28330, 28335, 28335, 28342, 28342, 28346, 28346, 28353, 28353, 28359, 28359, 28363, 28363, 28369, 28369, 28371, 28372, 28378, 28378, 28382, 28382, 28385, 28385, 28388, 28390, 28392, 28393, 28404, 28404, 28418, 28418, 28422, 28422, 28431, 28431, 28435, 28436, 28448, 28448, 28459, 28459, 28465, 28465, 28467, 28467, 28478, 28478, 28493, 28493, 28504, 28504, 28508, 28508, 28510, 28510, 28518, 28518, 28525, 28526, 28548, 28548, 28552, 28552, 28558, 28558, 28572, 28572, 28577, 28577, 28595, 28595, 28608, 28608, 28626, 28626, 28689, 28689, 28748, 28748, 28779, 28779, 28781, 28781, 28783, 28784, 28789, 28790, 28792, 28792, 28796, 28796, 28798, 28799, 28809, 28810, 28814, 28814, 28818, 28818, 28820, 28821, 28825, 28825, 28844, 28847, 28851, 28851, 28856, 28857, 28860, 28861, 28865, 28867, 28872, 28872, 28888, 28889, 28891, 28891, 28895, 28895, 28900, 28900, 28902, 28903, 28905, 28905, 28907, 28909, 28911, 28911, 28919, 28919, 28921, 28921, 28925, 28925, 28937, 28938, 28949, 28949, 28953, 28954, 28966, 28966, 28976, 28976, 28982, 28982, 29004, 29004, 29006, 29006, 29022, 29022, 29028, 29028, 29031, 29031, 29038, 29038, 29053, 29053, 29060, 29060, 29066, 29066, 29071, 29071, 29076, 29076, 29081, 29081, 29087, 29087, 29100, 29100, 29123, 29123, 29134, 29134, 29141, 29141, 29157, 29157, 29190, 29190, 29226, 29226, 29228, 29228, 29233, 29233, 29237, 29241, 29245, 29245, 29255, 29256, 29260, 29260, 29273, 29273, 29275, 29275, 29279, 29279, 29281, 29282, 29287, 29287, 29289, 29289, 29298, 29298, 29301, 29301, 29305, 29306, 29312, 29313, 29322, 29322, 29356, 29356, 29359, 29359, 29366, 29366, 29369, 29369, 29378, 29378, 29380, 29380, 29384, 29384, 29392, 29392, 29399, 29399, 29401, 29401, 29406, 29406, 29408, 29409, 29420, 29422, 29424, 29425, 29432, 29432, 29436, 29436, 29454, 29454, 29462, 29462, 29467, 29468, 29481, 29483, 29486, 29486, 29492, 29492, 29502, 29503, 29549, 29549, 29572, 29572, 29575, 29575, 29577, 29577, 29579, 29579, 29590, 29590, 29595, 29595, 29609, 29609, 29611, 29611, 29615, 29616, 29618, 29618, 29627, 29627, 29642, 29642, 29645, 29645, 29648, 29648, 29664, 29664, 29677, 29677, 29699, 29699, 29701, 29702, 29705, 29705, 29712, 29712, 29730, 29730, 29747, 29750, 29756, 29756, 29786, 29786, 29790, 29791, 29808, 29808, 29814, 29814, 29827, 29827, 29916, 29916, 29922, 29924, 29926, 29926, 29934, 29934, 29942, 29943, 29956, 29956, 29976, 29976, 29978, 29978, 29980, 29980, 29983, 29983, 29989, 29989, 29992, 29993, 29995, 29995, 29997, 29997, 30000, 30003, 30005, 30005, 30007, 30008, 30011, 30011, 30021, 30021, 30028, 30028, 30031, 30031, 30036, 30036, 30041, 30041, 30044, 30044, 30053, 30054, 30058, 30058, 30068, 30068, 30072, 30072, 30086, 30086, 30095, 30095, 30097, 30097, 30103, 30103, 30105, 30106, 30111, 30111, 30113, 30113, 30116, 30117, 30123, 30123, 30126, 30127, 30130, 30130, 30133, 30133, 30137, 30137, 30140, 30142, 30149, 30149, 30151, 30154, 30162, 30162, 30164, 30165, 30168, 30168, 30171, 30171, 30174, 30174, 30178, 30178, 30186, 30186, 30192, 30192, 30196, 30196, 30201, 30201, 30209, 30209, 30239, 30239, 30244, 30244, 30246, 30246, 30249, 30251, 30260, 30260, 30264, 30264, 30284, 30284, 30307, 30307, 30328, 30328, 30331, 30331, 30333, 30334, 30338, 30338, 30340, 30340, 30342, 30343, 30347, 30347, 30353, 30353, 30358, 30358, 30382, 30382, 30385, 30385, 30399, 30399, 30402, 30402, 30405, 30406, 30408, 30408, 30410, 30410, 30414, 30418, 30420, 30420, 30422, 30424, 30427, 30427, 30431, 30431, 30446, 30447, 30450, 30450, 30452, 30452, 30456, 30456, 30460, 30460, 30462, 30462, 30465, 30465, 30473, 30473, 30475, 30475, 30495, 30496, 30504, 30505, 30511, 30511, 30518, 30519, 30522, 30522, 30524, 30524, 30528, 30529, 30555, 30555, 30561, 30561, 30563, 30563, 30566, 30566, 30571, 30572, 30585, 30585, 30596, 30597, 30606, 30606, 30610, 30610, 30629, 30629, 30631, 30631, 30633, 30634, 30636, 30636, 30643, 30643, 30651, 30651, 30679, 30679, 30683, 30683, 30690, 30691, 30693, 30693, 30697, 30697, 30699, 30699, 30701, 30702, 30707, 30707, 30717, 30719, 30721, 30722, 30732, 30733, 30738, 30738, 30740, 30740, 30742, 30742, 30746, 30746, 30759, 30759, 30768, 30768, 30772, 30772, 30775, 30776, 30782, 30782, 30784, 30784, 30789, 30789, 30802, 30802, 30805, 30805, 30813, 30813, 30827, 30828, 30830, 30830, 30839, 30839, 30844, 30844, 30857, 30857, 30860, 30862, 30865, 30865, 30871, 30872, 30879, 30879, 30887, 30887, 30896, 30897, 30899, 30900, 30910, 30910, 30913, 30913, 30917, 30917, 30922, 30923, 30928, 30928, 30933, 30933, 30952, 30952, 30967, 30967, 30970, 30970, 30977, 30977, 31034, 31034, 31036, 31036, 31038, 31038, 31041, 31041, 31048, 31048, 31062, 31062, 31069, 31071, 31077, 31077, 31080, 31080, 31085, 31085, 31095, 31096, 31105, 31105, 31108, 31108, 31119, 31119, 31161, 31161, 31163, 31163, 31165, 31166, 31168, 31169, 31171, 31171, 31174, 31174, 31177, 31177, 31179, 31179, 31181, 31181, 31185, 31186, 31192, 31192, 31199, 31199, 31204, 31204, 31206, 31207, 31209, 31209, 31215, 31216, 31224, 31224, 31227, 31227, 31229, 31229, 31232, 31232, 31243, 31243, 31245, 31246, 31255, 31255, 31258, 31258, 31264, 31264, 31283, 31283, 31291, 31293, 31295, 31295, 31302, 31302, 31319, 31319, 31348, 31348, 31350, 31351, 31354, 31354, 31359, 31359, 31361, 31361, 31363, 31364, 31373, 31373, 31377, 31378, 31382, 31384, 31388, 31389, 31391, 31391, 31397, 31397, 31423, 31423, 31435, 31435, 31446, 31446, 31449, 31449, 31454, 31456, 31459, 31459, 31461, 31461, 31469, 31469, 31471, 31471, 31481, 31481, 31487, 31487, 31494, 31494, 31499, 31499, 31505, 31505, 31508, 31508, 31515, 31515, 31526, 31526, 31528, 31528, 31532, 31532, 31546, 31546, 31548, 31548, 31561, 31561, 31563, 31563, 31567, 31570, 31572, 31572, 31574, 31574, 31579, 31579, 31607, 31607, 31609, 31609, 31614, 31614, 31616, 31616, 31629, 31629, 31636, 31637, 31639, 31639, 31649, 31649, 31657, 31657, 31661, 31661, 31665, 31665, 31686, 31687, 31699, 31699, 31705, 31705, 31713, 31713, 31726, 31726, 31729, 31729, 31735, 31735, 31751, 31751, 31783, 31783, 31807, 31807, 31821, 31821, 31859, 31859, 31867, 31867, 31869, 31869, 31881, 31881, 31890, 31890, 31893, 31893, 31895, 31896, 31903, 31903, 31908, 31909, 31914, 31914, 31918, 31918, 31921, 31921, 31923, 31923, 31929, 31929, 31934, 31934, 31946, 31946, 31957, 31958, 31961, 31961, 31964, 31964, 31967, 31968, 31983, 31983, 31995, 31995, 32010, 32010, 32032, 32032, 32034, 32034, 32039, 32039, 32043, 32043, 32047, 32047, 32110, 32110, 32321, 32321, 32386, 32386, 32416, 32416, 32418, 32418, 32420, 32420, 32422, 32423, 32426, 32428, 32431, 32431, 32433, 32435, 32437, 32442, 32445, 32445, 32447, 32447, 32451, 32456, 32458, 32458, 32461, 32463, 32465, 32467, 32469, 32469, 32472, 32474, 32476, 32479, 32482, 32483, 32485, 32487, 32489, 32490, 32493, 32493, 32496, 32496, 32499, 32501, 32503, 32504, 32508, 32509, 32511, 32512, 32516, 32518, 32521, 32521, 32526, 32526, 32531, 32534, 32536, 32536, 32538, 32538, 32541, 32541, 32544, 32544, 32552, 32553, 32558, 32558, 32564, 32564, 32568, 32568, 32570, 32570, 32592, 32593, 32597, 32597, 32599, 32599, 32602, 32602, 32610, 32610, 32617, 32618, 32622, 32622, 32626, 32626, 32650, 32650, 32652, 32652, 32654, 32654, 32660, 32660, 32666, 32666, 32670, 32670, 32673, 32673, 32676, 32676, 32697, 32697, 32701, 32701, 32705, 32705, 32709, 32709, 32716, 32716, 32724, 32724, 32728, 32728, 32735, 32736, 32752, 32753, 32763, 32764, 32768, 32769, 32771, 32771, 32773, 32773, 32780, 32781, 32784, 32784, 32789, 32789, 32791, 32793, 32810, 32810, 32819, 32819, 32822, 32822, 32824, 32824, 32827, 32827, 32829, 32829, 32831, 32831, 32834, 32834, 32842, 32844, 32852, 32852, 32856, 32856, 32858, 32858, 32874, 32874, 32899, 32900, 32902, 32903, 32905, 32905, 32907, 32908, 32918, 32918, 32920, 32920, 32922, 32923, 32925, 32925, 32928, 32930, 32932, 32933, 32937, 32938, 32942, 32943, 32946, 32946, 32954, 32954, 32958, 32961, 32963, 32963, 32966, 32966, 32972, 32972, 32974, 32974, 32982, 32982, 32986, 32986, 32988, 32988, 32990, 32990, 32993, 32993, 33007, 33008, 33011, 33011, 33014, 33014, 33016, 33016, 33018, 33018, 33021, 33021, 33026, 33026, 33030, 33030, 33033, 33034, 33039, 33041, 33043, 33043, 33046, 33046, 33050, 33050, 33071, 33071, 33073, 33073, 33080, 33080, 33086, 33086, 33094, 33094, 33098, 33099, 33104, 33105, 33108, 33109, 33125, 33125, 33134, 33134, 33136, 33136, 33145, 33147, 33150, 33152, 33162, 33162, 33167, 33167, 33176, 33176, 33179, 33181, 33192, 33192, 33203, 33203, 33216, 33216, 33218, 33219, 33222, 33222, 33251, 33251, 33258, 33258, 33261, 33261, 33267, 33268, 33275, 33276, 33280, 33280, 33285, 33286, 33292, 33293, 33298, 33298, 33300, 33300, 33308, 33308, 33310, 33311, 33322, 33322, 33324, 33324, 33328, 33329, 33333, 33335, 33337, 33337, 33351, 33351, 33368, 33368, 33391, 33392, 33394, 33395, 33402, 33402, 33406, 33406, 33410, 33410, 33419, 33419, 33421, 33421, 33426, 33426, 33436, 33437, 33445, 33446, 33452, 33453, 33455, 33455, 33457, 33457, 33459, 33459, 33465, 33465, 33469, 33469, 33479, 33479, 33485, 33485, 33487, 33487, 33489, 33489, 33492, 33492, 33495, 33495, 33499, 33499, 33502, 33503, 33509, 33510, 33515, 33515, 33519, 33519, 33521, 33521, 33529, 33529, 33537, 33541, 33550, 33550, 33575, 33576, 33579, 33580, 33589, 33590, 33592, 33593, 33606, 33606, 33609, 33609, 33616, 33616, 33618, 33618, 33620, 33620, 33626, 33626, 33633, 33633, 33635, 33636, 33639, 33639, 33643, 33643, 33647, 33647, 33655, 33655, 33670, 33670, 33673, 33673, 33678, 33678, 33707, 33707, 33713, 33714, 33719, 33719, 33721, 33721, 33725, 33725, 33735, 33735, 33738, 33738, 33740, 33740, 33743, 33743, 33756, 33756, 33760, 33760, 33769, 33769, 33777, 33778, 33796, 33796, 33804, 33806, 33821, 33821, 33828, 33829, 33831, 33832, 33853, 33853, 33879, 33879, 33883, 33883, 33889, 33889, 33891, 33891, 33899, 33900, 33905, 33905, 33909, 33909, 33922, 33922, 33931, 33931, 33945, 33945, 33948, 33948, 33970, 33970, 33976, 33976, 33988, 33988, 33993, 33993, 34001, 34001, 34006, 34006, 34013, 34013, 34015, 34015, 34028, 34028, 34065, 34065, 34067, 34067, 34071, 34071, 34074, 34074, 34081, 34081, 34091, 34092, 34103, 34103, 34108, 34109, 34121, 34122, 34164, 34164, 34174, 34174, 34180, 34180, 34203, 34203, 34218, 34218, 34223, 34223, 34249, 34249, 34255, 34256, 34261, 34261, 34276, 34276, 34281, 34281, 34299, 34299, 34321, 34321, 34360, 34360, 34382, 34385, 34394, 34394, 34398, 34398, 34411, 34411, 34417, 34417, 34425, 34425, 34429, 34430, 34432, 34434, 34442, 34442, 34444, 34444, 34453, 34453, 34460, 34460, 34468, 34468, 34496, 34496, 34502, 34503, 34506, 34507, 34516, 34516, 34521, 34521, 34523, 34523, 34532, 34532, 34542, 34542, 34544, 34544, 34553, 34553, 34558, 34558, 34560, 34560, 34562, 34562, 34578, 34578, 34581, 34581, 34583, 34584, 34588, 34588, 34593, 34593, 34631, 34631, 34633, 34633, 34638, 34638, 34647, 34647, 34676, 34676, 34678, 34678, 34701, 34701, 34719, 34719, 34746, 34746, 34809, 34809, 34837, 34837, 34850, 34850, 34880, 34880, 34885, 34885, 34892, 34893, 34900, 34900, 34903, 34903, 34905, 34905, 34913, 34913, 34915, 34915, 34917, 34917, 34920, 34920, 34923, 34924, 34928, 34928, 34935, 34935, 34945, 34945, 34948, 34948, 34955, 34955, 34957, 34957, 34962, 34962, 34966, 34966, 34972, 34972, 34987, 34987, 34989, 34989, 34993, 34993, 35009, 35010, 35013, 35013, 35028, 35029, 35033, 35033, 35044, 35044, 35059, 35060, 35064, 35065, 35074, 35074, 35088, 35088, 35090, 35090, 35109, 35109, 35114, 35114, 35140, 35140, 35167, 35167, 35199, 35199, 35201, 35201, 35206, 35206, 35265, 35266, 35268, 35270, 35272, 35273, 35282, 35282, 35299, 35299, 35302, 35302, 35328, 35328, 35449, 35449, 35465, 35466, 35475, 35475, 35686, 35686, 35692, 35692, 35745, 35749, 35752, 35753, 35755, 35755, 35757, 35760, 35762, 35763, 35766, 35766, 35768, 35770, 35772, 35777, 35780, 35782, 35784, 35786, 35788, 35789, 35793, 35793, 35797, 35797, 35799, 35799, 35802, 35803, 35805, 35806, 35809, 35811, 35813, 35815, 35819, 35821, 35823, 35823, 35825, 35826, 35828, 35829, 35831, 35832, 35834, 35835, 35837, 35838, 35841, 35841, 35843, 35843, 35845, 35846, 35848, 35848, 35850, 35851, 35853, 35854, 35856, 35856, 35859, 35859, 35863, 35863, 35866, 35866, 35868, 35868, 35874, 35876, 35878, 35878, 35880, 35881, 35884, 35885, 35888, 35889, 35892, 35892, 35895, 35895, 35905, 35905, 35910, 35910, 35916, 35916, 35937, 35938, 35946, 35947, 35961, 35962, 35977, 35977, 35980, 35980, 36125, 36127, 36129, 36145, 36148, 36149, 36151, 36154, 36156, 36156, 36158, 36159, 36161, 36164, 36170, 36172, 36174, 36176, 36180, 36180, 36182, 36182, 36184, 36184, 36186, 36187, 36190, 36190, 36192, 36196, 36198, 36198, 36203, 36203, 36208, 36208, 36212, 36215, 36225, 36225, 36229, 36229, 36234, 36235, 36255, 36255, 36259, 36259, 36275, 36276, 36286, 36286, 36291, 36291, 36299, 36300, 36305, 36305, 36317, 36317, 36319, 36319, 36328, 36328, 36330, 36330, 36335, 36335, 36339, 36339, 36341, 36341, 36346, 36346, 36362, 36362, 36364, 36364, 36367, 36367, 36382, 36382, 36386, 36386, 36393, 36394, 36420, 36420, 36424, 36424, 36427, 36427, 36454, 36454, 36460, 36461, 36466, 36466, 36479, 36479, 36481, 36481, 36487, 36487, 36523, 36524, 36527, 36527, 36530, 36530, 36538, 36538, 36710, 36713, 36716, 36716, 36718, 36720, 36724, 36724, 36731, 36731, 36733, 36733, 36735, 36735, 36739, 36739, 36741, 36742, 36744, 36746, 36752, 36753, 36755, 36755, 36757, 36759, 36761, 36761, 36763, 36764, 36766, 36767, 36771, 36771, 36776, 36777, 36779, 36779, 36784, 36785, 36793, 36793, 36797, 36798, 36801, 36802, 36804, 36805, 36807, 36808, 36814, 36814, 36816, 36817, 36820, 36820, 36824, 36825, 36827, 36831, 36834, 36834, 36842, 36843, 36845, 36845, 36848, 36848, 36855, 36857, 36861, 36861, 36864, 36867, 36870, 36870, 36873, 36874, 36879, 36880, 36882, 36882, 36884, 36884, 36887, 36887, 36890, 36891, 36893, 36896, 36898, 36898, 36910, 36910, 36920, 36920, 36923, 36924, 36926, 36926, 36929, 36930, 36935, 36935, 36941, 36941, 36943, 36943, 36947, 36947, 36951, 36951, 36963, 36963, 36965, 36965, 36973, 36974, 36981, 36981, 36991, 36992, 37009, 37009, 37011, 37011, 37026, 37027, 37030, 37030, 37034, 37034, 37038, 37039, 37041, 37041, 37045, 37045, 37049, 37049, 37051, 37051, 37057, 37057, 37066, 37066, 37070, 37070, 37073, 37073, 37085, 37085, 37089, 37089, 37095, 37096, 37101, 37101, 37108, 37108, 37112, 37112, 37117, 37117, 37122, 37122, 37145, 37145, 37193, 37193, 37195, 37197, 37202, 37202, 37207, 37207, 37210, 37210, 37213, 37214, 37219, 37219, 37221, 37221, 37226, 37226, 37228, 37228, 37230, 37230, 37233, 37233, 37237, 37240, 37247, 37247, 37255, 37255, 37257, 37257, 37259, 37259, 37266, 37266, 37274, 37275, 37319, 37319, 37321, 37322, 37324, 37327, 37329, 37329, 37340, 37340, 37492, 37492, 38024, 38025, 38030, 38030, 38034, 38035, 38041, 38041, 38045, 38050, 38053, 38057, 38062, 38062, 38065, 38065, 38067, 38067, 38069, 38069, 38075, 38075, 38078, 38078, 38080, 38083, 38085, 38086, 38108, 38109, 38113, 38113, 38115, 38115, 38124, 38125, 38128, 38130, 38134, 38134, 38136, 38136, 38138, 38138, 38142, 38142, 38144, 38145, 38148, 38149, 38152, 38152, 38155, 38156, 38160, 38161, 38167, 38167, 38169, 38170, 38177, 38177, 38179, 38182, 38184, 38184, 38189, 38192, 38201, 38201, 38203, 38203, 38208, 38209, 38215, 38215, 38218, 38218, 38221, 38221, 38224, 38225, 38236, 38236, 38243, 38243, 38253, 38253, 38256, 38256, 38262, 38262, 38271, 38271, 38376, 38376, 38378, 38378, 38381, 38384, 38386, 38386, 38388, 38388, 38391, 38395, 38397, 38397, 38400, 38402, 38405, 38405, 38409, 38409, 38414, 38414, 38416, 38417, 38420, 38420, 38428, 38428, 38431, 38431, 38446, 38446, 38450, 38454, 38459, 38459, 38463, 38464, 38468, 38472, 38475, 38477, 38480, 38480, 38485, 38485, 38491, 38491, 38497, 38498, 38500, 38500, 38504, 38506, 38517, 38519, 38533, 38534, 38539, 38539, 38543, 38544, 38548, 38548, 38552, 38553, 38556, 38556, 38567, 38567, 38582, 38582, 38590, 38590, 38592, 38593, 38596, 38599, 38604, 38605, 38607, 38607, 38613, 38613, 38632, 38632, 38634, 38634, 38646, 38647, 38649, 38649, 38654, 38654, 38656, 38656, 38660, 38660, 38663, 38663, 38665, 38665, 38669, 38669, 38675, 38675, 38678, 38678, 38684, 38684, 38686, 38686, 38706, 38706, 38712, 38713, 38738, 38738, 38742, 38742, 38745, 38745, 38747, 38747, 38750, 38750, 38752, 38754, 38761, 38761, 38771, 38772, 38774, 38774, 38795, 38795, 38797, 38797, 38808, 38808, 38816, 38816, 38829, 38829, 38886, 38887, 38889, 38889, 38893, 38893, 38899, 38899, 38901, 38902, 39029, 39031, 39033, 39035, 39037, 39039, 39041, 39042, 39044, 39048, 39050, 39050, 39056, 39057, 39059, 39059, 39062, 39064, 39068, 39069, 39072, 39072, 39076, 39076, 39079, 39079, 39118, 39118, 39128, 39128, 39134, 39135, 39184, 39184, 39269, 39269, 39277, 39282, 39285, 39286, 39290, 39290, 39292, 39292, 39295, 39295, 39297, 39297, 39301, 39302, 39304, 39304, 39307, 39307, 39311, 39311, 39314, 39314, 39318, 39318, 39321, 39321, 39532, 39537, 39539, 39540, 39542, 39542, 39545, 39545, 39547, 39548, 39550, 39550, 39554, 39554, 39556, 39556, 39558, 39559, 39563, 39564, 39567, 39567, 39569, 39569, 39575, 39575, 39578, 39578, 39585, 39585, 39588, 39588, 39592, 39592, 39608, 39608, 39635, 39635, 39640, 39640, 39683, 39683, 39740, 39740, 39745, 39746, 39748, 39748, 39759, 39759, 39764, 39764, 40060, 40060, 40065, 40065, 40077, 40077, 40092, 40092, 40100, 40100, 40120, 40120, 40131, 40131, 40150, 40150, 40158, 40158, 40479, 40479, 40481, 40481, 40483, 40483, 40485, 40486, 40493, 40493, 40495, 40495, 40499, 40499, 40501, 40501, 40509, 40509, 40511, 40511, 40515, 40515, 40517, 40517, 40522, 40522, 40527, 40527, 40548, 40548, 40560, 40560, 40575, 40575, 40595, 40595, 40614, 40614, 40635, 40635, 40644, 40644, 40653, 40654, 40657, 40657, 40660, 40660, 40664, 40664, 40718, 40718, 40723, 40723, 40736, 40736, 40763, 40763, 40784, 40784, 40831, 40831, 40836, 40836, 40843, 40843, 40857, 40858, 40863, 40863
};

// Here we specify particular individual Unicodes to be included (appended at end of selected range)
static final int[] specificUnicodes = {

  // Commonly used codes, add or remove // in next line
  // 0x00A3, 0x00B0, 0x00B5, 0x03A9, 0x20AC, // £ ° µ Ω €

  // Numbers and characters for showing time, change next line to //* to use
/*
    0x002B, 0x002D, 0x002E, 0x0030, 0x0031, 0x0032, 0x0033, 0x0034, // - + . 0 1 2 3 4
    0x0035, 0x0036, 0x0037, 0x0038, 0x0039, 0x003A, 0x0061, 0x006D, // 5 6 7 8 9 : a m
    0x0070,                                                         // p
 //*/

  // More characters for TFT_eSPI test sketches, change next line to //* to use
  /*
    0x0102, 0x0103, 0x0104, 0x0105, 0x0106, 0x0107, 0x010C, 0x010D,
    0x010E, 0x010F, 0x0110, 0x0111, 0x0118, 0x0119, 0x011A, 0x011B,
 
    0x0131, 0x0139, 0x013A, 0x013D, 0x013E, 0x0141, 0x0142, 0x0143,
    0x0144, 0x0147, 0x0148, 0x0150, 0x0151, 0x0152, 0x0153, 0x0154,
    0x0155, 0x0158, 0x0159, 0x015A, 0x015B, 0x015E, 0x015F, 0x0160,
    0x0161, 0x0162, 0x0163, 0x0164, 0x0165, 0x016E, 0x016F, 0x0170,
    0x0171, 0x0178, 0x0179, 0x017A, 0x017B, 0x017C, 0x017D, 0x017E,
    0x0192,
 
    0x02C6, 0x02C7, 0x02D8, 0x02D9, 0x02DA, 0x02DB, 0x02DC, 0x02DD,
    0x03A9, 0x03C0, 0x2013, 0x2014, 0x2018, 0x2019, 0x201A, 0x201C,
    0x201D, 0x201E, 0x2020, 0x2021, 0x2022, 0x2026, 0x2030, 0x2039,
    0x203A, 0x2044, 0x20AC,
 
    0x2122, 0x2202, 0x2206, 0x220F,
 
    0x2211, 0x221A, 0x221E, 0x222B, 0x2248, 0x2260, 0x2264, 0x2265,
    0x25CA,
 
    0xF8FF, 0xFB01, 0xFB02,
  //*/
};

//                       >>>>>>>>>> USER CONFIGURED PARAMETERS END HERE <<<<<<<<<<

////////////////////////////////////////////////////////////////////////////////////////////////

// Variable to hold the inclusive Unicode range (16 bit values only for this sketch)
int firstUnicode = 0;
int lastUnicode  = 0;

PFont myFont;

PrintWriter logOutput;

void setup() {
  logOutput = createWriter("FontFiles/System_Font_List.txt"); 

  size(1000, 800);

  // Print the available fonts to the console as a list:
  String[] fontList = PFont.list();
  printArray(fontList);

  // Save font list to file
  for (int x = 0; x < fontList.length; x++)
  {
    logOutput.print("[" + x + "] ");
    logOutput.println(fontList[x]);
  }
  logOutput.flush(); // Writes the remaining data to the file
  logOutput.close(); // Finishes the file

  // Set the fontName from the array number or the defined fontName
  if (fontNumber >= 0)
  {
    fontName = fontList[fontNumber];
    fontType = "";
  }

  char[]   charset;
  int  index = 0, count = 0;

  int blockCount = unicodeBlocks.length;

  for (int i = 0; i < blockCount; i+=2) {
    firstUnicode = unicodeBlocks[i];
    lastUnicode  = unicodeBlocks[i+1];
    if (lastUnicode < firstUnicode) {
      delay(100);
      System.err.println("ERROR: Bad Unicode range secified, last < first!");
      System.err.print("first in range = 0x" + hex(firstUnicode, 4));
      System.err.println(", last in range  = 0x" + hex(lastUnicode, 4));
      while (true);
    }
    // calculate the number of characters
    count += (lastUnicode - firstUnicode + 1);
  }

  count += specificUnicodes.length;

  println();
  println("=====================");
  println("Creating font file...");
  println("Unicode blocks included     = " + (blockCount/2));
  println("Specific unicodes included  = " + specificUnicodes.length);
  println("Total number of characters  = " + count);

  if (count == 0) {
    delay(100);
    System.err.println("ERROR: No Unicode range or specific codes have been defined!");
    while (true);
  }

  // allocate memory
  charset = new char[count];

  for (int i = 0; i < blockCount; i+=2) {
    firstUnicode = unicodeBlocks[i];
    lastUnicode  =  unicodeBlocks[i+1];

    // loading the range specified
    for (int code = firstUnicode; code <= lastUnicode; code++) {
      charset[index] = Character.toChars(code)[0];
      index++;
    }
  }

  // loading the specific point codes
  for (int i = 0; i < specificUnicodes.length; i++) {
    charset[index] = Character.toChars(specificUnicodes[i])[0];
    index++;
  }

  // Make font smooth (anti-aliased)
  boolean smooth = true;

  // Create the font in memory
  myFont = createFont(fontName+fontType, displayFontSize, smooth, charset);

  // Print characters to the sketch window
  fill(0, 0, 0);
  textFont(myFont);

  // Set the left and top margin
  int margin = displayFontSize;
  translate(margin/2, margin);

  int gapx = displayFontSize*10/8;
  int gapy = displayFontSize*10/8;
  index = 0;
  fill(0);

  textSize(displayFontSize);

  for (int y = 0; y < height-gapy; y += gapy) {
    int x = 0;
    while (x < width) {

      int unicode = charset[index];
      float cwidth = textWidth((char)unicode) + 2;
      if ( (x + cwidth) > (width - gapx) ) break;

      // Draw the glyph to the screen
      text(new String(Character.toChars(unicode)), x, y);

      // Move cursor
      x += cwidth;
      // Increment the counter
      index++;
      if (index >= count) break;
    }
    if (index >= count) break;
  }


  // creating font to save as a file
  PFont    font;

  font = createFont(fontName+fontType, fontSize, smooth, charset);

  println("Created font " + fontName + str(fontSize) + ".vlw");

  // creating file
  try {
    print("Saving to sketch FontFiles folder... ");

    OutputStream output = createOutput("FontFiles/" + fontName + str(fontSize) + ".vlw");
    font.save(output);
    output.close();

    println("OK!");

    delay(100);

    // Open up the FontFiles folder to access the saved file
    String path = sketchPath();
    Desktop.getDesktop().open(new File(path+"/FontFiles"));

    System.err.println("All done! Note: Rectangles are displayed for non-existant characters.");
  }
  catch(IOException e) {
    println("Doh! Failed to create the file");
  }
}
