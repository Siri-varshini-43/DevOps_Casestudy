
FROM python:3.11-slim

WORKDIR /app

# Install Python dependencies
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Download spaCy English language model
RUN python -m spacy download en_core_web_sm

# Copy project files
COPY . .

# Expose Flask application port
EXPOSE 5000

# Start Flask using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
