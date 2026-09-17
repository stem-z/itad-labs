# dbt и DuckDB

dbt - CLI-инструмент проекта, а не постоянно работающий Docker-сервис. Он использует DuckDB только во время
выполнения SQL и сохраняет результат моделей как внешние Parquet-файлы в MinIO:

```text
raw в MinIO → DuckDB + dbt → staging в MinIO → DuckDB + dbt → mart в MinIO.
```

В ЛР № 2 dbt не запускает модели и не создаёт staging или mart. Начиная со следующих работ, внешний формат и место
материализации задаются общими настройками dbt-проекта:

- `models/staging/*` → `s3://staging/<model>.parquet`.
- `models/marts/*` → `s3://mart/<model>.parquet`.

Перед первым `dbt build` DAG соответствующей лабораторной работы создаёт целевой бакет (`staging` или `mart`).
dbt записывает объекты в существующий бакет, но не создаёт его сам.

Когда начнётся работа с dbt, скопируйте `profiles.yml.example` в `profiles.yml` и выполните:

```bash
uv run --env-file .env dbt debug --project-dir dbt --profiles-dir dbt
uv run --env-file .env dbt build --project-dir dbt --profiles-dir dbt
```

На хосте MinIO доступен как `localhost:9000`. В будущих DAG'ах dbt будет запускаться внутри контейнера Airflow,
поэтому Compose передаёт ему `MINIO_S3_ENDPOINT=minio:9000` и монтирует каталог `dbt/`.
