# Use an official lightweight Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy your scanner script into the container
COPY port_scanner.py .

# Default command to run the script
CMD ["python", "port_scanner.py"]

