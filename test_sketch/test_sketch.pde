#include <Servo.h>

// Set up dummy pin values for now
int frontSensorPin = A0;
int sideSensorPin = A3;
int motorPin = 5;
int servoPin = 10;

Servo servo;

void setup() {
  Serial.begin(9600);
  Serial.println("Hello World");
  pinMode(1, OUTPUT);
  servo.attach(servoPin);

  // Not sure what this does yet
  //servo.setMaximumPulse(2100);
  //servo.setMinimumPulse(900);
}

void loop() {
  // Read in sensor values
  int frontSensorValue = analogRead(frontSensorPin);
  int sideSensorValue = analogRead(sideSensorPin);
  Serial.println(frontSensorValue);
  Serial.println(sideSensorValue);
  delay(1000);
  
  // Set motor speed
  analogWrite(motorPin, 200);

  // Set servo angle
  servo.write(90);
}
