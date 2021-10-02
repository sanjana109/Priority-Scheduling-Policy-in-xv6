# Priority-Scheduling-Policy-in-xv6
Replacing Round-Robin Scheduling Policy with Priority based Scheduling Policy in xv6 Operating System

xv6 operating system supports pre-emptive scheduling and the default scheduling algorithm implemented is the Round Robin policy where the runnable processes are
allotted CPU for fixed time quantum one at a time.

As a part of this project, I have implemented a new scheduling algorithm which is the priority scheduler. In the priority scheduling policy, the processes are allocated CPU based on their priority. The scheduler first selects the process with the highest priority to execute then followed by the second highest priority and so on. The lower numerical value represents the higher priority.

# Implementation of this scheduling policy is done in two parts-
I) To add a system-call that sets a priority for the process

II) To replace the Round Robin policy with the priority scheduling policy.
