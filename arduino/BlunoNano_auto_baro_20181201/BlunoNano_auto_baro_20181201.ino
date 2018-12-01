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

int mode=0;
int vt_temp = 0;
int at_temp = 0;
double voltage = 0.0;
double current = 0.0;
int windD=0;

//Zero angle
int zero_angle=40; //anti-clock-wise is increasing
int norm_IMU_temp=0;
 
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
double SetpointBac=60;
int rud_range_min = 40;  // available rudder range minimun, vary from boat to boat
int rud_range_max = 120;  // available rudder range maximun, vary from boat to boat
String inString="";
char c;

//Current voltage sensor
Adafruit_INA219 sensor;

//Define Variables we'll be connecting to
double Setpoint, Input, Output;
//Specify the links and initial tuning parameters
PID myPID(&Input, &Output, &Setpoint,0.5,0,0.01, DIRECT);

void setup() 
{
  JY901.StartIIC(0x50);
  myservo1.attach(6);//the servo control used PWM
  myservo2.attach(5);//the servo control used PWM
  Serial.begin(115200);
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

    if ((char)inChar == 'D') {
      do {
        inChar = Serial.read();
        inString += (char)inChar;
      } while (isDigit(inChar));
      int temp_heading=inString.toInt();
      Setpoint=temp_heading;
      SetpointBac=Setpoint;      
      inString = "";
    }

    if ((char)inChar == 'M') {
      do {
        inChar = Serial.read();
        inString += (char)inChar;
      } while (isDigit(inChar));
      int temp_mode=inString.toInt();
      if(temp_mode==9)//2.4G
      {
        myservo1.detach();
        myservo2.detach();
        pinMode(5,INPUT_PULLUP);
        pinMode(6,INPUT_PULLUP);
        mode=9;
      }
      if(temp_mode==0)//BT
      {
        myservo1.attach(5);
        myservo2.attach(6);  
        mode=0;    
      }
      if(temp_mode==1)//Ban sail auto
      {
        mode=1;
      }
      if(temp_mode==2)//Ban rudder auto
      {
        mode=2;
      }
      if(temp_mode==3)//Ban auto
      {
        mode=3;
      }
      inString = "";
    }
  }
  inString = "";
  //Change the mode of control
  
  //print servo
  Serial.print(" S"); Serial.print(pos1);
  Serial.print(" R"); Serial.print(pos2);
  
  JY901.GetPress(); Serial.print(" BP");//barometer
  //Serial.print(JY901.stcPress.lPressure);Serial.print(" BH");//Pa
  Serial.print((int)JY901.stcPress.lAltitude);//mm
  
  //print IMU
  JY901.GetAngle(); Serial.print(" H");
  Serial.print((int)((float)JY901.stcAngle.Angle[2]/32768*180)+180);
  Serial.print(" h"); Serial.print(int(Setpoint));

  int IMU_temp=(int)((float)JY901.stcAngle.Angle[2]/32768*180)+180;

  //Norm the IMU angle for sail
  if(IMU_temp<zero_angle){
    norm_IMU_temp=360-(zero_angle-IMU_temp);
  } else{
    norm_IMU_temp=IMU_temp-zero_angle;
  }
  Serial.print(" HN"); Serial.print(norm_IMU_temp);

  //Current and Voltage
  float voltage = 0;
  float current = 0;
  float power = 0;
  voltage = sensor.getBusVoltage_V();//Get Voltage
  current = sensor.getCurrent_mA();//Get Current
  power = voltage * (current/1000); //Convert from mW to W
  Serial.print(" V"); Serial.print(voltage);//V
  Serial.print(" C"); Serial.print(current);//mA
  Serial.print(" P"); Serial.print(power);//W
  Serial.print(" "); Serial.println(mode);//W
  
  //auto sail
  if(mode!=1 && mode!=3 )//1 - ban sail, 3 - ban all
  {
    if (norm_IMU_temp>0 && norm_IMU_temp<180)
    {
    int dead_angle=90-norm_IMU_temp;
    if(dead_angle<37 && dead_angle>-21)//(dead_angle<37 && dead_angle>-21)
    {
      //myservo1.write(sail_range_max);
      //pos1=sail_range_max;
    } else{
      pos1=sail_range_max-abs(dead_angle)/4;
      myservo1.write(pos1);
    }
    }
    else {
    pos1=abs(norm_IMU_temp-290)/1.7;
    if(pos1<sail_range_min){
      pos1=sail_range_min;
    }
    myservo1.write(pos1); 
    }
  }

  //Auto Rudder
  if(mode!=2 && mode!=3 )//2 - ban rudder, 3 - ban all
  {
    //First condition
  if(Setpoint > 0 && Setpoint < 180)
  { //condition 1, case 1
    if(IMU_temp > Setpoint && IMU_temp < Setpoint + 180)
    {
      Input = 2 * Setpoint - IMU_temp;
      myPID.Compute();
      int Output_temp = 90 - Output;
      if (Output_temp < rud_range_min){
        myservo2.write(rud_range_min);
        pos2=rud_range_min;
      } else {
        myservo2.write(Output_temp);
        pos2=Output_temp;
      }
    }
    //condition 1, case 2
    else {
      if (IMU_temp>0 && IMU_temp < Setpoint+1){
        Input=IMU_temp;
      }else{
        Input=IMU_temp-360;
      }
      myPID.Compute();
      int Output_temp = 90 + Output;
      if (Output_temp > rud_range_max){
        myservo2.write(rud_range_max);
        pos2=rud_range_max;
      } else {
      myservo2.write(Output_temp);
      pos2=Output_temp;
      }
    }
  }
  //Another condition
  if(Setpoint > 179 && Setpoint < 361)
  {
    //condition 2, case 1
    if (IMU_temp<Setpoint && IMU_temp > Setpoint-180+1){
      Input=IMU_temp;
      myPID.Compute();
      int Output_temp = 90 + Output;
      if (Output_temp > rud_range_max){
        myservo2.write(rud_range_max);
        pos2=rud_range_max;
      }else {
        myservo2.write(Output_temp);
        pos2=Output_temp;
      }
    }
    //condition 2, case 2
    else{
      if (IMU_temp > Setpoint-1 && IMU_temp < 361){
        Input = 2 * Setpoint - IMU_temp;
      } else{
        Input = 2 *Setpoint - (IMU_temp+360);
      }
      myPID.Compute();
      int Output_temp = 90 - Output;
      if (Output_temp < rud_range_min){
        myservo2.write(rud_range_min);
        pos2=rud_range_min;
      } else {
        myservo2.write(Output_temp);
        pos2=Output_temp;
      }
    }
  }
  }
  delay(100);
}
