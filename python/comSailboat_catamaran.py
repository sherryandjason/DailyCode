import pymysql
import time
import serial
import math
import threading
import datetime

#global command=''
db=pymysql.connect("192.168.0.102","root","root","star")

#f=open('record.txt', 'a')
 
ser=serial.Serial("COM4", 57600)
getSensor="start"
getCommand="starT"
rudder=""
sail=""
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

	
def read():
	while True:
		#database
		cursor = db.cursor()
		cursor.execute("SELECT * FROM data WHERE id=1")
		dataSTAr = cursor.fetchone()
		global rudder
		global sail
		global xPosition
		global yPosition
		rudder=str(dataSTAr[2])
		sail=str(dataSTAr[3])
		xPosition=dataSTAr[4]
		yPosition=dataSTAr[5]
		#Sensor
		global getSensor
		line = ser.readline()
		if line:
			result = line.strip().decode()
			getSensor=result
			print(str(rudder)+ "  " + str(sail))
			print(result)
			timeFlag=datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
			with open('record_comSailboat_catamaran.txt', 'a') as f:
				f.write(str(timeFlag)+" "+str(getCommand))
				f.write(" xPosition: "+str(xPosition)+" yPosition: "+str(yPosition))
				f.write(" dataBaseRudder: "+str(rudder)+" dataBaseSail: "+str(sail))
				f.write(" "+str(getSensor)+" EOF")
				f.write("\n")
		#CHANGE TO SMALL
		time.sleep(0.01)
		
	
		

	
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
#t3=threading.Thread(target=dataBase)
#t4=threading.Thread(target=toRecord)
t1.setDaemon(False)
t2.setDaemon(False)
#t3.setDaemon(False)
#t4.setDaemon(False)
t1.start()
t2.start()
#t3.start()
#t4.start()
#f.close()

	
#db.close()
  
