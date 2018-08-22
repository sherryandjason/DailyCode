/*
reConminiSailBot
*/

/* Hardware connection*/
/*
IMU JY901 
IIC communication
JY901    Nano
SDA <---> SDA
SCL <---> SCL

Current Voltage sensor INA219
IIC
A4 <--> SDA
A5 <--> SCL

Servo motors
PWM output
Pins
D6 Sail pos2
D5 Rudder pos1

Wind Direction Sensor
Analog A1
*/

#include <Wire.h>
#include <JY901.h>
#include <Servo.h>
#include <Adafruit_INA219.h>
#include <PID_v1.h>

#define WD_PIN A1

CJY901 JY901I=CJY901();
CJY901 JY901J=CJY901();
CJY901 JY901K=CJY901();
CJY901 JY901L=CJY901();

int modeSwitch=0;
int vt_temp = 0;
int at_temp = 0;
double voltage = 0.0;
double current = 0.0;
int windD=0;

// Sail
int sail_range_min = 30;  // available sail range minimun, vary from boat to boat
int sail_range_max = 130;  // available sail range maximun, vary from boat to boat

//Servo
Servo myservo1;
Servo myservo2;
int pos1=90;
int pos2=90;
int pos1bac=90;
int pos2bac=90;
int rud_range_min = 40;  // available rudder range minimun, vary from boat to boat
int rud_range_max = 120;  // available rudder range maximun, vary from boat to boat
String inString="";
char c;

//Current voltage sensor
Adafruit_INA219 sensor;

//Define Variables we'll be connecting to
double Setpoint, Input, Output;
//Specify the links and initial tuning parameters
PID myPID(&Input, &Output, &Setpoint,1,0,0, DIRECT);

void setup() 
{
  
  JY901.StartIIC(0x50);
  myservo1.attach(6);//the servo control used PWM
  myservo2.attach(5);//the servo control used PWM
  Serial.begin(57600);
  while (!Serial) {
      // will pause nano until serial console opens
      delay(1);
  }
  sensor.begin();
  Setpoint = 100;
  myPID.SetMode(AUTOMATIC);
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

      if(pos1>=30&&pos1<=130)
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
      if(pos2 >= sail_range_min && pos2 <= sail_range_max)
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

  //print servo
  Serial.print(" S"); Serial.print(pos1);
  Serial.print(" R"); Serial.print(pos2);
    
  //print IMU
  JY901.GetAngle(); Serial.print(" H");
  Serial.println((int)((float)JY901.stcAngle.Angle[2]/32768*180));

  int IMU_temp=(int)((float)JY901.stcAngle.Angle[2]/32768*180)+180;
  //IMU_temp=IMU_temp+180;
  
  Serial.println(Input);
  Serial.println(Output);
  
  if(IMU_temp>Setpoint)
  {  // turn right
    Input = 2 * Setpoint - IMU_temp;
    myPID.Compute();
    int Output_temp = 90 - Output;
    if (Output_temp < rud_range_min){
      myservo2.write(rud_range_min);
      } else {
        myservo2.write(Output_temp);
      }
  }
  else{  // turn left
    Input = IMU_temp;
    myPID.Compute();
    int Output_temp = 90 + Output;
    if (Output_temp > rud_range_max){
      myservo2.write(rud_range_max);
      } else {
      myservo2.write(Output_temp);
        }
  }

  /*
  float voltage = 0;
  float current = 0;
  float power = 0;
  voltage = sensor.getBusVoltage_V();//Get Voltage
  current = sensor.getCurrent_mA();//Get Current
  power = voltage * (current/1000); //Convert from mW to W
  Serial.print(" V"); Serial.print(voltage);//V
  Serial.print(" C"); Serial.print(current);//mA
  Serial.print(" P"); Serial.println(power);//W
  */
  
  delay(100);
}
