#!/bin/bash
history -c 
set +o history
> ~/.bash_history
> /root/.bash_history
echo "export HISTCONTROL=ignorespace:ignoredups" >> ~/.bashrc
source ~/.bashrc
usermod -aG wheel root
chmod +x test1.sh
apt-get remove -y git
cd .. 
rm -rf demo25
set -o history
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
apt-get update
useradd sshuser -u 1010 -m -s /bin/bash sshuser
echo -e "P@ssw0rd\nP@ssw0rd" | passwd sshuser
usermod -aG wheel sshuser
echo "sshuser ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
sed 's/#Port 22/Port 2024/' /etc/openssh/sshd_config
sed '26i AllowUsers sshuser' /etc/openssh/sshd_config
sed 's/#MaxAuthTries 6/MaxAuthTries 2/' /etc/openssh/sshd_config
sed '105i Banner /etc/openssh/banner' /etc/openssh/sshd_config
echo "Authorized access only" > /etc/openssh/banner
systemctl restart sshd
apt-get update && apt-get install bind bind-utils -y
 set +o history
cat <<EOF > /var/lib/bind/etc/options.conf
options {
	version "unknown";
	directory "/etc/bind/zone";
	dump-file "/var/run/named_dump.db";
	statistics-file "/var/run/named.stats";
	recursing-file "/var/run/recursing";

	// disables the use of a PID file
	pid-file none;

	/*
	 * Oftenly used directives are listed below.
	 */

	listen-on { 192.168.1.62; };
	listen-on-v6 { none; };

	/*
	 * If the forward directive is set to "only", the server will only
	 * query the forwarders.
	 */
	//forward only;
	forwarders { 77.88.8.8 };
	include "/etc/bind/resolvconf-options.conf";

	/*
	 * Specifies which hosts are allowed to ask ordinary questions.
	 */
	allow-query { any; };

	/*
	 * This lets "allow-query" be used to specify the default zone access
	 * level rather than having to have every zone override the global
	 * value. "allow-query-cache" can be set at both the options and view
	 * levels.  If "allow-query-cache" is not set then "allow-recursion" is
	 * used if set, otherwise "allow-query" is used if set unless
	 * "recursion no;" is set in which case "none;" is used, otherwise the
	 * default (localhost; localnets;) is used.
	 */
	//allow-query-cache { localnets; };

	/*
	 * Specifies which hosts are allowed to make recursive queries
	 * through this server.  If not specified, the default is to allow
	 * recursive queries from all hosts.  Note that disallowing recursive
	 * queries for a host does not prevent the host from retrieving data
	 * that is already in the server's cache.
	 */
	allow-recursion { any; };

	/*
	 * Sets the maximum time for which the server will cache ordinary
	 * (positive) answers.  The default is one week (7 days).
	 */
	//max-cache-ttl 86400;

	/*
	 * The server will scan the network interface list every
	 * interface-interval minutes.  The default is 60 minutes.
	 * If set to 0, interface scanning will only occur when the
	 * configuration file is loaded.  After the scan, listeners will
	 * be started on any new interfaces (provided they are allowed by
	 * the listen-on configuration).  Listeners on interfaces that
	 * have gone away will be cleaned up.
	 */
	//interface-interval 0;
};

logging {
	// The default_debug channel has the special property that it only
	// produces output when the server’s debug level is non-zero. It
	// normally writes to a file called named.run in the server’s working
	// directory.

	// For security reasons, when the -u command-line option is used, the
	// named.run file is created only after named has changed to the new
	// UID, and any debug output generated while named is starting - and
	// still running as root - is discarded. To capture this output, run
	// the server with the -L option to specify a default logfile, or the
	// -g option to log to standard error which can be redirected to a
	// file.

	// channel default_debug {
	// 	file "/var/log/named/named.run" versions 10 size 20m;
	// 	print-time yes;
	// 	print-category yes;
	// 	print-severity yes;
	// 	severity dynamic;
	// };
};
EOF
set -o history
