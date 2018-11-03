import pymysql
import time
import serial
import math
import threading
import datetime
import re #regulization
from NatNetClient import NatNetClient

#global command=''
db=pymysql.connect("192.168.0.104","root","root","star")

#f=open('record.txt', 'a')
 
#ser=serial.Serial("COM4", 57600)#For PC
ser=serial.Serial("COM6", 115200)#For sailboat02
getSensor=(0,0,0,0,0,0,0,0,0,0,0,0,0,0)
getSensor_int=(0,0,0,0,0,0,0,0,0,0,0,0,0,0)
getCommand="starT"
getCommandD="starD"
rudder=""
sail=""
headingD=""
xPosition=""
yPosition=""
mcapPosition=(0,0,0)
mcapXYZ=(0,0,0)

def receiveNewFrame( frameNumber, markerSetCount, unlabeledMarkersCount, rigidBodyCount, skeletonCount, labeledMarkerCount, timecode, timecodeSub, timestamp, isRecording, trackedModelsChanged ):
	Received=""
	#print( "Received frame", frameNumber )

def receiveRigidBodyFrame( id, position, rotation ):
	global mcapPosition
	mcapPosition=position
	#print(mcapPosition)
	#print( "Received frame for rigid body", id )
	#print( "Received frame for rigid body", position )
	#print( "Received frame for rigid body", rotation )

def receivemCap():
	streamingClient = NatNetClient()
	streamingClient.newFrameListener = receiveNewFrame
	streamingClient.rigidBodyListener = receiveRigidBodyFrame
	streamingClient.run()

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
		global mcapPosition
		global mcapXYZ
		#print(mcapPosition)
		
		mcapX=int(mcapPosition[0]*100)
		mcapY=int(mcapPosition[1]*100)
		mcapZ=int(mcapPosition[2]*100)
		mcapXYZ=(mcapX, mcapY, mcapZ)
		#print(mcapXYZ)
		
		#Sensor
		global getSensor
		global getSensor_int
		line = ser.readline()
		if line:
			result = line.strip().decode()
			if len(result)<40:
				continue
			resultBlock=result.split()
			getSensor=re.findall(r'\d+', result)
			getSensor_int=[int(x) for x in getSensor]
			print(getSensor_int)
			#print(xPosition)
			#print(str(xPosition)+ "  " + str(yPosition))
			print(result)
			timeFlag=datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
			with open('record_comSailboat_mcap.txt', 'a') as f:
				f.write(str(timeFlag)+" "+str(getCommand)+ " " +str(getCommandD))
				f.write(" xPosition: "+str(xPosition)+" yPosition: "+str(yPosition))
				f.write(" dataBaseRudder: "+str(rudder)+" dataBaseSail: "+str(sail))
				f.write(" "+str(mcapXYZ))
				f.write(" "+str(getSensor_int)+" EOF")
				f.write("\n")
		time.sleep(0.01)
		
def auto():
	while True:
		global mcapPosition
		global mcapXYZ
		global getSensor
		global getSensor_int
		global headingD
		global xPosition
		global yPosition
		print(mcapXYZ)
		'''
		#database method
		cursor = db.cursor()
		cursor.execute("SELECT * FROM data WHERE id=1")
		dataSTAr = cursor.fetchone()
		xPosition=dataSTAr[4]
		yPosition=dataSTAr[5]		
		temp_x=dataSTAr[4]+0
		temp_y=dataSTAr[5]+0
		'''
		#As calibrated in the mcap. From the motive we can conclude the coordinate of the world in x-z-y. 
		#Then change up from Y to Z, which means the x-axis is the same, the z-axis changes to -y-axis, the y-axis changes to z-axis.
		
		#################
		#               #
		#	4		3	#
		#         		#
		#   X<--0		#108
		#       |  		#
		#	1	|   2	#
		#		Y  		#
		#				#
		########TV#######
		#Set the coordinate is in the left down corner
		#
		#print(mcapXYZ[0]+x0,mcapXYZ[1]+y0)
		
		xL=200
		xR=-200
		yU=-100
		yD=200
		flagTurnBack=1
		headingR=215
		headingL=60
		IMU=getSensor_int[5]
		Baro=getSensor_int[2]
		setPoint=getSensor_int[4]
		#print("setPoint",setPoint)
		#print("IMU",getSensor_int[5])
		#print("Baro",getSensor_int[2])		
		if mcapXYZ[0]>xL:#need to turn right
			headingD=60
			print("Right")
			if mcapXYZ[0]>300 and mcapXYZ[0]<340 and IMU>140:
				headingD=headingR
				print("Right-Come on")
			else:
				headingD=60
				print("Right-Come on-Done")
			
		if mcapXYZ[0]<xR:#need to turn left
			headingD=headingR
			print("Left")
		if mcapXYZ[1]>yD:#need to upwind
			if mcapXYZ[0]>0:
				headingD=60
			else:
				headingD=headingR
			flagTurnBack=1
			print("Up")
		if mcapXYZ[1]<yU and mcapXYZ[0]<abs(xL-50):#need to downwind
			if setPoint==headingR:
				headingD=330
			'''
			elif mcapXYZ[0]:
				if flagTurnBack==1:
					#headingD=220
					#sendHeading()
					flagTurnBack=0
				#time.sleep(0.3)
				headingD=330
			'''
			print("Down")			
		sendHeading()			
		
		'''
		xL=300
		xR=900
		yU=300
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
		'''
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
t3=threading.Thread(target=auto)
#t4=threading.Thread(target=toRecord)
t5=threading.Thread(target=receivemCap)
t1.setDaemon(False)
t2.setDaemon(False)
t3.setDaemon(False)
#t4.setDaemon(False)
t5.setDaemon(False)
t1.start()
t2.start()
t3.start()
#t4.start()
t5.start()
#f.close()

	
#db.close()
  
