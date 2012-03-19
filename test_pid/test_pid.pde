
#include <PID_v1.h>
#include <Servo.h>
#include <AFMotor.h>


// Set up pin values for sensors and servo
int frontSensorPin = A0;
int sideSensorPin = A1;
int servoPin = 10;

double side_ref, side_distance, delta_rudder_angle;

const double AGGRESSIVE_K_P = 2, CONSERVATIVE_K_P = 1;
const double AGGRESSIVE_K_D = 0, CONSERVATIVE_K_D = 0.25;
const double AGGRESSIVE_K_I = 0, CONSERVATIVE_K_I = 0.01;

PID pid(
  &side_distance,
  &delta_rudder_angle,
  &side_ref,
  AGGRESSIVE_K_P,
  AGGRESSIVE_K_I,
  AGGRESSIVE_K_D,
  DIRECT
);

// Servo object
Servo servo;

// DC Motor Object
AF_DCMotor motor(1, MOTOR12_64KHZ);

// Constant values like motor speed
const int MAX_MOTOR_SPEED = 255;
const int MIN_MOTOR_SPEED = 90;

const int MIN_SIDE_DISTANCE = 200;
const int MAX_SIDE_DISTANCE = 260;

const int MIN_FRONT_DISTANCE = 170;

const int ADJUST_RIGHT_RUDDER = 63;
const int NEUTRAL_RUDDER = 75;
const int ADJUST_LEFT_RUDDER = 87;

const int RIGHT_TURN = 55;

const int RIGHT_RUDDER_LIMIT = 55;
const int LEFT_RUDDER_LIMIT = 95;

const int DESIRED_DISTANCE_FROM_WALL_CM = 37.5;

// Decreasing servo angle variable
int servoChange = 0;

double find_distance(int sensor_value) {
  return 54.6297 - 0.0836611 * sensor_value;
}

void setup() {
  Serial.begin(9600);
  Serial.println("Hello World");
  
  // Setup Servo
  servo.attach(servoPin);
  servo.write(NEUTRAL_RUDDER);
  
  // Set motor speed
  pinMode(1, OUTPUT);
  motor.setSpeed(100);
  motor.run(FORWARD);
  
  // init the pid
  side_ref = DESIRED_DISTANCE_FROM_WALL_CM;
  side_distance = side_ref;
  delta_rudder_angle = 0;
  pid.SetOutputLimits(RIGHT_RUDDER_LIMIT, LEFT_RUDDER_LIMIT);
  pid.SetMode(AUTOMATIC);
  
  delay(5000); // Startup delay of 5 seconds.
}

void loop() {
  // Read in sensor values
  int frontSensorValue = analogRead(frontSensorPin);
  int sideSensorValue = analogRead(sideSensorPin);
  
  side_distance = find_distance(sideSensorValue);
  
  if (sideSensorValue > MIN_SIDE_DISTANCE &&
      sideSensorValue < MAX_SIDE_DISTANCE) {
    pid.SetTunings(CONSERVATIVE_K_P, CONSERVATIVE_K_I, CONSERVATIVE_K_D);
  } else {
    pid.SetTunings(AGGRESSIVE_K_P, AGGRESSIVE_K_I, AGGRESSIVE_K_D);
  }
  
  pid.Compute();
  
  // Set servo angle
  if (frontSensorValue > MIN_FRONT_DISTANCE) {
    pid.SetMode(MANUAL);
    servo.write(RIGHT_TURN);
    delay(50);
    pid.SetMode(AUTOMATIC);
  } else {
    int servoAngle = (int) (NEUTRAL_RUDDER + delta_rudder_angle);
    servo.write(servoAngle);
  }
}
