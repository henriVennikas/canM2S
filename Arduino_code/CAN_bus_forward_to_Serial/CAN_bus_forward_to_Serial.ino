// depends on mcp2515 library: https://github.com/autowp/arduino-mcp2515/archive/master.zip 

/*
 * Use desired CAN interface and library as long as the data is passed to serial
 * comma separated in the following order ID,DCL,D0,D1,D2,D3,D4,D5,D6,D7, (note the last comma as well)
 * serial speed must match Processing script serial speed, for automotive use > 115200 seems to work sufficiently
 */

#include <SPI.h>
#include <mcp2515.h>

struct can_frame canMsg;
MCP2515 mcp2515(10);

void setup() {
  Serial.begin(115200);

  SPI.begin();
  
  mcp2515.reset();
  mcp2515.setBitrate(CAN_500KBPS);
  mcp2515.setNormalMode();

}

void loop() {
  
  if (mcp2515.readMessage(&canMsg) == MCP2515::ERROR_OK) {
  
     Serial.print(canMsg.can_id, HEX); // print ID
     Serial.print(","); 
     Serial.print(canMsg.can_dlc, HEX); // print DLC
     Serial.print(",");
      
     for (int i = 0; i<canMsg.can_dlc; i++)  {  // print the data
          
        Serial.print(canMsg.data[i],HEX);
        //if(i<canMsg.can_dlc-1){
          Serial.print(",");
        //}
     }
  
     Serial.println();      
  }

}
