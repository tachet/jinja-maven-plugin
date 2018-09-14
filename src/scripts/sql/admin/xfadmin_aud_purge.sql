-- -------------------------------------------------------------
-- ADMIN PURGE AUDIT : SCRIPT DE PURGE
--
-- DESC : Vider toutes les tables audit
-- DATE : 13/07/2017
-- -------------------------------------------------------------

DROP TABLE IF EXISTS `DATABASECHANGELOG`;
DROP TABLE IF EXISTS `DATABASECHANGELOGLOCK`;
DELETE FROM `action_aud`;
DELETE FROM `admin_detail_aud`;
DELETE FROM `configuration_version_aud`;
DELETE FROM `content_node_editorial_entity_template_meta_data_aud`;
DELETE FROM `content_type_role_permission_aud`;
DELETE FROM `editor_configuration_aud`;
DELETE FROM `editorial_content_type_aud`;
DELETE FROM `editorial_context_search_interface_template_aud`;
DELETE FROM `editorial_entity_template_actions_aud`;
DELETE FROM `editorial_entity_template_aud`;
DELETE FROM `editorial_entity_template_meta_data_aud`;
DELETE FROM `editorial_entity_template_publication_channels_aud`;
DELETE FROM `export_engine_aud`;
DELETE FROM `flat_view_setting_aud`;
DELETE FROM `hanging_node_editorial_entity_template_meta_data_aud`;
DELETE FROM `list_meta_data_values_aud`;
DELETE FROM `meta_data_aud`;
DELETE FROM `meta_group_aud`;
DELETE FROM `meta_group_role_permission_aud`;
DELETE FROM `notification_group_aud`;
DELETE FROM `notification_role_permission_aud`;
DELETE FROM `notification_type_aud`;
DELETE FROM `proxyref_referential_aud`;
DELETE FROM `proxyref_referentialvalue_aud`;
DELETE FROM `proxyref_referentialvaluemetadata_aud`;
DELETE FROM `publication_channel_aud`;
DELETE FROM `relationship_template_aud`;
DELETE FROM `relationship_template_notification_type_aud`;
DELETE FROM `relationship_template_type_aud`;
DELETE FROM `relationships_template_editorial_entity_template_source_aud`;
DELETE FROM `relationships_template_editorial_entity_template_target_aud`;
DELETE FROM `relationships_template_meta_data_aud`;
DELETE FROM `request_node_editorial_entity_template_meta_data_aud`;
DELETE FROM `role_aud`;
DELETE FROM `search_interface_template_aud`;
DELETE FROM `search_interface_template_classification_aud`;
DELETE FROM `search_interface_template_direct_filter_aud`;
DELETE FROM `search_interface_template_editorial_entity_template_aud`;
DELETE FROM `search_interface_template_extended_filter_aud`;
DELETE FROM `search_interface_template_result_aud`;
DELETE FROM `step_aud`;
DELETE FROM `structural_node_editorial_entity_template_meta_data_aud`;
DELETE FROM `user_group_aud`;
DELETE FROM `user_group_editorial_context_aud`;
DELETE FROM `user_group_editorial_entity_templates_aud`;
DELETE FROM `workflow_aud`;
DELETE FROM `workflow_metadatas_aud`;
DELETE FROM `workflow_status_aud`;
DELETE FROM `workflow_status_aud`;
DELETE FROM `workflow_status_aud`;
DELETE FROM `relationship_template_filter_type_aud`;
DELETE FROM `configuration_version` where id not in (SELECT * FROM (SELECT max(id) FROM `configuration_version`) temp);