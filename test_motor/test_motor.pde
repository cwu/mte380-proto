#include <AFMotor.h>
const int MOTOR_PIN = 1;

AF_DCMotor motor(MOTOR_PIN, MOTOR12_64KHZ);

const int MAX_MOTOR_SPEED = 255;
const int MIN_MOTOR_SPEED = 90;

void setup() {
  motor.run(FORWARD);  
}

void loop() {  
  motor.setSpeed(MAX_MOTOR_SPEED);
}
