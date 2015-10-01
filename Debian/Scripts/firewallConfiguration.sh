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
	print "#!/bin/sh\n"	>	"$tmpFirewallDir"
	print "### BEGIN INIT INFO\n"	>>	"$tmpFirewallDir"
	print "# Provides:          firewall\n"	>>	"$tmpFirewallDir"
	print "# Required-Start:    $local_fs $remote_fs $network $syslog $named\n"	>>	"$tmpFirewallDir"
	print "# Required-Stop:     $local_fs $remote_fs $network $syslog $named\n"	>>	"$tmpFirewallDir"
	print "# Default-Start:     2 3 4 5\n"	>>	"$tmpFirewallDir"
	print "# Default-Stop:      0 1 6\n"	>>	"$tmpFirewallDir"
	print "# X-Interactive:     true\n"	>>	"$tmpFirewallDir"
	print "# Short-Description: firewall - iptables\n"	>>	"$tmpFirewallDir"
	print "# Description:       Start the web server and associated helpers\n"	>>	"$tmpFirewallDir"
	print "#  This script will start apache2, and possibly all associated instances.\n"	>>	"$tmpFirewallDir"
	print "#  Moreover, it will set-up temporary directories and helper tools such as\n"	>>	"$tmpFirewallDir"
	print "#  htcacheclean when required by the configuration.\n"	>>	"$tmpFirewallDir"
	print "### END INIT INFO\n\n"	>>	"$tmpFirewallDir"
	
	#Réinitialise toutes les règles existantes
	print "# Vider les tables actuelles\n"	>>	"$tmpFirewallDir"
	print "iptables -t filter -F\n\n"	>>	"$tmpFirewallDir"
	print "# Vider les règles personnelles\n"	>>	"$tmpFirewallDir"
	print "iptables -t filter -X\n\n"	>>	"$tmpFirewallDir"
	print "# Interdire toute connexion entrante et sortante\n"	>>	"$tmpFirewallDir"
	print "iptables -t filter -P INPUT DROP\n"	>>	"$tmpFirewallDir"
	print "iptables -t filter -P FORWARD DROP\n"	>>	"$tmpFirewallDir"
	print "iptables -t filter -P OUTPUT DROP\n\n"	>>	"$tmpFirewallDir"
	print "# ---\n\n"	>>	"$tmpFirewallDir"
	
	#Maintient des connexions déjà établies
	print "# Ne pas casser les connexions etablies\n"	>>	"$tmpFirewallDir"
	print "iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT\n"	>>	"$tmpFirewallDir"
	print "iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT\n\n"	>>	"$tmpFirewallDir"
	
	#Loopback
	print "# Autoriser loopback\n"	>>	"$tmpFirewallDir"
	print "iptables -t filter -A INPUT -i lo -j ACCEPT\n"	>>	"$tmpFirewallDir"
	print "iptables -t filter -A OUTPUT -o lo -j ACCEPT\n\n"	>>	"$tmpFirewallDir"
	
	#Ping
	print "# ICMP (Ping)\n"	>>	"$tmpFirewallDir"
	print "iptables -t filter -A INPUT -p icmp -j ACCEPT\n"	>>	"$tmpFirewallDir"
	print "iptables -t filter -A OUTPUT -p icmp -j ACCEPT\n\n"	>>	"$tmpFirewallDir"
	print "# ---\n\n"
	
	#SSH
	if [ -z "$sshPort" ]; then
		tmpSSHPort="22"
	else
		tmpSSHPort="$sshPort"
	fi
	echo -n "Veuillez entrer le port SSH configuré sur votre ordinateur "
	
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
done