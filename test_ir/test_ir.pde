int sensorPin = A0;
int sensorPin2 = A1;

const double M = -10;
const double B = 726;

int interpolateDistance(int value, double m, double b) {
  return (int) ((value - b) / m);
}

void setup() {
  Serial.begin(9600);
  Serial.println("Sensor Test");
}

void loop() {
  int value = analogRead(sensorPin);
  int value2 = analogRead(sensorPin2);
  Serial.print("Front Value : ");
  Serial.print(value);
  Serial.print(" | ");
  Serial.println(interpolateDistance(value, M, B));
  
  Serial.print("Side Value : ");
  Serial.print(value2);
  Serial.print(" | ");
  Serial.println(interpolateDistance(value, M, B));

  delay(1500);
}
