#include <bits/stdc++.h>
#define SIZE 100105
#define INF 1000000000
using namespace std;

int par[SIZE], dis[SIZE];
bool vis[SIZE];
vector<int> adj[SIZE], adjw[SIZE];
int n, e;

// Priority queue to manage nodes and distances
priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pq;

void dijkstra(int source) {
    par[source] = -1;
    pq.push({0, source}); // {distance, node}
    while (!pq.empty()) {
        int u = pq.top().second;
        pq.pop();

        if (vis[u]) continue;
        vis[u] = true;

        for (int i = 0; i < (int)adj[u].size(); i++) {
            int v = adj[u][i];
            int w = adjw[u][i];

            if (dis[u] + w < dis[v]) {
                par[v] = u;
                dis[v] = dis[u] + w;
                pq.push({dis[v], v});
            }
        }
    }
}

void pathPrint(char a[], int des) {
    if (par[des] == -1) {
        cout << a[des];
        return;
    }
    pathPrint(a, par[des]);
    cout << " -> " << a[des];
}

int main() {
    char a[] = {'0', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'};
    int u, v, w;

    // Input number of nodes and edges
    cin >> n >> e;

    for (int i = 0; i < e; i++) {
        cin >> u >> v >> w;
        adj[u].push_back(v);
        adjw[u].push_back(w);
    }

    // Initialize distance and visited arrays
    for (int i = 1; i <= n; i++) {
        dis[i] = INF;
        vis[i] = false;
    }

    dis[2] = 0; // Source node
    dijkstra(2); // Run Dijkstra's algorithm from node 2

    // Print the shortest paths and distances
    for (int i = 1; i <= n; i++) {
        cout << "a to " << a[i] << " total cost = " << dis[i] << " path: ";
        pathPrint(a, i);
        cout << endl;
    }

    return 0;
}
