###redis运维脚本-program management 
#!/bin/bash

USAG(){
        echo "sh $0 {start|stop|restart|login|ps|tail} PORT"
}
if [ "$#" = 1 ]
then
        REDIS_PORT="6379"
elif
        [ "$#" = 2 -a -z "$(echo "$2"|sed 's/[0-9]//g')" ]
then
        REDIS_PORT="$2"
else
        USAG
        exit 0
fi

REDIS_IP=$(hostname -I|awk '{print $1}') 
PATH_DIR=/opt/redis_cluster/redis_${REDIS_PORT}/
PATH_CONF=/opt/redis_cluster/redis_${REDIS_PORT}/conf/redis_${REDIS_PORT}.conf
PATH_LOG=/opt/redis_cluster/redis_${REDIS_PORT}/logs/redis_${REDIS_PORT}.log

CMD_START(){
        redis-server ${PATH_CONF}
}

CMD_SHUTDOWN(){
        redis-cli -c -h ${REDIS_IP} -p ${REDIS_PORT} shutdown
}

CMD_LOGIN(){
        redis-cli -c -h ${REDIS_IP} -p ${REDIS_PORT}
}

CMD_PS(){
        ps -ef|grep redis
}

CMD_TAIL(){
        tail -f ${PATH_LOG}
}

case $1 in
        start)
                CMD_START
                CMD_PS
                ;;
        stop)
                CMD_SHUTDOWN
                CMD_PS
                ;;
        restart)
                CMD_START
                CMD_SHUTDOWN
                CMD_PS
                ;;
        login)
                CMD_LOGIN
                ;;
        ps)
                CMD_PS
                ;;
        tail)
                CMD_TAIL
                ;;
        *)
                USAG
esac
