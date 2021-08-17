#!/bin/bash
#
# vim-anywhere - use Vim whenever, wherever
# Author: Chris Knadler
# Homepage: https://www.github.com/cknadler/vim-anywhere
#
# Open a temporary file with Vim. Once Vim is closed, copy the contents of that
# file to the system clipboard.

# Modified by lyhokia

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

TMPFILE_DIR=/tmp/vim-anywhere
TMPFILE=$TMPFILE_DIR/doc-$(date +"%y%m%d%H%M%S")

mkdir -p $TMPFILE_DIR
touch $TMPFILE

# Linux Wayland Sway
chmod o-r $TMPFILE # Make file only readable by you
bash "$SCRIPTPATH/sway-floating.sh" alacritty -e "nvim $TMPFILE"
cat $TMPFILE | wl-copy
