//  Created by Bodmer 24th Jan 2017

// The latest Arduino IDE versions support UTF-8 encoding of Unicode characters
// within sketches:
// https://playground.arduino.cc/Code/UTF-8

/*
  The library expects strings to be in UTF-8 encoded format:
  https://www.fileformat.info/info/unicode/utf8.htm

  Creating varaibles needs to be done with care when using character arrays:
  char c = 'µ';          // Wrong
  char bad[4] = "5µA";   // Wrong
  char good[] = "5µA";   // Good
  String okay = "5µA";   // Good

  This is because UTF-8 characters outside the basic Latin set occupy more than
  1 byte per character! A 16 bit unicode character occupies 3 bytes!

*/

//  The fonts are stored in arrays within the sketch tabs.

//  A processing sketch to create new fonts can be found in the Tools folder of
//  TFT_eSPI
//  https://github.com/Bodmer/TFT_eSPI/tree/master/Tools/Create_Smooth_Font/Create_font

#include "wqyMicroHei16.h"

//====================================================================================
//                                  Libraries
//====================================================================================

#include <TFT_eSPI.h>  // Hardware-specific library

TFT_eSPI tft = TFT_eSPI();  // Invoke custom library

uint16_t bg = TFT_BLACK;
uint16_t fg = TFT_WHITE;

//====================================================================================
//                                    Setup
//====================================================================================
void setup() {
    Serial.begin(115200);  // Used for messages and the C array generator

    Serial.println("Font test!");

    tft.begin();
    tft.setRotation(0);  // portrait

    fg = TFT_WHITE;
    bg = TFT_BLACK;
}

//====================================================================================
//                                    Loop
//====================================================================================
void loop() {
    tft.setTextColor(fg, bg);

    //----------------------------------------------------------------------------
    // Anti-aliased font test

    String test1 =
        "人皆生而平等，\n"
        "享有造物主赋予给他们\n"
        "的不可剥夺的权利，\n"
        "包括生命、自由和\n"
        "追求幸福的权利。";

    // Load a smooth font from SPIFFS
    tft.loadFont(wqyMicroHei16);

    tft.setRotation(0);

    // // Show all characters on screen with 2 second (2000ms) delay between
    // // screens
    // tft.showFont(2000);  // Note: This function moves the cursor position!

    tft.fillScreen(bg);
    tft.setCursor(0, 0);

    tft.println(test1);

    // Remove font parameters from memory to recover RAM
    tft.unloadFont();

    while (1)
        ;
}
//====================================================================================
