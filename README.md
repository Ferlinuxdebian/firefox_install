# Script para instalar o Firefox no Debian.

Esse script foi criado para instalar o Firefox na sua versão mais recente, nas versões estáveis do Debian, 
porém com a chegada dos novos tipos de pacotes, como flatpak, esse script já não é tão relevante, mas pode ser útil para 
quem não deseja usar esses novos formatos, ou por algum outro motivo. 

## Funcionamento
O script foi testado no Debian Jessie e Stretch, e necessita do wget e ferramentas como o tar e bzip2, comuns em qualquer
distribuição. 
Ele usa o wget com o link do **FTP (oficial)** da Mozilla, para baixar o Firefox, você pode ver mais detalhes nesse link:
https://ftp.mozilla.org/pub/firefox/releases/latest/README.txt

Ele cria no diretório root, um diretório chamado “firefox-installer0124” que armazenará o download do Firefox realizado pelo
wget, mesmo se cancelado, o wget tem a capacidade de retomar, poupando tempo e banda. 

Após o download, o script verifica se o tarball está integro, e instala o Firefox em /opt/firefox, criando links e 
proporcionando uma entrada no menu, essa entrada usa o ícone oficial, disponível no próprio tarball do Firefox.

A versão do Firefox instala por esse script é em português, outro detalhe importante é que ele não substituí ou 
remove a versão padrão ESR já presente no debian.

## Instalação 

Para rodar o script, como root, siga os passos abaixo. 

```
git clone https://github.com/Ferlinuxdebian/firefox_install.git
```
```
cd firefox_install
```
```
chmod +x firefox-install.sh  
```
```
./firefox-install.sh
```
### Screenshot
![alt text](https://i.imgur.com/GM4lyXu.png)

### Vídeo de demostração

https://goo.gl/nWC75o
