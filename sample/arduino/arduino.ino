
char led_pin = 13;
char serial_recv;
int cds;

void setup(){
  pinMode(led_pin, OUTPUT);
  Serial.begin(9600);
}

void loop(){
  while(Serial.available() > 0){
    serial_recv = Serial.read();
    switch(serial_recv){
    case 'o':
      digitalWrite(led_pin, true);
      break;
    case 'x':
      digitalWrite(led_pin, false);
      break;
    }
  }
  cds = analogRead(0);
  Serial.println(cds);
  delay(100);
}
