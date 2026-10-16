# WellWish backend image: used by the api, worker and beat containers.
# Dev:  docker compose builds it with REQUIREMENTS=dev (adds test + lint tools).
# Prod: build with --build-arg REQUIREMENTS=base.
FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_ROOT_USER_ACTION=ignore

WORKDIR /app

ARG REQUIREMENTS=dev
COPY requirements/ /tmp/requirements/
RUN pip install -r /tmp/requirements/${REQUIREMENTS}.txt

COPY . /app

EXPOSE 8000
CMD ["uvicorn", "config.asgi:application", "--host", "0.0.0.0", "--port", "8000"]
