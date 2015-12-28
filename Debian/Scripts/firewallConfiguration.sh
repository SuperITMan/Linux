#!/bin/bash
#Script permettant la configuration d'un firewall (iptables) pour Debian

GREEN="\\033[1;32m"
NORMAL="\\033[0m"
BOLD="\\033[1m"

firewallDir="/etc/init.d/firewall"
tmpFirewallDir="/tmp/tmpFirewall"

if [ -f "$tmpFirewallDir" ]; then
rm "$tmpFirewallDir"
fi
touch "$tmpFirewallDir"

while [ "$isGoodConfig" != "o" ] && [ "$isGoodConfig" != "O" ];
do
	#Règles de base d'un script s'exécutant au démarrage de Debian 8"
	printf "#!/bin/sh\n"	>	"$tmpFirewallDir"
	printf "### BEGIN INIT INFO\n"	>>	"$tmpFirewallDir"
	printf "# Provides:          firewall\n"	>>	"$tmpFirewallDir"
	printf "# Required-Start:    $local_fs $remote_fs $network $syslog $named\n"	>>	"$tmpFirewallDir"
	printf "# Required-Stop:     $local_fs $remote_fs $network $syslog $named\n"	>>	"$tmpFirewallDir"
	printf "# Default-Start:     2 3 4 5\n"	>>	"$tmpFirewallDir"
	printf "# Default-Stop:      0 1 6\n"	>>	"$tmpFirewallDir"
	printf "# X-Interactive:     true\n"	>>	"$tmpFirewallDir"
	printf "# Short-Description: firewall - iptables\n"	>>	"$tmpFirewallDir"
	printf "# Description:       Start the web server and associated helpers\n"	>>	"$tmpFirewallDir"
	printf "#  This script will start apache2, and possibly all associated instances.\n"	>>	"$tmpFirewallDir"
	printf "#  Moreover, it will set-up temporary directories and helper tools such as\n"	>>	"$tmpFirewallDir"
	printf "#  htcacheclean when required by the configuration.\n"	>>	"$tmpFirewallDir"
	printf "### END INIT INFO\n\n"	>>	"$tmpFirewallDir"
	
	#Réinitialise toutes les règles existantes
	printf "# Vider les tables actuelles\n"	>>	"$tmpFirewallDir"
	printf "iptables -t filter -F\n\n"	>>	"$tmpFirewallDir"
	printf "# Vider les règles personnelles\n"	>>	"$tmpFirewallDir"
	printf "iptables -t filter -X\n\n"	>>	"$tmpFirewallDir"
	printf "# Interdire toute connexion entrante et sortante\n"	>>	"$tmpFirewallDir"
	printf "iptables -t filter -P INPUT DROP\n"	>>	"$tmpFirewallDir"
	printf "iptables -t filter -P FORWARD DROP\n"	>>	"$tmpFirewallDir"
	printf "iptables -t filter -P OUTPUT DROP\n\n"	>>	"$tmpFirewallDir"
	printf "# ---\n\n"	>>	"$tmpFirewallDir"
	
	#Maintient des connexions déjà établies
	printf "# Ne pas casser les connexions etablies\n"	>>	"$tmpFirewallDir"
	printf "iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT\n"	>>	"$tmpFirewallDir"
	printf "iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT\n\n"	>>	"$tmpFirewallDir"
	printf "# ---\n\n"	>>	"$tmpFirewallDir"
	
	#Loopback
	printf "# Autoriser loopback\n"	>>	"$tmpFirewallDir"
	printf "iptables -t filter -A INPUT -i lo -j ACCEPT\n"	>>	"$tmpFirewallDir"
	printf "iptables -t filter -A OUTPUT -o lo -j ACCEPT\n\n"	>>	"$tmpFirewallDir"
	printf "# ---\n\n"	>>	"$tmpFirewallDir"
	
	#Ping
	printf "# ICMP (Ping)\n"	>>	"$tmpFirewallDir"
	printf "iptables -t filter -A INPUT -p icmp -j ACCEPT\n"	>>	"$tmpFirewallDir"
	printf "iptables -t filter -A OUTPUT -p icmp -j ACCEPT\n\n"	>>	"$tmpFirewallDir"
	printf "# ---\n\n"	>>	"$tmpFirewallDir"
	
	#SSH
	printf "# Autoriser les connexions SSH\n" >> "$tmpFirewallDir"
	printf "iptables -A INPUT -p tcp --dport ${SSH_CLIENT##* } -j ACCEPT" >> "$tmpFirewallDir"
	printf "# ---\n\n"	>>	"$tmpFirewallDir"
	
	echo "Voici votre configuration du pare-feu. Merci de confirmer celle-ci plus bas."
	echo ""
	echo "-------------------------------------------------------------"
	cat  "$tmpFirewallDir"
	echo ""
	echo "-------------------------------------------------------------"
	
	read -p "Confirmez-vous la configuration du pare-feu ? ([O]ui ou [Non]) : " -n1 isGoodConfig
	echo ""
	while [ "$isGoodConfig" != "n" ] && [ "$isGoodConfig" != "N" ] && [ "$isGoodConfig" != "o" ] && [ "$isGoodConfig" != "O" ];
		do
		echo "Erreur ! Veuillez répondre [O]ui ou [N]on"
		read -p "Confirmez-vous la configuration du pare-feu ? ([O]ui ou [Non]) : " -n1 isGoodConfig
		echo ""
	done
	if [ "$isGoodConfig" == "n" ] || [ "$isGoodConfig" == "N" ]
		then 
			echo "Erreur ! Veuillez recommencer."
	fi
done

echo -ne "Configuration de votre pare-feu...\r"
if [ -f "$firewallDir" ]; then
mv "$firewallDir" "$firewallDir".old
fi
mv "$tmpFirewallDir" "$firewallDir"
echo -ne "Configuration de votre interface pare-feu... ""$GREEN""fait""$NORMAL""\r"
echo ""