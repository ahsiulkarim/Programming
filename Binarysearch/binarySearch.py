def binary_search(arr, value):
    start = 0
    end = len(arr)
    while start < end:
        mid = (start + end) // 2
        if arr[mid] == value:
            return mid +1
        elif arr[mid] < value:
            start = mid + 1
        else:
            end = mid
    return -1

def main():
    arr = [4,2,5,6,8,9,10,1,5,6]
    arr.sort()
    print(arr)
    value = 4

    result =  binary_search(arr,value)

    print(result)



main()
