import pymysql
import time
import serial
import math
import threading
import datetime

#global command=''
db=pymysql.connect("192.168.0.102","root","root","star")

#f=open('record.txt', 'a')
 
ser=serial.Serial("COM8", 57600)
getSensor="start"
getCommand="starT"
getCommandD="starD"
rudder=""
sail=""
headingD=""
xPosition=""
yPosition=""
def send():
	while True:
		global getCommand
		global rudder
		global sail
		
		getCommand=input()
		command=getCommand.encode(encoding='utf-8')
		ser.write(command)
		
		#dataBaseCommand='R'+rudder
		#command=dataBaseCommand.encode(encoding='utf-8')
		#ser.write(command)
		#time.sleep(0.1)
		#dataBaseCommand='S'+sail
		#command=dataBaseCommand.encode(encoding='utf-8')
		#ser.write(command)
		time.sleep(0.1)
		#print(rudder)
		#print("rudder:"+str(rudder)+"   Sail:"+str(sail))
		#f.write("test sentence")
	#command=('R110B').encode(encoding='utf-8')
	
def sendHeading():
	global getCommandD
	global headingD
	getCommandD='D'+str(headingD)
	command=getCommandD.encode(encoding='utf-8')
	ser.write(command)
	time.sleep(0.1)

	
def read():
	while True:		
		global rudder
		global sail
		global xPosition
		global yPosition
		
		#Sensor
		global getSensor
		line = ser.readline()
		if line:
			result = line.strip().decode()
			getSensor=result
			print(str(xPosition)+ "  " + str(yPosition))
			print(result)
			timeFlag=datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
			with open('record_comSailboat_Brando.txt', 'a') as f:
				f.write(str(timeFlag)+" "+str(getCommand)+ " " +str(getCommandD))
				f.write(" xPosition: "+str(xPosition)+" yPosition: "+str(yPosition))
				f.write(" dataBaseRudder: "+str(rudder)+" dataBaseSail: "+str(sail))
				f.write(" "+str(getSensor)+" EOF")
				f.write("\n")
			

		time.sleep(0.01)
		
def auto():
	while True:
		global headingD
		global rudder
		global sail
		global xPosition
		global yPosition
		
		#database
		cursor = db.cursor()
		cursor.execute("SELECT * FROM data WHERE id=1")
		dataSTAr = cursor.fetchone()
		rudder=str(dataSTAr[2])
		sail=str(dataSTAr[3])
		xPosition=dataSTAr[4]
		yPosition=dataSTAr[5]
		
		temp_x=dataSTAr[4]+0
		temp_y=dataSTAr[5]+0
		
		xL=200
		xR=800
		yU=500
		yD=900
		if temp_y > yD:
			headingD=220
			print("YES220")
		if temp_y < yU:
			headingD=60
			print("YES60U")
		if temp_x > xR:
			headingD=330
			print("test330")
		if temp_x < xL:
			headingD=60;
			print("YES60L")
		sendHeading()
		print("pass")
	
	
	
"""
def controlFunction():
	While True:
		cursor.excute("SELECT * FROM data where Id=1")
		data=cursor.fetchone()
		x=data[4]
		y=data[5]
		print(x,y)

"""


t1=threading.Thread(target=send)
t2=threading.Thread(target=read)
t3=threading.Thread(target=auto)
#t4=threading.Thread(target=toRecord)
t1.setDaemon(False)
t2.setDaemon(False)
t3.setDaemon(False)
#t4.setDaemon(False)
t1.start()
t2.start()
t3.start()
#t4.start()
#f.close()

	
#db.close()
  
