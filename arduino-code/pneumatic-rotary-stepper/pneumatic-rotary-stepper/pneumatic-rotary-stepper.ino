#define RELAY1  4
#define RELAY2  7
#define RELAY3  8
#define RELAY4  12

#define PERIOD 250
#define ITERATIONS 8

void setup() {                
  // initialize the digital pins as an output.
  
  pinMode(RELAY1, OUTPUT);  
  pinMode(RELAY2, OUTPUT); 
//  pinMode(RELAY3, OUTPUT); 
//  pinMode(RELAY4, OUTPUT);  
  
}

void loop() {

  moving_right(PERIOD, ITERATIONS);
  moving_left(PERIOD, ITERATIONS);
  
}

void moving_right(int period, int iterations) {

  for (int ii = 0; ii < iterations; ii++) {

    // valve 2
    digitalWrite(RELAY1, HIGH);    // Turns ON Relay on digital pin 4
    digitalWrite(RELAY2, HIGH);    // Turns ON Relay on digital pin 4
    delay(period);               // size of drop in ms
    digitalWrite(RELAY2, LOW);     // Turns OFF Relay on digital pin 4
    delay(period);              // time between 1st and 2nd drops
    
    // valve 3  
    digitalWrite(RELAY1, LOW);     // Turns OFF Relay on digital pin 4
    digitalWrite(RELAY2, HIGH);    // Turns ON Relay on digital pin 4
    delay(period);               // size of drop in ms
    digitalWrite(RELAY2, LOW);     // Turns OFF Relay on digital pin 4
    delay(period);              // time between 1st and 2nd drops
  
  }
  
}

void moving_left(int period, int iterations) {

  for (int ii = 0; ii < iterations; ii++) {

    // valve 3
    digitalWrite(RELAY1, LOW);    // Turns ON Relay on digital pin 4
    digitalWrite(RELAY2, LOW);    // Turns ON Relay on digital pin 4
    delay(period);               // size of drop in ms
    digitalWrite(RELAY2, HIGH);     // Turns OFF Relay on digital pin 4
    delay(period);              // time between 1st and 2nd drops

    // valve 2
    digitalWrite(RELAY1, HIGH);     // Turns OFF Relay on digital pin 4
    digitalWrite(RELAY2, LOW);    // Turns ON Relay on digital pin 4
    delay(period);               // size of drop in ms
    digitalWrite(RELAY2, HIGH);     // Turns OFF Relay on digital pin 4
    delay(period);              // time between 1st and 2nd drops
  
  }
  
}

