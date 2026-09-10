{# depends_on: {{ ref('load_walmart_bronze') }} #}

{{
    config(
        materialized = 'incremental',
        transient = true,
        schema = 'SILVER',
        alias = 'WALMART_FACT_TABLE',
        unique_key = ['STORE_ID', 'DEPT_ID', 'DATE_ID'],
        incremental_strategy = 'merge',
    )
}}

WITH transform AS(
    SELECT DISTINCT
        s.STORE_ID,
        s.DEPT_ID,
        TO_NUMBER(TO_CHAR(d.DATE, 'YYYYMMDD')) AS DATE_ID,
        d.WEEKLY_SALES,
        f.FUEL_PRICE,
        f.TEMPERATURE,
        TO_DECIMAL(NULLIF(f.UNEMPLOYMENT, 'NA'), 18, 3) AS UNEMPLOYMENT,
        TO_DECIMAL(NULLIF(f.CPI, 'NA'), 18, 6) AS CPI,
        TO_DECIMAL(NULLIF(f.MARKDOWN1, 'NA'), 18, 2) AS MARKDOWN1,
        TO_DECIMAL(NULLIF(f.MARKDOWN2, 'NA'), 18, 2) AS MARKDOWN2,
        TO_DECIMAL(NULLIF(f.MARKDOWN3, 'NA'), 18, 2) AS MARKDOWN3,
        TO_DECIMAL(NULLIF(f.MARKDOWN4, 'NA'), 18, 2) AS MARKDOWN4,
        TO_DECIMAL(NULLIF(f.MARKDOWN5, 'NA'), 18, 2) AS MARKDOWN5
    FROM {{ ref('walmart_store_dim_transform') }} s
    INNER JOIN {{ source('source', 'DEPARTMENT_COPY') }} d 
        ON s.STORE_ID = d.STORE
        AND s.DEPT_ID = d.DEPT
    INNER JOIN {{ source('source', 'FACT_COPY') }} f 
        ON f.STORE = s.STORE_ID
        AND f.DATE = d.DATE

    {% if is_incremental() %}
        WHERE d.DATE > (
            SELECT MAX(TO_DATE(DATE_ID::VARCHAR, 'YYYYMMDD'))
            FROM {{ this }}
        )
    {% endif %}

)

SELECT
    STORE_ID,
    DEPT_ID,
    DATE_ID,
    WEEKLY_SALES,
    FUEL_PRICE,
    TEMPERATURE,
    UNEMPLOYMENT,
    CPI,
    MARKDOWN1,
    MARKDOWN2,
    MARKDOWN3,
    MARKDOWN4,
    MARKDOWN5,
    CURRENT_TIMESTAMP() AS INSERT_DATE
FROM 
    transform