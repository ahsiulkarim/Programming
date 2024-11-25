#include <bits/stdc++.h>
using namespace std;

vector<int> adj[100005];
int disc[100005], low[100005], parent[100005];
bool visited[100005], ap[100005]; // Tracks visited nodes and articulation points.
int timer = 0;

void dfs(int u) {
    visited[u] = true;
    disc[u] = low[u] = ++timer;
    int children = 0;

    for (int v : adj[u]) {
        if (!visited[v]) {
            children++;
            parent[v] = u;
            dfs(v);
            low[u] = min(low[u], low[v]);

            // Articulation point logic:
            if (parent[u] == -1 && children > 1)
                ap[u] = true;
            if (parent[u] != -1 && low[v] >= disc[u])
                ap[u] = true;
        } else if (v != parent[u]) {
            low[u] = min(low[u], disc[v]);
        }
    }
}

int main() {
    int n, e, u, v;
    cin >> n >> e;

    // Build the graph
    for (int i = 0; i < e; i++) {
        cin >> u >> v;
        adj[u].push_back(v);
        adj[v].push_back(u);
    }

    // Manual initialization instead of memset
    for (int i = 0; i <= n; i++) {
        visited[i] = false;
        ap[i] = false;
        parent[i] = -1;
        disc[i] = 0;
        low[i] = 0;
    }

    // Run DFS for every unvisited node
    for (int i = 1; i <= n; i++) {
        if (!visited[i]) {
            dfs(i);
        }
    }

    // Print articulation points
    cout << "Articulation points:" << endl;
    for (int i = 1; i <= n; i++) {
        if (ap[i]) {
            cout << i << " ";
        }
    }
    cout << endl;

    return 0;
}
