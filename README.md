# CAN Messages to Screen (canM2S)
Is a processing script tested on win10 and [Processing 3.5.4](https://processing.org/)
Note that in order to run the script on your desktop, contaning folder must have the same name as script file.

## Usage
![topology](https://github.com/henriVennikas/canM2S/blob/master/topology.png)

Use an Arduino and Processing to visualize data in a CAN network, might be useful for reverse engineering or just confirming data in a controller area network.

![screenshot](https://github.com/henriVennikas/canM2S/blob/tf/screenshot.gif)
Message ID, data bytes, counter in red and frequency in blue (frequency is average time in milliseconds) 

## Arduino script
Based on the mcp2515 library example. Passes messages from CAN bus to serial bus.


## Processing script
Opens serial port and listens for data.

### Operating logic:
1) Buffer data from serial until new line
2) Split the buffer to array of individual values
3) Create a temporary message object
4) Compare temporary message object to array list of received messages, if not same ID exists in array, then add entire message
6) If message ID is present in array list, then overwrite the message values in array list
7) Sort arraylist by message ID (which is also reflects message priority - more important comes first)

### Draw logic:
1) Create white canvas
2) loop through messages in arraylist to present each data byte and color text according to value
3) by every 20 messages start another column to fit on screen 

### Variables:
a - one of main size constants that sets the size of text and spacing accordingly,..
