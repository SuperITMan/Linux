#!/bin/bash
#Script permettant la configuration du nameserver pour un VPS Debian

GREEN="\\033[1;32m"
NORMAL="\\033[0m"
BOLD="\\033[1m"

nameServerDir="/etc/resolv.conf"
tmpNmServerDir="/tmp/tmpNameServer"

if [ -f "$tmpNmServerDir" ]; then
rm "$tmpNmServerDir"
fi
touch "$tmpNmServerDir"

while [ "$isGoodNameServer" != "o" ] && [ "$isGoodNameServer" != "O" ];
do
	echo "#Name Servers\n" > "$tmpNmServerDir"
	
	#NameServer OVH 213.186.33.99
	while [ "$isGoodOVH" != "o" ] && [ "$isGoodOVH" != "O" ] && [ "$isGoodOVH" != "n" ] && [ "$isGoodOVH" != "N" ];
	do
		echo -e "Desirez-vous avoir le $BOLDDNS OVH$NORMAL en nameserver [213.186.33.99] ? ([O]ui ou [Non]) : \c"
		read -n1 isGoodOVH
		echo ""
		
		if [ "$isGoodOVH" != "o" ] && [ "$isGoodOVH" != "O" ] && [ "$isGoodOVH" != "n" ] && [ "$isGoodOVH" != "N" ]
		then 
			echo "Erreur ! Veuillez répondre [O]ui ou [N]on."
		fi
	done
	
	if [ "$isGoodOVH" == "o" ] || [ "$isGoodOVH" == "O" ]
	then
		printf "nameserver 213.186.33.99\n" >> "$tmpNmServerDir"
	fi
	
	#NameServer Google 8.8.8.8
	while [ "$isGoodGoogle1" != "o" ] && [ "$isGoodGoogle1" != "O" ] && [ "$isGoodGoogle1" != "n" ] && [ "$isGoodGoogle1" != "N" ];
	do
		echo -e "Desirez-vous avoir le $BOLDDNS Google$NORMAL en nameserver [8.8.8.8] ? ([O]ui ou [Non]) : \c"
		read -n1 isGoodGoogle1
		echo ""
		
		if [ "$isGoodGoogle1" != "o" ] && [ "$isGoodGoogle1" != "O" ] && [ "$isGoodGoogle1" != "n" ] && [ "$isGoodGoogle1" != "N" ]
		then 
			echo "Erreur ! Veuillez répondre [O]ui ou [N]on."
		fi
	done
	
	if [ "$isGoodGoogle1" == "o" ] || [ "$isGoodGoogle1" == "O" ]
	then
		printf "nameserver 8.8.8.8\n" >> "$tmpNmServerDir"
	fi

	echo "Voici votre configuration du nameserver. Merci de confirmer celle-ci plus bas."
	echo ""
	echo "-------------------------------------------------------------"
	cat "$tmpNmServerDir"
	echo ""
	echo "-------------------------------------------------------------"
	
	read -p "Confirmez-vous la configuration de l'interface reseau ? ([O]ui ou [Non]) : " -n1 isGoodNameServer
	echo ""
	
	while [ "$isGoodNameServer" != "n" ] && [ "$isGoodNameServer" != "N" ] && [ "$isGoodNameServer" != "o" ] && [ "$isGoodNameServer" != "O" ];
		do
		echo "Erreur ! Veuillez répondre [O]ui ou [N]on."
		read -p "Confirmez-vous la configuration de l'interface reseau ? ([O]ui ou [Non]) : " -n1 isGoodNameServer
		echo ""
	done
	if [ "$isGoodNameServer" == "n" ] || [ "$isGoodNameServer" == "N" ]
		then 
			echo "Erreur ! Veuillez recommencer."
			isGoodOVH=""
			isGoodGoogle1=""
	fi
done

echo -ne "Configuration de votre nameserver...\r"
if [ -f "$nameServerDir" ]
then 
	mv "$nameServerDir" "$nameServerDir".old
fi

mv "$tmpNmServerDir" "$nameServerDir"

echo -ne "Configuration de votre nameserver... ""$GREEN""fait""$NORMAL""\r"
echo ""

