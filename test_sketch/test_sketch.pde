#include <Servo.h>
#include <AFMotor.h>

// Set up dummy pin values for now
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
const int MIN_SIDE_DISTANCE = 50;
const int MAX_SIDE_DISTANCE = 200;
const int MIN_FRONT_DISTANCE = 300;
const int STRAIGHT_ANGLE = 75;

void setup() {
  Serial.begin(9600);
  Serial.println("Hello World");
  pinMode(1, OUTPUT);
  servo.attach(servoPin);
  motor.run(FORWARD);

  // Not sure what this does yet
  //servo.setMaximumPulse(2100);
  //servo.setMinimumPulse(900);
}

void setMotorSpeed(int frontSensorValue, int sideSensorValue) {
  if (frontSensorValue < MIN_FRONT_DISTANCE) {
    motor.setSpeed(MIN_MOTOR_SPEED);
  } else {
    motor.setSpeed(MAX_MOTOR_SPEED);
  }
}

void setServoAngle(int frontSensorValue, int sideSensorValue) {
  // Wall in front
  if (frontSensorValue < MIN_FRONT_DISTANCE) {
    servo.write(95);
  // Get the boat straight
  } else {
    if (sideSensorValue > MIN_SIDE_DISTANCE && sideSensorValue < MAX_SIDE_DISTANCE) {
      servo.write(STRAIGHT_ANGLE);
    } else if (sideSensorValue < MIN_SIDE_DISTANCE) {
      servo.write(95);
    } else if (sideSensorValue > MAX_SIDE_DISTANCE) {
      servo.write(85);
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
  setMotorSpeed(frontSensorValue, sideSensorValue);
  
  // Set servo angle
  //setServoAngle(frontSensorValue, sideSensorValue);
  servo.write(90);
}
