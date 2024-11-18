#include <iostream>
using namespace std;


int partition(int arr[], int l, int h) {
    int pivot = arr[l];
    int i = l, j = h;

    while (i < j) {
        if (arr[i] <= pivot) {
            i++;
        }
        if (arr[j]<pivot) {
            j--;
        }
        if (i < j) {
            swap(arr[i], arr[j]);
        }
    }

    swap(arr[l], arr[j]);
    return j;
}


void quickSort(int arr[], int l, int h) {
    if (l < h) {
        int j = partition(arr, l, h);
        quickSort(arr, l, j - 1);
        quickSort(arr, j + 1, h);
    }
}


int main() {
    int arr[] ={10,16,20,32,15,45,8,7,9,11} ;
    int n =sizeof(arr);

    cout << "Original array: ";
    for (int i = 0; i < n; i++) {
        cout << arr[i] << " ";
    }
    cout << endl;

    quickSort(arr, 0, n - 1);

    cout << "Sorted array: ";
    for (int i = 0; i < n; i++) {
        cout << arr[i] << " ";
    }

    return 0;
}
