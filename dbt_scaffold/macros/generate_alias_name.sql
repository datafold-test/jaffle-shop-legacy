{# Override dbt's default alias-naming.

   Default behaviour: `node.name` when no alias is set. This macro
   makes the contract explicit and ensures `+alias:` overrides (or
   `{{ config(alias=...) }}` inside a model) land exactly verbatim
   with no transformation. Important for diff-validation alias
   conventions like `STG_<NAME>_<ticket_id>` — no surprises from
   dbt's default mangling.

   - custom set / truthy → custom verbatim
   - else                → node.name #}
{% macro generate_alias_name(custom_alias_name=none, node=none) -%}
    {%- if custom_alias_name -%}
        {{ custom_alias_name | trim }}
    {%- else -%}
        {{ node.name }}
    {%- endif -%}
{%- endmacro %}
