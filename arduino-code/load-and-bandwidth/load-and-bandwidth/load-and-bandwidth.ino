#define RELAY1  4
#define RELAY2  7
#define RELAY3  8
#define RELAY4  12
#define LEFT    false
#define RIGHT   true
#define DELAY   64
#define CYCLES  10

void setup() {

  // initialize the digital pins as an output.
  pinMode(RELAY1, OUTPUT);
  pinMode(RELAY2, OUTPUT);
//  pinMode(RELAY3, OUTPUT);
//  pinMode(RELAY4, OUTPUT);
  
}

void loop() {

  bool last_direction = RIGHT;
  
  for (int i=0; i <= CYCLES; i++){
    last_direction = move_left(last_direction);
  }

  for (int i=0; i <= CYCLES; i++){
    last_direction = move_right(last_direction);
  }
  
}

bool move_right(bool last_direction) {

  digitalWrite(RELAY1, HIGH);   // Valve B/D
  if (last_direction == RIGHT) {
    digitalWrite(RELAY2, HIGH);   // Valve D
    delay(DELAY);
  }
  digitalWrite(RELAY2, LOW);    // Valve B
  delay(DELAY);
  
  digitalWrite(RELAY1, LOW);    // Valve A/C
  digitalWrite(RELAY2, HIGH);   // Valve C
  delay(DELAY);
  digitalWrite(RELAY2, LOW);    // Valve A
  delay(DELAY);

  return RIGHT;

}

bool move_left(bool last_direction) {
  
  digitalWrite(RELAY1, LOW);    // Valve A/C
  if (last_direction == LEFT) {
    digitalWrite(RELAY2, LOW);   // Valve A
    delay(DELAY);
  }
  digitalWrite(RELAY2, HIGH);    // Valve C
  delay(DELAY);
  
  digitalWrite(RELAY1, HIGH);   // Valve B/D
  digitalWrite(RELAY2, LOW);   // Valve B
  delay(DELAY);
  digitalWrite(RELAY2, HIGH);    // Valve D
  delay(DELAY);

  return LEFT;

}
