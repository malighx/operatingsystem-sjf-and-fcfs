#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <limits.h> // Include for INT_MAX

// Define the Process Control Block (PCB)
typedef struct {
    int pid;
    int arrival_time;
    int burst_time;
    int waiting_time;
    int turnaround_time;
    char state[20]; // Process state: "Ready", "Running", "Terminated"
} PCB;

// Function to create a process
PCB create_process(int pid, int arrival_time, int burst_time) {
    PCB process;
    process.pid = pid;
    process.arrival_time = arrival_time;
    process.burst_time = burst_time;
    process.waiting_time = 0;
    process.turnaround_time = 0;
    strcpy(process.state, "Ready");
    return process;
}

// Function to schedule processes using SJF (Shortest Job First)
void schedule_sjf(PCB ready_queue[], int n) {
    int current_time = 0;
    int completed = 0;

    while (completed < n) {
        int shortest_index = -1;
        int shortest_burst = INT_MAX; // Use INT_MAX from limits.h

        // Find the process with the shortest burst time that has arrived
        for (int i = 0; i < n; i++) {
            if (ready_queue[i].arrival_time <= current_time && 
                strcmp(ready_queue[i].state, "Ready") == 0 && 
                ready_queue[i].burst_time < shortest_burst) {
                shortest_burst = ready_queue[i].burst_time;
                shortest_index = i;
            }
        }

        if (shortest_index == -1) {
            // No process is ready to execute
            current_time++;
        } else {
            // Execute the shortest job
            ready_queue[shortest_index].waiting_time = current_time - ready_queue[shortest_index].arrival_time;
            current_time += ready_queue[shortest_index].burst_time;
            ready_queue[shortest_index].turnaround_time = current_time - ready_queue[shortest_index].arrival_time;
            strcpy(ready_queue[shortest_index].state, "Terminated");
            completed++;
        }
    }
}

// Function to calculate and display statistics
void calculate_statistics(PCB ready_queue[], int n) {
    int total_waiting_time = 0, total_turnaround_time = 0;
    printf("\nProcess ID\tWaiting Time\tTurnaround Time\n");
    for (int i = 0; i < n; i++) {
        total_waiting_time += ready_queue[i].waiting_time;
        total_turnaround_time += ready_queue[i].turnaround_time;
        printf("%d\t\t%d\t\t%d\n", ready_queue[i].pid, ready_queue[i].waiting_time, ready_queue[i].turnaround_time);
    }
    printf("\nAverage Waiting Time: %.2f\n", (float)total_waiting_time / n);
    printf("Average Turnaround Time: %.2f\n", (float)total_turnaround_time / n);
}

// Function to display the ready queue
void display_ready_queue(PCB ready_queue[], int n) {
    printf("\nReady Queue:\n");
    printf("Process ID\tArrival Time\tBurst Time\tState\n");
    for (int i = 0; i < n; i++) {
        printf("%d\t\t%d\t\t%d\t\t%s\n", ready_queue[i].pid, ready_queue[i].arrival_time, ready_queue[i].burst_time, ready_queue[i].state);
    }
}

int main() {
    int n;
    printf("Enter the number of processes: ");
    scanf("%d", &n);

    // Create an array of PCBs
    PCB ready_queue[n];

    // Input process details
    for (int i = 0; i < n; i++) {
        int arrival_time, burst_time;
        printf("Enter arrival time and burst time for process %d: ", i + 1);
        scanf("%d %d", &arrival_time, &burst_time);
        ready_queue[i] = create_process(i + 1, arrival_time, burst_time);
    }

    // Display the ready queue before scheduling
    display_ready_queue(ready_queue, n);

    // Schedule processes using SJF
    schedule_sjf(ready_queue, n);

    // Display the ready queue after scheduling
    display_ready_queue(ready_queue, n);

    // Calculate and display statistics
    calculate_statistics(ready_queue, n);

    return 0;
}