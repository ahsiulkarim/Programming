#include<iostream>

using namespace std;

int main(){
 int c,f,l,mid,n,s,array[100];

cout << " Enter number of elements:\n";
cin >> n;

cout << " Enter all " << n << " integers in sorted order:\n";

for(c=0; c<n; c++){
  cin >> array[c];
}

cout << "Enter value to find \n:";
cin >> s;

f = 0;
l = n-1;
mid = (f+l)/2;

while(f<=l){
    if(array[mid]<s){
        f = mid + 1;
    }
    else if(array[mid] == s){
        cout << s << " found at location " << mid+1 << " \n ";
        break;
    }
    else{
        l = mid-1;
    }
     mid = (f+l)/2;
  }
  if(f>l){
    cout << s << " is not found in the array.\n ";
  }
  return 0;
}
