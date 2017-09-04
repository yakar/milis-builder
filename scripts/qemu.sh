QEMU=`which qemu-system-x86_64`
[[ -z $QEMU ]] && mesaj hata "Qemu kurulmalıdır."; exit 1

# RAM
[[ -z $RAM ]] || [[ "$RAM" -lt "256" ]] && RAM=1024

if [ -f "$3" ]; then
	qemu-system-x86_64 --enable-kvm -m $RAM $3
else
	mesaj hata "$3 bulunamadı!"
fi
