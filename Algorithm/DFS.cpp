#include <iostream>
#include <vector>

using namespace std;

void dfs(int node, const vector<vector<int>>& adjList, vector<bool>& visited) {
    // Mark the current node as visited and print it
    visited[node] = true;
    cout << node << " ";

    // Recur for all the vertices adjacent to this vertex
    for (int neighbor : adjList[node]) {
        if (!visited[neighbor]) {
            dfs(neighbor, adjList, visited);
        }
    }
}
   void addEdge(vector<vector<int>> &adjList, int s, int t){
    adjList[s].push_back(t);
    adjList[t].push_back(s);
 }
int main() {
    int n = 5; // Number of nodes
    vector<vector<int>> adjList(n);

  addEdge(adjList, 0, 1);
  addEdge(adjList, 0, 2);
  addEdge(adjList, 0, 3);
  addEdge(adjList, 2, 4);

    vector<bool> visited(n, false); // Track visited nodes

    cout << "DFS traversal starting from node 0:" << endl;
    dfs(0, adjList, visited);

    return 0;
}
