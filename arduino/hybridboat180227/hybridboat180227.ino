/*
Onboard controller 
This program runs on the boat
*/

/* Hardware connection*/
/*

Servo motors
PWM output
Pins
D5 
D6 
*/

#include <Wire.h>
#include <Servo.h>

int modeSwitch=0;
int vt_temp = 0;
int at_temp = 0;

Servo myservo1;
Servo myservo2;
int pos1=0;
int pos2=0;
int pos1bac=90;
int pos2bac=90;
String inString="";
char c;

void setup() 
{
  myservo1.attach(5);//the servo control used PWM
  myservo2.attach(6);//the servo control used PWM
  Serial.begin(57600);
} 

void loop() 
{
  while(Serial.available())
  {
    int inChar = Serial.read();
    if ((char)inChar == 'S') {
      do {
        inChar = Serial.read();
        inString += (char)inChar;
      } while (isDigit(inChar));
      pos1=inString.toInt();

      if(pos1>=0&&pos1<=180)
      {
        pos1bac=pos1;
      }
      myservo1.write(pos1);
      inString = "";
    }
    
    if ((char)inChar == 'R') {
      do {
        inChar = Serial.read();
        inString += (char)inChar;
      } while (isDigit(inChar));
      pos2=inString.toInt();
      if(pos2>=0&&pos2<=180)
      {
        pos2bac=pos2;
      }
      myservo2.write(pos2);
      inString = "";
    }
    if((char)inChar=='M'){
    modeSwitch=1-modeSwitch;
    if(modeSwitch==1)//2.4G
    {
      myservo1.detach();
      myservo2.detach();
      pinMode(5,INPUT_PULLUP);
      pinMode(6,INPUT_PULLUP);
      }
      if(modeSwitch==0)//BT
      {
        myservo1.attach(5);
        myservo2.attach(6);      
      }
    }
  }
  inString = "";
  //Change the mode of control
  delay(100);
}
