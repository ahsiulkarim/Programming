package com.array.mavenproject1;
public class MatrixOperation { 
     int[][]array1;
     int[][]array2;
     int[][]array3;
     int[][]array4;
     
  
     public  MatrixOperation(int[][] array1 ,int[][]array2 ,int[][] array3,int[][]array4){
       this.array1=array1;
       this.array2=array2;
       this.array3=array3;
       this.array4=array4;
    }
      int [][] addition=new int[3][3]; 
     public void additon(){
         for(int i=0; i<3; i++){
             for(int j=0; j<3; j++){
             addition[i][j]=array2[i][j]+array3[i][j];
            }     
        }
    }
     
     public void printAddition(){
         for(int i=0; i<3; i++){
             for(int j=0; j<3; j++){
                 System.out.print(addition[i][j]+"\t");
             }
           System.out.println();
         }
     }
     
     int [][] subtraction=new int[3][3]; 
     public void subtraction(){
         for(int i=0; i<3; i++){
             for(int j=0; j<3; j++){
             subtraction[i][j]=array2[i][j]-array3[i][j];
            }     
        }
    }
     
          public void printSubtraction(){
         for(int i=0; i<3; i++){
             for(int j=0; j<3; j++){
                 System.out.print(subtraction[i][j]+"\t");
             }
            System.out.println();
         }
     }
       int[][] mul=new int[4][3];
       
       public void multiplication(){
           for(int i=0; i<4; i++){
               for(int j=0; j<3; j++){
                   int sum=0;
                   for(int k=0; k<3; k++){
                       sum=sum+array1[i][k]*array4[k][j];
                            
                   }
                 mul[i][j]=sum;
               }
           }
       }
  public void printMultiplication(){
      for(int i=0; i<4; i++){
          for(int j=0; j<3; j++){
               System.out.print(mul[i][j]+"\t");             
          }
           System.out.println();
        }
     
    }
  
  int[][] trans=new int[3][3];
  public void transpose(){
      for(int i=0; i<3; i++){
          for(int j=0; j<3; j++){
              trans[i][j]=array4[j][i];
          }
      }
  }
  
  public void printTranspose(){
      for(int i=0; i<3; i++){
          for(int j=0; j<3; j++){
              System.out.print(trans[i][j]+"\t");
          }
          System.out.println();
      }
  }         

   
}
