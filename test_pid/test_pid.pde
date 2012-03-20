

#include <PID_v1.h>
#include <Servo.h>
#include <AFMotor.h>


// Set up pin values for sensors and servo
int frontSensorPin = A1;
int sideSensorPin = A0;
int servoPin = 10;

double side_ref, side_distance, delta_rudder_angle;

const double AGGRESSIVE_K_P = 0.75;
const double CONSERVATIVE_K_P = 0.1;
const double AGGRESSIVE_K_D = 0.2;
const double CONSERVATIVE_K_D = 0;
const double AGGRESSIVE_K_I = 0;
const double CONSERVATIVE_K_I = 0;


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

const double DESIRED_DISTANCE_FROM_WALL_CM = 38.0;
const double MARGIN = 3.0;

// Decreasing servo angle variable
int servoChange = 0;

double find_distance(int sensor_value) {
  double sensor[] = { 
    493, 482, 472, 464, 448,
    437, 426, 416, 414, 403,
    385, 377, 371, 356, 348,
    337, 326, 320, 322, 314,
    307, 303, 299, 291, 286,
    279, 251, 234, 215, 198,
    179, 162, 160 };
  double dist[] = {
    20, 21, 22, 23, 24,
    25, 26, 27, 28, 29,
    30, 31, 32, 33, 34,
    35, 36, 37, 38, 39,
    40, 41, 42, 43, 44,
    45, 50, 55, 60, 65,
    70, 75, 80};
  
  if (sensor_value >= sensor[0]) {
    return dist[0]-1;
  }
  
  for (int i = 0; i < 33-1; i++) {
    if (sensor_value >= sensor[i+1] && sensor_value <= sensor[i
    ]) {
      return (dist[i] + dist[i+1]) / 2;
    }
  }
  return  dist[33-1]+1;
}

void setup() {
  Serial.begin(9600);
  Serial.println("Hello World");
  
  // Setup Servo
  servo.attach(servoPin);
  servo.write(NEUTRAL_RUDDER);
  
  // Set motor speed
  pinMode(1, OUTPUT);
  
  motor.run(FORWARD);
  motor.setSpeed(255);
  
  // init the pid
  side_ref = DESIRED_DISTANCE_FROM_WALL_CM;
  side_distance = side_ref;
  delta_rudder_angle = 0;
  pid.SetOutputLimits(RIGHT_RUDDER_LIMIT - NEUTRAL_RUDDER, LEFT_RUDDER_LIMIT - NEUTRAL_RUDDER);
  pid.SetSampleTime(100);
  
  pid.SetMode(AUTOMATIC);
  
}

int clampServoAngle(int servoAngle) {
  return max(ADJUST_RIGHT_RUDDER,
            min(ADJUST_LEFT_RUDDER, servoAngle));
}

#define NUM_ROLLING_AVG_VALUES 5
int rollingAverage(int new_value) {
  static int values[NUM_ROLLING_AVG_VALUES] = { 0 };
  static int sum = 0;
  
  sum -= values[0];
  for (int i = 1; i < NUM_ROLLING_AVG_VALUES; i++) {
    values[i-1]= values[i];
  }
  values[NUM_ROLLING_AVG_VALUES-1] = new_value;
  sum += new_value;
  
  return sum / NUM_ROLLING_AVG_VALUES;
}

void loop() {
  // Read in sensor values
  int frontSensorValue = analogRead(frontSensorPin);
  int sideSensorValue = analogRead(sideSensorPin);
  
  side_distance = find_distance(sideSensorValue);
  
  if (side_distance > DESIRED_DISTANCE_FROM_WALL_CM - MARGIN
   && side_distance < DESIRED_DISTANCE_FROM_WALL_CM + MARGIN) {
    pid.SetTunings(CONSERVATIVE_K_P, CONSERVATIVE_K_I, CONSERVATIVE_K_D);
  } else {
    pid.SetTunings(AGGRESSIVE_K_P, AGGRESSIVE_K_I, AGGRESSIVE_K_D);
  }
  
  pid.Compute();
  
  // Set servo angle
  if (frontSensorValue > MIN_FRONT_DISTANCE) {
    pid.SetMode(MANUAL);
    servo.write(RIGHT_TURN);
    
    pid.SetMode(AUTOMATIC);
  } else {
    int servoAngle = (int) (NEUTRAL_RUDDER - delta_rudder_angle);      
    servo.write(clampServoAngle(servoAngle));
  }
  if (1) {
    Serial.print("sensor : ");
    Serial.print(sideSensorValue);
    Serial.print(" dist : ");
    Serial.print(side_distance);
    Serial.print(" cm | servoAngle : ");
    Serial.print(NEUTRAL_RUDDER - delta_rudder_angle);
    Serial.print("(");
    Serial.print(delta_rudder_angle);
    Serial.print(") | Kp : ");
    Serial.println(pid.GetKp());    
  }
  delay(50);
}
