#include<iostream>

using namespace std;
   int n;
   int dp[1000];
int fib(int n){
 if(n<=1){
    return 1;
 }

 if(n==2){
    return 2;
 }
  if(dp[n]!= 0){
    return dp[n];
  }
 return  dp[n] = fib(n-1)+fib(n-2);

}

int main(){

   cout << "Enter a number:";
   cin>> n;
   for(int i=0; i<n; i++){
    dp[i] = 0;
   }

   int result=fib(n);
   cout<<" The " << n << " th fibnacci number is " << result;
}
