Servidor HTTP para exportação de informação do sistema
Fernanda F, Luana S, Fernando F

Objetivos:
    1.	Compreender a construção e personalização de sistemas Linux embarcados.
    2.	Desenvolver uma aplicação em Python que acesse informações do sistema através dos diretórios /proc e /sys.
    3.	Criar e expor um serviço REST simples dentro do ambiente gerado com Buildroot.
    4.	Trabalhar com conceitos relacionados a processos, uso de recursos, dispositivos e interfaces do sistema operacional.

Descrição do Trabalho
    Neste projeto, foi utilizado o Buildroot para gerar uma imagem Linux embarcada contendo uma aplicação em Python 3.
    Essa aplicação, denominada linuxstatus.py, é configurada para ser executada automaticamente após o boot do sistema operacional embarcado. O programa implementa um servidor HTTP que escuta na porta 8080 e disponibiliza um endpoint REST no formato GET /status.
    Esse endpoint, quando acessado, retorna em formato JSON informações coletadas em tempo real do sistema.
    Todas as informações são obtidas dinamicamente a cada requisição, utilizando exclusivamente os arquivos do kernel expostos nos diretórios /proc e /sys.

Funcionamento Básico do Programa
    O programa consiste em um servidor HTTP simples implementado em Python. O funcionamento é descrito a seguir:
        •	Após a inicialização do sistema embarcado, o programa é executado automaticamente.
    O programa é um servidor HTTP escrito em Python que coleta informações do sistema operacional Linux e as disponibiliza em formato JSON através de uma requisição HTTP.
        •	Quando o servidor é iniciado, ele fica escutando na porta 8080.
        •	Se um cliente (navegador, curl, Postman etc.) acessar o endereço: http://0.0.0.0:8080/status, o servidor irá:
            1.	Executar funções que coletam dados diretamente dos arquivos virtuais do Linux em /proc e /sys.
            2.	Montar uma resposta no formato JSON com essas informações.
            3.	Sistema Operacional retorna através do protocolo http as informações no formato JSON.
    Caso o cliente acesse uma URL diferente de /status, o servidor retorna um erro 404 (Not Found).
    Ou seja, o programa funciona como uma API simples de monitoramento do sistema, mostrando em tempo real dados de hardware, processos, dispositivos e rede da máquina em execução.

Como executar
    1.	Executa o script de incialização da maquina target (servidor): $ ./start_qemu.sh
    2.	Abra um navegador ou use curl para acessar (cliente): curl http://localhost:8080/status

Fontes de Informação: Arquivos /proc e /sys
    O Linux fornece informações do kernel e do hardware por meio dos sistemas de arquivos virtuais /proc e /sys. Esses diretórios não contêm dados armazenados em disco, mas sim informações geradas em tempo real pelo kernel.
    A seguir, detalha-se como cada informação do programa é obtida:
    5.1 Data e Hora (get_datetime)
    •	Obtida pela biblioteca datetime do Python.
    •	Formato: YYYY-MM-DD HH:MM:SS.
    5.2 Uptime (get_uptime)
    •	Lido a partir de /proc/uptime.
    •	O arquivo contém dois valores:
    o	Primeiro → segundos desde o último boot.
    o	Segundo → tempo de inatividade acumulado da CPU.
    •	O programa pega o primeiro valor e retorna como inteiro.
    5.3 CPU (get_cpu_info)
    •	Informações vêm de dois arquivos:
    o	/proc/cpuinfo → modelo e frequência da CPU.
    o	/proc/stat → tempo gasto em diferentes estados (usuário, sistema, ocioso, etc.).
    •	Para calcular uso:
    1.	Lê valores totais e ociosos.
    2.	Espera 0,1s.
    3.	Lê novamente.
    4.	Calcula porcentagem de tempo não ocioso no intervalo.
    5.4 Memória (get_memory_info)
    •	Obtida de /proc/meminfo.
    •	Campos usados:
    o	MemTotal → memória total do sistema (KB).
    o	MemAvailable → memória disponível.
    •	Conversão para MB (divisão por 1024).
    •	used_mb = total - available.
    5.5 Versão do Sistema (get_os_version)
    •	Lida de /proc/version.
    •	Contém versão do kernel Linux e compilador usado.
    5.6 Processos (get_process_list)
    •	Diretório /proc contém subpastas nomeadas com o PID dos processos.
    •	Para cada PID, o programa lê /proc/[pid]/comm para obter o nome do processo.
    •	Retorna lista com { "pid": <número>, "name": <nome> }.
    5.7 Discos (get_disks)
    •	Informações de /proc/partitions.
    •	Cada linha descreve um dispositivo de bloco.
    •	Campos extraídos:
    o	Nome do dispositivo (sda, sdb1, etc.).
    o	Tamanho em blocos → convertido para MB.
    •	Exemplo: /dev/sda, /dev/sda1.
    5.8 Adaptadores de Rede (get_network_adapters)
    •	Interfaces listadas em /proc/net/dev.
    •	Para cada interface, tenta ler /sys/class/net/[interface]/address.
    o	Contém o endereço MAC da interface (não o IP!).
    o	Caso não esteja disponível, retorna "N/A".

