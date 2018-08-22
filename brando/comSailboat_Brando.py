#import pysql
import time
import serial
import math
import threading

#db=pymysql.connect("10.20.5.11","root","root","star")
#cursor=db.cursor()

ser=serial.Serial("COM6", 57600)

def send():
	while True:
		command=input().encode(encoding='utf-8')
		ser.write(command)
		time.sleep(0.1)
	#command=('R110B').encode(encoding='utf-8')

	
def read():
	while True:
		line = ser.readline()
		if line:
			result = line.strip().decode()
			print(result)
		time.sleep(0.1)

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
t1.setDaemon(False)
t2.setDaemon(False)
t1.start()
t2.start()

	
#db.close()
  
