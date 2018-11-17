#Copyright © 2018 Naturalpoint
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.


# OptiTrack NatNet direct depacketization sample for Python 3.x
#
# Uses the Python NatNetClient.py library to establish a connection (by creating a NatNetClient),
# and receive data via a NatNet connection and decode it using the NatNetClient library.
import pymysql
from NatNetClient import NatNetClient

#global command=''

mcapPosition=(0,0,0)

# This is a callback function that gets connected to the NatNet client and called once per mocap frame.
def receiveNewFrame( frameNumber, markerSetCount, unlabeledMarkersCount, rigidBodyCount, skeletonCount,labeledMarkerCount, timecode, timecodeSub, timestamp, isRecording, trackedModelsChanged ):
	Received=""
	#print( "Received frame", frameNumber )

# This is a callback function that gets connected to the NatNet client. It is called once per rigid body per frame
def receiveRigidBodyFrame( id, position, rotation ):
	db=pymysql.connect("192.168.0.104","root","root","star")
	global mcapPosition
	mcapPosition=position
	print(mcapPosition)
	#database method
	cursor = db.cursor()
	#cursor.execute("SELECT * FROM data8802 WHERE id=1")
	#cursor.execute("INSERT INTO data8802 (Id,D ,xPosition, yPosition) VALUES ('%d','%d','%d', '%d')" %(1,60,mcapPosition[0],mcapPosition[1]))
	cursor.execute("UPDATE data8802 SET xPosition='%d' WHERE Id=1" %(mcapPosition[0]*1000))
	db.commit()
	cursor.execute("UPDATE data8802 SET yPosition='%d' WHERE Id=1" %(mcapPosition[1]*1000))
	db.commit()
	db.close()

# This will create a new NatNet client
streamingClient = NatNetClient()

# Configure the streaming client to call our rigid body handler on the emulator to send data out.
streamingClient.newFrameListener = receiveNewFrame
streamingClient.rigidBodyListener = receiveRigidBodyFrame

# Start up the streaming client now that the callbacks are set up.
# This will run perpetually, and operate on a separate thread.
streamingClient.run()

