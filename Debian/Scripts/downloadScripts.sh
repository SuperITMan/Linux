#!/bin/bash
#Script permettant le téléchargement de tous les scripts de configuration

VERT="\\033[1;32m"
ROUGE="\\033[1;31m"
NORMAL="\\033[0;39m"

ping -c3 8.8.8.8 >/dev/null
test_ping=$?
if ! [ $test_ping -ne 0 ]
then
#Téléchargement des scripts sur github
echo "Téléchargement des scripts pour le fonctionnement du panel."
echo -ne '0%   [                                                                      >]\r'
sleep 1
wget -q https://raw.githubusercontent.com/SuperITMan/Linux/master/Debian/Scripts/networkInterfaceConf.sh -O networkInterfaceConf.sh
echo -ne '25%  [=================                                                     >]\r'
sleep 1
wget -q https://raw.githubusercontent.com/SuperITMan/Linux/master/Debian/Scripts/networkNameserverConf.sh -O networkNameserverConf.sh
echo -ne '50%  [==================================                                    >]\r'
sleep 1
wget -q https://raw.githubusercontent.com/SuperITMan/Linux/master/Debian/Scripts/firewallConfiguration.sh -O firewallConfiguration.sh
echo -ne '75%  [===================================================                   >]\r'
sleep 1
wget -q https://raw.githubusercontent.com/SuperITMan/Linux/master/Debian/Scripts/sourcesListConf.sh -O sourcesListConf.sh
echo -ne '100% [======================================================================>]\r'
sleep 1
fi

#Attribution des droits nécessaires à l'exécution des scripts
chmod +x networkInterfaceConf.sh
chmod +x networkNameserverConf.sh
chmod +x sourcesListConf.sh
chmod +x firewallConfiguration.sh

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
	[3] Configuration du pare-feu
		- iptables
	
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
	
	"3")
		./firewallConfiguration.sh
	;;
		
	"Q")
		exit ;;
	
	"q") 
		exit ;;
	
	 * )  echo "Choix invalide ! "$choice     ;;

	esac
    sleep 1

done