#include <Wire.h>
#include<Servo.h>

#define INTERVAL 1;

Servo temServo;
Servo volServo;

int modeSwitch=0;
int temPos=0;
int volPos=0;
String inString="";
char c;
  
void setup() {
  // put your setup code here, to run once:
  temServo.attach(5);
  volServo.attach(6);
  Serial.begin(57600);
}

void loop() {
  // put your main code here, to run repeatedly:
  while(Serial.available())
  {
    //change the angle of temperature
    int inchar=Serial.read();
    if((char)inchar=='T'){
      do{
      inchar=Serial.read();
      inString+=(char)inchar;
    }while (isDigit(inchar));
    temPos=inString.toInt();
    if(temPos>180)
      temPos=180;
    if(temPos<0)
      temPos=0;
    temServo.write(temPos);
    inString="";
    }
    // Change the angle of volecity
    if((char)inchar=='V'){
      do{
      inchar=Serial.read();
      inString+=(char)inchar;
    }while (isDigit(inchar));
    volPos=inString.toInt();
    if(volPos>180)
      volPos=180;
    if(volPos<0)
      volPos=0;
    volServo.write(volPos);
    inString="";
    }
    //Change the mode of control
    if((char)inchar=='M'){
      modeSwitch=1-modeSwitch;
      if(modeSwitch==1)//2.4G
      {
        temServo.detach();
        temServo.detach();
        pinMode(5,INPUT_PULLUP);
        pinMode(6,INPUT_PULLUP);
        //digitalWrite(5,
      }
      if(modeSwitch==0)//BT
      {
        temServo.attach(5);
        volServo.attach(6);      
      }
    }
    //Increase the angle of temperature
    if((char)inchar=='d'){
      temPos=temPos+INTERVAL;
      temServo.write(temPos);
    }
    //decrease the angle of temperature
    if((char)inchar=='a'){
      temPos=temPos-INTERVAL;
      temServo.write(temPos);
    }
    //increase the angle of volecity
    if((char)inchar=='h'){
      volPos=volPos+INTERVAL;
      volServo.write(volPos);
    }
    //decrease the angle of volecity
    if((char)inchar=='f'){
      volPos=volPos-INTERVAL;
      volServo.write(volPos);
    }    
  }
  //Serial.print("temPos:");Serial.print(temPos);Serial.print("; ");
  //Serial.print("volPos:");Serial.print(volPos);Serial.println("");
  Serial.print("temPos:");Serial.print(temServo.read());Serial.print(":");
  Serial.print("volPos:");Serial.print(volServo.read());Serial.println("");
  delay(100);
}
