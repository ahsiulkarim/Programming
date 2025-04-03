#include<iostream>

using namespace std;
int main() {
    int array[100], search, n,c;

    cout << "Enter number of elements in array: ";
    cin >> n;
    cout << "Enter " << n << " integer(s):\n";

    for(int c=0; c<n; c++){
        cin >> array[c];
    }

    cout << "Enter a number to search:\n";
    cin >> search;

    for(int c=0; c<n; c++){
        if(array[c] == search){
            cout << search << " is present at location " << c+1 << " \n";
            break;
        }
    }

    if(c == n){
        cout << search << " isn't present in the array.\n";
    }
    return 0;
}

