#!/bin/bash

# Função para exibir mensagens com destaque
function echo_msg {
    echo -e "\033[1;34m$1\033[0m"
}

# Função para criar diretórios
function create_directories {
    echo_msg "Criando diretórios de imagens e arquivos Docker..."
    mkdir -p src/assets/images/BG src/assets/images/Screenshots
}

# Função para mover imagens existentes
function move_images {
    echo_msg "Movendo imagens existentes..."
    mv src/BG/* src/assets/images/BG/
    mv src/Screenshots/* src/assets/images/Screenshots/
    mv src/orange.png src/assets/images/
}

# Função para limpar diretórios antigos
function clean_old_directories {
    echo_msg "Removendo diretórios antigos..."
    rmdir src/BG src/Screenshots
}

# Função para gerar o Dockerfile
function create_dockerfile {
    echo_msg "Gerando Dockerfile..."
    cat <<EOL > Dockerfile
# Usar imagem base do Python
FROM python:3.10-slim

# Configuração do diretório de trabalho
WORKDIR /app

# Copiar os arquivos do projeto
COPY . .

# Instalar dependências
RUN pip install --no-cache-dir -r requirements.txt

# Comando de inicialização do projeto
CMD ["python", "src/test.py"]
EOL
}

# Função para gerar docker-compose.yml
function create_docker_compose {
    echo_msg "Gerando docker-compose.yml..."
    cat <<EOL > docker-compose.yml
version: '3.8'

services:
  app:
    build: .
    volumes:
      - .:/app
    ports:
      - "8000:8000"
    command: python src/test.py
EOL
}

# Função para configurar o ambiente de desenvolvimento
function setup_development_environment {
    echo_msg "Configurando o ambiente de desenvolvimento..."

    # Verificar se o arquivo requirements.txt existe
    if [ ! -f requirements.txt ]; then
        echo_msg "Arquivo requirements.txt não encontrado! Criando um novo arquivo vazio."
        touch requirements.txt
    fi

    # Verificar se o arquivo test.py existe
    if [ ! -f src/test.py ]; then
        echo_msg "Arquivo src/test.py não encontrado! Criando um arquivo de exemplo."
        mkdir -p src
        cat <<EOL > src/test.py
# Exemplo de código Python
print("Hello, World!")
EOL
    fi
}

# Função para exibir mensagem de conclusão
function complete_message {
    echo_msg "Reorganização e configuração completa!"
}

# Execução das funções
create_directories
move_images
clean_old_directories
create_dockerfile
create_docker_compose
setup_development_environment
complete_message
