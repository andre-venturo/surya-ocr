FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir poetry

RUN git clone --depth 1 https://github.com/datalab-to/surya.git .

RUN poetry config virtualenvs.create false
RUN poetry install --only main --no-interaction --no-ansi

# Models download automatically on first run; optionally pre-cache them
# by uncommenting the next line (increases image size significantly):
# RUN python -c "from surya.model.detection.model import load_model; load_model()"

ENTRYPOINT ["poetry", "run"]
CMD ["surya_ocr", "--help"]
