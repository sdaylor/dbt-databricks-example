{% macro clean_ci_db(ci_db_name) %}
    {% set re = modules.re %}
    {% if re.fullmatch('(^dbt_ci_[0-9]{8}_[0-9]{8}$)', ci_db_name) %}
        {% set sql %}
            DROP DATABASE IF EXISTS {{ ci_db_name }} CASCADE;
        {% endset %}

        {% do run_query(sql) %}
        {% do log("CI database dropped: " ~ ci_db_name, info=True) %}
    {% else %}
        {% do exceptions.raise_compiler_error("CI DB drop failed, invalid database name: " ~ ci_db_name) %}
    {% endif %}
{% endmacro %}