#! /bin/sh

### BEGIN INIT INFO
# Provides:          pgpool2
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Should-Start:      postgresql
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: start pgpool-II
# Description: pgpool-II is a connection pool server and replication
#              proxy for PostgreSQL.
### END INIT INFO


PATH=/sbin:/bin:/usr/sbin:/usr/bin:/home/postgres/sbin
DAEMON=/usr/sbin/pgpool
PIDFILE=/var/run/pgpool/pgpool.pid
PGPOOLLOG=/var/log/pgpool/pgpool.log
PGPUSER=postgres

test -x $DAEMON || exit 5

# Include pgpool defaults if available
if [ -f /etc/default/pgpool2 ] ; then
	. /etc/default/pgpool2
fi

# Create the log file if it does not exist
if [ ! -x $PGPOOLLOG ]
then
	touch $PGPOOLLOG
	chown postgres:postgres $PGPOOLLOG
fi

OPTS=""
if [ x"$PGPOOL_LOG_DEBUG" = x"yes" ]; then
	OPTS="$OPTS -d"
fi

. /lib/lsb/init-functions


is_running() {
	pidofproc -p $PIDFILE $DAEMON >/dev/null
}


d_start() {
	if ! test -d /var/run/pgpool; then
		install -d -m 2775 -o postgres -g postgres /var/run/pgpool
	fi

	if is_running; then
		:
	else
		su - $PGPUSER -c "$DAEMON -n $OPTS &" >>$PGPOOLLOG 2>&1
	fi
}


d_stop() {
	killproc -p $PIDFILE $DAEMON -INT
	status=$?
	[ $status -eq 0 ] || [ $status -eq 3 ]
	return $?
}


d_reload() {
	killproc -p $PIDFILE $DAEMON -HUP
	status=$?
	[ $status -eq 0 ] || [ $status -eq 3 ]
	return $?
}


case "$1" in
    start)
	log_daemon_msg "Starting pgpool-II" pgpool
	d_start
	log_end_msg $?
	;;
    stop)
	log_daemon_msg "Stopping pgpool-II" pgpool
	d_stop
	log_end_msg $?
	;;
    status)
	is_running
	status=$?
	if [ $status -eq 0 ]; then
		log_success_msg "pgpool-II is running."
	else
		log_failure_msg "pgpool-II is not running."
	fi
	exit $status
	;;
    restart|force-reload)
	log_daemon_msg "Restarting pgpool-II" pgpool
	d_stop && sleep 1 && d_start
	log_end_msg $?
	;;
    try-restart)
	if $0 status >/dev/null; then
		$0 restart
	else
		exit 0
	fi
	;;
    reload)
	exit 3
	log_daemon_msg "Reloading pgpool-II" pgpool
	d_reload
	log_end_msg $?
	;;
    *)
	log_failure_msg "Usage: $0 {start|stop|status|restart|try-restart|reload|force-reload}"
	exit 2
	;;
esac

