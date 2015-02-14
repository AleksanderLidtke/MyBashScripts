#!/bin/bash
set -e # Any subsequent commands which fail will cause the shell script to exit immediately.

SRC='/home/alek/Dropbox/PhD/'
DEST='/media/alek/Seagate Backup Plus Drive/PhD'

if [ ! -w "$DEST" ]; then # Check if the destination folder is writable.
	zenity --error --text="Tried to copy from:\n $SRC \nto:\n $DEST\nbut the destination folder isn't writable!"
	exit 0 # No point continuing.
fi

SYNC_LOG_DIRECTORY='/home/alek/SyncLogs/'
SYNC_LOG_FILE=$(date +%Y%m%d_%H%M%S_SyncLog) # Create a unique log file.
echo > $SYNC_LOG_FILE # Actually create the file.
if [ ! -w "$SYNC_LOG_FILE" ]; then # Check if the log file is writable.
	zenity --error --text="Cannot write to the synchronisation log file:\n$SYNC_LOG_FILE!"
	exit 0 # Finish here, we want the log file.
fi

# Let the user know what's happening.
zenity --info --text="$(date "+%Y-%b-%d %H:%M:%S"): Copying all the newer files from:\n$SRC\ninto:\n$DEST"

# Actually do the sync of the two folders.
# Be recursive in subdirectories, skip files that are newer on the receiver, copy symlinks as symlinks,
# preserve the files' executability, preserve modification times, show progress during transfer,
# output a change-summary for all updates into SYNC_LOG_FILE.
rsync --recursive --update --links --executability --times --progress --itemize-changes --log-file=$SYNC_LOG_FILE $SRC "$DEST"

# Move the sync log where it's supposed to be.
mv $SYNC_LOG_FILE $SYNC_LOG_DIRECTORY/

# Let the user know we're done.
zenity --info --text="$(date "+%Y-%b-%d %H:%M:%S"): Finished the copying all the newer files from:\n$SRC\ninto:\n$DEST.\nLog written to:\n$SYNC_LOG_DIRECTORY$SYNC_LOG_FILE"
