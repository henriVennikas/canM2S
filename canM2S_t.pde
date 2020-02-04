/*
* A processing script that receives CAN data from serial port formatted "ID,D0,D1,D2,D3,D4,D5,D6,D7,\n"
* Henri Vennikas 2020
* license: MIT
*/

import processing.serial.*;
import java.util.*;

Serial port;


int w = 3600;                          // window height
int h = 1800;                          // window width
int c = 25;                            // column length, number of rows in one colum 
int a = floor(h/(c*1.1));              // calculate row height to match the amount of rows provided above

String data = null;                    // incoming data from Serial port
String comm = "COM5";                  // COM port that your arduino is connected to
int speed = 115200;                    // serial port baud rate, must match setting on the arduino

ArrayList <msg> msgs;                  // array list for storing and sorting received messages
float col, row, roffs, coffs = 0;      // column and row indexes of data, (c,r)offs - offset for paging to major columns
int f, bl = 0;                         // f - fill, bl - baseline for non zero values
PFont font;


//*********************************************************************************************************//

void setup(){
   msgs = new ArrayList<msg>();              // initialize array list with elements of objects of msg
   size(w, h);                               // window size, modify if necessary
   port = new Serial(this, comm, speed);     // open serial port
   port.bufferUntil('\n');                   // listen serial until newline character appears, probably capturing a message
   font = loadFont("LiberationMono-48.vlw"); // use some font for drawing text
}

//*********************************************************************************************************//

void draw(){
   
  background(255);
  
   for (int x = 0; x<msgs.size(); x++){          // cycle through every message object in array list
    
    for  (int y = 0; y<msgs.get(x).dlc+2; y++){    // cycle through each data byte of the message
      
      f=0;                                       // fill value for coloring message text
      
      coffs = floor(x/25)*a*14;                  // column  offset, for each 20 messages on screen, start a new column
      roffs = floor(x/25)*25;                    // row offset, for each 20 messages start from 1st row
      
      row = 20+(x-roffs)*a*1.1;                  // padding value + multiple of no. message - offset * some more padding
      
      col = 20+y*1.1*a+coffs;                    // padding value + multiple of no. data byte * some padding + column offset

      if (y==7){                // not so fancy method for getting databyte value and assigning it to fill value
        f = msgs.get(x).d7;
      } else if (y==1) {
        f = msgs.get(x).d1;
      } else if (y==2) {
        f = msgs.get(x).d2;
      } else if (y==3) {
        f = msgs.get(x).d3;
      } else if (y==4) {
        f = msgs.get(x).d4;
      } else if (y==5) {
        f = msgs.get(x).d5;
      } else if (y==6) {
        f = msgs.get(x).d6;
      } else if (y==0) {
        f = msgs.get(x).d0;
      }
      
      if (f>0){                  // baseline can be used eg. if necessary to start from some other color than black
        bl = ((255/155)*f)+100;
      } else{
        bl=0;
      }
               
      fill(0, bl, 0);            // draw databyte values
      textFont(font, a*0.6);
      text(hex(f,2), a*2+col+a/2, a*.75+row);
      textAlign(CENTER);
      fill(0,0,0);
           
    }
    
    fill(0, 0, 0); 
    text(hex(msgs.get(x).id,3), a+coffs, a*.75+row); // draw message ID values
    //text(msgs.get(x).dlc, 2.2*a+coffs, a*.75+row); // toggle line comment to enable DLC value after message ID
  }
}



//*********************************************************************************************************//

public void serialEvent (Serial port){
  if (port.available()>0){
    try{
      data = port.readStringUntil('\n'); // read serial until newline character
      
      int dl = data.length(); // integer for data length captured
    
      if ((dl>0)&&(dl<32)){  // eg. if capturing of data starts in the middle of transmission, some gibberish may appear , helps to avoid this happening
        
        String[] sl = data.split(",");              // sl - split line, assign each value to an string array
                 
        int[] tm = new int[11];                    // tm - temporary array with integer values of canmsg fields
          for (int i=0; i < sl.length-1 ; i++){

            if(sl[i]!=null){
              
              tm[i] = unhex(sl[i]);
            }
          }
        
        if((tm[1]>0)&&(tm[1]<9)){  //avoid gibberish
          
          int[] ts = new int[8];  
          
          
          msg tmsg = new msg(tm[0], tm[1], tm[2], tm[3], tm[4], tm[5], tm[6], tm[7], tm[8], tm[9], millis(), null); //temporary msg object for searching arraylist for matches with current id
                 
          int is_id = msgs.indexOf(tmsg);
          
            if(is_id == -1){    // if ID is not present in the arraylist then add the entire message
              msgs.add(tmsg); //(new msg(tm[0], tm[1], tm[2], tm[3], tm[4], tm[5], tm[6], tm[7], tm[8], tm[9])); // why not add tmsg?
 
              Collections.sort(msgs); // sort the arraylist to keep the ID based order

            } else {   // for timing purposes do not check if messages are identical, just overwrite it with timing info if(msgs.get(is_id) != tmsg){ // if the message is identical? 
              tmsg.tf =  tmsg.t-msgs.get(is_id).t; // calculate frequency of message in milliseconds from the previous time
              msgs.set(is_id, tmsg); 
            }
        }
     }
      
    }
    catch (Exception e) {
      System.err.println(e.toString());
    }
  }
}
