#include <Servo.h>

/* ========= Servo setup =========== */
Servo servoFoodLid1;
Servo servoFoodLid2;
Servo servoBucketLid;

Servo myServo[3] = {servoFoodLid1, servoFoodLid2, servoBucketLid};
int pos[3] = {0, 0, 0};

#define FOODLID_1 0
#define FOODLID_2 1
#define BUCKETLID 2

#define SERVO_1 11
#define SERVO_2 12
#define SERVO_3 13
/* ================================= */

// imput pin
// 2, 3, 4, 5 => MODE
const int INPUT_PIN[] = {2, 3, 4, 5};
#define MODE_1 2
#define MODE_2 3
#define MODE_3 4
#define MODE_4 5

// output pin
// 6, 7, 8, 9 => RDY || 10 => STA || 11 => FNH
const int OUTPUT_PIN[] = {6, 7, 8, 9, 10, A0};
#define RDY_M1_OPN 6
#define RDY_M2_FD_1 7
#define RDY_M3_FD_2 8
#define RDY_M4_MIX 9
#define STA 10
#define FNH A0

// state of plate box
// 0 =>  Closed || 1 =>  Opened
int state_open = 0;

void setup() {
  for (int i = 0; i < 4; i++) {
    pinMode(INPUT_PIN[i], INPUT);
  }
  for (int i = 0; i < 6; i++) {
    pinMode(OUTPUT_PIN[i], OUTPUT);
    digitalWrite(OUTPUT_PIN[i], LOW);
  }
  myServo[0].attach(SERVO_1);
  myServo[1].attach(SERVO_2);
  myServo[2].attach(SERVO_3);

  Serial.begin(9600);
  Serial.println("Start servo control");
  state_open = 0;
}

void singleTurn90(int index, char side) {
  if (side == 'r') {
    for (pos[index]  ; pos[index] <= 90; pos[index] += 1) {
      myServo[index].write(pos[index]);
      delay(5);
    }
  } else if (side == 'l') {
    for (pos[index]  ; pos[index] >= 0; pos[index] -= 1) {
      myServo[index].write(pos[index]);
      delay(5);
    }
  }
}

void multiTurn90(int index1, int index2, char side) {
  if (side == 'r') {
    pos[index2] = 90;
    for (pos[index1] = 0 ; pos[index1] <= 90; pos[index1] += 1) {
      myServo[index1].write(pos[index1]);
      myServo[index2].write(pos[index2]);
      pos[index2] -= 1;
      delay(5);
    }
  } else if (side == 'l') {
    pos[index2] = 0;
    for (pos[index1] = 90 ; pos[index1] >= 0; pos[index1] -= 1) {
      myServo[index1].write(pos[index1]);
      myServo[index2].write(pos[index2]);
      pos[index2] += 1;
      delay(5);
    }
  }
}

int readPin(int pin) {
  int val = digitalRead(pin);
  return val;
}

void servoControl(int MODE) {
  // servo method
  if (MODE == RDY_M1_OPN) {
    Serial.println("Open the box");
    if (state_open == 1) {
      singleTurn90(BUCKETLID, 'r');
    }
    else if (state_open == 0) {
      singleTurn90(BUCKETLID, 'l');      
    }
    delay(500);
  }
  else if (MODE == RDY_M2_FD_1) {
    Serial.println("1st Food Feeding");
    singleTurn90(FOODLID_1, 'r');
    delay(500);
    singleTurn90(FOODLID_1, 'l');
  }
  else if (MODE == RDY_M3_FD_2) {
    Serial.println("2nd Food Feeding");
    singleTurn90(FOODLID_2, 'l');
    delay(500);
    singleTurn90(FOODLID_2, 'r');
  }
  else if (MODE == RDY_M4_MIX) {
    Serial.println("Mix Food Feeding");
    multiTurn90(FOODLID_1, FOODLID_2, 'r');
    delay(500);
    multiTurn90(FOODLID_1, FOODLID_2, 'l');
  }
  // end servo 
  digitalWrite(MODE, HIGH);           // RDY
  digitalWrite(STA, state_open);      // STATUS
  digitalWrite(FNH, HIGH);            // FNH
  delay(100);
  digitalWrite(FNH, LOW);
  digitalWrite(MODE, LOW);
}

void loop() {
  if (readPin(MODE_1) == 1) {
    state_open = (state_open + 1) % 2;
    servoControl(RDY_M1_OPN);
  }
  else if (readPin(MODE_2) == 1) {
    servoControl(RDY_M2_FD_1);
  }
  else if (readPin(MODE_3) == 1) {
    servoControl(RDY_M3_FD_2);
  }
  else if (readPin(MODE_4) == 1) {
    servoControl(RDY_M4_MIX);
  }
}
