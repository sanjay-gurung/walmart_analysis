{# depends_on: {{ ref('load_walmart_bronze') }} #}

{{ config(
    materialized = 'incremental',
    transient = true,
    schema = 'SILVER',
    alias = 'WALMART_DATE_DIM',
    unique_key = ['STORE_ID', 'DATE_ID'],
    incremental_strategy = 'merge',
    merge_update_columns = [
        'STORE_DATE',
        'ISHOLIDAY',
        'UPDATE_DATE'
    ]
) }}

WITH source_data AS (
    SELECT
        STORE AS STORE_ID,
        TO_NUMBER(TO_CHAR(DATE, 'YYYYMMDD')) AS DATE_ID,
        DATE AS STORE_DATE,
        ISHOLIDAY
    FROM {{ source('source', 'DEPARTMENT_COPY') }}
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY STORE, TO_NUMBER(TO_CHAR(DATE, 'YYYYMMDD'))
        ORDER BY DATE DESC
    ) = 1
)
-- WITH source_data AS (

--     SELECT DISTINCT
--         STORE AS STORE_ID,
--         TO_NUMBER(TO_CHAR(DATE, 'YYYYMMDD')) AS DATE_ID,
--         DATE AS STORE_DATE,
--         ISHOLIDAY

--     FROM {{ source('source', 'DEPARTMENT_COPY') }}
-- )
SELECT
    STORE_ID,
    DATE_ID,
    STORE_DATE,
    ISHOLIDAY,
    CURRENT_TIMESTAMP() AS INSERT_DATE,
    CURRENT_TIMESTAMP() AS UPDATE_DATE

FROM source_data