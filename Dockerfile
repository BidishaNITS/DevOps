FROM python:3.11-slim

# Create work dir inside the image
WORKDIR /app

# Copy dependencies file first (better layer caching)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the app code
COPY app.py .

# App runs on 5000
EXPOSE 5000

# Start the app
CMD ["python", "app.py"]