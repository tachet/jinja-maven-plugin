#!/bin/sh

# Usage :
# downloadArtifactSnapShot "<groupId>" "<artifactId>" "<version>" "<packaging type>"
# Example: downloadArtifactSnapShot "eu/els/sie/flash" "flash-async" "2.0.0-SNAPSHOT" "jar"
# groupId : use "/" caracter for groupId.
# This function use the caller working derectory.
function downloadArtifactSnapShot(){

	NEXUS_URL="http://nexus.lefebvre-sarrut.eu/repository/snapshots" 

	echo "Downloading $1 with version $3" 
	echo "Getting artifact $1 build metadata"
	
	wget --no-cache -O  maven-metadata.xml $NEXUS_URL/$1/$2/$3/maven-metadata.xml
	BUILD_NUMBER="$(grep 'value'  maven-metadata.xml | head -1  | awk -F'<value>' '{print $2}' | awk -F'</value>' '{print $1}')"
	
	echo "Found BUILD_NUMBER : $BUILD_NUMBER"
	rm -f maven-metadata.xml
	
	echo "Downloading BUILD VERSION $BUILD_NUMBER"
	wget  -O $2"."$4 $NEXUS_URL/$1/$2/$3/$2"-"$BUILD_NUMBER"."$4
	echo "Artifact available under $WORKING_DIRECTORY/$3"."$4"

}