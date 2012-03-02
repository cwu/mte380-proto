#include <Servo.h>

  

int sensorPin = A0;
int servo1Pin = 10;

void setup() {
  Serial.begin(9600);
  Serial.println("Hello World");
  pinMode(1, OUTPUT);
  servo.attach(servo1Pin);
  
  //servo.setMaximumPulse(2100);
  //servo.setMinimumPulse(900);
}

void loop() {
  int sensorValue = analogRead(sensorPin);
  Serial.println(sensorValue);
  delay(1000);
  
  servo.write(90);
  Serial.println(sensorValue);
  delay(1000);
  servo.write(91);
  Serial.println(sensorValue);
  delay(1000);
}
