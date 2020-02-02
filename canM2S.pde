import processing.serial.*;
import java.util.*;

Serial port;

String data=null;                //old was info
ArrayList <msg> msgs;
msg id_check;
int id_element;
int a = 40;            // size of square, px
float col, row, roffs, coffs = 0;      // column and row indexes of data, (c,r)offs - offset for paging to major columns
int f, bl = 0;         // f - fill, bl - baseline for non zero values
PFont font;
long timestamp;

//*********************************************************************************************************//

void setup(){
   msgs = new ArrayList<msg>();
   
   size(1800, 900);
   
   port = new Serial(this, "COM4", 115200);
   
   port.bufferUntil('\n');

   font = loadFont("LiberationMono-48.vlw");
}

//*********************************************************************************************************//

void draw(){
   
  background(255);
  
   for (int x = 0; x<msgs.size(); x++){
    
    for  (int y = 0; y<msgs.get(x).dlc; y++){
      
      f=0;
      
      coffs = floor(x/20)*a*14;
      roffs = floor(x/20)*20;
      
      row = 20+(x-roffs)*a*1.1;       //*1.15;
      
      col = 20+y*1.1*a+coffs;   //*1.03+a;

      if (y==7){
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
      
      if (f>0){
        bl = ((255/155)*f)+100;
      } else{
        bl=0;
      }
         
      //fill(255, 255, 255);
      //rect(a*2+col,row,a,a);
      
      fill(0, bl, 0);
      textFont(font, a*0.6);
      text(hex(f,2), a*2+col+a/2, a*.75+row);
      textAlign(CENTER);
      fill(0,0,0);
           
    }
    
    fill(0, 0, 0);
    text(hex(msgs.get(x).id,3), a+coffs, a*.75+row);
    //text(msgs.get(x).dlc, 2.2*a+coffs, a*.75+row);
  }
}



//*********************************************************************************************************//

public void serialEvent (Serial port){
  if (port.available()>0){
    try{
      data = port.readStringUntil('\n');
      
      int dl = data.length();
    
      if ((dl>0)&&(dl<32)){  //avoid gibberish
        
        String[] sl = data.split(",");              // sl - split line
                 
        int[] tm = new int[11];                    // tm - temporary array with integer values of canmsg fields
          for (int i=0; i < sl.length-1 ; i++){

            if(sl[i]!=null){
              
              tm[i] = unhex(sl[i]);
            }
          }
        
        if((tm[1]>0)&&(tm[1]<9)){  //avoid gibberish
          
          int[] ts = new int[8];  
          
          
          msg tmsg = new msg(tm[0], tm[1], tm[2], tm[3], tm[4], tm[5], tm[6], tm[7], tm[8], tm[9]); //temporary msg object for searching arraylist for matches with current id
                 
          int is_id = msgs.indexOf(tmsg);
          
            if(is_id==-1){
              msgs.add(new msg(tm[0], tm[1], tm[2], tm[3], tm[4], tm[5], tm[6], tm[7], tm[8], tm[9]));
 
              Collections.sort(msgs);

            } else if(msgs.get(is_id) != tmsg){
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
