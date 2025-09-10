** Relatório Técnico - SystemInfo: Servidor HTTP para exportação de informação do sistema**
Luana S, Fernanda F, Fernando N
________________________________________
1. Objetivos
O presente trabalho tem como objetivos principais:
1.	Compreender a construção e personalização de sistemas Linux embarcados.
2.	Desenvolver uma aplicação em Python que acesse informações do sistema através dos diretórios /proc e /sys.
3.	Criar e expor um serviço REST simples dentro do ambiente gerado com Buildroot.
4.	Trabalhar com conceitos relacionados a processos, uso de recursos, dispositivos e interfaces do sistema operacional.
________________________________________
2. Descrição do Trabalho
Neste projeto, foi utilizado o Buildroot para gerar uma imagem Linux embarcada contendo uma aplicação em Python 3.
Essa aplicação, denominada linuxstatus.py, é configurada para ser executada automaticamente após o boot do sistema operacional embarcado. O programa implementa um servidor HTTP que escuta na porta 8080 e disponibiliza um endpoint REST no formato GET /status.
Esse endpoint, quando acessado, retorna em formato JSON informações coletadas em tempo real do sistema.
Todas as informações são obtidas dinamicamente a cada requisição, utilizando exclusivamente os arquivos do kernel expostos nos diretórios /proc e /sys.
________________________________________
3. Funcionamento Básico do Programa
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
________________________________________
4. Como executar
1.	Executa o script de incialização da maquina target (servidor): $ ./start_qemu.sh
2.	Abra um navegador ou use curl para acessar (cliente): curl http://localhost:8080/status
5. Fontes de Informação: Arquivos /proc e /sys
O Linux fornece informações do kernel e do hardware por meio dos sistemas de arquivos virtuais /proc e /sys. Esses diretórios não contêm dados armazenados em disco, mas sim informações geradas em tempo real pelo kernel.
O diretório /proc fornece estatísticas do sistema e informações sobre processos em execução.
O diretório /sys (introduzido no kernel 2.6) expõe atributos de hardware e dispositivos através do sysfs.
A seguir, detalha-se como cada informação do programa é obtida:
________________________________________
5.1 Data e Hora (get_datetime)
Obtida pela biblioteca datetime do Python.
Formato: YYYY-MM-DD HH:MM:SS.
________________________________________
5.2 Uptime (get_uptime)
Lido a partir de /proc/uptime.
O arquivo contém dois valores:
Primeiro → segundos desde o último boot.
Segundo → tempo de inatividade acumulado da CPU.
O programa pega o primeiro valor e retorna como inteiro.
________________________________________
5.3 CPU (get_cpu_info)
Informações vêm de dois arquivos:
/proc/cpuinfo → modelo e frequência da CPU.
/proc/stat → tempos acumulados de execução em diferentes estados (usuário, sistema, ocioso, iowait, etc.).
Para calcular uso:
Lê valores totais e de tempo ocioso.
Espera 0,1s.
Lê novamente.
Calcula a porcentagem de tempo não ocioso no intervalo.
Observação: o cálculo é aproximado, pois considera apenas o tempo ocioso em relação ao total, sem detalhar outros estados da CPU.
________________________________________
5.4 Memória (get_memory_info)
Obtida de /proc/meminfo.
Campos usados:
MemTotal → memória total do sistema (KB).
MemAvailable → estimativa da memória disponível para uso sem necessidade de swap.
Conversão para MB (divisão por 1024).
Cálculo: used_mb = total - available.
________________________________________
5.5 Versão do Sistema (get_os_version)
Lida de /proc/version.
Contém versão do kernel Linux e compilador usado na construção.
________________________________________
5.6 Processos (get_process_list)
O diretório /proc contém subpastas nomeadas com o PID de cada processo.
Para cada PID, o programa lê /proc/[pid]/comm para obter o nome curto do processo.
Retorna lista com objetos no formato { "pid": <número>, "name": <nome> }.
Observação: outras informações mais completas poderiam ser obtidas em arquivos como /proc/[pid]/status ou /proc/[pid]/cmdline, mas o código não os utiliza.
________________________________________
5.7 Discos (get_disks)
Informações de /proc/partitions.
Cada linha descreve um dispositivo de bloco conhecido pelo kernel.
Campos extraídos:
Nome do dispositivo (sda, sdb1, etc.).
Tamanho em blocos → convertido para MB.
Exemplo de saída: /dev/sda, /dev/sda1.
Observação: esta abordagem mostra apenas partições e dispositivos de bloco, não a ocupação real do sistema de arquivos.
________________________________________
5.8 Adaptadores de Rede (get_network_adapters)
Interfaces listadas em /proc/net/dev.
Para cada interface, tenta ler /sys/class/net/[interface]/address.
Contém o endereço MAC da interface.
Caso não esteja disponível, retorna "N/A".

Obs: como nenhum processo estaria sendo executado normalmente, o programa “# while true; do :; done” estava rodando para realização do teste e coleta de informação.________________________________________
6. Saida JSON
 Fotos anexadas no envio da atividade
________________________________________
7. Conclusão
O trabalho permitiu compreender a integração entre sistemas Linux embarcados e aplicações em espaço de usuário. Através do uso exclusivo de arquivos em /proc e /sys, foi possível implementar um servidor REST simples, leve e sem dependências externas, capaz de fornecer informações detalhadas sobre o estado do sistema em tempo real.
Além de atender aos requisitos obrigatórios do enunciado, a atividade reforçou conceitos fundamentais de processos, monitoramento de recursos e arquitetura de sistemas embarcados, consolidando o aprendizado sobre o uso do Buildroot e a personalização de distribuições Linux.


curl http://192.168.1.10:8080/status

export LINUX_OVERRIDE_SRCDIR=/workspaces/labsisop-buildroot/linux-4.13.9/

vi /home/codespace/.bashrc
adicionar no final do arquivo

FALTOU ADICIONAR qemu-system-i386 --kernel output/images/bzImage --hda output/images/rootfs.ext2 --nographic --append "console=ttyS0 root=/dev/sda"