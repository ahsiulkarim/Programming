/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.array.mavenproject1;

import java.util.Scanner;

/**
 *
 * @author Computer City
 */
public class Mavenproject1 {

    public static void main(String[] args) {
         Scanner sc=new Scanner(System.in);
         int[][] array1=new int[4][3];
         System.out.println("The first Matrix is:");
         for(int i=0; i<4; i++){
             for(int j=0; j<3; j++){
                 array1[i][j]=sc.nextInt();
             }
         }
         System.out.println("The second Matrix is:");
         int[][] array2=new int[3][3];
         
         for(int i=0; i<3; i++){
             for(int j=0; j<3; j++){
                 array2[i][j]=sc.nextInt();
             }
         }
         
         System.out.println("The third Matrix is:");
     int[][] array3= new int[3][3];
           for(int i=0; i<3; i++){
             for(int j=0; j<3; j++){
                 array3[i][j]=sc.nextInt();
             }
         }
           
      System.out.println("The fourth Matrix is:");
     int[][] array4= new int[3][3];
           for(int i=0; i<3; i++){
             for(int j=0; j<3; j++){
                 array4[i][j]=sc.nextInt();
             }
         }   
            
         MatrixOperation matrixoperation=new MatrixOperation(array1,array2,array3,array4);
         System.out.println("The value of addition:");
         matrixoperation.additon();
         matrixoperation.printAddition();
         System.out.println("\nThe value of subtraction:");
         matrixoperation.subtraction();
         matrixoperation.printSubtraction();
         System.out.println("The multiplication is:");
         matrixoperation.multiplication();
         matrixoperation.printMultiplication();
         System.out.println("The transpose Matrix is:");
         matrixoperation.transpose();
         matrixoperation.printTranspose();
    }
}
