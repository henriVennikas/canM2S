Usage - use an Arduino and Processing to visualize data in a CAN network, might be useful for reverse engineering or just confirming data in a controller area network.


Arduino script: based on the mcp2515 library example. Passes messages from CAN bus to serial bus.


Processing script: opens serial port and listens for data.

Operating logic:
1) Buffer data from serial until new line
2) Split the buffer to individual values array
3) Create a temporary message object
4) Compare temporary message object to array list of received messages, if same ID exists in array, if not, then add entire message
5) If message ID is present in array list, compare data of received message and the one in array list, if equal then discard
6) If message ID is present in array list, and message data not equal, then overwrite the array list values with received values
7) Sort arraylist by message ID (which is also reflects message priority - more important comes first)

Draw logic:
1) Create white canvas
2) loop through messages in arraylist to present each data byte and color text according to value
3) by every 20 messages start another column to fit on screen 

Variables:

a - one of main size constants that sets the size of text and spacing accordingly

