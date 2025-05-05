# PYTHON FUNDAMENTALS | PROJECT: LOG ANALYSER

## OPERATION ORDER
Operation Log Recon is a focused task aimed at understanding log data. The main goal is to create a special Python tool to carefully look into log files, especially the ones in /var/log/auth.log. Your job is to pull out, examine, and understand the vast amount of information hidden in these files, to learn more about how the system works, its security, and any unusual activities.

**1. VISION**\
To empower cybersecurity teams with unparalleled insights into system operations and security through advanced log analysis, enhancing the ability to preemptively identify and mitigate risks, thereby ensuring operational integrity and security resilience.

**2. MISSION**\
Parse and analyse data from critical log files. The mission is to transform raw log data into actionable intelligence, providing a clear and comprehensive understanding of system behaviours, security threats, and operational anomalies.

**3. STRATEGY**\
Ensure the findings and insights from the log analysis are effectively communicated to relevant stakeholders through comprehensive reports.

**4. OBJECTIVES**
- Data Extraction
- Pattern Identification
- Threat Analysis

## Project Structure

### 1. Log Parse auth.log: Extract command usage.
  1.1. Include the Timestamp.\
  1.2. Include the executing user.\
  1.3. Include the command.

### 2. Log Parse auth.log: Monitor user authentication changes.
  2.1. Print details of newly added users, including the Timestamp.\
  2.2. Print details of deleted users, including the Timestamp.\
  2.3. Print details of changing passwords, including the Timestamp.\
  2.4. Print details of when users used the su command.\
  2.5. Print details of users who used the sudo; include the command.\
  2.6. Print ALERT! if users failed to use the sudo command; include the command.
