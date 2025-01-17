#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <errno.h>

typedef struct Process {
    char name[5];
    int arrivalTime;
    int burstTime;
    int priority;
    int waitingTime;
    int completionTime;
} Process;

void swapProcesses(Process *a, Process *b) {
    Process temp = *a;
    *a = *b;
    *b = temp;
}

void sortProcessesByArrivalTime(Process *processes, int numProcesses) {
    for (int i = 0; i < numProcesses - 1; i++) {
        for (int j = 0; j < numProcesses - i - 1; j++) {
            if (processes[j].arrivalTime > processes[j + 1].arrivalTime) {
                swapProcesses(&processes[j], &processes[j + 1]);
            }
        }
    }
}

void fcfsScheduling(Process *processes, int numProcesses) {
    sortProcessesByArrivalTime(processes, numProcesses);
    int currentTime = 0;
    for (int i = 0; i < numProcesses; i++) {
        if (currentTime < processes[i].arrivalTime) {
            currentTime = processes[i].arrivalTime;
        }
        processes[i].waitingTime = currentTime - processes[i].arrivalTime;
        currentTime += processes[i].burstTime;
        processes[i].completionTime = currentTime;
    }
}

void sjfScheduling(Process *processes, int numProcesses) {
    sortProcessesByArrivalTime(processes, numProcesses);
    int currentTime = 0;
    int completed = 0;
    while (completed < numProcesses) {
        int shortestJobIndex = -1;
        int minBurstTime = INT_MAX;
        for (int i = 0; i < numProcesses; i++) {
            if (processes[i].arrivalTime <= currentTime && processes[i].completionTime == 0) {
                if (processes[i].burstTime < minBurstTime) {
                    minBurstTime = processes[i].burstTime;
                    shortestJobIndex = i;
                }
            }
        }
        if (shortestJobIndex != -1) {
            if (currentTime < processes[shortestJobIndex].arrivalTime) {
                currentTime = processes[shortestJobIndex].arrivalTime;
            }
            processes[shortestJobIndex].waitingTime = currentTime - processes[shortestJobIndex].arrivalTime;
            currentTime += processes[shortestJobIndex].burstTime;
            processes[shortestJobIndex].completionTime = currentTime;
            completed++;
        } else {
            currentTime++;
        }
    }
}

void roundRobinScheduling(Process *processes, int numProcesses, int timeQuantum) {
    Process remainingProcesses[numProcesses];
    for (int i = 0; i < numProcesses; i++) {
        remainingProcesses[i] = processes[i];
    }
    int currentTime = 0;
    int completed = 0;
    while (completed < numProcesses) {
        int found = 0;
        for (int i = 0; i < numProcesses; i++) {
            if (remainingProcesses[i].burstTime > 0) {
                found = 1;
                if (currentTime < remainingProcesses[i].arrivalTime) {
                    currentTime = remainingProcesses[i].arrivalTime;
                }
                if (remainingProcesses[i].burstTime <= timeQuantum) {
                    currentTime += remainingProcesses[i].burstTime;
                    processes[i].waitingTime = currentTime - processes[i].arrivalTime - processes[i].burstTime;
                    processes[i].completionTime = currentTime;
                    remainingProcesses[i].burstTime = 0;
                    completed++;
                } else {
                    currentTime += timeQuantum;
                    remainingProcesses[i].burstTime -= timeQuantum;
                }
            }
        }
        if (found == 0) {
            for (int i = 0; i < numProcesses; i++) {
                if (processes[i].completionTime == 0) {
                    currentTime++;
                    break;
                }
            }
        }
    }
}

void priorityScheduling(Process *processes, int numProcesses) {
    sortProcessesByArrivalTime(processes, numProcesses);
    int currentTime = 0;
    int completed = 0;
    while (completed < numProcesses) {
        int highestPriorityIndex = -1;
        int minPriority = INT_MAX;
        for (int i = 0; i < numProcesses; i++) {
            if (processes[i].arrivalTime <= currentTime && processes[i].completionTime == 0) {
                if (processes[i].priority < minPriority) {
                    minPriority = processes[i].priority;
                    highestPriorityIndex = i;
                }
            }
        }
        if (highestPriorityIndex != -1) {
            if (currentTime < processes[highestPriorityIndex].arrivalTime) {
                currentTime = processes[highestPriorityIndex].arrivalTime;
            }
            processes[highestPriorityIndex].waitingTime = currentTime - processes[highestPriorityIndex].arrivalTime;
            currentTime += processes[highestPriorityIndex].burstTime;
            processes[highestPriorityIndex].completionTime = currentTime;
            completed++;
        } else {
            currentTime++;
        }
    }
}

float calculateAverageWaitingTime(Process *processes, int numProcesses) {
    float totalWaitingTime = 0;
    for (int i = 0; i < numProcesses; i++) {
        totalWaitingTime += processes[i].waitingTime;
    }
    return (numProcesses > 0) ? totalWaitingTime / numProcesses : 0;
}

void printProcesses(Process *processes, int numProcesses) {
    printf("\nProcess Table:\n");
    printf("Name\tArrival\tBurst\tPriority\tWaiting Time\tCompletion\n");
    for (int i = 0; i < numProcesses; i++) {
        printf("%s\t%d\t%d\t%d\t\t%d\t\t%d\n", processes[i].name, processes[i].arrivalTime,
               processes[i].burstTime, processes[i].priority, processes[i].waitingTime, processes[i].completionTime);
    }
}

void printGanttChart(Process *processes, int numProcesses) {
    printf("\nGantt Chart:\n");

    // Print top border
    printf(" ");
    for (int i = 0; i < numProcesses; i++) {
        printf("+-----"); // Adjust width based on process name length if needed
    }
    printf("+\n");

    // Print process names
    printf(" ");
    for (int i = 0; i < numProcesses; i++) {
        printf("| %-3s ", processes[i].name);
    }
    printf("|\n");

    // Print separator line
    printf(" ");
    for (int i = 0; i < numProcesses; i++) {
        printf("+-----");
    }
    printf("+\n");

    // Print time intervals
    printf("0");
    int currentTime = 0;
    for (int i = 0; i < numProcesses; i++) {
        if (currentTime < processes[i].arrivalTime) {
            int idleTime = processes[i].arrivalTime - currentTime;
            for (int j = 0; j < idleTime * 5; j++) printf("-");
            printf("%d", processes[i].arrivalTime);
            currentTime = processes[i].arrivalTime;
        }
        for (int j = 0; j < processes[i].burstTime * 5; j++) printf("-");
        currentTime += processes[i].burstTime;
        printf("%d", currentTime);
    }
    printf("\n");
}
/*
void printGanttChart(Process *processes, int numProcesses) {
    printf("\nGantt Chart:\n");
    int currentTime = 0;
    for (int i = 0; i < numProcesses; i++) {
        if (currentTime < processes[i].arrivalTime) {
            printf("| Idle ");
            for (int j = 0; j < processes[i].arrivalTime - currentTime; j++) {
                printf("-");
            }
            printf(" ");
            currentTime = processes[i].arrivalTime;
        }
        printf("| %s ", processes[i].name);
        for (int j = 0; j < processes[i].burstTime; j++) {
            printf("-");
        }
        printf(" ");
        currentTime += processes[i].burstTime;
    }
    printf("|\n");
    currentTime = 0;
    for (int i = 0; i < numProcesses; i++) {
        if (currentTime < processes[i].arrivalTime) {
            printf("%d", currentTime);
            for (int j = 0; j < processes[i].arrivalTime - currentTime + 2; j++) {
                printf(" ");
            }
            currentTime = processes[i].arrivalTime;
        }
        printf("%d", currentTime);
        for (int j = 0; j < processes[i].burstTime + 3; j++) {
            printf(" ");
        }
        currentTime += processes[i].burstTime;
    }
    printf("%d\n", currentTime);
}
*/
int main() {
    int choice, numProcesses, timeQuantum, i, j;
    Process *processes = NULL;

    while (1) {
        printf("\n----- CPU Scheduling Simulator -----\n");
        printf("1. First-Come, First-Served (FCFS)\n");
        printf("2. Shortest Job First (SJF)\n");
        printf("3. Round Robin (RR)\n");
        printf("4. Priority Scheduling\n");
        printf("0. Exit\n");
        printf("Enter your choice: ");
        if (scanf("%d", &choice) != 1) {
            printf("Invalid input.\n");
            while (getchar() != '\n');
            continue;
        }

        if (choice == 0) {
            printf("Exiting program.\n");
            break;
        }

        printf("Enter the number of processes: ");
        if (scanf("%d", &numProcesses) != 1 || numProcesses <= 0) {
            printf("Invalid number of processes.\n");
            while (getchar() != '\n');
            continue;
        }

        processes = (Process *)malloc(numProcesses * sizeof(Process));
        if (processes == NULL) {
            perror("Memory allocation failed");
            return 1;
        }

        printf("\n----- Enter process details: -----\n");
        for (i = 0; i < numProcesses; i++) {
            printf("Process %d name: ", i + 1);
            if (scanf("%4s", processes[i].name) != 1) {
                printf("Invalid input.\n");
                free(processes);
                processes = NULL;
                break;
            }
            processes[i].name[4] = '\0';
            printf("Arrival time: ");
            if (scanf("%d", &processes[i].arrivalTime) != 1) {
                printf("Invalid input.\n");
                free(processes);
                processes = NULL;
                break;
            }
            printf("Burst time: ");
            if (scanf("%d", &processes[i].burstTime) != 1) {
                printf("Invalid input.\n");
                free(processes);
                processes = NULL;
                break;
            }
            printf("Priority: ");
            if (scanf("%d", &processes[i].priority) != 1) {
                printf("Invalid input.\n");
                free(processes);
                processes = NULL;
                break;
            }
            printf("\n");
            processes[i].waitingTime = 0;
            processes[i].completionTime = 0;
        }

        if (processes == NULL) continue;

        Process *fcfsProcesses = (Process *)malloc(numProcesses * sizeof(Process));
        Process *sjfProcesses = (Process *)malloc(numProcesses * sizeof(Process));
        Process *rrProcesses = (Process *)malloc(numProcesses * sizeof(Process));
        Process *priorityProcesses = (Process *)malloc(numProcesses * sizeof(Process));

        if (!fcfsProcesses || !sjfProcesses || !rrProcesses || !priorityProcesses) {
            perror("Memory allocation failed");
            free(processes);
            return 1;
        }

        memcpy(fcfsProcesses, processes, numProcesses * sizeof(Process));
        memcpy(sjfProcesses, processes, numProcesses * sizeof(Process));
        memcpy(rrProcesses, processes, numProcesses * sizeof(Process));
        memcpy(priorityProcesses, processes, numProcesses * sizeof(Process));

        fcfsScheduling(fcfsProcesses, numProcesses);
        sjfScheduling(sjfProcesses, numProcesses);
        printf("Enter time quantum for Round Robin: ");
        if (scanf("%d", &timeQuantum) != 1 || timeQuantum <= 0) {
            printf("Invalid time quantum, using default value 2.\n");
            timeQuantum = 2;
        }
        roundRobinScheduling(rrProcesses, numProcesses, timeQuantum);
        priorityScheduling(priorityProcesses, numProcesses);

        float fcfsAvgWait = calculateAverageWaitingTime(fcfsProcesses, numProcesses);
        float sjfAvgWait = calculateAverageWaitingTime(sjfProcesses, numProcesses);
        float rrAvgWait = calculateAverageWaitingTime(rrProcesses, numProcesses);
        float priorityAvgWait = calculateAverageWaitingTime(priorityProcesses, numProcesses);

        printf("\n----- Algorithm Comparison -----\n");
        printf("FCFS average waiting time: %.2f\n", fcfsAvgWait);
        printf("SJF average waiting time: %.2f\n", sjfAvgWait);
        printf("Round Robin average waiting time: %.2f\n", rrAvgWait);
        printf("Priority average waiting time: %.2f\n", priorityAvgWait);

        float minAvgWait = fcfsAvgWait;
        char *bestAlgo = "FCFS";
        if (sjfAvgWait < minAvgWait) {
            minAvgWait = sjfAvgWait;
            bestAlgo = "SJF";
        }
        if (rrAvgWait < minAvgWait) {
            minAvgWait = rrAvgWait;
            bestAlgo = "Round Robin";
        }
        if (priorityAvgWait < minAvgWait) {
            minAvgWait = priorityAvgWait;
            bestAlgo = "Priority";
        }
        printf("\nThe best algorithm is %s with average waiting time: %.2f\n", bestAlgo, minAvgWait);

        switch (choice) {
            case 1:
                printProcesses(fcfsProcesses, numProcesses);
                printf("Average Waiting Time: %.2f\n", fcfsAvgWait);
                printGanttChart(fcfsProcesses, numProcesses);
                break;
            case 2:
                printProcesses(sjfProcesses, numProcesses);
                printf("Average Waiting Time: %.2f\n", sjfAvgWait);
                printGanttChart(sjfProcesses, numProcesses);
                break;
            case 3:
                printProcesses(rrProcesses, numProcesses);
                printf("Average Waiting Time: %.2f\n", rrAvgWait);
                printGanttChart(rrProcesses, numProcesses);
                break;
            case 4:
                printProcesses(priorityProcesses, numProcesses);
                printf("Average Waiting Time: %.2f\n", priorityAvgWait);
                printGanttChart(priorityProcesses, numProcesses);
                break;
            default:
                printf("Invalid choice.\n");
        }

        free(processes);
        free(fcfsProcesses);
        free(sjfProcesses);
        free(rrProcesses);
        free(priorityProcesses);
    }
    return 0;
}
