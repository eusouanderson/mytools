# Instalação e Uso do Script de Configuração de Ambiente de Desenvolvimento em Python

Este script cria uma estrutura de diretórios organizada para um projeto Python, além de gerar arquivos essenciais como `Dockerfile`, `docker-compose.yml` e arquivos de exemplo, caso necessário. A seguir estão as instruções para instalar e usar o script.

## Pré-requisitos

- **Bash:** O script é escrito para ser executado em um ambiente Bash (Linux/macOS ou WSL no Windows).
- **Docker:** O script cria um `Dockerfile` e um arquivo `docker-compose.yml`, portanto, o Docker precisa estar instalado na sua máquina.

## Passo 1: Preparação do Ambiente

Antes de executar o script, garanta que você tenha os seguintes requisitos instalados:

### Instalar o Docker:

Se ainda não tem o Docker instalado, siga as instruções abaixo:

- **Para Linux:**
  - [Instruções para instalação no Linux](https://docs.docker.com/engine/install/)
- **Para Windows:**
  - [Instruções para instalação no Windows](https://docs.docker.com/desktop/install/windows-install/)
- **Para macOS:**
  - [Instruções para instalação no macOS](https://docs.docker.com/desktop/install/mac-install/)

### Instalar o Bash (caso necessário):

- **No Windows:** Utilize o [WSL](https://docs.microsoft.com/en-us/windows/wsl/) para rodar o Bash.
- **No macOS e Linux:** O Bash já deve estar pré-instalado.

## Passo 2: Baixar o Script

1. Crie um arquivo de script Bash em seu projeto com o nome `setup.sh`.
2. Copie o conteúdo do script a seguir para o arquivo `setup.sh`:

```bash
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

