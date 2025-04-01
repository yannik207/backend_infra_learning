FROM python:3.10.7-slim

RUN pip install poetry==1.8.2
# Prevent Python from creating .pyc files
ENV PYTHONDONTWRITEBYTECODE=1 \
    # Poetry settings
    POETRY_HOME=/opt/poetry \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

WORKDIR /app

# Copy the necessary files
COPY pyproject.toml ./
COPY webserver/main.py ./webserver/
COPY webserver/__init__.py ./webserver/

# Verify Poetry installation
RUN poetry install --no-root 
#&& rm -rf $POETRY_CACHE_DIR

# Expose port for the application
EXPOSE 80

ENTRYPOINT ["poetry", "run", "uvicorn", "webserver.main:app", "--host", "0.0.0.0", "--port", "80"]