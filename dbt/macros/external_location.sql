{% macro external_location(relation, config) %}
  {% set tags = config.get('tags', []) %}
  {% if 'staging' in tags %}
    {{ return('s3://staging/' ~ relation.identifier ~ '.parquet') }}
  {% elif 'mart' in tags %}
    {{ return('s3://mart/' ~ relation.identifier ~ '.parquet') }}
  {% else %}
    {{ exceptions.raise_compiler_error(
        'External dbt model must have either the staging or mart tag.'
    ) }}
  {% endif %}
{% endmacro %}
