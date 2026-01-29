# DEVELOPER DOCUMENTATION — Inception

## Prérequis

- Docker
- Docker Compose
- GNU Make
- Linux ou macOS

## Mise en place

Créer un fichier .env à la racine du projet contenant les variables nécessaires
au fonctionnement des services.

Aucun mot de passe n’est présent dans les Dockerfiles ou les fichiers versionnés.

## Build et lancement

make build

## Arrêt

make stop
make down

## Gestion des secrets

Docker Secrets est recommandé mais nécessite Docker Swarm.
Le projet utilise Docker Compose sans Swarm, donc les variables d’environnement sont importer
via un fichier .env non versionné sont utilisées conformément au sujet.

## Persistance des données

Les données sont stockées dans des Docker volumes pour assurer leur persistance.
docker compose volume ls 

## Sécurité et réseau

NGINX est le seul point d’entrée.
Le port 443 est le seul port exposé.
TLSv1.2 ou TLSv1.3 est utilisé.
