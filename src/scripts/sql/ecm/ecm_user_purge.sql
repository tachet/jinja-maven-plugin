-- -------------------------------------------------------------
-- ECM USER : SCRIPT DE PURGE
--
-- DESC : Vider toutes les tables contenant de FlashId
-- DATE : 20/07/2017
-- -------------------------------------------------------------

delete from workflow_history;
delete from assignment_role_status;
delete from editorial_entity_lock;
delete from notifications;
delete from saved_search_user;
delete from saved_search;
delete from search_full_text;
delete from filter_values;
delete from filter_instance;