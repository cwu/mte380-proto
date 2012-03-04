#include <Servo.h>

// Set up dummy pin values for now
int frontSensorPin = A0;
int sideSensorPin = A3;
int motorPin = 5;
int servoPin = 10;

// Servo object
Servo servo;

// Constant values like motor speed
const int MAX_MOTOR_SPEED = 255;
const int MIN_MOTOR_SPEED = 90;
const int MIN_SIDE_DISTANCE = 50;
const int MAX_SIDE_DISTANCE = 200;
const int MIN_FRONT_DISTANCE = 300;
const int STRAIGHT_ANGLE = 90;

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
  
  // Sensor debugging
  /*
  Serial.println(frontSensorValue);
  Serial.println(sideSensorValue);
  Serial.println();
  delay(1000);
  */
  
  // Set motor speed
  if (frontSensorValue < MIN_FRONT_DISTANCE) {
    analogWrite(motorPin, MIN_MOTOR_SPEED);
  else {
    analogWrite(motorPin, MAX_MOTOR_SPEED);
  }
  
  // Set servo angle
  if (sideSensorValue > MIN_SIDE_DISTANCE && sideSensorValue < MAX_SIDE_DISTANCE) {
    servo.write(STRAIGHT_ANGLE);
  } else if (sideSensorValue < MIN_SIDE_DISTANCE) {
    servo.write(95);
  } else if (sideSensorValue > MAX_SIDE_DISTANCE) {
    servo.write(85);
  }
}
