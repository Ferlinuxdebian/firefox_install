#!/bin/bash

# "============================================="
# "==     Firefox Script Installer v 1.0      =="
# "==                                         =="
# "==          by Fernando Debian             =="
# "==                                         =="
# "============================================="

########################################
#function extrair o tar.bz2 para /opt/##
########################################
install_firefox_opt () {
if [ -f $install ]; then
	if [ -d /opt/ ]; then #Verifica com se /opt existe, alguns pacotes deb removem esse diretório.
    echo "Instalando o firefox, por favor aguarde..."
    tar xjf $install -C /opt/ 2>/dev/null
   		   if [ $? -eq 0 ]; then #Verifica se o comando de extrair tem sucesso.
  	       desktop_icon #veja function desktop_icons
  	       echo "Firefox instalado em /opt com sucesso."
           #Pega o nome do usuário, para definir permissões na pasta firefox
  	       permission=$(grep 1000 /etc/passwd | cut -d ':' -f 1)
	         chown -R $permission:$permission /opt/firefox
	   		   ln -s /opt/firefox/firefox /usr/local/bin/firefox
				   exit 0
         else
           echo "Arquivo inválido, ou corrompido" 1>&2
           [ -d /opt/firefox ] && rm -rf /opt/firefox
    	     exit 1
         fi
	else
 	  mkdir /opt/
	  install_firefox_opt
	fi
else
  echo "Arquivo inválido ou inexistente no diretório" 1>&2
fi
}

##################################
#funtion criar ".desktop e ícone.#
##################################
desktop_icon () {
icon_path=/opt/firefox/browser/chrome/icons/default/default48.png
menu_file=/usr/share/applications/
icon_install=/usr/share/icons/hicolor/48x48/apps/
mv $icon_path $icon_install
cat << EOF > $menu_file/firefox.desktop
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=Firefox
Comment=Navegador de internet
Exec=/opt/firefox/firefox
Icon=/usr/share/icons/hicolor/48x48/apps/default48.png
Categories=Network;WebBrowser;
Terminal=false
EOF
}

############################
#function Remove o firefox.#
############################
remove_firefox () {
icon_remove=/usr/share/icons/hicolor/48x48/apps/default48.png
desktop_menu_remove=/usr/share/applications/firefox.desktop
opt=/opt/
opt_firefox=/opt/firefox
if [ -f $icon_remove -a -f $desktop_menu_remove -a -d $opt -a -d $opt_firefox ]; then
  echo "Removendo o firefox, por favor aguarde..."
  sleep 2
  rm -rf $opt_firefox
  rm -rf $icon_remove
  rm -rf $desktop_menu_remove
	rm  /usr/local/bin/firefox
else
  echo "Firefox não está instalado, ou não foi instado com esse script." 1>&2
fi
}

################
#function ajuda#
################
help_firefox () {
cat << EOF

PARA INSTALAR
firefox-install -i
firefox-install install

PARA REMOVER O FIREFOX
firefox-install -r
firefox-install remove

PARA VER A VERSÃO DO FIREFOX
firefox-install -v
firefox-install version

PARA VER ESSA TELA
firefox-install -h
firefox-install help

EOF
}

################################
#function para baixar o firefox#
################################
download_firefox () {

#  Baixa a ultima versão do firefox, do ftp da mozila, mais detalhes
#  aqui: https://ftp.mozilla.org/pub/firefox/releases/latest/README.txt
#  também verifica se o downlaod foi concluído com exito, se não for,
#  retoma e se não conseguir em 2 tentativas, sair com erro.

mkdir -p $HOME/firefox-installer0124
cd $HOME/firefox-installer0124
install="firefox-installer"

#Verifica a arquitetura da maquina, e passa esse valor para a variável "$arquitetura".
if [ `arch` = 'x86_64' ]; then
	arquitetura=linux64
else
	if [ `arch` = 'i386' ]; then
	arquiterura=linux
	else
	echo "Arquitetura não suportada."
	fi
fi

#Essa parte verifica o Downlaod do firefox.
echo
echo "Realizando o download do Firefox, por favor aguarde."
echo
wget -c -O firefox-installer "https://download.mozilla.org/?product=firefox-latest&os="$arquitetura"&lang=pt-BR" -q --show-progress
	if [ $? -eq 0 ]; then
	 sleep 2
	 echo "Firefox baixado com sucesso! Realizando a instalação"
	 install_firefox_opt
	else
	  sleep 5
	  echo
	  echo "O Download do firefox falhou, realizando uma nova tentativa de Download."
	  echo
     wget -c -O firefox-installer "https://download.mozilla.org/?product=firefox-latest&os="$arquitetura"&lang=pt-BR" -q --show-progress
    	if [ $? -eq 0 ]; then
     	 sleep 2
   	 	 echo "Nova tentativa realizando com sucesso!"
   	 	 install_firefox_opt
   		else
		    sleep 2
		    echo
   	 	  echo "Infelizmente não foi possível realizar o Downlaod do firefox."
   		  echo
   		  exit 5
	     fi
	fi
}

#################
#FIM DAS FUNÇÕES#
#################
#verifica conta root e argumentos.
if [ $(id -u) -eq 0 ]; then
  #Verifica argumentos instalar e remover.
	case $1 in
	-i|install)
	download_firefox
	;;
	-r|remove)
	remove_firefox
	;;
	-h|help)
	help_firefox
	;;
	-v|version)
  /opt/firefox/firefox --version 2> /dev/null || echo "Firefox não está instalado" 1>&2
	;;
	*) echo "Parâmetro inválido, por favor:" 1>&2
	help_firefox
	;;
	esac
else
  echo "Você precisa logar-se como root para instalar o firefox." 1>&2
fi
