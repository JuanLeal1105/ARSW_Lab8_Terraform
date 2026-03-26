#!/bin/bash

LB_IP=$(terraform output -raw lb_public_ip)

echo "=================================================="
echo "VALIDANDO LOAD BALANCER"
echo "IP Objetivo: $LB_IP"
echo "=================================================="

for i in {1..10}
do
   RESPONSE=$(curl -s --connect-timeout 5 http://$LB_IP)
   
   if [ $? -eq 0 ]; then
     echo "Request $i: $RESPONSE"
   else
     echo "Request $i: [Error] No hay respuesta del servidor"
   fi
   
   sleep 1
done

echo "=================================================="
echo "Validación terminada"