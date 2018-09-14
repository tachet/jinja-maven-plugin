------------------------------
FLASH - Scripts de déploiement
------------------------------

------------------------------
Notes
------------------------------

Le script "flash-REC6.sh" permet le déploiement complet de tous les modules FLASH sur l'environnement REC6.
Il n'a que deux paramètres : 1) la version à déployer, 2) la version en cours, à sauvegarder en vue d'un rollback.
Prérequis : la version à déployer a déjà été installée sur un autre environnement, via le script "flash-install.sh". Ce script archive les livrables localement (variable LOCALSAVEPATH).
------------------------------

Le script "flash-install.sh" permet le déploiement complet d'un ou de plusieurs modules FLASH sur un ou plusieurs environnements, de REC1 à REC5.
Il est accompagné de fichiers de configuration placés dans le dossier "conf", ainsi organisés :
- un fichier générique "flash-GEN-shell-conf.txt"
- un fichier spécifique "flash-ENV-conf.txt" par environnement (INTEG|REC1|REC2|REC3|REC4|REC5).

Les paramètres passés en ligne de commande peuvent être saisis dans n'importe quel ordre, mais ils doivent respecter l'orthographe et la casse spécifiés dans les fichiers de configuration pour les variables FCFGBDDS, FCFGDBMODULES, FCFGAPPMODULES, FCFGCLEANTYPES, FCFGEXECTYPES, FCFGENVS, et FCFGDEPLOYACTIONS.

Les actions concernées sont :
- la sauvegarde des données (paramètre "save")
- la récupération des livrables sur le serveur Nexus (paramètre "tag")
- l'arrêt des applicatifs (paramètre "stop")
- la purge des répertoires (paramètre "clean")
- le déploiement (copie) des livrables sur les serveurs (paramètre "deploy")
-----------------------------------------------------------------------------------------
Le (re)démarrage des applicatifs (paramètre "start") n'est pas complètement opérationnel.
-----------------------------------------------------------------------------------------

Une pause est ajoutée à la fin de chaque groupe d'opérations et peut être activée avec le paramètre "pause".

Les paramètres "allenvs", "allmods" et "allbdds" permettent de traiter respectivement :
- tous les environnements, 
- tous les modules, 
- toutes les bases de données (pour la sauvegarde avant déploiement).

Les webapps de l'ECM ("ecm-core", "ecm-user" et "xfadmin") étant sur la même installation de Tomcat, il est possible de les traiter simultanément avec le paramètre "tomcat".

Le paramètre "clean" permet de purger les répertoires sur les serveurs.
Il est complété par les paramètres complémentaires "logs" ou "app", qui permettent de préciser le type de nettoyage à effectuer.

L'utilisateur doit être membre du groupe "sudoers".
Le déploiement se base sur des connexions ssh aux serveurs FLASH. Pour éviter de ressaisir le mot de passe utilisateur à chaque connexion ssh, il est préférable de générer une clé ssh pour l'utilisateur sur chacun des serveurs.
Pour les mêmes raisons, il faut également paramétrer le compte exécutant les scripts pour les commandes nécessitant des accès sudo.

Pour une exécution réelle des traitements, le script doit être lancé avec le paramètre "real". Sans ce paramètre, le script se contente d'afficher les commandes à exécuter.
------------------------------


------------------------------
Utilisation
------------------------------

# Sauvegarde des données mongoDB, MariaDB ou SolR
flash-install.sh save allbdds|ecm|admin|hazelcast|solrapp allenvs|INTEG|REC1|REC2|REC3|REC4|REC5 allbdds|mongodb|mariadb|solr test|real

# Récupération des livrables sur le serveur Nexus
flash-install.sh tag allmods|ecm-core|ecm-user|admin|async|batch|erm|cache allenvs|INTEG|REC1|REC2|REC3|REC4|REC5 [1-9].[0-9]*.[0-9]* | [1-9].[0-9]*."R"[0-9]* | [1-9].[0-9]*."RC"[0-9]* | "r_"[1-9].[0-9]*.[0-9]* | 0.[0-9]* test|real

# Arrêt des modules
flash-install.sh stop allmods|tomcat|ecm-core|ecm-user|admin|async|batch|erm|cache allenvs|INTEG|REC1|REC2|REC3|REC4|REC5 test|real

# Purge des environnements (logs et applicatifs)
flash-install.sh clean logs|app allmods|tomcat|ecm-core|ecm-user|admin|async|batch|erm|cache allenvs|INTEG|REC1|REC2|REC3|REC4|REC5 test|real

# Déploiement des livrables sur les serveurs
flash-install.sh deploy allmods|tomcat|ecm-core|ecm-user|admin|async|batch|erm|cache allenvs|INTEG|REC1|REC2|REC3|REC4|REC5 test|real

# Démarrage des modules
flash-install.sh start allmods|tomcat|ecm-core|ecm-user|admin|async|batch|erm|cache allenvs|INTEG|REC1|REC2|REC3|REC4|REC5 test|real


------------------------------
Exemples d'utiisation
------------------------------

Sauvegarde de la bdd mariadb "ecm" de l'environnement REC1
flash-install.sh save ecm REC1 mariadb real

Récupération de la version "1.0.0" du livrable "ecm-core" pour l'environnement REC1
flash-install.sh tag ecm-core REC1 1.0.0 real

Simulation (omission du paramètre "real") d'arrêt du module "ecm-core" de l'environnement REC1
flash-install.sh stop ecm-core REC1

Purge des logs de toutes les webapps de l'ECM sur l'environnement REC2
flash-install.sh clean logs tomcat REC2 real

Simulation (omission du paramètre "real") de suppression du livrable du module "ecm-core" sur l'environnement REC1
flash-install.sh clean app ecm-core REC1

Déploiement du livrable du module "ecm-user" sur l'environnement REC1
flash-install.sh deploy ecm-user REC1 real

Simulation (omission du paramètre "real") de déploiement complet de tous les modules du tag 1.0.2 sur l'environnement REC1, avec une pause après chaque action
flash-install.sh complete allbdds allmods REC1 1.0.2 pause

Démarrage du module "admin" (webapp "xfadmin") sur l'environnement REC1
flash-install.sh start admin REC1 real

