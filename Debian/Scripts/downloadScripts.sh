#!/bin/bash
#Script permettant le téléchargement de tous les scripts de configuration

VERT="\\033[1;32m"
ROUGE="\\033[1;31m"
NORMAL="\\033[0;39m"

#Téléchargement des scripts sur github
echo "Téléchargement des scripts pour le fonctionnement du panel."
echo -ne '0%  [                                                                      >]\r'
sleep 1
wget -q https://raw.githubusercontent.com/SuperITMan/Linux/master/Debian/Scripts/networkInterfaceConf.sh -O networkInterfaceConf.sh
echo -ne '0%  [                                                                      >]\r'
sleep 1
wget -q https://raw.githubusercontent.com/SuperITMan/Linux/master/Debian/Scripts/networkNameserverConf.sh -O networkNameserverConf.sh
echo -ne '0%  [                                                                      >]\r'
sleep 1
wget -q https://raw.githubusercontent.com/SuperITMan/Linux/master/Debian/Scripts/sourcesListConf.sh -O sourcesListConf.sh


#Attribution des droits nécessaires à l'exécution des scripts
chmod +x networkInterfaceConf.sh
chmod +x networkNameserverConf.sh
chmod +x sourcesListConf.sh

while :
do
	clear
cat<<EOF
==============================================================
                    Configuration Debian
==============================================================
Veuillez choisir votre option

	[1] Configuration reseau
		- interface eth0 + nameserver
	[2] Configuration des sources de Debian
		- sources.list
	[3] ...
		- 
	[4] 
		- 
	[5] 
		- 
	[6] 
		- 
	
	[Q]uitter le script
	
--------------------------------------------------------------

EOF

	read -n1 -s choice
	
	case "$choice" in
	
	#Configuration réseau
	"1")
		./networkInterfaceConf.sh
		./networkNameserverConf.sh
	;;
	"2")
		./sourcesListConf.sh
	;;
		
	"Q")
		exit ;;
	
	"q") 
		exit ;;
	
	 * )  echo "Choix invalide ! "$choice     ;;

	esac
    sleep 1

done