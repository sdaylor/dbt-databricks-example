{% macro build_ci_db(ci_db_name, prod_db_name) %}

    {% set create_ci_db_query %}
        CREATE DATABASE IF NOT EXISTS {{ ci_db_name }};
    {% endset %}
    {% do run_query(create_ci_db_query) %}
    {% do log("CI database created: " ~ ci_db_name, info=True) %}

    {% set list_table_query %}
        SHOW TABLES IN {{ prod_db_name }}
    {% endset %}
    {% set results_list = run_query(list_table_query).columns["tableName"].values() %}
    {% do log("Table list fetched" ~ results_list, info=True) %}

    {% for table_name in results_list %}
        {% set create_table_query %}
            CREATE OR REPLACE TABLE {{ ci_db_name }}.{{ table_name }} SHALLOW CLONE {{ prod_db_name }}.{{ table_name }};
        {% endset %}
        {% do run_query(create_table_query) %}
    {% endfor %}

{% endmacro %}