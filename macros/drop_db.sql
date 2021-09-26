{% macro drop_db(db_name) %}
    {% set sql %}
        DROP DATABASE IF EXISTS {{ db_name }} CASCADE;
    {% endset %}

    {% do run_query(sql) %}
    {% do log("Database dropped", info=True) %}
{% endmacro %}