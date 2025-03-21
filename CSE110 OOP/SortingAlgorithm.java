/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.array.main3;

/**
 *
 * @author Computer City
 */
public class SortingAlgorithm {
     int[] data;
 
 public SortingAlgorithm(int[] data){
     this.data=data;
 }
  int min;
 public void selectionSort(){
     for(int j=0; j<data.length-1; j++){
         min=j;
         for(int i=j+1; i<data.length; i++){
             if(data[i]<data[min]){
                 min=i;
             }
         }
         int temp=data[j];
         data[j]=data[min];
         data[min]=temp;
     }
 }
 
 public void print(){
     for(int i=0; i<data.length; i++){
         System.out.print(data[i]+" ");
     }
 }
}
