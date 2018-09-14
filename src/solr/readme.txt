=====================================================
 Installation de SOLR sur le poste de développement
=====================================================

1- Installer la version 5.5.2 de SolR dans le répertoire <SOLR_INSTALL_DIR>


2- Copier le repertoire ./solr-home dans un répertoire de travail. Le répertoire copié sera dénommé <SOLR_HOME>.


3- Démarrer SolR en définissant <SOLR_HOME> comme notre instance:

        <SOLR_INSTALL_DIR>\bin\solr start -s <SOLR_HOME> -f -p 8983 -V

   soit, par exemple:

        C:\Users\jdantan\TOOLS\solr-5.5.2\bin\solr start -s "C:\Users\jdantan\ENV\solr\sprint10" -f -p 8983 -V

   Les parametres fournis définissent:
      -s : le repertoire de l'instance (SOLR_HOME)
      -p : le port
      -f : le mode d'exécution foreground => SolR reste actif dans la console DOS. Cela permet de voir les logs directement, ce qui facilite le debogage lors du développement.
      -V : le mode verbeux => plus d'information pour débugger lors du développement


4- Créer le "core" (i.e: la collection de document indexés)

        <SOLR_INSTALL_DIR>\bin\solr create –c <core-name> -d <conf-dir>

   soit, par exemple:

        C:\Users\jdantan\TOOLS\solr-5.5.2\bin\solr create -c flash -d "C:\Users\jdantan\WKSP\ELS\sie-ecm-core\solr\configuration"

   Les paramètres fournis definissent:
     -c : le nom du core
     -d : le repertoire contenant la configuration de SolR (solrconfig.xml, schema.xml, ...)


5- Indexer le jeu de données

        java -Dc=<core_name>   <SOLR_INSTALL_DIR>\example\exampledocs\post.jar "<PROJECT_ROOT>\sie-ecm-core\solr\datasets\EditorialEntities.xml"

  soit, par exemple:

        java -Dc=flash -jar C:\Users\jdantan\TOOLS\solr-5.5.2\example\exampledocs\post.jar "C:\Users\jdantan\WKSP\ELS\sie-ecm-core\solr\datasets\EditorialEntities.xml"

  Les paramètres fournis definissent:
    -Dc : le nom du core (passé sous forme de propriété Java)
    ...EditorialEntities.xml : réfence le dataset à indexer