#!/bin/bash
# File              : useful_tools.sh
# Author            : lmcallme <l.m.zhongguo@gmial.com>
# Date              : 22.05.2018
# Last Modified Date: 22.05.2018
# Last Modified By  : lmcallme <l.m.zhongguo@gmial.com>

# configuare

ACCOUNT="qqmail"
SMTP_HOST="smtp.qq.com"
SMTP_PORT="465"
IMAP_HOST="imap.qq.com"
IMAP_PORT="993"
USER_="123@qq.com"
PASSWORD="mypassword"
REAL_NAME="just_a_qqmail"
FROM="123@qq.com"

# get current dir
#保存PWD
_SAVED_PWD=$PWD
#获得该文件的位置
echo "$0" | grep -q "$0"
if [ $? -eq 0 ]; then
        cd "$(dirname "$BASH_SOURCE")"
        CUR_FILE=$(pwd)/$(basename "$BASH_SOURCE")
        CUR_DIR=$(dirname "$CUR_FILE")
        cd - > /dev/null
else
        if [ ${0:0:1} = "/" ]; then
                CUR_FILE=$0
        else
                CUR_FILE=$(pwd)/$0
        fi
        CUR_DIR=$(dirname "$CUR_FILE")
fi
#去掉路径中的相对路径，如a/..b/c
cd "$CUR_DIR"
DIR=$PWD
cd - > /dev/null
#恢复 PWD
cd "$_SAVED_PWD"

if [ -e ${DIR}/env.sh ]; then
	source ${DIR}/env.sh
fi

# 配置mutt
if [ ! -e ~/.muttrc ]; then
    sudo apt install mutt msmtp offlineimap
fi
cat >~/.muttrc<<EOF
set mbox_type=Maildir
set sendmail="/usr/bin/msmtp"

set folder=~/.mail
source ~/.mutt/mailboxes
set spoolfile="+${ACCOUNT}/INBOX"
#set record = "+${ACCOUNT}/Sent\ Message"
set postponed = "+${ACCOUNT}/Drafts"
unset record

macro index D \
    "<save-message>+${ACCOUNT}/Trash<enter>" \
    "move message to the trash"

set realname="${REAL_NAME}"
set from="${FROM}"
set mail_check = 0
set editor="vim"

# sort/threading
set sort = threads
set sort_aux = reverse-last-date-received
set sort_re

# look and feel
set pager_index_lines = 8
set pager_context = 5
set pager_stop
set menu_scroll
set smart_wrap
set tilde
unset markers

# composing
set fcc_attach
unset mime_forward
set forward_format = "Fwd: %s"
set include
set forward_quote

ignore *  # frist, ignore all headers
unignore from: to: cc: date: subject # then, show only these
hdr_order from: to: cc: date: subject # and in this order
EOF

# 配置 msmtp
cat >~/.msmtprc<<EOF
defaults
tls on
logfile ~/.msmtp.log

account netease
host smtp.163.com
port 25
from hello@163.com
auth login
tls off
user hello@163.com
password mypassword

account ${ACCOUNT}
host ${SMTP_HOST}
port ${SMTP_PORT}
from ${FROM}
auth login
tls_starttls off
tls on
tls_certcheck off
user ${USER_}
password ${PASSWORD}

account default : ${ACCOUNT}
EOF

# 配置offlineimaprc
cat >~/.offlineimaprc<<EOF
[general]
accounts = ${ACCOUNT}
# change to whatever you want
ui = ttyui

[mbnames]
enabled = yes
filename = ~/.mutt/mailboxes
header = "mailboxes "
peritem = "+%(accountname)s/%(foldername)s"
sep = " "
footer = "\n"

[Account ${ACCOUNT}]
localrepository = mylocal
# Profile-Name for the local Mails for a given Account
remoterepository = myremote
# Profile-Name for the remote Mails for a given Account
autorefresh = 5
# fetches your mails every 5 Minutes

[Repository mylocal]
type = Maildir
# Way of storing Mails locally. Only Maildir is currently supported
localfolders = ~/.mail/${ACCOUNT}
# Place where the synced Mails should be

[Repository myremote]
type = IMAP
# Type of remote Mailbox. Only IMAP is supported right now.
remotehost = ${IMAP_HOST}
# Where to connect
ssl = yes
# Whether to use SSL or not
remoteport = ${IMAP_PORT}
# Would specify a port if uncommented. That way, it just tries to use a default-port
remoteuser = ${USER_}
# Login-Name
remotepass = ${PASSWORD}
# Login-Password. -- ACHTUNG! Of course, this is not too safe. Make sure that the file is readable only by you. Even better: use some of the suggestions in the OfflineIMAP-Manual to make it safer.
maxconnection = 1
realdelete = no
sslcacertfile = /etc/ssl/certs/ca-certificates.crt
EOF

if [ ! -e ~/.config/systemd/user/offlineimap.service ]; then
    cp ${DIR}/service/offlineimap.service ~/.config/systemd/user/offlineimap.service
    cp ${DIR}/service/offlineimap.timer ~/.config/systemd/user/offlineimap.timer
fi

systemctl --user enable offlineimap.timer
