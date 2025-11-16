# Utiliser une image de base compatible Raspberry Pi (Debian/Ubuntu ARM)
FROM arm64v8/debian:bookworm

# Mettre à jour et installer Cockpit
RUN apt-get update && \
    apt-get install -y \
        cockpit \
        systemd \
        sudo \
        network-manager \
        iproute2 \
        && apt-get clean && rm -rf /var/lib/apt/lists/*

# Créer un utilisateur administrateur avec mot de passe
RUN useradd -m -s /bin/bash admin && \
    echo "admin:admin123" | chpasswd && \
    usermod -aG sudo admin

# Activer NetworkManager au démarrage
RUN systemctl enable NetworkManager

# Créer une interface dummy et l’ajouter à NetworkManager
RUN ip link add fake0 type dummy

# Exposer le port par défaut de Cockpit
EXPOSE 9090

# Activer systemd dans le conteneur
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
