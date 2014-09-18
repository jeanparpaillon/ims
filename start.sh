#!/bin/bash
basedir=$(cd $(dirname $0) && pwd)

function usage() {
    echo "Usage: $0 [-d] [-t] [-s] [-c <config>] [-h]"
    echo -e "\t-d           Print debug messages"
    echo -e "\t-q           Print only error messages"
    echo -e "\t-t           Start HTTP listener"
    echo -e "\t-s           Start HTTPS listener (default: HTTP)"
    echo -e "\t-h           Print this help"

}

function join {
    local IFS="$1"; shift; echo -n "$*"
}

ssldir=${basedir}/priv/ssl
cacertfile=$ssldir/cowboy-ca.crt
certfile=$ssldir/server.crt
keyfile=$ssldir/server.key

name=
debug=info
configdir=${basedir}/priv
config=${configdir}/default.config
idx=-1
http_listener="{http, occi_http, [{port, 8080}]}"
listeners[0]=${http_listener}
while getopts ":hdqtsc:x:p:" opt; do
    case $opt in
	d)
	    debug=debug
	    set -x
	    ;;
	q)
	    debug=error
	    ;;
	t)
	    idx=$(( $idx + 1 ))
	    listeners[$idx]=${http_listener}
	    ;;
	s)
	    idx=$(( $idx + 1 ))
	    listeners[$idx]="{https, occi_https, [{port, 8443}, {cacertfile, \"$cacertfile\"}, {certfile, \"$certfile\"}, {keyfile, \"$keyfile\"}]}"
	    ;;
	c)
	    if [ -e $OPTARG ]; then
		config=`pwd`/$OPTARG
	    elif [ -e ${configdir}/$OPTARG ]; then
		config=${configdir}/$OPTARG
	    else
		echo "Could not find config: "$OPTARG
		exit 1
	    fi
	    ;;
	p)
	    htpasswd=$OPTARG
	    ;;
	h)
	    usage
	    exit 0
	    ;;
	*)
	    usage
	    exit 1
	    ;;
    esac
done

if [ -d ${basedir}/deps ]; then
    depsbin=${basedir}/deps
else
    depsbin=${basedir}/..
fi

case $debug in
    debug)
	debug_app="-s reloader"
	;;
    *)
	debug_app=
	;;
esac

listeners=$(echo -n "["; join , "${listeners[@]}"; echo -n "]")

cd ${basedir}
exec erl -pa $PWD/ebin \
     $depsbin/*/ebin \
     -boot start_sasl \
     -config $config \
     -kernel error_logger silent \
     -mnesia dir "\"${basedir}/priv/Mnesia\"" \
     -lager handlers "[{lager_console_backend, $debug}]" \
     -ims listeners "$listeners" \
     $debug_app -s ims
