#!/bin/sh
export ORACLE_SID=$ORACLE_SID
rman target / <<EOF
delete noprompt force archivelog all completed after 'sysdate-1/24';
EOF
