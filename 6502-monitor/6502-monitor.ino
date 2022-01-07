const char addr[] = {22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52};
const char dta[] =  {31, 33, 35, 37, 39, 41, 43, 45};
#define CLOCK 2
#define readWrite 3
//unsigned long clockTime = 0;
//unsigned long beginningTime = 0;
unsigned int clockCounter = 0;

void setup() { 
  // put your setup code here, to run once:
  
  for (int i=0; i < 16; i++)
  {
    pinMode(addr[i], INPUT);
  }
  for (int i=0; i < 8; i++)
  {
    pinMode(dta[i], INPUT);
  }
  pinMode(CLOCK, INPUT);
  pinMode(readWrite, INPUT);
  attachInterrupt(digitalPinToInterrupt(CLOCK), onClock, RISING);
  Serial.begin(56700);
}

void onClock()
{
  clockCounter++;
//  clockTime = micros();
  char output[15];
  unsigned int address = 0;
  for (int i=15; i >= 0; i--)
  {
    int bit = digitalRead(addr[i]) ? 1 : 0;
    Serial.print(bit);
    address = (address << 1) + bit;
  }
  
  Serial.print("\t");
  
  unsigned int dat = 0;
  for (int i=7; i >= 0; i--)
  {
    int bit = digitalRead(dta[i]) ? 1 : 0;
    Serial.print(bit);
    dat = (dat << 1) + bit;
  }
  Serial.print('\t');
  sprintf(output, " %04x\t%c\t%02x\t%d\n", address, digitalRead(readWrite)?'r':'W', dat, clockCounter);
  Serial.print(output);// Serial.println(clockTime);
}

void loop() {
  // put your main code here, to run repeatedly:
  

}
