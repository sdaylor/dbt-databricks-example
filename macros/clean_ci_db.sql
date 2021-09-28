{% macro clean_ci_db(ci_db_name) %}
    {% set sql %}
        DROP DATABASE IF EXISTS {{ ci_db_name }} CASCADE;
    {% endset %}

    {% do run_query(sql) %}
    {% do log("CI database dropped: " ~ ci_db_name, info=True) %}
{% endmacro %}