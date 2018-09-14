#!/usr/bin/env bash
#------------------------------------------------------------------------------

STARTTIME=$(date +'%d/%m/%Y - %Hh%Mm%Ss')
STARTYYYYMMDD=$(date +'%Y%m%d%H%M%S')
clear
#------------------------------------------------------------------------------

function fpause {
	if [ "[$FPAUSE]" == "[]" ]
	then
		echo -e "\n" \
			"-------------------------------------------------------------------------------\n" \
			"-------------------------------------------------------------------------------\n\n\n\n"
	else
		echo -e "\nAppuyer sur la touche <Entrée> pour continuer..."
		read ENTERKEY
		case $ENTERKEY in
			*)	echo -e "Reprise du script...\n\n" ;;
		esac
	fi
#------------------------------------------------------------------------------
}


function fdemarrage {
	echo -e \
		"-------------------------------------------------------------------------------\n\n\n" \
		"                          DEMARRAGE [$STARTTIME]...\n\n\n" \
		"-------------------------------------------------------------------------------\n" \
		"\tHOSTNAME = $HOSTNAME\n" \ \
		"\tFUSER = $FUSER\n" \
		"\tFUSERLOCALSHELLURI = $FUSERLOCALSHELLURI\n" \
		"\tFUSERLOCALCONFURI = $FUSERLOCALCONFURI\n" \
		"-------------------------------------------------------------------------------\n"
#------------------------------------------------------------------------------
}


function fzip_ecmres_jar {
	if [ "[$FECMRJAR]" == "[]" ]
	then
		echo ""
	else
		echo -e "\n\n" \
			"\t--------------------------------------\n" \
			"\tRÉCUPÉRATION ET COMPRESSION DU JAR ECM\n" \
			"\t--------------------------------------\n"
		echo -e "\nNom du répertoire ERM distant contenant le JAR :" #(ex. : ow.20170912.xf-ecmRes-3.0.8)
		read FECMRDIR
		if [ "[$FECMRDIR]" == "[]" ]
		then
			echo -e "Aucun dossier à traiter\n" \
				"-------------------------------------------------------------------------------\n" \
				"-------------------------------------------------------------------------------\n\n\n\n"
		else
			echo -e "\n" \
				"\t-------------------------------------------------------\n" \
				"\tRépertoire ERM : [$FECMRDIR]\n" \
				"\t-------------------------------------------------------\n"
			if [ -d $ECMJARDOWNLOADDIR ]
			#------------------------------------------------------------------
			then
				echo -e "\tRépertoire de téléchargement local : [$ECMJARDOWNLOADDIR]\n" \
					"\t-----------------------------------------------------\n"
			else
				mkdir $ECMJARDOWNLOADDIR
			fi
			#------------------------------------------------------------------
			FECMRJARDIR=$ermIP:${ermAPPDIR}hot-deploy/$FECMRDIR
			echo -e "\tPurge du répertoire [$ECMJARDOWNLOADDIR]"
			rm -f $ECMJARDOWNLOADDIR/*
			echo -e "\t-----------------------------------------------------\n"
			#------------------------------------------------------------------
			echo -e "\tCopie du JAR ecmRes dans le répertoire local de téléchargement [$ECMJARDOWNLOADDIR]"
			FECMRCOPYCMD="scp $FECMRJARDIR/*.jar $ECMJARDOWNLOADDIR"
			echo "$FECMRCOPYCMD"
			#------------------------------------------------------------------
			if [ "[$FEXECTYPE]" == "[real]" ]
			then
				echo -e "\n" \
					"\tExécution de la commande...\n"
				$FECMRCOPYCMD
				echo -e "\t-----------------------------------------------------\n"
				FECMRZIPCMD='zip -r '$ECMJARDOWNLOADDIR/$FECMRDIR'.zip '$ECMJARDOWNLOADDIR'/*.jar'
				echo "$FECMRZIPCMD"
				if [[ `ls -A $ECMJARDOWNLOADDIR` ]]; then
					$FECMRZIPCMD
				else
					echo "Le répertoire [$ECMJARDOWNLOADDIR] est vide. Rien à zipper"
				fi
				echo -e "\t---------------------------\n"
			fi
		fi
	fi
#------------------------------------------------------------------------------
}


function fcheck_ecmc_version {
	if [ "[$FECMCVERSION]" == "[]" ]
	then
		echo ""
	else
		echo -e "\n" \
			"----------------------------------------\n" \
			"RÉCUPÉRATION DE LA VERSION DE L'ECM CORE\n" \
			"----------------------------------------\n"
		for FAPPMODULE in ${FAPPMODULES[@]};
		do
			FMODIP=$(fset_dyn_var "${FAPPMODULE}IP")
			FPOMURI=$(fset_dyn_var "${FAPPMODULE}POMURI")
			FCHECKVERSIONCMD="ssh $FUSER@$FMODIP cat $FPOMURI | grep version --color"
			echo -e "\n" \
				"\t-------------------------------------------------------------------------\n" \
				"\tCommande pour la vérification du numéro de version de l'ECM CORE :\n\n" \
				"\t$FCHECKVERSIONCMD\n\n"
			#----------------------------------
			if [ "[$FEXECTYPE]" == "[real]" ]
			then
				echo -e "\n" \
					"\t--------------------------\n" \
					"\tExécution des commandes...\n"
				$FCHECKVERSIONCMD
				echo -e "\t--------------------------\n"
			fi
		done
	fi
#------------------------------------------------------------------------------
}

#Récupération des versions d'ASYNC/ERM (à intégrer dans la gestion par envs.)
function fcheck_async-erm_versions {
	ipenvs=(4 44 14);
	for ipenv in ${ipenvs[@]}; do ssh 10.16.14.$ipenv 'apps=(async erm);
	 SHORTHOST=${HOSTNAME:6:9}; lchostname=$(echo $SHORTHOST | tr [:upper:] [:lower:]);
	 case $lchostname in tstapp005) basepaths=(/usr/share/REC1) ;; tstapp007) basepaths=(/usr/share/REC2 /usr/share/REC3) ;; tstapp047) basepaths=(/opt/REC4 /opt/REC5) ;; *) esac;
	 echo -e "\n\n\t[HOSTNAME (lowercase) : $lchostname]";
	 for app in ${apps[@]};
	 do
	  for basepath in ${basepaths[@]}
	  do appver=$(unzip -q -c $basepath/flash/$app/$app.jar META-INF/maven/eu.els.sie.xmlfirst/sie-xf-$app/pom.properties | grep version);
	   echo -e "\t[$basepath] [$app : $appver]";
	  done;
	 done';
	done
#------------------------------------------------------------------------------
}

function fset_dyn_var() {
	local varName="$1"
	declare result="${!varName}"
	echo $result
#------------------------------------------------------------------------------
}


function fset_arg_vars {
	echo -e "\n" \
		"--------------------------------------------------------------------\n" \
		"DÉFINITION DES VARIABLES À PARTIR DES ARGUMENTS EN LIGNE DE COMMANDE\n" \
		"--------------------------------------------------------------------\n\n\n" \
		"\t---------\n" \
		"\tARGUMENTS\n" \
		"\t---------\n"
	for ARG in $@
	do
		VALUE=$(echo $ARG | cut -f2 -d=)
		echo -e "\t[$VALUE]"
		#----------------------------------
		# Environnements
		for FCFGENV in ${FCFGENVS[@]};
		do
			#echo "FCFGENV : $FCFGENV"
			if [ $VALUE == $FCFGENV ] || [ $VALUE == 'allenvs' ]
			then
				FENVS+=(${FCFGENV})
			fi
		done
		#----------------------------------
		# Modules applicatifs
		for FCFGAPPMODULE in ${FCFGAPPMODULES[@]};
		do
			#echo "FCFGAPPMODULE : $FCFGAPPMODULE"
			if [ $VALUE == $FCFGAPPMODULE ] || [ $VALUE == 'allmods' ]
			then
				FAPPMODULES+=(${FCFGAPPMODULE//-/})
			fi
		done
		#----------------------------------
		# Types de bases de données
		for FCFGBDD in ${FCFGBDDS[@]};
		do
			#echo "FCFGBDD : $FCFGBDD"
			if [ $VALUE == $FCFGBDD ] || [ $VALUE == 'allbdds' ]
			then
				FBDDS+=($FCFGBDD)
			fi
		done
		#------------------------------
		# Noms des de données
		for FCFGDBMODULE in ${FCFGDBMODULES[@]};
		do
			#echo "FCFGDBMODULE : $FCFGDBMODULE"
			if [ $VALUE == $FCFGDBMODULE ] || [ $VALUE == 'allbdds' ]
			then
				FDBMODULES+=($FCFGDBMODULE)
			fi
		done
		#------------------------------
		#Scripts à exécuter
		for FCFGDEPLOYACTION in ${FCFGDEPLOYACTIONS[@]};
		do
			if [ $VALUE == $FCFGDEPLOYACTION ] || [ $VALUE == "complete" ]
			then
				FDEPLOYACTIONS+=($FCFGDEPLOYACTION)
			fi
		done
		#------------------------------
		# Type de purge : logs|app
		for FCFGCLEANTYPE in ${FCFGCLEANTYPES[@]};
		do
			if [ $VALUE == $FCFGCLEANTYPE ] || [ $VALUE == "complete" ]
			then
				FCLEANTYPES+=($FCFGCLEANTYPE)
			fi
		done
		#------------------------------
		case "$VALUE" in
			#--------------------------
			# Version de livrable FLASH
			# Idéalement, il faudrait le pattern '0\.[0-9]+(\.[0-9]+)*',
			# mais les opérateurs RegExp ne semblent pas fonctionner ici
			[1-9].[0-9]*.[0-9]* | [1-9].[0-9]*."R"[0-9]* | [1-9].[0-9]*."RC"[0-9]* | "r_"[1-9].[0-9]*.[0-9]* | 0.[0-9]*)	FMODVER=${VALUE} ;;
			#--------------------------
			# Pause dans l'exécution des principales opérations
			pause)	FPAUSE=${VALUE} ;;
			#--------------------------
			# Type d'exécution des commandes : test|real
			real)	FEXECTYPE=${VALUE} ;;
			#--------------------------
			# Version de l'ECM CORE
			ecmcver)	FECMCVERSION=${VALUE} ;;
			#--------------------------
			# JAR ecmRes à zipper
			zipjar | jarzip)	FECMRJAR=${VALUE} ;;
			#--------------------------
			# CONFIGurations à copier localement
			copyconf)	FCOPYCONFIG=${VALUE} ;;
			#--------------------------
			*)
		esac
	done
	#--------------------------------------------------------------------------
}


function fsave_mongodb {
	FMODMONGODBNAME=$(fset_dyn_var "${FDBMODULE}MONGODBNAME")
	FMODMONGODBBACKUPNAME=$(fset_dyn_var "${FDBMODULE}MONGODBBACKUPNAME")
	FMONGODBCOLLECTIONSWCARD=$(fset_dyn_var "${FDBMODULE}MONGODBCOLLECTIONSWCARD")
	FMONGODUMPDATEDIR="${FMODMONGODBBACKUPNAME}_$(date +'%Y%m%d%H%M%S')"
 	FMONGODUMPCMD="ssh $FUSER@$FDBMODIP mongodump --db $FMODMONGODBNAME --archive=$MONGODBBACKUPDIR/$FMONGODUMPDATEDIR.gz --quiet --gzip"
	#FMONGODUMPARCHIVECMD="ssh $FUSER@$FDBMODIP zip -r $MONGODBBACKUPDIR/$FMONGODUMPDATEDIR.zip $MONGODBBACKUPDIR/$FMODMONGODBNAME/$FMONGODBCOLLECTIONSWCARD"
	#FMONGODUMPCLEANCMD="ssh $FUSER@$FDBMODIP rm -rf $MONGODBBACKUPDIR/$FMODMONGODBNAME/"
	echo -e "\n" \
		"\t-------------------------------------------------------------------------\n" \
		"\tCommande pour le backup de la base [$FMODMONGODBNAME] en modes \"archive\" et \"quiet\" :\n\n" \
		"\t$FMONGODUMPCMD\n\n\n\n" \
		"\tCommande pour l'archivage du répertoire de sauvegarde :\n\n"
	#----------------------------------
	if [ "[$FEXECTYPE]" == "[real]" ]
	then
		echo -e "\n" \
			"\t--------------------------\n" \
			"\tExécution des commandes...\n"
		$FMONGODUMPCMD
		#$FMONGODUMPARCHIVECMD
		#$FMONGODUMPCLEANCMD
		echo -e "\t--------------------------\n"
	fi
	#--------------------------------------------------------------------------
}


function fsave_mariadb {
	FMODMARIADBNAME=$(fset_dyn_var "${FDBMODULE}MARIADBNAME")
	FMODMARIADBBACKUPNAME=$(fset_dyn_var "${FDBMODULE}MARIADBBACKUPNAME")
	FMARIADUMPCMD="ssh $FUSER@$MARIADBIP mysqldump -uroot --databases $FMODMARIADBNAME --default-character-set=latin1 --skip-set-charset --result-file=${MARIADBBACKUPDIR}/${FMODMARIADBBACKUPNAME}.sql"
	#Ne pas renommer la base. Sera fait par le script de sauvegarde quotidienne
	#FMARIARENAMEDBCMD="ssh $FUSER@$MARIADBIP sed -i 's/${FMODMARIADBNAME}/${FMARIADMINDBNAME}/g' ${MARIADBBACKUPDIR}/${FMODMARIADBBACKUPNAME}.sql"
	echo -e \
		"\tCommande pour le backup de la base [$FMODMARIADBNAME] ($STARTYYYYMMDD) :\n\n" \
		"\t$FMARIADUMPCMD\n\n" \
		"\t$FMARIARENAMEDBCMD\n\n"
	if [ "[$FEXECTYPE]" == "[real]" ]
	then
		echo -e "\tExécution de la commande...\n\n"
		$FMARIADUMPCMD
		#$FMARIARENAMEDBCMD
	fi
	#--------------------------------------------------------------------------
}


function fsave_solr {
	FSOLRDATEBACKUPNAME="${SOLRBACKUPNAME}_$(date +'%Y%m%d%H%M%S')"
	FSOLRSAVECMD="curl ${SOLRCOREURL}/replication -d\"command=backup&location=${SOLRTMPBACKUPDIR}&name=$FSOLRDATEBACKUPNAME\""
	FSOLRDUMPARCHIVECMD="ssh $FUSER@$SOLRIP zip -r $SOLRBACKUPDIR/$FSOLRDATEBACKUPNAME.zip $SOLRTMPBACKUPDIR/snapshot.$FSOLRDATEBACKUPNAME/*"
	FSOLRDUMPCLEANCMD="ssh -t $FUSER@$SOLRIP sudo rm -rf $SOLRTMPBACKUPDIR/snapshot.*"
	FSOLRSCPCMD="scp $SOLRBACKUPDIR/$FSOLRDATEBACKUPNAME.zip $SOLRLOCALBACKUPDIR"
	echo -e "\n" \
		"\tCommande pour le backup de la base [$FDBMODULE] :\n\n" \
		"\t$FSOLRSAVECMD\n\n\n\n" \
		"\tCommande pour l'archivage du répertoire de sauvegarde :\n\n" \
		"\t$FSOLRDUMPARCHIVECMD\n\n\n\n" \
		"\tCommande pour la suppression du répertoire de sauvegarde temporaire :\n\n" \
		"\t$FSOLRDUMPCLEANCMD\n\n"
	#----------------------------------
	if [ "[$FEXECTYPE]" == "[real]" ]
	then
		echo -e "\n" \
			"\t--------------------------\n" \
			"\tExécution des commandes...\n"
		#$FSOLRDUMPCLEANCMD
		#$FSOLRSAVECMD
		$FSOLRDUMPARCHIVECMD
		$FSOLRDUMPCLEANCMD
	fi
	#--------------------------------------------------------------------------
}


function fsave_data {
	for FBDD in ${FBDDS[@]};
	do
		FBDDUPPER="$(echo $FBDD | awk '{print toupper($FBDD)}')"
		echo -e "\n" \
			"\t------------------------------------\n" \
			"\tSAUVEGARDE DES BASES DE [$FBDDUPPER]\n" \
			"\t------------------------------------"
		for FDBMODULE in ${FDBMODULES[@]};
		do
			FDBMODIP=$(fset_dyn_var "${FDBMODULE}${FBDDUPPER}IP")
			if [ "[$FDBMODIP]" == "[]" ]
			then echo ""
			else
				echo -e "\n" \
					"\t---------------------------------\n" \
					"\tBASE [$FDBMODULE] sur [$FDBMODIP]\n" \
					"\t---------------------------------\n"
				#scp ./conf/flash-{GEN-shell,$FENV}-conf.txt $FUSER@$FDBMODIP:$FUSERCONFIG
				#----------------------
				case $FBDD in
					'mongodb')	fsave_mongodb ;;
					'mariadb')	fsave_mariadb ;;
					'solr'	)	fsave_solr;;
					*)
				esac
			fi
		done
	done
	#--------------------------------------------------------------------------
}


function fget_deliverables {
	if [ "[$FMODVER]" == "[]" ]
	then
		echo -e "\n-------------------------------------------------------------------\n" \
			"Préciser la version des livrables ou l'application à télécharger !\n" \
			"------------------------------------------------------------------"
	else
		echo -e "\n" \
			"--------------------------\n" \
			"RÉCUPÉRATION DES LIVRABLES\n" \
			"--------------------------\n"
		for FAPPMODULE in ${FAPPMODULES[@]};
		do
			FMODIP=$(fset_dyn_var "${FAPPMODULE}IP")
			FMODDELIVFNAME=$(fset_dyn_var "${FAPPMODULE}DELIVFNAME")
			FMODDELIVFEXT=$(fset_dyn_var "${FAPPMODULE}DELIVFEXT")
			FMODNEXUSFLASHDIR=$(fset_dyn_var "${FAPPMODULE}NEXUSFLASHDIR")
			FMODNEXUSDELIVDIR=$(fset_dyn_var "${FAPPMODULE}NEXUSDELIVDIR")
			FMODARTIFACT=$(fset_dyn_var "${FAPPMODULE}ARTIFACT")
			FMODOWNER=$(fset_dyn_var "${FAPPMODULE}OWNER")
			FMODPERM=$(fset_dyn_var "${FAPPMODULE}PERM")
			FMODUPPER="$(echo $FAPPMODULE | awk '{print toupper($FAPPMODULE)}')"
			#--------------------------
			CLEANCMD1="rm -f $DOWNLOADDIR/$FMODDELIVFEXT/$FMODDELIVFNAME.$FMODDELIVFEXT"
			CLEANCMD2="rm -f $DOWNLOADDIR/$FMODDELIVFEXT/$FMODARTIFACT-*.$FMODDELIVFEXT*"
			GOTODOWNLOADDIR="cd $DOWNLOADDIR/$FMODDELIVFEXT/"
			echo -e "\t-----------------------------------\n[$NEXUSFLASHBASEURL]"
			#NEXUSFLASHBASEURL=http://nexus.lefebvre-sarrut.eu/repository/releases/eu/els/sie/flash/flash-ecm-core-rest/1.1.R1/flash-ecm-core-rest-1.1.R1.war
			#NEXUSFLASHBASEURL=http://srvic/nexus/service/local/artifact/maven/redirect?r=releases&g=eu.els.sie.flash&a=
			#GETCMD="wget $FMODNEXUSFLASHDIR$FMODNEXUSDELIVDIR$FMODARTIFACT/$FMODVER/$FMODARTIFACT-$FMODVER.$FMODDELIVFEXT --content-disposition --no-proxy"
			#http://srvic/nexus/service/local/artifact/maven/redirect?r=releases&g=eu.els.sie.flash&a=flash-ecm-core-rest&v=1.1.12&e=war
			#GETCMD="wget $NEXUSFLASHBASEURL&a=$FMODARTIFACT&v=$FMODVER&e=$FMODDELIVFEXT --content-disposition --no-proxy"
			GETCMD="wget $NEXUSFLASHBASEURL/$FMODARTIFACT/$FMODVER/$FMODARTIFACT-$FMODVER.$FMODDELIVFEXT --content-disposition --no-proxy"
			RENAMECMD="mv ./$FMODARTIFACT-$FMODVER.$FMODDELIVFEXT ./$FMODDELIVFNAME.$FMODDELIVFEXT"
			SAVEDELIVFCMD="cp ./$FMODDELIVFNAME.$FMODDELIVFEXT $DELIVFSAVEDIR/$FMODVER/"
			CLEANREMOTEHOMEDIRCMD="ssh -t $FUSER@$FMODIP sudo rm -f $FUSERREMOTEHOMEDIR/$FMODDELIVFNAME.$FMODDELIVFEXT"
			CLEANREMOTEDEPLOYDIRCMD="ssh -t $FUSER@$FMODIP sudo rm -f $TMPDEPLOYDIR/$FMODDELIVFNAME.$FMODDELIVFEXT"
			SCPCMD="scp $DOWNLOADDIR/$FMODDELIVFEXT/$FMODDELIVFNAME.$FMODDELIVFEXT $FUSER@$FMODIP:"
			CHOWNCMD="ssh -t $FUSER@$FMODIP sudo chown $FMODOWNER $FUSERREMOTEHOMEDIR/$FMODDELIVFNAME.$FMODDELIVFEXT"
			CHMODCMD="ssh -t $FUSER@$FMODIP sudo chmod $FMODPERM $FUSERREMOTEHOMEDIR/$FMODDELIVFNAME.$FMODDELIVFEXT"
			MVCMD="ssh -t $FUSER@$FMODIP sudo mv $FUSERREMOTEHOMEDIR/$FMODDELIVFNAME.$FMODDELIVFEXT $TMPDEPLOYDIR"
			SCPCHECKCMD="ssh $FUSER@$FMODIP ls -l $TMPDEPLOYDIR"
			#--------------------------
			if [ "[$DOWNLOADDIR]" == "[]" ] || [ "[$FMODDELIVFEXT]" == "[]" ] || [ "[FMODDELIVFNAME]" == "[]" ]
			then
				echo -e \
					"\t---------------------------------\n" \
					"\t[$FAPPMODULE] Vérifier les dossiers !\n" \
					"\t---------------------------------\n"
			else
				echo -e "\n" \
					"\t----------------------------------\n" \
					"\tCommandes à exécuter [$FMODUPPER] :\n" \
					"\t----------------------------------\n\n" \
					"\t$CLEANCMD1\n" \
					"\t$CLEANCMD2\n" \
					"\t$GOTODOWNLOADDIR\n" \
					"\t$GETCMD\n\n" \
					"\t$RENAMECMD\n\n" \
					"\t$SAVEDELIVFCMD\n\n" \
					"\t$CLEANREMOTEHOMEDIRCMD\n\n" \
					"\t$CLEANREMOTEDEPLOYDIRCMD\n\n" \
					"\t$SCPCMD\n\n" \
					"\t$CHOWNCMD\n\n" \
					"\t$CHMODCMD\n\n" \
					"\t$MVCMD\n\n" \
					"\t$SCPCHECKCMD\n\n"
				#----------------------
				if [ "[$FEXECTYPE]" == "[real]" ]
				then
					$GOTODOWNLOADDIR
					$CLEANCMD1
					$CLEANCMD2
					$GETCMD
					$RENAMECMD
					if [ -d $DELIVFSAVEDIR/$FMODVER/ ]
					then
						echo ''
					else
						mkdir $DELIVFSAVEDIR/$FMODVER/
					fi
					$SAVEDELIVFCMD
					$CLEANREMOTEDIRSCMD
					$SCPCMD
					$CHOWNCMD
					$CHMODCMD
					$MVCMD
					$SCPCHECKCMD
				fi
			fi
			echo -e "\t---------------------------------------------------\n\n"
		done
	fi
	#--------------------------------------------------------------------------
}


function fstop_by_script {
	FMODSTOPSCRIPT=$(fset_dyn_var "${FAPPMODULE}STOPSCRIPT")
	SUDOSTOPMODULESCRIPT="ssh -t $FUSER@$FMODIP sudo $FMODSTOPSCRIPT"
	#----------------------------------
	if [ "[$FMODSTOPSCRIPT]" == "[]" ]
	then
		echo -e "\tAucun script pour arrêter le module [$FMODUPPER]"
	else
		echo -e "\tCommande d'arrêt du module [$FMODUPPER] : \n\n\t$SUDOSTOPMODULESCRIPT\n"
		#------------------------------
		if [ "[$FEXECTYPE]" == "[real]" ]
		then
			$SUDOSTOPMODULESCRIPT
		fi
	fi
	#--------------------------------------------------------------------------
}


function fstop_by_process_kill {
	#!!! Utilisation de guillemets doubles pour passer la valeur de la variable locale !!!
	FMODGREP=$(fset_dyn_var "${FAPPMODULE}GREP")
	if [ "[$FMODGREP]" == "[]" ]
	then
		echo -e \
			"\tAucun process à interrompre pour le module [$FMODUPPER]\n" \
			"\t-------------------------------------------------\n"
	else
		FMODPROCID=$(ssh $FUSER@$FMODIP "ps aux | grep $FMODGREP | awk {'print \$2'}")
		KILLPROCESSCMD="ssh -t $FUSER@$FMODIP sudo kill -9 $FMODPROCID"
		if [ "[$FMODPROCID]" == "[]" ]
		then
			echo -e "\tAucun process à interrompre pour le module [$FMODUPPER]"
		else
			echo -e "\tCommande d'arrêt du module [$FMODUPPER] : \n\n\t$KILLPROCESSCMD\n"
			#--------------------------
			if [ "[$FEXECTYPE]" == "[real]" ]
			then
				$KILLPROCESSCMD
			fi
		fi
	fi
	#--------------------------------------------------------------------------
}


function fstop_modules {
	echo -e "\n" \
		"-----------------\n" \
		"ARRÊT DES MODULES\n" \
		"-----------------"
	for FAPPMODULE in ${FAPPMODULES[@]};
	do
		FMODIP=$(fset_dyn_var "${FAPPMODULE}IP")
		#------------------------------
		FMODUPPER="$(echo $FAPPMODULE | awk '{print toupper($FAPPMODULE)}')"
		echo -e "\n ---------------------------\n" \
			"IP DU MODULE = [$FMODIP]\n" \
			"---------------------------\n"
		FMODSTOPSCRIPT=$(fset_dyn_var "${FAPPMODULE}STOPSCRIPT")
		if [ "[$FMODSTOPSCRIPT]" == "[]" ]
		then
			echo -e \
				"\tAucun script de prévu. Arrêt par suppression du process\n" \
				"\t-------------------------------------------------------\n"
			#Arrêt par suppression du process
			fstop_by_process_kill
		else
			echo -e \
				"\tArrêt par script\n" \
				"\t----------------\n"
			#Arrêt par exécution de script
			fstop_by_script
		fi
	done
	#--------------------------------------------------------------------------
}


function fclean_logs {
	echo -e "\n" \
		"\t----------------------------\n" \
		"\tPURGE DES LOGS [$FAPPMODULE]\n" \
		"\t----------------------------"
	#Pattern des logs à supprimer
	FLOGSPATTERN=$(fset_dyn_var "${FAPPMODULE}LOGSPATTERN")
	echo -e "\tFLOGSPATTERN[$FAPPMODULE] = [$FLOGSPATTERN]"
	#----------------------------------
	if [ "[$FLOGSPATTERN]" == "[]" ]
	then
		echo -e "\tAucune commande à exécuter"
	else
		SUDOCLEANLOGSCMD="ssh -t $FUSER@$FMODIP sudo rm -f $FLOGSPATTERN"
		echo -e "\n\tCommande à exécuter : [$SUDOCLEANLOGSCMD]\n"
		#------------------------------
		if [ "[$FEXECTYPE]" == "[real]" ]
		then
			$SUDOCLEANLOGSCMD
		fi
	fi
	#--------------------------------------------------------------------------
}


function fclean_apps {
	echo -e "\n" \
		"\t---------------------------------\n" \
		"\tPURGE DES LIVRABLES [$FAPPMODULE]\n" \
		"\t---------------------------------"
	#Pattern des livrables à supprimer
	FAPPPATTERN=$(fset_dyn_var "${FAPPMODULE}APPPATTERN")
	#----------------------------------
	if [ "[$FAPPPATTERN]" == "[]" ]
	then
		echo -e "\tAucune commande à exécuter"
	else
		echo -e "\tFAPPPATTERN[$FAPPMODULE] = [$FAPPPATTERN]"
		SUDOCLEANAPPCMD="ssh -t $FUSER@$FMODIP sudo rm -rf $FAPPPATTERN"
		echo -e "\n\tCommande à exécuter : [$SUDOCLEANAPPCMD]\n"
		#------------------------------
		if [ "[$FEXECTYPE]" == "[real]" ]
		then
			$SUDOCLEANAPPCMD
		fi
	fi
	#--------------------------------------------------------------------------
}


function fclean_modules {
	echo -e "\n" \
		"---------------------\n" \
		"PURGE DES RÉPERTOIRES\n" \
		"---------------------"
	for FCLEANTYPE in ${FCLEANTYPES[@]};
	do
		for FAPPMODULE in ${FAPPMODULES[@]};
		do
			#Adresse IP du module
			FMODIP=$(fset_dyn_var "${FAPPMODULE}IP")
			echo "FMODIP[$FAPPMODULE] = $FMODIP"
			#--------------------------
			if [ $FCLEANTYPE == "logs" ] || [ $FCLEANTYPE == "complete" ]
			then
				fclean_logs
			fi
			#--------------------------
			if [ $FCLEANTYPE == "apps" ] ||  [ $FCLEANTYPE == "app" ] || [ $FCLEANTYPE == "complete" ]
			then
				fclean_apps
			fi
		done
	done
	#--------------------------------------------------------------------------
}


function fdeploy_modules {
	echo -e "\n" \
		"----------------------------------\n" \
		"COPIE DES LIVRABLES SUR LE SERVEUR\n" \
		"----------------------------------"
	for FAPPMODULE in ${FAPPMODULES[@]};
	do
		FMODIP=$(fset_dyn_var "${FAPPMODULE}IP")
		FMODDELIVFNAME=$(fset_dyn_var "${FAPPMODULE}DELIVFNAME")
		FMODDELIVFEXT=$(fset_dyn_var "${FAPPMODULE}DELIVFEXT")
		FMODAPPDIR=$(fset_dyn_var "${FAPPMODULE}APPDIR")
		#------------------------------
		SUDOMODEPLOYCMD="ssh -t $FUSER@$FMODIP sudo -i mv $TMPDEPLOYDIR/$FMODDELIVFNAME.$FMODDELIVFEXT $FMODAPPDIR"
		echo -e "\n\tCommande à exécuter : \n\n\t[$SUDOMODEPLOYCMD]\n"
		#------------------------------
		if [ "[$FEXECTYPE]" == "[real]" ]
		then
			$SUDOMODEPLOYCMD
		fi
	done
	#--------------------------------------------------------------------------
}


function fstart_modules {
	echo -e "\n" \
		"---------------------\n" \
		"DÉMARRAGE DES MODULES\n" \
		"---------------------"
	for FAPPMODULE in ${FAPPMODULES[@]};
	do
		FMODIP=$(fset_dyn_var "${FAPPMODULE}IP")
		FMODGREP=$(fset_dyn_var "${FAPPMODULE}GREP")
		#------------------------------
		FMODUPPER="$(echo $FAPPMODULE | awk '{print toupper($FAPPMODULE)}')"
		#------------------------------
		echo -e "\n ---------------------------\n"
		if [ "[$FMODIP]" == "[]" ]
		then
			echo -e \
				" IP inconnue pour le module [$FMODUPPER]\n" \
				" ----------------------------------------\n"
		else
			echo -e \
				" IP DU MODULE $FMODUPPER = [$FMODIP]\n" \
				" -----------------------------------\n"
			FMODSTARTCMD=$(fset_dyn_var "${FAPPMODULE}STARTCMD")
			ssh -t $FUSER@$FMODIP "echo $FMODSTARTCMD>./conf/modstartcmd"
			if [ "[$FMODSTARTCMD]" == "[]" ]
			then
				echo -e "\tAucune commande de démarrage pour le module [$FMODUPPER]\n" \
					"\t---------------------------------------------------\n"
			else
				echo -e \
					"\tCommande de démarrage pour le module [$FMODUPPER] :\n\n" \
					"\t$FMODSTARTCMD\n" \
					"\t---------------------------------------------------\n"
				FMODPROCID=$(ssh $FUSER@$FMODIP "ps aux | grep $FMODGREP | awk {'print \$2'}")
				#----------------------
				if [ "[$FMODPROCID]" == "[]" ]
				then
					# Process non encore démarré. À démarrer
					if [ "[$FEXECTYPE]" == "[real]" ]
					then
						ssh -t $FUSER@$FMODIP /usr/bin/env bash <<'MODSTART'
						sudo -i
						SUDOMODSTARTCMD=$(cat ./conf/modstartcmd)
						$SUDOMODSTARTCMD
MODSTART
					fi
				else
					echo -e \
						"\tProcess déjà démarré !\n"
				fi
			fi
		fi
	done
	#--------------------------------------------------------------------------
}


function fstart_modules {
	echo -e "\n" \
		"---------------------\n" \
		"DÉMARRAGE DE ...\n" \
		"---------------------"
	#Cache server REC1
	ssh 10.16.14.7
	ps aux | grep [c]ache
	cd /opt/cacheserver/
	sudo ./startCacheServer.sh
	tail -f ./logs/hazelcast-server.2018-04-27.0.log

	#ERM REC1
	ssh 10.16.14.4
	ps aux | grep [e]rm.jar | grep REC1
	sudo /usr/share/REC1/flash/erm/start-erm.sh

	#ASYNC REC1
	ssh 10.16.14.4
	ps aux | grep [a]sync.jar | grep REC1
	sudo /usr/share/REC1/flash/async/start-async.sh

	#TOMCAT REC1
	ssh 10.16.14.5
	clear
	ps aux | grep [t]omcat | grep REC1
	sudo /usr/share/REC1/flash/apache-tomcat-8.5.11/bin/startup.sh
	echo -e "\n\n"
	ps aux | grep [t]omcat | grep REC1
	echo -e "\n\n"
	tail -f /usr/share/REC1/flash/apache-tomcat-8.5.11/logs/catalina.out
#------------------------------------------------------------------------------
}


function fcopy_configs {
	echo -e "\n" \
		"------------------------\n" \
		"COPIE DES CONFIGURATIONS\n" \
		"------------------------"
	if [ "[$FCOPYCONFIG]" == "[]" ]
	then
		echo -e "\tAucune commande à exécuter"
	else
		for FAPPMODULE in ${FAPPMODULES[@]};
		do
			FMODIP=$(fset_dyn_var "${FAPPMODULE}IP")
			FMODCONFDIR=$(fset_dyn_var "${FAPPMODULE}CONFIGDIR")
			FMODCONFPATT=$(fset_dyn_var "${FAPPMODULE}CONFIGFILESPATTERN")
			FMODCONFTARGET=$FUSERLOCALCONFSAVEDIR/$FENV/$FMODVER/
			#------------------------------
			if [ "[$FMODCONFDIR]" == "[]" ] || [ "[$FMODCONFPATT]" == "[]" ]
			then
				echo -e "\tAucune configuration à copier pour [$FAPPMODULE]"
			else
				CONFIGCOPYCMD="scp -r $FMODIP:${FMODCONFDIR}$FMODCONFPATT $FMODCONFTARGET"
				echo -e "\n\tCommande à exécuter : \n\n\t[$CONFIGCOPYCMD]\n"
				#------------------------------
				if [ "[$FEXECTYPE]" == "[real]" ]
				then
					$CONFIGCOPYCMD
				fi
			fi
		done
	fi
}


#------------------------------------------------------------------------------

source ./conf/flash-GEN-shell-conf.txt
fset_arg_vars $@
fdemarrage
#------------------------------------------------------------------------------

for FENV in ${FENVS[@]};
do
	echo -e "\n\n" \
		"\t---------------------\n" \
		"\tENVIRONNEMENT [$FENV]\n" \
		"\t---------------------\n"
	pwd
	if [ $HOSTNAME == 'RBFRP1230' ]
	then
		scp ./conf/flash-{GEN-shell,$FENV}-conf.txt \
			$FUSER@$CONFIGSERVERIP:$FUSERCONFIG
	fi
	source ./conf/flash-$FENV-conf.txt
	#----------------------------------
	for FDEPLOYACTION in ${FDEPLOYACTIONS[@]};
	do
		if [ $FDEPLOYACTION == "save" ]
		then
			fsave_data
			fpause
		fi
		if [ $FDEPLOYACTION == "tag" ]
		then
			fget_deliverables
			fpause
		fi
		if [ $FDEPLOYACTION == "stop" ]
		then
			fstop_modules
			fpause
		fi
		if [ $FDEPLOYACTION == "clean" ]
		then
			fclean_modules
			fpause
		fi
		if [ $FDEPLOYACTION == "deploy" ]
		then
			fdeploy_modules
			fpause
		fi
		if [ $FDEPLOYACTION == "start" ]
		then
			fstart_modules
			fpause
		fi
		if [ $FDEPLOYACTION == "zipjar" ] || [ $FDEPLOYACTION == "jarzip" ]
		then
			fzip_ecmres_jar
			fpause
		fi
		if [ $FDEPLOYACTION == "ecmcver" ]
		then
			fcheck_ecmc_version
			fpause
		fi
		if [ $FDEPLOYACTION == "copyconf" ]
		then
			fcopy_configs
			fpause
		fi
	done
done
#------------------------------------------------------------------------------

# TOUS ENVIRONNEMENTS
for FDEPLOYACTION in ${FDEPLOYACTIONS[@]};
do
	if [ $FDEPLOYACTION == "ermver" ] ||  [ $FDEPLOYACTION == "asyncver" ]
	then
		echo -e "\n" \
			"\t-------------------------------------------------------------------\n" \
			"\tAFFICHAGE DE LA VERSION DE [$FDEPLOYACTION] (TOUS ENVIRONNEMENTS)\n" \
			"\t-------------------------------------------------------------------"
		fcheck_async-erm_versions
		fpause
	fi
done
#------------------------------------------------------------------------------
