-- -------------------------------------------------------------
-- ADMIN PURGE ARCHIVED DATA
-- -------------------------------------------------------------
-- SCRIPT BEGIN
----------------------------------------------------------------

-- editorial_entity_template
delete from editorial_entity_template_meta_data where editoriale_entity_template_id in
  (select id from editorial_entity_template where
    entity_status = 0
    or creation_workflow_id in (select id from workflow where entity_status = 0)
    or modification_workflow_id in (select id from workflow where entity_status = 0) );
delete from editorial_entity_template_publication_channels where editorial_entity_template_id in (select id from editorial_entity_template where
    entity_status = 0
    or creation_workflow_id in (select id from workflow where entity_status = 0)
    or modification_workflow_id in (select id from workflow where entity_status = 0) );
delete from relationships_template_editorial_entity_template_source where editorial_entity_template_id in (select id from editorial_entity_template where
    entity_status = 0
    or creation_workflow_id in (select id from workflow where entity_status = 0)
    or modification_workflow_id in (select id from workflow where entity_status = 0) );
delete from relationships_template_editorial_entity_template_target where editorial_entity_template_id in (select id from editorial_entity_template where
    entity_status = 0
    or creation_workflow_id in (select id from workflow where entity_status = 0)
    or modification_workflow_id in (select id from workflow where entity_status = 0) );
delete from flat_view_setting where editoriale_entity_template_id in (select id from editorial_entity_template where
    entity_status = 0
    or creation_workflow_id in (select id from workflow where entity_status = 0)
    or modification_workflow_id in (select id from workflow where entity_status = 0) );
delete from search_interface_template_editorial_entity_template where editorial_entity_template_id in (select id from editorial_entity_template where
    entity_status = 0
    or creation_workflow_id in (select id from workflow where entity_status = 0)
    or modification_workflow_id in (select id from workflow where entity_status = 0)
    or search_interface_template_id in ( select id from search_interface_template where entity_status = 0));
delete from user_group_editorial_entity_templates where editorial_entity_templates_id in (select id from editorial_entity_template where
    entity_status = 0
    or creation_workflow_id in (select id from workflow where entity_status = 0)
    or modification_workflow_id in (select id from workflow where entity_status = 0) );
delete from content_node_editorial_entity_template_meta_data where editoriale_entity_template_id in (select id from editorial_entity_template where
    entity_status = 0
    or creation_workflow_id in (select id from workflow where entity_status = 0)
    or modification_workflow_id in (select id from workflow where entity_status = 0) );
delete from hanging_node_editorial_entity_template_meta_data where editoriale_entity_template_id in (select id from editorial_entity_template where
    entity_status = 0
    or creation_workflow_id in (select id from workflow where entity_status = 0)
    or modification_workflow_id in (select id from workflow where entity_status = 0) );
delete from structural_node_editorial_entity_template_meta_data where editoriale_entity_template_id in (select id from editorial_entity_template where
    entity_status = 0
    or creation_workflow_id in (select id from workflow where entity_status = 0)
    or modification_workflow_id in (select id from workflow where entity_status = 0) );

delete from request_node_editorial_entity_template_meta_data where editoriale_entity_template_id in (select id from editorial_entity_template where
    entity_status = 0 );

delete from editorial_entity_template
    where entity_status = 0
    or creation_workflow_id in (select id from workflow where entity_status = 0)
    or modification_workflow_id in (select id from workflow where entity_status = 0);
    


-- editorial_context
delete from editorial_context_search_interface_template
    where editorial_context_id in (select id from editorial_context where entity_status = 0 )
    or search_interface_template_id in ( select id from search_interface_template where entity_status = 0);
delete from user_group_editorial_context where editorial_context_id in (select id from editorial_context where entity_status = 0 );
delete from editorial_context where entity_status = 0;

-- search_interface_template
delete from search_interface_template_direct_filter where meta_data_id in (select id from meta_data
    where entity_status = 0
    or search_interface_template_id in ( select id from search_interface_template where entity_status = 0));
delete from search_interface_template_extended_filter where meta_data_id in (select id from meta_data
    where entity_status = 0
    or search_interface_template_id in ( select id from search_interface_template where entity_status = 0));
delete from structural_node_editorial_entity_template_meta_data where meta_data_id in (select id from meta_data where entity_status = 0);
delete from content_node_editorial_entity_template_meta_data where meta_data_id in (select id from meta_data where entity_status = 0);
delete from hanging_node_editorial_entity_template_meta_data where meta_data_id in (select id from meta_data where entity_status = 0);
delete from search_interface_template_result where meta_data_id in (select id from meta_data
    where entity_status = 0
    or search_interface_template_id in ( select id from search_interface_template where entity_status = 0));

-- relationship_template
delete from relationships_template_editorial_entity_template_source
    where relationship_template_id in (select id from relationship_template where entity_status = 0
    or search_interface_template_target_id in (select id from search_interface_template where entity_status = 0));
delete from relationships_template_editorial_entity_template_target
    where relationship_template_id in (select id from relationship_template where entity_status = 0
    or search_interface_template_target_id in (select id from search_interface_template where entity_status = 0));
delete from relationship_template_notification_type
    where relationship_template_id in (select id from relationship_template where entity_status = 0
    or search_interface_template_target_id in (select id from search_interface_template where entity_status = 0));
delete from relationships_template_meta_data
    where relationship_template_id in (select id from relationship_template where entity_status = 0
    or search_interface_template_target_id in (select id from search_interface_template where entity_status = 0));
delete from relationship_template
    where entity_status = 0
    or search_interface_template_target_id in (select id from search_interface_template where entity_status = 0);


delete from search_interface_template_classification where search_interface_template_id in ( select id from search_interface_template where entity_status = 0);
delete from search_interface_template where entity_status = 0;

-- meta data
delete from list_meta_data_values where meta_data_id in (select id from meta_data where entity_status = 0);
delete from meta_data where entity_status = 0;

-- role
delete from content_type_role_permission where role_id in (select id from role where entity_status = 0);
delete from meta_group_role_permission where role_id in (select id from role where entity_status = 0);
delete from notification_role_permission where role_id in (select id from role where entity_status = 0);
delete from step_roles where roles_id in (select id from role where entity_status = 0);
delete from role where entity_status = 0;

-- user group
delete from user_group_editorial_entity_templates where user_groups_id in (select id from user_group where entity_status = 0);
delete from user_group_editorial_context where user_group_id in (select id from user_group where entity_status = 0);
delete from user_group where entity_status = 0;

-- workflow
delete from step where workflow_id in ( select id from workflow where entity_status = 0);
delete from meta_data_workflow where workflow_id in ( select id from workflow where entity_status = 0);
delete from workflow where entity_status = 0;


-- -------------------------------------------------------------
-- SCRIPT END
-- --------------------------------------------------------------