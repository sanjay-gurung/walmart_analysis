{{ config(
    materialized = 'view',
    schema = 'GOLD',
    alias = 'VIEW_WEEKLY_SALES_BY_STORE_HOLIDAY'
) }}

WITH view_data as (
    SELECT
        f.STORE_ID,
        d.ISHOLIDAY,
        SUM(f.WEEKLY_SALES) AS WEEKLY_SALES_BY_STORE
    FROM WALMART_DB.SILVER.WALMART_FACT_TABLE f
    JOIN WALMART_DB.SILVER.WALMART_DATE_DIM d
        ON f.DATE_ID = d.DATE_ID
    GROUP BY
        f.STORE_ID,
        d.ISHOLIDAY
    ORDER BY
        f.STORE_ID,
        d.ISHOLIDAY
)

SELECT * FROM view_data
