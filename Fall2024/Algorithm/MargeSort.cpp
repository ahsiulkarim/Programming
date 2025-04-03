#include<bits/stdc++.h>
using namespace std;

// Merge function to combine two sorted subarrays into one sorted array
void marge(int ara[], int start, int mid, int end) {
    int i = start;        // Starting index of the first subarray
    int j = mid + 1;      // Starting index of the second subarray
    int combined[1005];   // Temporary array to hold the merged results
    int tempIndex = start; // Index to track the position in the combined array

    // Merge the two subarrays into combined[]
    while (i <= mid && j <= end) {
        if (ara[i] < ara[j]) {        // If the element in the first subarray is smaller
            combined[tempIndex++] = ara[i];
            i++;                      // Move to the next element in the first subarray
        } else {                      // If the element in the second subarray is smaller
            combined[tempIndex++] = ara[j];
            j++;                      // Move to the next element in the second subarray
        }
    }

    // If there are remaining elements in the first subarray, add them to combined[]
    while (i <= mid) {
        combined[tempIndex++] = ara[i];
        i++;
    }

    // If there are remaining elements in the second subarray, add them to combined[]
    while (j <= end) {
        combined[tempIndex++] = ara[j];
        j++;
    }

    // Copy the sorted elements from combined[] back to the original array (ara[])
    for (int i = start; i <= end; i++) {
        ara[i] = combined[i];
    }
}

// Merge Sort function to recursively divide and sort the array
void margeSort(int ara[], int start, int end) {
    // Base condition: If the start index is greater than or equal to the end index, stop
    if (start < end) {
        int mid = (start + end) / 2;  // Find the middle index
        margeSort(ara, start, mid);   // Recursively sort the first half
        margeSort(ara, mid + 1, end); // Recursively sort the second half
        marge(ara, start, mid, end);  // Merge the two sorted halves
    }
}

int main() {
    int n;             // Size of the array
    int ara[1005];     // Input array (size assumed to be <= 1005)
    cout <<"Take value of n: ";
    cin >> n;          // Read the size of the array
    cout << "Enter elements:";
    for (int i = 0; i < n; i++) cin >> ara[i]; // Read the elements of the array

    margeSort(ara, 0, n - 1); // Call the merge sort function on the entire array

    // Print the sorted array
    for (int i = 0; i < n; i++) {
        cout << ara[i] << endl;
    }

    return 0;
}

