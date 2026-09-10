{{ config(
    materialized = 'view',
    pre_hook = [

        "{{ macros_copy_csv(
            'STORES_COPY',
            '$1::INTEGER AS store,
             $2::STRING AS type,
             $3::INTEGER AS size',
            'stores.csv'
        ) }}",

        "{{ macros_copy_csv(
            'DEPARTMENT_COPY',
            '$1::INTEGER AS store,
             $2::INTEGER AS dept,
             $3::DATE AS date,
             $4::INTEGER AS weekly_sales,
             $5::STRING AS isHoliday',
            'department.csv'
        ) }}",

        "{{ macros_copy_csv(
            'FACT_COPY',
            '$1::INTEGER AS store,
             $2::DATE AS date,
             $3::STRING AS temperature,
             $4::STRING AS fuel_price,
             $5::STRING AS markDown1,
             $6::STRING AS markDown2,
             $7::STRING AS markDown3,
             $8::STRING AS markDown4,
             $9::STRING AS markDown5,
             $10::STRING AS CPI,
             $11::STRING AS unEmployment,
             $12::STRING AS isHoliday',
            'fact.csv'
        ) }}"

    ]
) }}

SELECT 1 AS bronze_load_completed