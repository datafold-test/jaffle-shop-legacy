{# Override dbt's default schema-naming convention.

   Default dbt behaviour: if a model declares `+schema: foo`, dbt builds
   it in `{target.schema}_foo` (prefixed with the profile's schema).
   We never want that prefix — model placement is controlled directly
   by `+schema:` and `+database:` overrides. Without this macro,
   marts/staging would land in dbt_dev_marts / dbt_dev_staging on a
   dev profile instead of marts / staging.

   - custom none → target.schema verbatim (no prefix)
   - custom set  → custom verbatim (no prefix) #}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
