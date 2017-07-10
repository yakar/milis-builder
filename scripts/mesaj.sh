#!/bin/bash

# Kullanimi:
#	mesaj hata  "mesajimiz.." | mesaj kirmizi "mesaj.."
#	mesaj uyari "mesajimiz.." | mesaj turuncu "mesaj.."
#	mesaj bilgi "mesajimiz.." | mesaj yesil "mesaj.."
#
# NOT: hata/uyari/bilgi mesajlarinda [!], [-] ve [*] mesajın öncesinde çıkar.

mesaj() {
	local durum="$1"
	local mesaj="$2"

	case "$1" in
		hata)
			echo -e "\e[31m[!] $mesaj\e[0m" #kirmizi
			;;
		kirmizi)
			echo -e "\e[31m$mesaj\e[0m"
			;;

		uyari)
			echo -e "\e[97m[-] $mesaj\e[0m" #turuncu
			;;
		turuncu)
			echo -e "\e[97m$mesaj\e[0m"
			;;

		bilgi)
			echo -e "\e[32m[*] $mesaj\e[0m" #yesil
			;;
		yesil)
			echo -e "\e[32m$mesaj\e[0m" #yesil
			;;
	esac
}