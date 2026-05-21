-- Override generate_database_name to always use JAFFLE_SHOP as the target database.
-- The run_dbt tool auto-generates a profile with database=DEV, but the actual
-- project database is JAFFLE_SHOP (where DATAFOLDROLE has ownership).
{% macro generate_database_name(custom_database_name=none, node=none) -%}
    JAFFLE_SHOP
{%- endmacro %}
