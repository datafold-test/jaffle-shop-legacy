{% macro cents_to_dollars(column_name, scale=2) %}
    cast({{ column_name }} as numeric(18, {{ scale }})) / 100
{% endmacro %}
