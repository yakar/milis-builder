ONTANIMLI_OTURUM="cinnamon-session"
[[ -z "$1" ]] && { exec $ONTANIMLI_OTURUM; }
exec "$1"
