# Use Python slim image
FROM python:3.12-slim

# Avoid prompts and bytecode
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Python requirements
COPY requirements.txt .

# Install dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy OnTheSpot source (from repo or local copy)
COPY src/ ./src
COPY pyproject.toml setup.cfg ./

# Install OnTheSpot
RUN pip install --no-cache-dir .

# Copy web server script
COPY server.py .

# Expose port for Web UI
EXPOSE 5000

# Run Flask server
CMD ["python", "server.py"]
