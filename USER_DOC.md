# USER DOCUMENTATION — Inception

## Présentation du projet

Ce projet met en place une infrastructure Docker sécurisée composée de plusieurs services
communiquant entre eux via un réseau Docker dédié.

La stack fournit les services suivants :

- NGINX : serveur web et point d’entrée unique de l’infrastructure
- WordPress : application web accessible via un navigateur
- MariaDB : base de données utilisée par WordPress

L’accès à l’infrastructure se fait exclusivement via NGINX, sur le port 443, en utilisant
le protocole TLSv1.2 ou TLSv1.3.

## Démarrer et arrêter le projet

### Démarrer le projet

make build

### Arrêter le projet

make stop

### Arrêt complet et nettoyage

make down

## Accès au site web et à l’administration

Site :
https://localhost
https://kiteixei.42.fr

Administration :
https://localhost/wp-admin

## Gestion des identifiants

Les identifiants sont définis via des variables d’environnement chargées depuis un fichier .env.
Ce fichier n’est pas versionné et ne doit pas être partagé.

## Vérification du bon fonctionnement

make ps
