#include <Servo.h>

int servoPin = 10;
char buffer[1024];
int length;
int servoAngle;

// Servo object
Servo servo;

void setup() {
  Serial.begin(9600);
  Serial.println("Start Rudder Profiler");
  servo.attach(servoPin);
  length = 0;
  servoAngle = 90;
  
  
  Serial.println("Enter servo angle: ");
}

void loop() {
  if (Serial.available()>0) {
    char c = Serial.read();
    
    if (c == '\n') {
      buffer[length] = '\0';
      Serial.print("Setting servo angle to : ");
      Serial.println(buffer);
      
      int desiredAngle = atoi(buffer);
      if (desiredAngle < 30 || desiredAngle > 180 - 30) {
        Serial.println("Desired angle is out of range. Ignoring.");
      } else {
        servoAngle = desiredAngle;
      }
      
      Serial.println("Enter servo angle: ");
      length = 0;
      buffer[length]='\0';
    } else {
      buffer[length++] = c;
    }
  }
  servo.write(servoAngle);
}

