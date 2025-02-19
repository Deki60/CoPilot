#!/bin/bash

# Définition du répertoire courant et de la version par défaut
currDir=$(pwd)
version="dev"  # Utilisation de 'dev' par défaut pour refléter ta branche GitHub
if [[ ! -z "$1" ]]; then
  version="$1"
fi

# Vérifier si Docker est installé
function check_docker_installed() {
  if ! command -v docker &> /dev/null; then
    echo "Docker n'est pas installé. Veuillez l'installer avant d'exécuter ce script."
    exit 1
  fi
}

# Build du backend avec ton fork GitHub
function build_backend() {
  echo "Build backend (version=${version})"
  cd "$currDir/backend" || exit
  docker build . --no-cache -t deki60/copilot-backend:${version}
  echo "Backend buildé avec succès !"
}

# Build du frontend avec ton fork GitHub
function build_frontend() {
  echo "Build frontend (version=${version})"
  cd "$currDir/frontend" || exit
  
  # Copie du fichier .env.example en .env si non présent
  if [[ ! -f .env ]]; then
    cp .env.example .env
  fi

  # Demander l'IP ou le domaine pour le frontend
  echo "🔹 Veuillez entrer le domaine ou l'adresse IP pour le frontend (ex: frontend.mondomaine.com) :"
  read frontendIp

  # Modification du fichier .env pour définir l'URL
  sed -i "s|0.0.0.0|${frontendIp}|g" .env

  docker build . --no-cache -t deki60/copilot-frontend:${version}
  echo "Frontend buildé avec succès !"
}

echo "🔹 Copilot Docker - Build Script"
echo "🔹 Version cible : ${version}"

# Vérification de l’installation de Docker
check_docker_installed

# Exécution des builds
build_backend
build_frontend

echo "Build terminé avec succès ! Les images sont disponibles :"
echo "Backend : deki60/copilot-backend:${version}"
echo "Frontend : deki60/copilot-frontend:${version}"
