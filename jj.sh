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

        packetloss=`echo $dados | grep "packet loss" | awk -F ',' '{print $3}' | awk '{print $1}'`
        rrt=`echo $dados | grep "round-trip" | cut -f 6 -d "/"`
        
        situacao="Circuito degradado"
        ok='0.0%'
        nok='100.0%'
        case $packetloss in
            '0.0%') 
                echo 1 $packetloss==$ok
                situacao="Conectividade ok"
            ;;
            '100.0%')
                echo 2 $packetloss==$nok
                situacao="Hostname inacessível"
            ;;
        esac
        echo "${servidor},${ip},${rrt},${packetloss},${situacao}" | tee -a output.csv 
    done
} < $filename