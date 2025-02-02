# **Controle de Motor CC com PWM, Sensor Hall e Módulo de Controle**

## 📌 **Descrição do Projeto**
Este projeto implementa um sistema de controle para um motor de corrente contínua (CC), utilizando:
- **Módulo de Potência (PWM)**: Responsável por fornecer a potência necessária ao motor por meio da modulação por largura de pulso (PWM).
- **Módulo de Monitoramento (Sensor Hall)**: Realiza a leitura da posição do motor e, a partir dessa informação, monitora sua velocidade.
- **Módulo de Controle**: Integra os módulos anteriores e ajusta dinamicamente a velocidade do motor ao longo do tempo.

Os módulos mencionados são implementados dentro do código em VHDL, estruturados para execução na FPGA Nexys 2.

## ⚙️ **Funcionamento**
1. O **Módulo de Potência** utiliza sinais PWM para controlar a tensão aplicada ao motor, permitindo ajustes na velocidade de rotação.
2. O **Módulo de Monitoramento** usa um sensor Hall para capturar a posição do eixo do motor e calcular a velocidade com base nessas leituras.
3. O **Módulo de Controle** recebe os dados do sensor Hall, processa a informação e ajusta o sinal PWM conforme necessário para manter a velocidade desejada.

## 🛠️ **Tecnologias e Componentes Utilizados**
- **FPGA Nexys 2**
- **Xilinx ISE 14.7** para implementação na FPGA Nexys 2
- **Vivado 2024.2** para simulações dos códigos
- **VHDL** como linguagem de descrição de hardware
- **Sensor Hall** (módulo de efeito Hall digital)
- **Motor CC**
- **Fonte de Alimentação**
- **FPGA** responsável por integrar os módulos e manter a estabilidade da velocidade.

## 🔧 **Aplicações**
Este sistema pode ser utilizado em diversas áreas, como:
- Controle preciso de velocidade em motores de pequeno e médio porte
- Implementação em sistemas de automação industrial para controle de atuadores
- Aplicações robóticas que exigem ajuste dinâmico de velocidade
- Projetos acadêmicos e de pesquisa voltados para controle de motores em FPGA

## 🚀 **Como Executar o Projeto**
1. Conecte os módulos à FPGA Nexys 2 conforme o esquema elétrico.
2. Utilize o Xilinx ISE para a implementação na FPGA.
3. Use o Vivado 2024.2 para simular e validar os códigos.
4. Ajuste os parâmetros de controle conforme a necessidade.
5. Monitore a velocidade do motor.

## 📜 **Conclusão**
Este projeto demonstra um sistema eficiente e modular para controle de velocidade de um motor CC. A combinação do PWM, sensor Hall e módulo de controle com uma placa FPGA, permite um ajuste preciso e dinâmico da velocidade.

🔹 Criado por Thalles Mikael Cunha da Silva
