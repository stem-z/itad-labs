# dbt-модели

Модели этого проекта материализуются во внешние Parquet-файлы MinIO.

- Файл из `models/staging/` с тегом `staging` записывается как `s3://staging/<model>.parquet`.
- Файл из `models/marts/` с тегом `mart` записывается как `s3://mart/<model>.parquet`.
- Источники raw объявляются в YAML с `external_location`, указывающим на объект или шаблон объектов MinIO.

Пример staging-модели:

```sql
select *
from {{ source('raw', 'source_file') }}
```

Путь и формат задаются общими настройками [dbt_project.yml](../dbt_project.yml) и макросом
[`external_location`](../macros/external_location.sql). Не добавляйте в модель materialization `table`.
