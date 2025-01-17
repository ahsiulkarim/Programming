#include <iostream>
#include <vector>
#include <algorithm>
#include <queue>
#include <limits> // For numeric_limits

using namespace std;

struct Process {
    int id;
    int burstTime;
    int arrivalTime;
    int priority;
    int remainingTime;
    int waitingTime;
    int turnaroundTime;

    Process(int id, int burstTime, int arrivalTime, int priority = 0) : id(id), burstTime(burstTime), arrivalTime(arrivalTime), priority(priority), remainingTime(burstTime), waitingTime(0), turnaroundTime(0) {}
};

void displayGanttChart(const vector<pair<int, int>>& schedule) {
    cout << "\nGantt Chart:\n";
    for (const auto& s : schedule) {
        cout << "| P" << s.first << " " << string(s.second, '-') << " ";
    }
    cout << "|\n";

    int time = 0;
    for (const auto& s : schedule) {
        cout << time << string(s.second + 4, ' ');
        time += s.second;
    }
    cout << time << "\n";
}

float computeAvgWaitingTime(const vector<Process>& processes) {
    float total = 0;
    for (const auto& p : processes) {
        total += p.waitingTime;
    }
    return processes.empty() ? 0 : total / processes.size();
}

float computeAvgTurnaroundTime(const vector<Process>& processes) {
    float total = 0;
    for (const auto& p : processes) {
        total += p.turnaroundTime;
    }
    return processes.empty() ? 0 : total / processes.size();
}

// FCFS
void executeFCFS(vector<Process> processes) {
    sort(processes.begin(), processes.end(), [](const Process& a, const Process& b) {
        return a.arrivalTime < b.arrivalTime;
    });

    int currentTime = 0;
    vector<pair<int, int>> schedule;

    for (auto& p : processes) {
        if (currentTime < p.arrivalTime) {
            currentTime = p.arrivalTime;
        }
        p.waitingTime = currentTime - p.arrivalTime;
        p.turnaroundTime = p.waitingTime + p.burstTime;
        currentTime += p.burstTime;
        schedule.emplace_back(p.id, p.burstTime);
    }

    displayGanttChart(schedule);
}

// SJF (Preemptive)
void executeSJF(vector<Process> processes) {
    sort(processes.begin(), processes.end(), [](const Process& a, const Process& b) {
        return a.arrivalTime < b.arrivalTime;
    });

    int currentTime = 0;
    vector<pair<int, int>> schedule;
    vector<Process> remainingProcesses = processes;
    int completedProcesses = 0;

    while (completedProcesses < processes.size()) {
        int shortestJobIndex = -1;
        int shortestBurstTime = numeric_limits<int>::max();

        for (int i = 0; i < remainingProcesses.size(); ++i) {
            if (remainingProcesses[i].arrivalTime <= currentTime && remainingProcesses[i].remainingTime > 0 && remainingProcesses[i].remainingTime < shortestBurstTime) {
                shortestBurstTime = remainingProcesses[i].remainingTime;
                shortestJobIndex = i;
            }
        }

        if (shortestJobIndex == -1) {
            currentTime++;
        } else {
            schedule.push_back({remainingProcesses[shortestJobIndex].id, 1});
            remainingProcesses[shortestJobIndex].remainingTime--;
            currentTime++;

            if (remainingProcesses[shortestJobIndex].remainingTime == 0) {
                for (auto& p : processes) {
                    if (p.id == remainingProcesses[shortestJobIndex].id) {
                        p.turnaroundTime = currentTime - p.arrivalTime;
                        p.waitingTime = p.turnaroundTime - p.burstTime;
                        break;
                    }
                }
                completedProcesses++;
            }
        }
    }
    displayGanttChart(schedule);
}

// Priority (Preemptive)
void executePriority(vector<Process> processes) {
    sort(processes.begin(), processes.end(), [](const Process& a, const Process& b) {
        return a.arrivalTime < b.arrivalTime;
    });

    int currentTime = 0;
    vector<pair<int, int>> schedule;
    vector<Process> remainingProcesses = processes;
    int completedProcesses = 0;

    while (completedProcesses < processes.size()) {
        int highestPriorityIndex = -1;
        int highestPriority = numeric_limits<int>::max(); // Lower number means higher priority

        for (int i = 0; i < remainingProcesses.size(); ++i) {
            if (remainingProcesses[i].arrivalTime <= currentTime && remainingProcesses[i].remainingTime > 0 && remainingProcesses[i].priority < highestPriority) {
                highestPriority = remainingProcesses[i].priority;
                highestPriorityIndex = i;
            }
        }

        if (highestPriorityIndex == -1) {
            currentTime++;
        } else {
            schedule.push_back({remainingProcesses[highestPriorityIndex].id, 1});
            remainingProcesses[highestPriorityIndex].remainingTime--;
            currentTime++;

            if (remainingProcesses[highestPriorityIndex].remainingTime == 0) {
                for (auto& p : processes) {
                    if (p.id == remainingProcesses[highestPriorityIndex].id) {
                        p.turnaroundTime = currentTime - p.arrivalTime;
                        p.waitingTime = p.turnaroundTime - p.burstTime;
                        break;
                    }
                }
                completedProcesses++;
            }
        }
    }
    displayGanttChart(schedule);
}

// Round Robin
void executeRoundRobin(vector<Process> processes, int timeQuantum) {
    sort(processes.begin(), processes.end(), [](const Process& a, const Process& b) {
        return a.arrivalTime < b.arrivalTime;
    });

    int currentTime = 0;
    vector<pair<int, int>> schedule;
    queue<int> readyQueue;
    vector<int> remainingBurstTimes(processes.size());
    vector<int> startTimes(processes.size(), 0); // To calculate waiting time

    for (int i = 0; i < processes.size(); ++i) {
        remainingBurstTimes[i] = processes[i].burstTime;
    }

    int processIndex = 0;
    while (processIndex < processes.size() || !readyQueue.empty()) {
        // Add arriving processes to the ready queue
        while (processIndex < processes.size() && processes[processIndex].arrivalTime <= currentTime) {
            readyQueue.push(processIndex);
            processIndex++;
        }

        if (readyQueue.empty()) {
            currentTime++;
            continue;
        }

        int currentProcessIndex = readyQueue.front();
        readyQueue.pop();

        int executionTime = min(timeQuantum, remainingBurstTimes[currentProcessIndex]);
        schedule.push_back({processes[currentProcessIndex].id, executionTime});
        currentTime += executionTime;
        remainingBurstTimes[currentProcessIndex] -= executionTime;

        if (remainingBurstTimes[currentProcessIndex] > 0) {
            readyQueue.push(currentProcessIndex);
        } else {
            for (auto& p : processes) {
                if (p.id == processes[currentProcessIndex].id) {
                    p.turnaroundTime = currentTime - p.arrivalTime;
                    p.waitingTime = p.turnaroundTime - p.burstTime;
                    break;
                }
            }
        }
    }
    displayGanttChart(schedule);
}

void displayMenu() {
    cout << "\nCPU Scheduling Simulator\n";
    cout << "1. FCFS\n";
    cout << "2. SJF (Preemptive)\n";
    cout << "3. Priority (Preemptive)\n";
    cout << "4. Round Robin\n";
    cout << "5. Exit\n";
    cout << "Enter your choice: ";
}

int main() {
    int choice;
    do {
        displayMenu();
        cin >> choice;

        if (choice >= 1 && choice <= 4) {
            int n;
            cout << "Enter the number of processes: ";
            cin >> n;

            vector<Process> processes;
            for (int i = 0; i < n; ++i) {
                int burst, arrival, priority_val = 0;
                cout << "Enter burst time, arrival time for process " << i + 1 << ": ";
                cin >> burst >> arrival;
                if (choice == 3) {
                    cout << "Enter priority for process " << i + 1 << ": ";
                    cin >> priority_val;
                }
                processes.emplace_back(i + 1, burst, arrival, priority_val);
            }

            vector<Process> fcfsProcesses = processes;
            vector<Process> sjfProcesses = processes;
            vector<Process> priorityProcesses = processes;
            vector<Process> rrProcesses = processes;

            float avgWaitingFCFS = 0, avgTurnaroundFCFS = 0;
            float avgWaitingSJF = 0, avgTurnaroundSJF = 0;
            float avgWaitingPriority = 0, avgTurnaroundPriority = 0;
            float avgWaitingRR = 0, avgTurnaroundRR = 0;

            cout << "\nExecuting FCFS:\n";
            executeFCFS(fcfsProcesses);
            avgWaitingFCFS = computeAvgWaitingTime(fcfsProcesses);
            avgTurnaroundFCFS = computeAvgTurnaroundTime(fcfsProcesses);
            cout << "Average Waiting Time: " << avgWaitingFCFS << "\n";
            cout << "Average Turnaround Time: " << avgTurnaroundFCFS << "\n";

            cout << "\nExecuting SJF (Preemptive):\n";
            executeSJF(sjfProcesses);
            avgWaitingSJF = computeAvgWaitingTime(sjfProcesses);
            avgTurnaroundSJF = computeAvgTurnaroundTime(sjfProcesses);
            cout << "Average Waiting Time: " << avgWaitingSJF << "\n";
            cout << "Average Turnaround Time: " << avgTurnaroundSJF << "\n";

            cout << "\nExecuting Priority (Preemptive):\n";
            executePriority(priorityProcesses);
            avgWaitingPriority = computeAvgWaitingTime(priorityProcesses);
            avgTurnaroundPriority = computeAvgTurnaroundTime(priorityProcesses);
            cout << "Average Waiting Time: " << avgWaitingPriority << "\n";
            cout << "Average Turnaround Time: " << avgTurnaroundPriority << "\n";

            if (choice == 4) {
                int timeQuantum;
                cout << "Enter time quantum for Round Robin: ";
                cin >> timeQuantum;
                cout << "\nExecuting Round Robin:\n";
                executeRoundRobin(rrProcesses, timeQuantum);
                avgWaitingRR = computeAvgWaitingTime(rrProcesses);
                avgTurnaroundRR = computeAvgTurnaroundTime(rrProcesses);
                cout << "Average Waiting Time: " << avgWaitingRR << "\n";
                cout << "Average Turnaround Time: " << avgTurnaroundRR << "\n";
            }

            cout << "\nComparison of Scheduling Algorithms:\n";
            cout << "-----------------------------------------------------------------------------\n";
            cout << "Algorithm\t\tAvg Waiting Time\tAvg Turnaround Time\n";
            cout << "-----------------------------------------------------------------------------\n";
            cout << "FCFS\t\t\t" << avgWaitingFCFS << "\t\t\t" << avgTurnaroundFCFS << "\n";
            cout << "SJF (Preemptive)\t" << avgWaitingSJF << "\t\t\t" << avgTurnaroundSJF << "\n";
            cout << "Priority (Pre.)\t" << avgWaitingPriority << "\t\t\t" << avgTurnaroundPriority << "\n";
            if (choice == 4) {
                cout << "Round Robin\t\t" << avgWaitingRR << "\t\t\t" << avgTurnaroundRR << "\n";
            }
            cout << "-----------------------------------------------------------------------------\n";

        } else if (choice != 5) {
            cout << "Invalid choice!\n";
        }
    } while (choice != 5);

    return 0;
}
