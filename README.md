Daily Backup Marker File
This repository contains a simple Windows Batch script designed to create or update a date-stamped marker file within a specified folder. This is particularly useful for identifying daily snapshots or mirrored backups, where the content itself doesn't inherently show the backup date.

Purpose
When performing daily mirrored backups (e.g., using robocopy or other synchronization tools), the destination folder typically reflects the exact content and structure of the source. This can make it difficult to quickly determine which day's backup a specific mirrored folder represents, especially if you retain multiple daily copies.

This script addresses that by creating an empty .txt file with the current date embedded in its name (e.g., Today_is_YYYYMMDD.txt). This file acts as a visual timestamp or marker for the backup, allowing you to easily identify when that particular mirrored copy was made.

The script ensures that only one such file exists per day by renaming the previous day's marker file (if found) to the current day's format.

How it Works
Gets Current Date: Utilizes WMIC and batch scripting to reliably obtain the current system date in YYYYMMDD format.

Gets Previous Day's Date: Uses a simple PowerShell command to calculate yesterday's date.

Constructs Filenames: Determines the expected filenames for today's and yesterday's marker files (e.g., Today_is_20250714.txt).

Renames Previous File: If a file matching yesterday's marker filename is found in the target directory, it is renamed to today's filename. This efficiently updates the timestamp.

Creates New File (if necessary): If yesterday's file isn't found (e.g., on the first run, or after manual deletion), and today's file doesn't already exist, an empty marker file for today is created.

Setup and Usage
1. Download the Script
Download the UpdateTodayFile.bat file from this repository and save it to a convenient location on your Windows machine (e.g., C:\Scripts\).

2. Configure the Target Folder
Open the UpdateTodayDate.bat file in a text editor (like Notepad). Locate the following line near the top:

set "TARGET_FOLDER=D:\Folder\"

Change D:\Folder\ to the absolute path of the folder where your mirrored backups are stored and where you want the marker file to appear. Make sure the folder exists.

3. Schedule with Task Scheduler
To automate the daily execution of this script, you should set it up in Windows Task Scheduler:

Open Task Scheduler: Press Win + R, type taskschd.msc, and press Enter, or search for "Task Scheduler" in the Start menu.

Create Basic Task:

In the right-hand "Actions" pane, click "Create Basic Task...".

Name: Enter a descriptive name like DailyBackupMarker or UpdateDailyDateFile.

Trigger: Select "Daily".

Time: Set this to 00:00:00 (midnight) or shortly after your daily backup process is expected to complete.

Action: Select "Start a program".

Program/script: Click "Browse" and navigate to where you saved UpdateTodayFile.bat (e.g., C:\Scripts\UpdateTodayFile.bat).

Start in (optional): Crucially, enter the same TARGET_FOLDER path you configured in step 2 (e.g., D:\Folder\). This ensures the script runs in the correct directory context.

Click through the remaining prompts to finish creating the task.

Once configured, the Task Scheduler will run this script every day at 00:00, ensuring your backup folder always contains an up-to-date timestamp file.
