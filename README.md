*this project has been created as part of the 42 curriculum by **kiteixei.***

# DESCRIPTION

Inception a pour objectif de nous faire découvrir Docker et les principes fondamentaux de la containerisation.

Le but final du projet est de pouvoir lancer, à l’aide d’une seule commande, **trois conteneurs Docker** qui communiquent entre eux grâce à **Docker Network**.

Le projet impose de travailler à l’intérieur d’une **machine virtuelle**. À première vue, une machine virtuelle et Docker peuvent sembler similaires, mais leur fonctionnement est fondamentalement différent.

Docker permet de lancer une application dans un environnement stable et isolé, **sans la lourdeur d’une machine virtuelle complète**. Les conteneurs Docker interagissent directement avec le **kernel** du système hôte, tandis qu’une machine virtuelle simule un environnement matériel complet à l’aide d’un **hyperviseur** (programme qui émule une machine physique).

Cette différence d’architecture explique pourquoi Docker est plus léger et plus rapide, alors que la machine virtuelle est généralement plus sécurisée, car elle n’interagit pas directement avec le kernel de la machine hôte, aussi appelé **bare metal**.

# INSTRUCTIONS

## make build

Construit les trois images Docker et lance les conteneurs associés.

## make down

Arrête tous les conteneurs en cours d’exécution et supprime les volumes.

## make stop

Arrête les conteneurs sans supprimer les volumes.

## make ps

Affiche la liste des conteneurs en cours d’exécution.

# RESSOURCES

- https://tuto.grademe.fr/inception/#sujet
- https://hub.docker.com/_/mariadb
- https://hub.docker.com/_/wordpress
- https://hub.docker.com/u/library
- https://blog.stephane-robert.info/docs/conteneurs/moteurs-conteneurs/docker/network/
- https://www.youtube.com/watch?v=aN4PCILrbBg
- https://fr.wikipedia.org/wiki/Transport_Layer_Security
- https://www.it-connect.fr/chapitres/le-protocole-tcp/

L’intelligence artificielle a été utilisée pour expliquer en détail la partie **Docker Network** et aider à la compréhension des concepts liés aux communications entre conteneurs.

# ADDITIONAL SECTIONS

Pour ce projet, le choix s’est porté sur **Debian Bookworm** comme base pour tous les conteneurs.

Cette version correspond aux recommandations du sujet. Debian a été préférée à Alpine car elle est plus accessible, utilise le gestionnaire de paquets **apt**, et offre une documentation plus riche, ce qui facilite la configuration et le débogage des conteneurs.

Introduction aux Réseaux Docker

Docker utilise des réseaux pour permettre aux conteneurs de communiquer entre eux et avec le monde extérieur. Par défaut, Docker crée un réseau bridge, mais il existe d'autres types de réseaux adaptés à différents scénarios.
Comprendre ces réseaux est essentiel pour déployer des applications Docker complexes.

## MACHINE VIRTUAL VS DOCKER

Sur la machine hôte :

Application → Kernel → Bare metal (CPU, RAM, disque, etc.)

Dans une machine virtuelle :

Application → Hyperviseur → Kernel → Bare metal

Dans un conteneur Docker :

Application → Kernel → Bare metal

La machine virtuelle est donc plus sécurisée mais plus lourde à déployer et à transporter.

À l’inverse, les conteneurs Docker sont **légers, rapides et scalables**, ce qui permet de déployer très rapidement un environnement identique sur plusieurs machines.

## Secrets vs Variables d’environnement

Les variables d’environnement sont utilisées pour stocker des informations nécessaires au fonctionnement des services (identifiants, mots de passe, configuration).

Elles peuvent être définies via des fichiers ou directement exportées sur le système.

Dans le cadre de ce projet, les variables d’environnement sont privilégiées afin de rester conformes aux contraintes pédagogiques du sujet.

# Docker Network vs Host Network

Docker propose plusieurs types de réseaux, chacun ayant ses propres caractéristiques et cas d'utilisation. Les principaux sont :
Bridge: Le réseau par défaut, utilisé pour la communication entre les conteneurs sur le même hôte Docker.
Host: Supprime l'isolation réseau entre le conteneur et l'hôte Docker.
None: Isole complètement le conteneur du réseau.
Overlay: Permet aux conteneurs de communiquer sur plusieurs hôtes Docker (nécessite Docker Swarm).
Macvlan: Attribue une adresse MAC directement à l'interface réseau du conteneur.

1. Réseau Bridge

Le réseau bridge est le réseau par défaut créé par Docker. Il permet aux conteneurs de communiquer entre eux en utilisant des adresses IP internes. 
Docker crée un pont réseau (généralement docker0) sur l'hôte, et chaque conteneur connecté à ce réseau reçoit une adresse IP de ce sous-réseau.

Schéma :
+---------------------+    +---------------------+    +---------------------+
| Conteneur 1         |    | Conteneur 2         |    | Conteneur 3         |
| IP: 172.17.0.2      |    | IP: 172.17.0.3      |    | IP: 172.17.0.4      |
+---------------------+    +---------------------+    +---------------------+
         |                      |                      |
         +----------------------+----------------------+
                            |
                            |
            +-------------------------------+
            | Docker Bridge (docker0)       |
            | IP: 172.17.0.1                |
            +-------------------------------+
                            |
            +-------------------------------+
            | Hôte Docker                   |
            +-------------------------------+

Utilisation :

Communication entre les conteneurs sur le même hôte.
Exposition des ports des conteneurs vers l'extérieur en utilisant le port forwarding.
Création d'un réseau bridge personnalisé :
docker network srcs_inception dans notre cas.

2. --network host

Le conteneur partage directement la pile reseau de la machine hote 

Le conteneur utilise la meme ip que l'hote
les meme interfaces reseau 
les meme ports 
Aucun bridge docker 

Cas d'utilisation 

Acceder a la pile reseau linux reel plus precisement pour des applications reseaux de bas niveau (analyse de paquets,VPN..)

## Docker volumes vs Bind Mounts 

Un bind mount relie directement un dossier de la machine hote a un dossier du conteneur.
Le contenu existant dans l'image a cet emplacement est masquer par celui de l'hote. Si le dossier hote est vide l'application peut ne plus fonctionner.

Un volume Docker est gerer par Docker. Lors de la premiere utilisation, si le volume est vide et que le dossier de l'image contient des fichiers, Docker copie ces fichiers dans le volume avant de le
monter.Cela evite de msaquer les donnees necessaire au fonctionnement de l'application.

Les deux on des utilisation differente l'un va etre utiliser pour de la base de donnes, CMS, donnes persistante, il va initialiser pour eviter de casser l'applicaiton 
alors que le bind mount est fait pour editer du code en live, injecter des configs locales, acceder a des fichiers systeme, faire du debug 

Un bind mount partage directement les fichiers du projets avec le contenneur, ce qui permet des modifications en temp reel. Un volume docker stocke les fichiers dans un espace interne a Docker
separe du projet local ce qui rend l'edition direct du code moins pratique 