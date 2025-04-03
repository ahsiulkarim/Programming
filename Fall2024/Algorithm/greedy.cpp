#include <iostream>
#include <vector>
using namespace std;


void bubbleSort(vector<int> &coin) {
    int n = coin.size();
    for (int i = 0; i < n - 1; ++i) {
        for (int j = 0; j < n - i - 1; ++j) {
            if (coin[j] < coin[j + 1]) {
                int temp = coin[j];
                coin[j] = coin[j+1];
                coin[j + 1] = temp;
            }
        }
    }
}


int minimumCoin(vector<int> &coin, int target) {
    bubbleSort(coin);

    int count = 0;
    int remAmount = target;
    int i;

    i = 0;
    while (remAmount != 0 && i < coin.size()) {
        count += remAmount / coin[i];
        remAmount%=coin[i];
        ++i;
    }
  if(remAmount == 0){
    return count;
  }

  else{
    return -1;
  }

}

int main() {
    vector<int> coin = {1 ,5,10,25};

    int target = 63;

    int result = minimumCoin(coin, target);

    if (result != -1) {
        cout << "Minimum number of coins required: " << result << endl;
    } else {
        cout << "The target cannot be achieved with the given coins." << endl;
    }

    return 0;
}


