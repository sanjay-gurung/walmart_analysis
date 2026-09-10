{% snapshot walmart_fact_table_snapshot %}
{{
    config(
      target_database='WALMART_DB',
      target_schema='snapshots',
      unique_key='STORE_ID || \'-\' || DEPT_ID || \'-\' || DATE_ID',
      strategy='check',
      check_cols = [
            'WEEKLY_SALES',
            'FUEL_PRICE',
            'TEMPERATURE',
            'UNEMPLOYMENT',
            'CPI',
            'MARKDOWN1',
            'MARKDOWN2',
            'MARKDOWN3',
            'MARKDOWN4',
            'MARKDOWN5'
        ],
    )
}}

SELECT *
FROM {{ ref('walmart_fact_table_transform') }}

{% endsnapshot %}