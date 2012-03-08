#include <AFMotor.h>
#include <Servo.h>
const int MOTOR_PIN = 1;
const int SERVO_PIN = 10;

AF_DCMotor motor(MOTOR_PIN, MOTOR12_64KHZ);
Servo servo;

const int MAX_MOTOR_SPEED = 255;
const int MIN_MOTOR_SPEED = 90;
const int NEUTRAL_RUDDER = 75;

void setup() {
  motor.run(FORWARD);  
  servo.attach(SERVO_PIN);
}

void loop() {  
  motor.setSpeed(MAX_MOTOR_SPEED);
  servo.write(NEUTRAL_RUDDER);
}
