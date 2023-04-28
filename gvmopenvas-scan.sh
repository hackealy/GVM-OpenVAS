#!/bin/bash

# Definir as variáveis de usuário, senha e endereço IP do alvo
USER="seu_usuario"
PASSWORD="sua_senha"
TARGET_IP="endereco_IP_do_alvo"
TARGET_NAME="nome_do_alvo"

# Criar um alvo para a varredura
TARGET_ID=$(omp -u $USER -w $PASSWORD -T $TARGET_NAME -t $TARGET_IP | awk '{print $3}' | tr -d '()')

# Iniciar a varredura e obter o ID da varredura
SCAN_ID=$(omp -u $USER -w $PASSWORD -C "Full and fast" -T $TARGET_ID | awk '{print $3}' | tr -d '()')

# Obter o status da varredura
SCAN_STATUS=$(omp -u $USER -w $PASSWORD -G $SCAN_ID | grep -E "^status" | awk '{print $2}')

# Aguardar a varredura ser concluída
while [[ $SCAN_STATUS != "Done" ]]
do
    sleep 5
    SCAN_STATUS=$(omp -u $USER -w $PASSWORD -G $SCAN_ID | grep -E "^status" | awk '{print $2}')
done

# Obter o ID do resultado da varredura
RESULT_ID=$(omp -u $USER -w $PASSWORD -R $SCAN_ID | grep -E "^report id" | awk '{print $3}' | tr -d '()')

# Exibir o relatório de vulnerabilidades
omp -u $USER -w $PASSWORD -F $RESULT_ID > relatorio_de_vulnerabilidades.html
