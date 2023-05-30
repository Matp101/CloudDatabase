import paho.mqtt.client as mqtt
import json
import mysql.connector
import os

DEBUG = os.environ['DEBUGGING_script']

# MQTT connection
MQTT_USERNAME = os.environ['MQTT_USER']
MQTT_PASSWORD = os.environ['MQTT_PASS']
MQTT_BROKER_ADDRESS = os.environ['MQTT_IP']
MQTT_PORT_NUMBER = os.environ['MQTT_PORT']

SQL_USERNAME = os.environ['SQL_USER']
SQL_PASSWORD = os.environ['SQL_PASS']
SQL_BROKER_ADDRESS = os.environ['SQL_IP']
SQL_PORT_NUMBER = os.environ['SQL_PORT']
SQL_DATABASE = os.environ['SQL_DBNAME']

# MySQL connection
mydb = mysql.connector.connect(
  host=str(SQL_BROKER_ADDRESS),
  port=int(SQL_PORT_NUMBER),
  user=str(SQL_USERNAME),
  password=str(SQL_PASSWORD),
  database=str(SQL_DATABASE)
)

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):
    print("Connected to MQTT with result code "+str(rc))

    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe("daly_bms/#") # '+' works as a wildcard for a single level

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    try:

        #payload = json.loads(msg.payload)
        payload = msg.payload.decode('utf-8')

        # Extract serial number from topic
        sn = msg.topic.split('/')[1]
        session_id = msg.topic.split('/')[2]

        # Check if serial number exists
        mycursor = mydb.cursor()
        mycursor.execute(f"SELECT sn FROM serialnumber WHERE sn='{sn}'")
        sn_exist = mycursor.fetchone()
        if sn_exist is None:
            if DEBUG == 'True': print(f"INSERT INTO serialnumber(sn, name, `k-param`) VALUES ('{sn}', NULL, 0)")
            mycursor.execute(f"INSERT INTO serialnumber(sn, name, `k-param`) VALUES ('{sn}', NULL, 0)")
            mydb.commit()

        # Check if session id exists
        mycursor = mydb.cursor()
        mycursor.execute(f"SELECT session_id FROM `sessionid` WHERE session_id='{session_id}'")
        session_exist = mycursor.fetchone()
        if session_exist is None:
            if DEBUG == 'True' : print(f"INSERT INTO sessionid (session_id, time, name, sn) VALUES ('{session_id}', CURRENT_TIMESTAMP, NULL, '{sn}')")
            mycursor.execute(f"INSERT INTO sessionid (session_id, time, name, sn) VALUES ('{session_id}', CURRENT_TIMESTAMP, NULL, '{sn}')")
            mydb.commit()

        # Insert data
        if DEBUG == 'True' : print(f"INSERT INTO data (id, session, data, time) VALUES (NULL, '{session_id}', '{payload}', CURRENT_TIMESTAMP)")
        mycursor.execute(f"INSERT INTO data (id, session, data, time) VALUES (NULL, '{session_id}', '{payload}', CURRENT_TIMESTAMP)")
        mydb.commit()
        
        print(f"Message received on topic {msg.topic} : {payload}")

    except json.JSONDecodeError:
        print("Received message is not a valid JSON")


client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.username_pw_set(str(MQTT_USERNAME), str(MQTT_PASSWORD)) # if MQTT requires authentication
client.connect(str(MQTT_BROKER_ADDRESS), int(MQTT_PORT_NUMBER)) 
client.loop_forever()
