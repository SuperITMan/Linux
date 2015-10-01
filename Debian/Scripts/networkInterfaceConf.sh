#!/bin/bash
#Script permettant la configuration de l'interface réseau pour un VPS sur un Serveur dédié chez OVH

GREEN="\\033[1;32m"
NORMAL="\\033[0m"
BOLD="\\033[1m"

interfacesDir="/etc/network/interfaces"
tmpInterfacesDir="/tmp/tmpInterfaces"

#ifconfig -a | egrep '^[^ ]' |  awk '{ if($1 != "lo") print $1}'

if [ -f "$tmpInterfacesDir" ]; then
rm "$tmpInterfacesDir"
touch "$tmpInterfacesDir"
fi

while [ "$isGoodConfig" != "o" ] && [ "$isGoodConfig" != "O" ];
do
	while [ "$isGoodIp" != "o" ] && [ "$isGoodIp" != "O" ];
	do
		tmpIpAddress="$ipAddress"
		echo -n "Veuillez entrer l'adresse ip à configurer [$ipAddress] : "
		read ipAddress
		if [ -z "$ipAddress" ]
		then
			ipAddress="$tmpIpAddress"
		fi
		
		echo -e "Confirmez-vous l'adresse ""$BOLD""$ipAddress""$NORMAL"" comme adresse ip ? ([O]ui ou [Non]) : \c"
		read -n1 isGoodIp
		echo ""
		while [ "$isGoodIp" != "n" ] && [ "$isGoodIp" != "N" ] && [ "$isGoodIp" != "o" ] && [ "$isGoodIp" != "O" ];
		do
		echo "Erreur ! Veuillez répondre [O]ui ou [N]on."
		echo -e "Confirmez-vous l'adresse ""$BOLD""$ipAddress""$NORMAL"" comme adresse ip ? ([O]ui ou [Non]) : \c"
		read -n1 isGoodIp
		echo ""
		done

		if [ "$isGoodIp" == "n" ] || [ "$isGoodIp" == "N" ]
		then 
			echo "Erreur ! Veuillez recommencer."
		fi
	done

	while [ "$isGoodGW" != "o" ] && [ "$isGoodGW" != "O" ];
	do
		tmpGWAddress="$gwAddress"
		echo -n "Veuillez entrer l'adresse du gateway à configurer (Chez OVH : xxx.xxx.xxx.254) [$gwAddress] : "
		read gwAddress
		if [ -z "$gwAddress" ]
		then
			gwAddress="$tmpGWAddress"
		fi

		echo -e "Confirmez-vous l'adresse ""$BOLD""$gwAddress""$NORMAL"" comme gateway ? ([O]ui ou [Non]) : \c"
		read -n1 isGoodGW
		echo ""
		while [ "$isGoodGW" != "n" ] && [ "$isGoodGW" != "N" ] && [ "$isGoodGW" != "o" ] && [ "$isGoodGW" != "O" ];
		do
		echo "Erreur ! Veuillez répondre [O]ui ou [N]on"
		echo -e "Confirmez-vous l'adresse ""$BOLD""$gwAddress""$NORMAL"" comme gateway ? ([O]ui ou [Non]) : \c"
		read -n1 isGoodGW
		echo ""
		done

		if [ "$isGoodGW" == "n" ] || [ "$isGoodGW" == "N" ]
		then 
			echo "Erreur ! Veuillez recommencer."
		fi
	done

	touch "$tmpInterfacesDir"

	printf "auto eth0\niface eth0 inet static\n\n" > "$tmpInterfacesDir"
	printf "address $ipAddress\nnetmask 255.255.255.255\nbroadcast $ipAddress\n\n" >> "$tmpInterfacesDir"
	printf "post-up route add $gwAddress dev eth0\npost-up route add default gw $gwAddress\n" >> "$tmpInterfacesDir"
	printf "post-down route del $gwAddress dev eth0\npost-down route del default gw $gwAddress" >> "$tmpInterfacesDir"

	echo "Voici votre configuration de l'interface reseau. Merci de confirmer celle-ci plus bas."
	echo ""
	echo "-------------------------------------------------------------"
	cat "$tmpInterfacesDir"
	echo ""
	echo "-------------------------------------------------------------"
	
	read -p "Confirmez-vous la configuration de l'interface reseau ? ([O]ui ou [Non]) : " -n1 isGoodConfig
	echo ""
	while [ "$isGoodConfig" != "n" ] && [ "$isGoodConfig" != "N" ] && [ "$isGoodConfig" != "o" ] && [ "$isGoodConfig" != "O" ];
		do
		echo "Erreur ! Veuillez répondre [O]ui ou [N]on"
		read -p "$gwAddress est-elle bien l'adresse désirée ? ([O]ui ou [Non]) : " -n1 isGoodConfig
		echo ""
	done
	if [ "$isGoodConfig" == "n" ] || [ "$isGoodConfig" == "N" ]
		then 
			echo "Erreur ! Veuillez recommencer."
			isGoodGW="n"
			isGoodIp="n"
	fi
done

echo -ne "Configuration de votre interface reseau...\r"
if [ -f "$interfacesDir" ]; then
mv "$interfacesDir" "$interfacesDir".old
fi
mv "$tmpInterfacesDir" "$interfacesDir"
echo -ne "Configuration de votre interface reseau... ""$GREEN""fait""$NORMAL""\r"
echo ""
echo -ne "Redémarrage de votre interface reseau...\r"
ifup eth0
echo -ne "Redémarrage de votre interface reseau... ""$GREEN""fait""$NORMAL""\r"
echo ""
