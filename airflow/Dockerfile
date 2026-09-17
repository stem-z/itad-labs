FROM ghcr.io/astral-sh/uv:0.11.26 AS uv
FROM apache/airflow:2.10.5-python3.12

COPY --from=uv /uv /uvx /bin/

USER airflow
WORKDIR /opt/airflow/project

COPY --chown=airflow:root pyproject.toml uv.lock ./
RUN uv sync --locked --no-dev --no-install-project

ENV PATH="/opt/airflow/project/.venv/bin:${PATH}"

