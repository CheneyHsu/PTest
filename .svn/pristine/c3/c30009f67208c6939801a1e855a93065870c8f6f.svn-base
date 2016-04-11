until [ $# -eq 0 ]
do
su - $1 <<EOF 2>&1
pwd;
echo "====$1===="
tmadmin -v
EOF
        shift
   done

