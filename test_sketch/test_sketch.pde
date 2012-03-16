#include <Servo.h>
#include <AFMotor.h>

// Set up pin values for sensors and servo
int frontSensorPin = A0;
int sideSensorPin = A1;
int servoPin = 10;

// Servo object
Servo servo;

// DC Motor Object
AF_DCMotor motor(1, MOTOR12_64KHZ);

// Constant values like motor speed
const int MAX_MOTOR_SPEED = 255;
const int MIN_MOTOR_SPEED = 90;
const int MIN_SIDE_DISTANCE = 230;
const int MAX_SIDE_DISTANCE = 320;
const int MIN_FRONT_DISTANCE = 200;
const int RIGHT_RUDDER = 62;
const int NEUTRAL_RUDDER = 77;
const int LEFT_RUDDER = 88;
const int LEFT_TURN = 95;

// Decreasing servo angle variable
int servoChange = 0;

void setup() {
  Serial.begin(9600);
  Serial.println("Hello World");
  pinMode(1, OUTPUT);
  servo.attach(servoPin);
  motor.run(FORWARD);
}

void setMotorSpeed(int frontSensorValue, int sideSensorValue) {
  if (frontSensorValue > MIN_FRONT_DISTANCE) {
    motor.setSpeed(MIN_MOTOR_SPEED);
  } else {
    motor.setSpeed(MAX_MOTOR_SPEED);
  }
}

void setServoAngle(int frontSensorValue, int sideSensorValue) {
  //servoChange = 0;
  // Wall in front
  if (frontSensorValue > MIN_FRONT_DISTANCE) {
    servo.write(LEFT_TURN);
    delay(50);
    servoChange = 0;
  // Get the boat straight
  } else {
    if (sideSensorValue > MIN_SIDE_DISTANCE && sideSensorValue < MAX_SIDE_DISTANCE) {
      servo.write(NEUTRAL_RUDDER);
      servoChange = 0;
    } else if (sideSensorValue < MIN_SIDE_DISTANCE) {
      if (servoChange < 0) {
        servoChange = 0;
      }
      servo.write(min(RIGHT_RUDDER + servoChange, NEUTRAL_RUDDER));
      servoChange++;
      delay(50);
      if (servoChange > 20) {
        servoChange = 0;
      }
    } else if (sideSensorValue > MAX_SIDE_DISTANCE) {
      if (servoChange > 0) {
        servoChange = 0;
      }
      servo.write(max(LEFT_RUDDER + servoChange, NEUTRAL_RUDDER));
      servoChange--;
      delay(50);
      if (servoChange < -20) {
        servoChange = 0;
      }
    }
  }
}

void loop() {
  // Read in sensor values
  int frontSensorValue = analogRead(frontSensorPin);
  int sideSensorValue = analogRead(sideSensorPin);
  
  // Sensor debugging
  /*
  Serial.println(frontSensorValue);
  //Serial.println(sideSensorValue);
  //Serial.println();
  delay(1000);
  //*/
  
  // Set motor speed
  motor.setSpeed(255);
  //Serial.println(sideSensorValue);
  //delay(250);
  //setMotorSpeed(frontSensorValue, sideSensorValue);
  
  // Set servo angle
  setServoAngle(frontSensorValue, sideSensorValue);
}
