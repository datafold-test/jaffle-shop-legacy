{% macro snowflake__create_schema(relation) -%}
  {#
    Override the default schema creation. The schemas (DEV.DATAFOLD_TMP,
    JAFFLE_SHOP.STAGING, JAFFLE_SHOP.MARTS) are pre-created by the platform.
    Attempting CREATE SCHEMA IF NOT EXISTS fails on DEV because DATAFOLDROLE
    does not have CREATE SCHEMA on DEV. Since the target schemas already exist,
    this macro intentionally skips schema creation.
  #}
{% endmacro %}
