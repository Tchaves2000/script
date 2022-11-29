#!/bin/bash
echo "hostname, ip, rtt, perda_de_pacotes, status" | tee output.csv 

filename="ips.csv"
{
    read
    while IFS="," read -r servidor ip
    do 
        echo "${servidor}-${ip}"
        echo "ping -c1 ${ip}"
        dados=$(ping -c1 ${ip}) 
        #echo "${dados}"

        packetloss=`echo $dados | grep "packet loss" | awk -F ',' '{print $3}' | awk '{print $1}'`
        rrt=`echo $dados | grep "round-trip" | cut -f 6 -d "/"`
        
        situacao="Circuito degradado"
        if [ $packetloss=="100.0%" ];then
            situacao="Hostname inacessível"
        elif [ "$packetloss"=="0.0%" ]; then
            situacao="Conectividade ok"
        fi
        
        echo $servidor
        echo $ip
        echo $rrt
        echo $packetloss
        echo $situacao
        #echo "${servidor}, ${ip}, ${rtt}, $packetloss, ${situacao}"
        echo "${servidor},${ip},${rrt},${packetloss},${situacao}" | tee -a output.csv 
        #echo ${i}-${linha}\n
    done
} < $filename