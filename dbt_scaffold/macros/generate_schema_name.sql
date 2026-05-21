{% macro generate_schema_name(custom_schema_name, node) -%}
    {#
        Custom schema name generator:
        - If a model explicitly sets a custom schema (e.g. via config(schema=...)),
          use that custom schema name directly (without prepending the target schema).
        - Otherwise, fall back to the default target schema.
        This override is needed because the pre-created target schemas are fixed
        (DEV.DATAFOLD_TMP for testing, JAFFLE_SHOP.STAGING / JAFFLE_SHOP.MARTS for prod)
        and dbt should not attempt to CREATE SCHEMA.
    #}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
