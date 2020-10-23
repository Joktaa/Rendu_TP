# TP4 : Déploiement multi-noeud

# 0. Prerequisites
Le Vagrantfile est à retrouvé dans ./Vagrantfile. La machine désactive selinux, ouvre son port 22, fait une mise à jour, et installe vim.

# I. Consignes générales
|Name|IP|Rôle|
|-----------|-----------|----------------|
|node1.gitea|192.168.10.11|Accueil le module gitea|
|node2.db|192.168.10.12|Accueil la BDD giteadb|
|node3.rproxy|192.168.10.13|Accueil le reverse proxy nginx|
|node4.nfs|192.168.10.14|A un dossier lié avec chacun des autres serveurs|