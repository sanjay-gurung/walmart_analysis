{# depends_on: {{ ref('load_walmart_bronze') }} #}

{{ config(
    materialized = 'incremental',
    transient = true,
    schema = 'SILVER',
    alias = 'WALMART_STORE_DIM',
    unique_key = ['STORE_ID', 'DEPT_ID'],
    incremental_strategy = 'merge',
    merge_update_columns = [
        'STORE_TYPE',
        'STORE_SIZE',
        'UPDATE_DATE'
    ]
) }}

WITH source_data AS (
    SELECT DISTINCT
        d.STORE AS STORE_ID,
        d.DEPT AS DEPT_ID,
        s.TYPE AS STORE_TYPE,
        s.SIZE AS STORE_SIZE
    FROM {{ source('source', 'DEPARTMENT_COPY') }} d
    INNER JOIN {{ source('source', 'STORES_COPY') }} s
        ON d.STORE = s.STORE
)

SELECT
    STORE_ID,
    DEPT_ID,
    STORE_TYPE,
    STORE_SIZE,
    CURRENT_TIMESTAMP() AS INSERT_DATE,
    CURRENT_TIMESTAMP() AS UPDATE_DATE
FROM source_data