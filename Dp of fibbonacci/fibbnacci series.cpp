#include<iostream>

using namespace std;

int n,a,b,c;

int dp[100];

int fib(int n){
   if(n<=1){
      return 1;
   }
   if(n==2){
    return 2;
   }

   if(dp[n]!=0){
    return dp[n];
   }


   return dp[n] = fib(n-1) + fib(n-2);

}

int main(){
  cout<< "Enter a number:";
  cin>> n;

  for( int i = 3; i<=n; i++){
    dp[i] = 0;
  }

  int result = fib(n);

  cout<< " Fibbonacci series is given below:  ";
  cout<< " 1 ";
  cout<< " 2 ";
  for(int i = 3; i<=n; i++){
      cout << "  "<< dp[i];
  }


}


