#!/bin/bash
#Script permettant la configuration du fichier source list pour un VPS Debian

GREEN="\\033[1;32m"
NORMAL="\\033[0m"
BOLD="\\033[1m"

sourceListDir="/etc/apt/sources.list"
tmpSourceListDir="/tmp/tmpSourcesList"

if [ -f "$tmpSourceListDir" ]; then
rm "$tmpSourceListDir"
fi
touch "$tmpSourceListDir"

while [ "$isGoodSourcesList" != "o" ] && [ "$isGoodSourcesList" != "O" ];
do
	echo "#Sources list\n" > "$tmpSourceListDir"
	
	#Sources pour un serveur chez OVH
	while [ "$isGoodOVH" != "o" ] && [ "$isGoodOVH" != "O" ] && [ "$isGoodOVH" != "n" ] && [ "$isGoodOVH" != "N" ];
	do
		echo -e "Votre serveur est-il hébergé chez OVH ? ([O]ui ou [Non]) : \c"
		read -n1 isGoodOVH
		echo ""
		
		if [ "$isGoodOVH" != "o" ] && [ "$isGoodOVH" != "O" ] && [ "$isGoodOVH" != "n" ] && [ "$isGoodOVH" != "N" ]
		then 
			echo "Erreur ! Veuillez répondre [O]ui ou [N]on."
		fi
	done
	
	if [ "$isGoodOVH" == "o" ] || [ "$isGoodOVH" == "O" ]
	then
		printf "deb http://debian.mirrors.ovh.net/debian/ jessie main\n" >> "$tmpSourceListDir"
		printf "deb-src http://debian.mirrors.ovh.net/debian/ jessie main\n\n" >> "$tmpSourceListDir"
		
		printf "deb http://debian.mirrors.ovh.net/debian/ jessie-updates main\n" >> "$tmpSourceListDir"
		printf "deb-src http://debian.mirrors.ovh.net/debian/ jessie-updates main\n\n" >> "$tmpSourceListDir"
	else
		printf "deb http://http.debian.net/debian jessie main\n" >> "$tmpSourceListDir"
		printf "deb-src http://http.debian.net/debian jessie main\n\n" >> "$tmpSourceListDir"
		
		printf "deb http://http.debian.net/debian jessie-updates main\n" >> "$tmpSourceListDir"
		printf "deb-src http://http.debian.net/debian jessie-updates main\n\n" >> "$tmpSourceListDir"
	fi
	
	printf "deb http://security.debian.org/ jessie/updates main\n" >> "$tmpSourceListDir"
	printf "deb-src http://security.debian.org/ jessie/updates main\n\n" >> "$tmpSourceListDir"
	
	echo "Voici votre configuration du liste de sources. Merci de confirmer celle-ci plus bas."
	echo ""
	echo "-------------------------------------------------------------"
	cat "$tmpSourceListDir"
	echo ""
	echo "-------------------------------------------------------------"
	
	read -p "Confirmez-vous la configuration de la liste de sources ? ([O]ui ou [Non]) : " -n1 isGoodSourcesList
	echo ""
	
	while [ "$isGoodSourcesList" != "n" ] && [ "$isGoodSourcesList" != "N" ] && [ "$isGoodSourcesList" != "o" ] && [ "$isGoodSourcesList" != "O" ];
		do
		echo "Erreur ! Veuillez répondre [O]ui ou [N]on."
		read -p "Confirmez-vous la configuration de la liste de sources ? ([O]ui ou [Non]) : " -n1 isGoodSourcesList
		echo ""
	done
	if [ "$isGoodSourcesList" == "n" ] || [ "$isGoodSourcesList" == "N" ]
		then 
			echo "Erreur ! Veuillez recommencer."
			isGoodOVH=""
	fi
done

echo -ne "Configuration de votre liste de sources...\r"
if [ -f "$sourceListDir" ]
then 
	mv "$sourceListDir" "$sourceListDir".old
fi

mv "$tmpSourceListDir" "$sourceListDir"

echo -ne "Configuration de votre liste de sources... ""$GREEN""fait""$NORMAL""\r"
echo ""