ONTANIMLI_OTURUM="mate-session"
[[ -z "$1" ]] && { exec $ONTANIMLI_OTURUM; }
exec "$1"
