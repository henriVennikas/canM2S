import java.util.Comparator;

// msg object - these are stored in the array list. Each object is a set of integer values. dlc and d0-d7 could actually be byte values, but unsigned bytes seem not to be supported.

public class msg implements Comparable<msg>{
 
  private Integer id, dlc, d0, d1, d2, d3, d4, d5, d6, d7;
  

  public msg(Integer id, Integer dlc, Integer d0, Integer d1, 
             Integer d2, Integer d3, Integer d4, Integer d5, 
             Integer d6, Integer d7){
               
    super();
    this.id = id;
    this.dlc = dlc;
    this.d0 = d0;
    this.d1 = d1;
    this.d2 = d2;
    this.d3 = d3;
    this.d4 = d4;
    this.d5 = d5;
    this.d6 = d6;
    this.d7 = d7;
    
  }
  
  @Override
  public boolean equals(Object msg){
   return(this.id.equals(((msg)msg).id));  
  }
   
  public Integer getmsgid() {
    return id;
  }
  
  public void setmsgid(Integer id) {
    this.id = id;
  }
  
  //@Override
    public int compareTo(msg m) {
      Integer thisid = id; 
      Integer cmprid = ((msg)m).getmsgid();
      return thisid.compareTo(cmprid);
    }
}
