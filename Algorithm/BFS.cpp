


#include <iostream>
#include <vector>
#include <queue>

using namespace std;

void bfs(int startNode, const vector<vector<int>>& adjList) {
    int n = adjList.size();
    vector<bool> visited(n, false); // Track visited nodes
// 2->3->4
    queue<int> q;
    q.push(startNode);
    visited[startNode] = true;

    while (!q.empty()) {
        int currentNode = q.front();
        q.pop();

        // Process the current node
        cout << currentNode << " ";

        // Visit all unvisited neighbors 2 4
        for (int neighbor : adjList[currentNode]) {
            if (!visited[neighbor]) {
                visited[neighbor] = true;
                q.push(neighbor);
            }
        }
    }
}

int main() {
    int n = 5; // Number of nodes
    vector<vector<int>> adjList(n);

    // Add edges to the adjacency list
    adjList[0] = {1, 2}; // Edges from node 0 to 1 and 2
    adjList[1] = {0, 3, 4}; // Edges from node 1 to 0, 3, and 4
    adjList[2] = {0}; // Edge from node 2 to 0
    adjList[3] = {1}; // Edge from node 3 to 1
    adjList[4] = {1}; // Edge from node 4 to 1

    cout << "BFS traversal starting from node 0:" << endl;
    bfs(0, adjList);

    return 0;
}
