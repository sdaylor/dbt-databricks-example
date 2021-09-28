{% macro build_ci_db(ci_db_name, prod_db_name) %}

    {% set create_ci_db_query %}
        CREATE DATABASE IF NOT EXISTS {{ ci_db_name }};
    {% endset %}
    {% do run_query(create_ci_db_query) %}
    {% do log("CI database created: " ~ ci_db_name, info=True) %}

    {% set list_table_query %}
        SHOW TABLE EXTENDED IN {{ prod_db_name }} LIKE '*'
    {% endset %}
    {% set tables_list = run_query(list_table_query).columns["information"].values() %}
    {% do log("Tables fetched: " ~ tables_list|length, info=True) %}

    {% for table in tables_list %}
        {% set ns = namespace() %}
        {% for attr in table.split('\n') %}
            {% if attr.startswith('Type:') %}
                {% set ns.table_type = attr.split(': ')[1] %}
            {% elif attr.startswith('Table:') %}
                {% set ns.table_name = attr.split(': ')[1] %}
            {% elif attr.startswith('View Original Text:') %}
                {% set ns.view_definition = attr.split(': ')[1] %}
            {% endif %}
        {% endfor %}
        {% if ns.table_type == 'VIEW' %}
            {% set create_query %}
                CREATE OR REPLACE VIEW {{ ci_db_name }}.{{ ns.table_name }} AS {{ ns.view_definition }};
            {% endset %}
        {% else %}
            {% set create_query %}
                CREATE OR REPLACE TABLE {{ ci_db_name }}.{{ ns.table_name }} SHALLOW CLONE {{ prod_db_name }}.{{ ns.table_name }};
            {% endset %}
        {% endif %}
        {% do log("Creating object " ~ ns.table_name ~ " of type " ~ ns.table_type, info=True) %}
        {% do run_query(create_query) %}
    {% endfor %}

{% endmacro %}