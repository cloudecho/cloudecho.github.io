---
layout: post
title:  "Shell Script to Put File in a FTP Server"
date:   2021-12-18 12:47:00 +0800
categories: Util
tags:
- ftp
---

TL;DR;

```sh
#!/bin/bash

# The 3 variables below store server and login details
HOST="192.168.0.104"
USER="user1"
PASSWORD="1234"


# $1 is the first argument to the script
# We are using it as upload directory path
# If it is '.', file is uploaded to current directory.
DESTINATION=$1


# Rest of the arguments are a list of files to be uploaded.
# ${@:2} is an array of arguments without first one.
ALL_FILES="${@:2}"


# FTP login and upload is explained in paragraph below
ftp -inv $HOST <<EOF
user $USER $PASSWORD
cd $DESTINATION
mput $ALL_FILES
bye
EOF
```


The above script requires the following data:

1. Server’s hostname
2. Server user’s login details
3. The directory in which to upload files on the server (passed as an argument to the script)
4. The list of files to be uploaded to the server (passed as an argument to script)


The options -inv can also be written as -i -n -v and their functions are explained in the below table:

| Option  |	Meaning |
|---------|---------|
|-i	      | Disable interactive mode, so that FTP will not ask for confirmation of each file while using mput command etc. We are using this for convenience while uploading or downloading files |
|-n	      | Disable auto-login. We have to do this, so we can manually log in using “user” command inside the script |
|-v       | Enables verbose mode. This helps us to see the server responses after executing each FTP command |

To execute the script supply the upload directory and also a list of files:

```sh
./script_name.sh  path_to_upload file1 file2 file3
```

See https://www.geeksforgeeks.org/shell-script-to-put-file-in-a-ftp-server/
