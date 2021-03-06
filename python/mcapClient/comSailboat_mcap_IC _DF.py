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

ser=serial.Serial("COM11", 115200)#For STAr_Server_Ceiling_slim
#ser=serial.Serial("COM10", 115200)#For STAr_Server_OUTSIDE
#ser=serial.Serial("COM8", 115200)#For STAr_Server
#ser=serial.Serial("COM4", 57600)#For Motive PC
#ser=serial.Serial("COM6", 115200)#For sailboat02
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
flagTurnBack=1
flagDownWind=0
distance=0
flagDistance=0
mcapXYZBacX=[]
mcapXYZBacY=[]

def receiveNewFrame( frameNumber, markerSetCount, unlabeledMarkersCount, rigidBodyCount, skeletonCount, labeledMarkerCount, timecode, timecodeSub, timestamp, isRecording, trackedModelsChanged ):
	Received=""
	#print( "Received frame", frameNumber )

def receiveRigidBodyFrame( id, position, rotation ):
	global mcapPosition
	#print(id)
	if id==10:
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
		
		#getCommand=input()
		#command=getCommand.encode(encoding='utf-8')
		#ser.write(command)
		
		#database method for IC
		'''
		cursor = db.cursor()
		cursor.execute("SELECT D FROM data8802 WHERE id=1")
		dataSTAr = cursor.fetchone()
		dir=dataSTAr[0]		
		temp_dir=dataSTAr[0]+0
		dataBaseCommand='D'+str(temp_dir)
		command=dataBaseCommand.encode(encoding='utf-8')
		ser.write(command)
		'''
		
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
		global distance
		global flagDistance
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
			#print(result)
			timeFlag=datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
			with open('record_comSailboat_mcap_IC_DF.txt', 'a') as f:
				f.write(str(timeFlag)+" "+str(getCommand)+ " " +str(getCommandD))
				f.write(" xPosition: "+str(xPosition)+" yPosition: "+str(yPosition))
				f.write(" dataBaseRudder: "+str(rudder)+" dataBaseSail: "+str(sail))
				f.write(" "+str(mcapXYZ))
				f.write(" "+str(getSensor_int))
				f.write(" "+str(distance)+" EOF")
				f.write("\n")
			#with open('record_comSailboat_mcap_Baro.txt','a') as w:
				#w.write(str(timeFlag))
				#w.write(" "+str(mcapXYZ[2])+" "+str(getSensor_int[2]))
				#w.write("\n")
			
		time.sleep(0.01)
		
def auto():
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
	while True:
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
		global mcapPosition
		global mcapXYZ
		global getSensor
		global getSensor_int
		global headingD
		global xPosition
		global yPosition
		print(mcapXYZ)
		xL=-180
		xR=-270
		yU=0
		yD=150
		global flagTurnBack
		global flagDownWind
		global distance
		global flagDistance
		global mcapXYZBacX
		global mcapXYZBacY
		headingL=50
		headingR=345#360 345 WITH THE PID 2.5
		IMU=getSensor_int[5]
		Baro=getSensor_int[2]
		setPoint=getSensor_int[4]	
		
		if flagDistance<10:
			mcapXYZBacX.append(mcapXYZ[0])
			#print(mcapXYZBacX)
			mcapXYZBacY.append(mcapXYZ[1])
			flagDistance=1+flagDistance
		if flagDistance>9:
			#print(len(mcapXYZBacX),flagDistance)
			tempDistance=math.sqrt(((mcapXYZBacX[0]-mcapXYZBacX[7])*10)**2+((mcapXYZBacY[0]-mcapXYZBacY[7])*10)**2)/10
			distance=tempDistance+distance
			mcapXYZBac=mcapXYZ
			flagDistance=0
			mcapXYZBacX=[]
			mcapXYZBacY=[]
			print(distance)
		
		
		if mcapXYZ[0]>xL and flagDownWind==0:#need to turn right
			headingD=headingR
			flagTurnBack=1
			sendHeading()	
			print("Right")
		if mcapXYZ[0]<xR and flagDownWind==0:#need to turn left
			headingD=headingL
			flagTurnBack=1
			sendHeading()
			print("Left")
		
		if mcapXYZ[1]>yD and flagTurnBack==0:#need to upwind
			if mcapXYZ[0]>0:
				headingD=headingL
			else:
				headingD=headingL
			flagTurnBack=1
			flagDownWind=0
			sendHeading()
			print("Up")
		if mcapXYZ[1]<yU and flagDownWind==0:#mcapXYZ[1]<yU and mcapXYZ[0]<30 and mcapXYZ[0]>xR:#need to downwind
			headingD=230#240
			flagTurnBack=0
			flagDownWind=1
			sendHeading()
			print("Down")
		time.sleep(0.1)


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
  
