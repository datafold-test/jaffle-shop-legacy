{# Override dbt's default database-naming.

   Default behaviour falls back to target.database when custom is set,
   which is fine for single-database projects but masks the intent of
   `+database: FOO` overrides. With this macro, `+database:` lands
   exactly where written.

   - custom none → target.database verbatim
   - custom set  → custom verbatim #}
{% macro generate_database_name(custom_database_name=none, node=none) -%}
    {%- if custom_database_name is none -%}
        {{ target.database }}
    {%- else -%}
        {{ custom_database_name | trim }}
    {%- endif -%}
{%- endmacro %}
