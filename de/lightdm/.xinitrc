ONTANIMLI_OTURUM="xfce4-session"
[[ -z "$1" ]] && { exec $ONTANIMLI_OTURUM; }
exec "$1"
