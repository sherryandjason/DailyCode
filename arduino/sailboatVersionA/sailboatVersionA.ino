/*
Onboard controller 
This program runs on the boat
*/

/* Hardware connection*/
/*
IMU JY901 
IIC communication
JY901    Nano
SDA <---> SDA
SCL <---> SCL

Current Voltage sensor
Analog Read
Pins 
A0 Voltage
A1 Current

Servo motors
PWM output
Pins
D5 Sail
D6 Rudder
*/

#include <Wire.h>
#include <JY901.h>
#include <Servo.h>

#define VT_PIN A0
#define AT_PIN A1
#define WORK_VOLTAGE 5.0

int vt_temp = 0;
int at_temp = 0;
double voltage = 0.0;
double current = 0.0;

Servo myservo1;
Servo myservo2;
int pos1=90;
int pos2=90;
int pos1bac=90;
int pos2bac=90;
String inString="";
char c;

void setup() 
{
  JY901.StartIIC();
  myservo1.attach(5);//the servo control used PWM
  myservo2.attach(6);//the servo control used PWM
  Serial.begin(57600);
  Serial.println("IMU(Degree)/Voltage(V)/Current(A)");
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

      if(pos1>=30&&pos1<=90)
      {
        pos1bac=pos1;
      }
      if((pos1<30&&pos1>0)||(pos1>90&&pos1<360)||pos1==0)
      {
        pos1=pos1bac;
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
      if(pos2>=50&&pos2<=130)
      {
        pos2bac=pos2;
      }
      if((pos2<50&&pos2>0)||(pos2>130&&pos2<360)||pos2==0)
      {
        pos2=pos2bac;
      }
      myservo2.write(pos2);
      inString = "";
    }
  }
  inString = "";
  
  //print and transmit data;
  JY901.GetAngle();
  Serial.print("H");
  Serial.print((int)((float)JY901.stcAngle.Angle[2]/32768*180));
  Serial.print("  ");
  
  vt_temp = analogRead(VT_PIN);
  at_temp = analogRead(AT_PIN);
  voltage = vt_temp * (WORK_VOLTAGE/1023.0) * 5;
  current = at_temp * (WORK_VOLTAGE/1023.0);
  Serial.print("V");Serial.print(voltage);Serial.print("  ");Serial.print("C");Serial.println(current);

  delay(100);
}
