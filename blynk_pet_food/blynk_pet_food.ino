// Fill-in information from your Blynk Template here
#define BLYNK_TEMPLATE_ID "TMPLvVrxLmD6"
#define BLYNK_DEVICE_NAME "PetFood"
#define BLYNK_AUTH_TOKEN "5l25Z-1qyqOV00XLCxS7_UOqQk7xxb2P"

#define BLYNK_FIRMWARE_VERSION        "0.1.0"
#define BLYNK_PRINT Serial
#define APP_DEBUG
#define USE_NODE_MCU_BOARD


#include "BlynkEdgent.h"
#include <SoftwareSerial.h>

/* == SoftwareSerial setup === */
SoftwareSerial mySerial(5, 16);
/* =========================== */

/* ======= Blynk setup ======= */
char auth[] = BLYNK_AUTH_TOKEN;
char ssid[] = "Wantana-A305";
char pass[] = "18115949";
/* =========================== */

/* ===== Set LED widget ====== */
WidgetLED busy(V9);
WidgetLED opened(V4);
WidgetLED closed(V5);
WidgetLED process(V6);
WidgetLED feeding_1(V7);
WidgetLED feeding_2(V8);
WidgetLED feeding_mix(V10);
/* =========================== */

BlynkTimer timer;

const int COM_OPEN = B00101001;
const int COM_FOOD1 = B01001010;
const int COM_FOOD2 = B01010101;
const int COM_MIX = B01011010;

const int REC_OPEN_OCC_OPN = B00101101;
const int REC_OPEN_OCC_CLS = B00101100;
const int REC_OPEN_OPN = B00101001;
const int REC_OPRN_CLS = B00101000;
const int REC_FOOD1_FED = B01001010;
const int REC_FOOD1_FNH = B01001011;
const int REC_FOOD2_FED = B01010100;
const int REC_FOOD2_FNH = B01010101;
const int REC_MIX_FED = B01011010;
const int REC_MIX_FNH = B01011011;

int state = 0;
int state_send = 0;

// Open the box
BLYNK_WRITE(V0) {
  if (param.asInt() == 1 && state == 0) {
    state = 1;
  }
}

// 1st Food
BLYNK_WRITE(V1) {
  if (param.asInt() == 1 && state == 0) {
    state = 2;
  }
}

// 2nd Food
BLYNK_WRITE(V2) {
  if (param.asInt() == 1 && state == 0) {
    state = 3;
  }
}

// Mix Food
BLYNK_WRITE(V3) {
  if (param.asInt() == 1 && state == 0) {
    state = 4;
  }
}

BLYNK_CONNECTED() {
  Blynk.syncVirtual(V0);
  Blynk.syncVirtual(V1);
  Blynk.syncVirtual(V2);
  Blynk.syncVirtual(V3);
}

void pet_food_control() {
  if (state_send == 0) {
    if (state != 0) {
      state_send = 1;
      busy.on();
      if (state == 1) {
        mySerial.write(COM_OPEN);
        Serial.print("Send :");
        Serial.println(COM_OPEN, 2);
      }
      else if (state == 2) {
        mySerial.write(COM_FOOD1);      
      }
      else if (state == 3) {
        mySerial.write(COM_FOOD2);
      }
      else if (state == 4) {
        mySerial.write(COM_MIX);
      }
    }
    else {
      busy.off();
    }
  }

  if (mySerial.available()) {
    int d_receive = mySerial.read();
    state_send = 0;
    Serial.print("Receive :");
    Serial.println(d_receive, 2);

    if (d_receive == REC_OPEN_OCC_OPN || d_receive == REC_OPEN_OCC_CLS) {
      // off      
      opened.off();
      closed.off();

      // on
      process.on();
      busy.on();
      state = 1;
      state_send = 1;
    }
    else if (d_receive == REC_OPEN_OPN) {
      // off
      closed.off();
      process.off();
      
      // on
      opened.on();

      // reset state
      state = 0;
    }
    else if (d_receive == REC_OPRN_CLS) {
      // off
      opened.off();
      process.off();
      
      // on
      closed.on();

      // reset state
      state = 0;
    }
    else if (d_receive == REC_FOOD1_FED) {
      // on
      feeding_1.on();
      busy.on();
      state = 2;
      state_send = 1;

      // off
    }
    else if (d_receive == REC_FOOD1_FNH) {
      // on
      // off
      feeding_1.off();

      // reset state
      state = 0;
    }
    else if (d_receive == REC_FOOD2_FED) {
      // on
      feeding_2.on();
      busy.on();
      state = 3;
      state_send = 1;
      
      // off
    }
    else if (d_receive == REC_FOOD2_FNH) {
      // on
      // off
      feeding_2.off();


      // reset state
      state = 0;
    }
    else if (d_receive == REC_MIX_FED) {
      // on
      feeding_mix.on();
      busy.on();
      state = 4;
      state_send = 1;

      // off
    }
    else if (d_receive == REC_MIX_FNH) {
      // on
      // off
      feeding_mix.off();

      // reset state
      state = 0;
    }
  }
}

void setup()
{
  Serial.begin(115200);  
  delay(100);

  Blynk.begin(auth, ssid, pass);

  /* ======= init blynk ======= */
  opened.off();
  closed.on();
  process.off();
  feeding_1.off();
  feeding_2.off();
  feeding_mix.off();
  /* ========================== */

  // delay(100);
  mySerial.begin(10000);  
  timer.setInterval(1, pet_food_control);
}

void loop() {
  Blynk.run();
  timer.run();
}

