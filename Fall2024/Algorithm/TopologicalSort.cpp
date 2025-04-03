#include<bits/stdc++.h>
using namespace std;

// Function to perform DFS and find the topological order
void dfs(int node, vector<int> adj[], vector<bool> &visited, stack<int> &stk) {
    visited[node] = true; // Mark the current node as visited

    // Visit all its neighbors
    for (int neighbor : adj[node]) {
        if (!visited[neighbor]) {
            dfs(neighbor, adj, visited, stk); // Recursively visit unvisited neighbors
        }
    }

    // Push the current node to the stack after processing all its neighbors
    stk.push(node);
}

// Function to perform topological sort
vector<int> topologicalSort(int n, vector<int> adj[]) {
    vector<bool> visited(n, false); // To track visited nodes
    stack<int> stk;                // To store the topological order

    // Perform DFS for all nodes
    for (int i = 0; i < n; i++) {
        if (!visited[i]) {
            dfs(i, adj, visited, stk); // Start DFS from unvisited node
        }
    }

    // Extract the topological order from the stack
    vector<int> topoOrder;
    while (!stk.empty()) {
        topoOrder.push_back(stk.top());
        stk.pop();
    }

    return topoOrder;
}

int main() {
    int n, m; // Number of nodes and edges
    cout << "Enter number of nodes:";
    cin >> n;

    cout << "Enter number of edges:";
    cin >> m;

    vector<int> adj[n]; // Adjacency list to represent the graph

    // Input edges
    cout << "input edges:\n";
    for (int i = 0; i < m; i++) {
        int u, v;
        cin >> u >> v;
        adj[u].push_back(v); // Directed edge from u to v
    }

    // Perform topological sort
    vector<int> topoOrder = topologicalSort(n, adj);

    // Print the topological order
    for (int node : topoOrder) {
        cout << node << " ";
    }

    return 0;
}

