#include<bits/stdc++.h>
using namespace std;

// Macros for colors used in DFS traversal
#define WHITE 0
#define GREY 1
#define BLACK 2

// Graph represented using adjacency lists
vector<int> adj[100005];      // Adjacency list of the original graph
vector<int> transpose[100005]; // Adjacency list of the transposed graph
int col[100005];              // Array to track the colors (visited status) of nodes
stack<int> s;                 // Stack to store the order of nodes after DFS

// First DFS: Process nodes in the original graph and push them to a stack in order of completion
void dfs1(int u) {
    col[u] = GREY;            // Mark the current node as visited (GREY)
    int v;
    for (int i = 0; i < adj[u].size(); i++) {
        v = adj[u][i];        // Traverse all adjacent nodes
        if (col[v] == WHITE) { // If adjacent node is not visited, call DFS on it
            dfs1(v);
        }
    }
    col[u] = BLACK;           // Mark the current node as fully processed (BLACK)
    s.push(u);                // Push the node to the stack
}

// Second DFS: Explore the transposed graph
void dfs2(int u) {
    col[u] = GREY;            // Mark the current node as visited (GREY)
    int v;
    for (int i = 0; i < transpose[u].size(); i++) {
        v = transpose[u][i];  // Traverse all adjacent nodes in the transposed graph
        if (col[v] == WHITE) { // If adjacent node is not visited, call DFS on it
            dfs2(v);
        }
    }
    col[u] = BLACK;           // Mark the current node as fully processed (BLACK)
}

int main() {
    int n, e;                 // `n` is the number of nodes, `e` is the number of edges
    int cnt = 0;              // Counter for the number of SCCs
    cin >> n >> e;            // Input number of nodes and edges
    int u, v;

    // Input edges and build both original and transposed graphs
    for (int i = 0; i < e; i++) {
        scanf("%d %d", &u, &v);
        adj[u].push_back(v);        // Add edge u -> v in original graph
        transpose[v].push_back(u); // Add edge v -> u in transposed graph
    }

    // Initialize all nodes as unvisited in the color array
    for (int i = 1; i <= n; i++) {
        col[i] = WHITE;
    }

    // Perform the first DFS to get the finishing order of nodes
    for (int i = 1; i <= n; i++) {
        if (col[i] == WHITE) { // If node `i` is unvisited, perform DFS from it
            dfs1(i);
        }
    }

    // Reset the color array for the second DFS
    for (int i = 1; i <= n; i++) {
        col[i] = WHITE;
    }

    // Perform the second DFS in the order defined by the stack
    while (!s.empty()) {
        int a = s.top();       // Get the top element from the stack
        s.pop();               // Remove the top element
        if (col[a] == WHITE) { // If the node is unvisited, it starts a new SCC
            cnt++;             // Increment the SCC counter
            dfs2(a);           // Perform DFS on the transposed graph
        }
    }

    // Output the total number of SCCs
    cout << cnt << endl;
}

