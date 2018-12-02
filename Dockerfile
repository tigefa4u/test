FROM tigefa/bionic

CMD ["/sbin/my_init"]
RUN mkdir -p /etc/my_init.d
COPY vncserver.sh /etc/my_init.d/vncserver.sh
RUN chmod +x /etc/my_init.d/vncserver.sh

RUN apt-get update && \
	apt-get install -y sudo apt-utils wget curl apt-transport-https dirmngr locales locales-all xz-utils \
  gnupg gnupg2 tightvncserver xterm fluxbox ca-certificates \
	libasound2 libdbus-glib-1-2 libgtk2.0-0 libgtk2.0-dev libgtk-3-dev libxrender1 libxt6 tzdata netcat \
  aria2 whois figlet git p7zip p7zip-full zip unzip && \
  add-apt-repository ppa:webupd8team/terminix -y && \
  add-apt-repository ppa:clipgrab-team/ppa -y && \
  add-apt-repository ppa:uget-team/ppa -y && \
  add-apt-repository ppa:transmissionbt/ppa -y && \
  add-apt-repository ppa:numix/ppa -y && \
  add-apt-repository ppa:numix/numix-daily -y && \
  add-apt-repository ppa:mc3man/mpv-tests -y && \
  add-apt-repository ppa:qbittorrent-team/qbittorrent-unstable -y && \
  add-apt-repository ppa:neovim-ppa/stable -y && \
  add-apt-repository ppa:webupd8team/java -y && \
  add-apt-repository ppa:certbot/certbot -y && \
  add-apt-repository ppa:chris-lea/redis-server -y && \
  add-apt-repository ppa:brightbox/ruby-ng -y && \
  echo "deb [trusted=yes] https://deb.torproject.org/torproject.org bionic main" | sudo tee /etc/apt/sources.list.d/tor.list && \
  echo "deb-src [trusted=yes] https://deb.torproject.org/torproject.org bionic main" | sudo tee -a /etc/apt/sources.list.d/tor.list && \
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
  apt-get update -yqq && apt-get dist-upgrade -yqq && \
  apt-get install -yqq ubuntu-budgie-desktop && \
  apt-get install -y lubuntu-gtk-desktop && \
  apt-get install -y git git-lfs bzr mercurial subversion command-not-found command-not-found-data gnupg gnupg2 tzdata gvfs-bin && \
  apt-get install -y gnome-system-monitor gnome-usage tilix && \
  apt-get install -y python-pip python3-pip python-apt python-xlib net-tools telnet bash bash-completion lsb-base lsb-release && \
  apt-get install -y dconf-cli dconf-editor clipit xclip flashplugin-installer caffeine python3-xlib breeze-cursor-theme htop && \
  apt-get install -y numix-gtk-theme numix-icon-theme-circle && \
  apt-get install -y tor deb.torproject.org-keyring lshw && \
  apt-get install -y language-pack-gnome-en language-pack-gnome-id && \
  apt-get autoremove -y && \
  ln -fs /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh && \
  update-alternatives --set x-terminal-emulator $(which tilix)

RUN ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LC_NUMERIC="id_ID.UTF-8" \
    LC_TIME="id_ID.UTF-8" \
    LC_COLLATE="en_US.UTF-8" \
    LC_MONETARY="id_ID.UTF-8" \
    LC_MESSAGES="en_US.UTF-8"\
    LC_PAPER="id_ID.UTF-8" \
    LC_NAME="id_ID.UTF-8" \
    LC_ADDRESS="id_ID.UTF-8" \
    LC_TELEPHONE="id_ID.UTF-8" \
    LC_MEASUREMENT="id_ID.UTF-8" \
    LC_IDENTIFICATION="id_ID.UTF-8"

####user section####
# ENV USER developer
# ENV HOME "/home/$USER"

RUN echo 'developer ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo '%developer ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo 'sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo 'www-data ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo '%www-data ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN useradd --create-home --home-dir /home/developer --shell /bin/bash developer && \
	mkdir /home/developer/.vnc/

RUN usermod -aG sudo developer && \
    usermod -aG root developer && \
    usermod -aG adm developer && \
    usermod -aG www-data developer

COPY vnc.sh /home/developer/.vnc/
COPY xstartup /home/developer/.vnc/

RUN chmod 760 /home/developer/.vnc/vnc.sh /home/developer/.vnc/xstartup && \
	chown -fR developer:developer /home/developer

# USER "$USER"
###/user section####

####Setup a VNC password####
RUN	echo vncpassw | vncpasswd -f > /home/developer/.vnc/passwd && \
	chmod 600 /home/developer/.vnc/passwd && \
  chown -fR developer:developer /home/developer

EXPOSE 5901
####/Setup VNC####

# CMD ["/home/developer/.vnc/vnc.sh"]
