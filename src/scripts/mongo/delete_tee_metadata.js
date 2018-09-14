###########################################################
# Requête à executer sur la collection mongo "node".   
# Cette requête supprime la métadonnée système Tee sur 
#  tous les nœuds de référence.
###########################################################

db.node.update (
   {type:'REFERENCE' },
   { $pull: { metaInstanceList: { 'metaData.code': 'systemTee'} } },
   { multi: true }
)