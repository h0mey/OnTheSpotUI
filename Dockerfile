# Use slim Python image
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

# Set working dir
WORKDIR /app

# Copy requirements if you have one
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy OnTheSpot source
COPY src/ ./src
COPY pyproject.toml setup.cfg ./

# Install OnTheSpot package
RUN pip install --no-cache-dir .

# Copy web server script
COPY server.py .

# Expose port for web UI
EXPOSE 5000

# Run the web server
CMD ["python", "server.py"]
