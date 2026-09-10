{% macro macros_copy_csv(table_nm, column_definitions, file_nm) %}

delete from {{ var('rawhist_db') }}.{{ var('wrk_schema') }}.{{ table_nm }};

COPY INTO {{ var('rawhist_db') }}.{{ var('wrk_schema') }}.{{ table_nm }}

FROM (
    SELECT
        {{ column_definitions }}
    FROM @{{ var('rawhist_db') }}.{{ var('wrk_schema') }}.{{ var('stage_name') }}
)
FILES = ('{{ file_nm }}')
FILE_FORMAT = (
    TYPE = CSV
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    SKIP_HEADER = 1
)
FORCE = TRUE;

{% endmacro %}

