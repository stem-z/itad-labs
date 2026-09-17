# ITAD Labs

Сквозной учебный data-проект курса «Информационные технологии анализа данных».

## Контур данных

```text
Источник → raw в MinIO → staging → mart → анализ и отчёт.
```

MinIO хранит файлы. Airflow ожидает и скачивает HTTP-источник. PostgreSQL используется только как база метаданных
Airflow. DuckDB читает и записывает Parquet-объекты в MinIO, а dbt задаёт SQL-модели. dbt запускается через `uv`, а не
как отдельный Docker-сервис.

При старте webserver и scheduler используют штатный entrypoint Airflow: он применяет миграции метабазы и создаёт
администратора из `.env`. Отдельных init-контейнеров нет. Бакет `raw` создаётся ingestion-кодом при первой записи;
`staging` и `mart` появятся только в следующих работах.

## Команды

Команды ниже работают одинаково в PowerShell, macOS и Linux. Для `dbt` предварительно скопируйте
`dbt/profiles.yml.example` в `dbt/profiles.yml`.

```bash
uv run ruff check .

docker compose up --build -d
uv run --env-file .env dbt debug --project-dir dbt --profiles-dir dbt
uv run --env-file .env dbt build --project-dir dbt --profiles-dir dbt
uv run --env-file .env python scripts/read_raw.py --path "s3://raw/green_tripdata/ingested_on=2026-01-01/green_tripdata_2025-01.parquet"
docker compose down
```

`Makefile` оставлен как необязательные сокращения для macOS, Linux и WSL. В частности, можно выполнить
`make read-raw RAW_PATH="s3://raw/green_tripdata/ingested_on=2026-01-01/green_tripdata_2025-01.parquet"`.

## Структура

- `config/` — будущие правила качества.
- `data/source/` — неизменяемые Git-снимки для ручного fallback.
- `airflow/dags/` — DAG'и оркестрации.
- `src/` — код ingestion, проверки и анализа.
- `scripts/` — кроссплатформенные точки входа для локальных проверок.
- `dbt/` — dbt-модели, материализуемые во внешние Parquet-файлы MinIO.
- `infra/` — место для инфраструктурных материалов следующих лабораторных работ.
