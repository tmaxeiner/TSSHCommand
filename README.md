# TSSHCommand
Send commands over ssh with Delphi. This is no implementation of ssh protocol in Delphi but a Wrapper to use ssh in a Delphi way. Since Openssh is a part of Windows 10, usage is easy without installing putty or something else.
---

# Description
TSSHCommand is a wrapper for Delphi to use built in openssh in Windows 10 to:
- send commands to a remote ssh server
- send files with scp to a remote server
- receive files with scp from a remote server

# Advantage
Openssh is available in windows 10 since 1803 and I think standard install since 1809.
Using ssh with Delphi gives out of the box encryption and authentication mechanism.
Openssh in Windows is key compatible with openssh key in Linux.
Command line options are compatible in Windows and Linux.

# Prerequisites
This wrapper uses shellexecute to start ssh.exe. Normally ssh is located in c:\windows\system32\Openssh\.
I don't know why but shellexecute can't open the Openssh folder. If you start cmd.exe and navigate to c:\windows\system32\, you see no folder Openssh. Ich you use powershell, you see the folder and can enter it.
So my detour is to copy ssh.exe from Openssh folder to my application folder or to a other folder e.g. c:\tools\
To use the scp function, same is for scp.exe.

# Repo Contens 
Included is the wrapper as Delphi record, demo application and test.

# Usage
Evertything is visible in the demo application.
After entering basic settings like:
- hostname
- port (if set other than 22)
- username
- keyfile
you can perform as many commands and scp copy action with one line of code each.



''''
