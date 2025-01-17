#include <iostream>
#include <vector>
#include <algorithm>
#include <iomanip>
#include <queue>
#include <climits>

using namespace std;

struct Process {
    int id;
    int burst_time;
    int arrival_time;
    int priority;
    int waiting_time;
    int turnaround_time;
};

void print_gantt_chart(const vector<int>& process_ids, const vector<int>& completion_times) {
    cout << "\nGantt Chart:\n";
    for (int id : process_ids) {
        cout << "| P" << id << " ";
    }
    cout << "|\n";

    for (int time : completion_times) {
        cout << time << "\t";
    }
    cout << "\n";
}

double fcfs(const vector<Process>& processes) {
    int n = processes.size();
    vector<Process> proc = processes;
    vector<int> gantt_ids, gantt_times;

    sort(proc.begin(), proc.end(), [](Process a, Process b) { return a.arrival_time < b.arrival_time; });

    int time = 0;
    double total_waiting_time = 0;

    cout << "\nExecuting First-Come, First-Served (FCFS) Scheduling:\n";
    for (Process& p : proc) {
        if (time < p.arrival_time) {
            time = p.arrival_time;
        }
        gantt_ids.push_back(p.id);
        time += p.burst_time;
        gantt_times.push_back(time);

        p.turnaround_time = time - p.arrival_time;
        p.waiting_time = p.turnaround_time - p.burst_time;
        total_waiting_time += p.waiting_time;

        cout << "Process " << p.id << ": Waiting Time = " << p.waiting_time
             << ", Turnaround Time = " << p.turnaround_time << "\n";
    }

    cout << "Average Waiting Time: " << total_waiting_time / n << "\n";
    print_gantt_chart(gantt_ids, gantt_times);

    return total_waiting_time / n;
}

double sjf(const vector<Process>& processes) {
    int n = processes.size();
    vector<Process> proc = processes;
    vector<int> gantt_ids, gantt_times;

    sort(proc.begin(), proc.end(), [](Process a, Process b) {
        return a.arrival_time < b.arrival_time;
    });

    int time = 0;
    double total_waiting_time = 0;
    vector<bool> completed(n, false);

    cout << "\nExecuting Shortest Job First (SJF) Scheduling:\n";

    while (count(completed.begin(), completed.end(), true) < n) {
        int idx = -1;
        int min_burst = INT_MAX;

        for (int i = 0; i < n; i++) {
            if (!completed[i] && proc[i].arrival_time <= time && proc[i].burst_time < min_burst) {
                min_burst = proc[i].burst_time;
                idx = i;
            }
        }

        if (idx == -1) {
            time++;
            continue;
        }

        Process& p = proc[idx];
        gantt_ids.push_back(p.id);
        time += p.burst_time;
        gantt_times.push_back(time);
        p.turnaround_time = time - p.arrival_time;
        p.waiting_time = p.turnaround_time - p.burst_time;
        total_waiting_time += p.waiting_time;
        completed[idx] = true;

        cout << "Process " << p.id << ": Waiting Time = " << p.waiting_time
             << ", Turnaround Time = " << p.turnaround_time << "\n";
    }

    cout << "Average Waiting Time: " << total_waiting_time / n << "\n";
    print_gantt_chart(gantt_ids, gantt_times);

    return total_waiting_time / n;
}

double round_robin(const vector<Process>& processes, int time_quantum) {
    int n = processes.size();
    vector<Process> proc = processes;
    vector<int> gantt_ids, gantt_times;
    queue<int> ready_queue;

    vector<int> remaining_burst_time(n);
    for (int i = 0; i < n; i++) {
        remaining_burst_time[i] = proc[i].burst_time;
    }

    int time = 0;
    double total_waiting_time = 0;
    int completed = 0;

    cout << "\nExecuting Round Robin (RR) Scheduling:\n";

    while (completed < n) {
        bool process_executed = false;
        for (int i = 0; i < n; i++) {
            if (proc[i].arrival_time <= time && remaining_burst_time[i] > 0) {
                gantt_ids.push_back(proc[i].id);
                int exec_time = min(time_quantum, remaining_burst_time[i]);
                time += exec_time;
                remaining_burst_time[i] -= exec_time;
                gantt_times.push_back(time);

                if (remaining_burst_time[i] == 0) {
                    completed++;
                    proc[i].turnaround_time = time - proc[i].arrival_time;
                    proc[i].waiting_time = proc[i].turnaround_time - proc[i].burst_time;
                    total_waiting_time += proc[i].waiting_time;

                    cout << "Process " << proc[i].id << ": Waiting Time = " << proc[i].waiting_time
                         << ", Turnaround Time = " << proc[i].turnaround_time << "\n";
                }
                process_executed = true;
            }
        }

        if (!process_executed) {
            time++;
        }
    }

    cout << "Average Waiting Time: " << total_waiting_time / n << "\n";
    print_gantt_chart(gantt_ids, gantt_times);

    return total_waiting_time / n;
}

double priority_scheduling(const vector<Process>& processes) {
    int n = processes.size();
    vector<Process> proc = processes;
    vector<int> gantt_ids, gantt_times;

    sort(proc.begin(), proc.end(), [](Process a, Process b) {
        return a.arrival_time < b.arrival_time;
    });

    int time = 0;
    double total_waiting_time = 0;
    vector<bool> completed(n, false);

    cout << "\nExecuting Priority Scheduling:\n";

    while (count(completed.begin(), completed.end(), true) < n) {
        int idx = -1;
        int max_priority = INT_MIN;

        for (int i = 0; i < n; i++) {
            if (!completed[i] && proc[i].arrival_time <= time && proc[i].priority > max_priority) {
                max_priority = proc[i].priority;
                idx = i;
            }
        }

        if (idx == -1) {
            time++;
            continue;
        }

        Process& p = proc[idx];
        gantt_ids.push_back(p.id);
        time += p.burst_time;
        gantt_times.push_back(time);
        p.turnaround_time = time - p.arrival_time;
        p.waiting_time = p.turnaround_time - p.burst_time;
        total_waiting_time += p.waiting_time;
        completed[idx] = true;

        cout << "Process " << p.id << ": Waiting Time = " << p.waiting_time
             << ", Turnaround Time = " << p.turnaround_time << "\n";
    }

    cout << "Average Waiting Time: " << total_waiting_time / n << "\n";
    print_gantt_chart(gantt_ids, gantt_times);

    return total_waiting_time / n;
}

void display_menu() {
    cout << "\nCPU Scheduling Algorithm Simulator:\n";
    cout << "1. First-Come, First-Served (FCFS)\n";
    cout << "2. Shortest Job First (SJF)\n";
    cout << "3. Round Robin (RR)\n";
    cout << "4. Priority Scheduling\n";
    cout << "5. Compare Algorithms\n";
    cout << "6. Exit\n";
    cout << "Select an option: ";
}

void compare_algorithms(const vector<Process>& processes) {
    int time_quantum;
    cout << "\nEnter time quantum for Round Robin: ";
    cin >> time_quantum;

    cout << "\nComparing CPU Scheduling Algorithms:\n";

    double fcfs_waiting_time = fcfs(processes);
    double sjf_waiting_time = sjf(processes);
    double rr_waiting_time = round_robin(processes, time_quantum);
    double priority_waiting_time = priority_scheduling(processes);

    cout << "\nAverage Waiting Times:\n";
    cout << "FCFS: " << fcfs_waiting_time << "\n";
    cout << "SJF: " << sjf_waiting_time << "\n";
    cout << "Round Robin: " << rr_waiting_time << "\n";
    cout << "Priority: " << priority_waiting_time << "\n";

    double min_waiting_time = min({fcfs_waiting_time, sjf_waiting_time, rr_waiting_time, priority_waiting_time});

    cout << "\nBest Algorithm (Minimum Average Waiting Time):\n";
    if (min_waiting_time == fcfs_waiting_time) {
        cout << "FCFS\n";
    } else if (min_waiting_time == sjf_waiting_time) {
        cout << "SJF\n";
    } else if (min_waiting_time == rr_waiting_time) {
        cout << "Round Robin\n";
    } else {
        cout << "Priority\n";
    }
}

int main() {
    vector<Process> processes;
    int n;

    cout << "Enter the number of processes: ";
    cin >> n;

    for (int i = 0; i < n; i++) {
        Process p;
        p.id = i + 1;

        cout << "Enter burst time for process P" << p.id << ": ";
        cin >> p.burst_time;

        cout << "Enter arrival time for process P" << p.id << ": ";
        cin >> p.arrival_time;

        cout << "Enter priority for process P" << p.id << " (higher number = higher priority): ";
        cin >> p.priority;

        processes.push_back(p);
    }

    int choice;

    do {
        display_menu();
        cin >> choice;

        switch (choice) {
            case 1:
                fcfs(processes);
                break;
            case 2:
                sjf(processes);
                break;
            case 3: {
                int time_quantum;
                cout << "Enter time quantum: ";
                cin >> time_quantum;
                round_robin(processes, time_quantum);
                break;
            }
            case 4:
                priority_scheduling(processes);
                break;
            case 5:
                compare_algorithms(processes);
                break;
            case 6:
                cout << "Exiting program.\n";
                break;
            default:
                cout << "Invalid choice. Please try again.\n";
        }
    } while (choice != 6);

    return 0;
}
