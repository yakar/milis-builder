ONTANIMLI_OTURUM="awesome"
[[ -z "$1" ]] && { exec $ONTANIMLI_OTURUM; }
exec "$1"
