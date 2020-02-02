import java.util.Comparator;

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
    
    
  //  public Comparator<msg> msgcmpid = new Comparator<msg>() {

  //  public int compare(msg m1, msg m2) {

  //   int cmprid1 = m1.getmsgid();
  //   int cmpdid2 = m2.getmsgid();

  //   /*For ascending order*/
  //   return cmprid1-cmpdid2;

  //   /*For descending order*/
  //   //rollno2-rollno1;
  //   }};
  
 //    @Override
 //   public int compareTo(msg comparemsg) {
 //       Integer compareid=((msg)comparemsg).getmsgid();
 //       /* For Ascending order*/
 //       return this.id-compareid;

 //       /* For Descending order do like this */
 //       //return compareage-this.studentage;
 //}

}
