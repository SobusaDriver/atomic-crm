#!/bin/bash
set -e

echo "=================================================="
echo "    Atomic CRM Full-Stack Deployment Script"
echo "=================================================="

# Optional: pull the latest code if deploying from git
# git pull origin main

echo "[1/3] Building and starting frontend service..."
# Rebuild the frontend container seamlessly
docker-compose up -d --build frontend

echo "[2/3] Ensuring backend and backup services are running..."
# Start any missing services in the background
docker-compose up -d

echo "[3/3] Cleaning up old images to save disk space..."
docker image prune -f

echo "=================================================="
echo "Deployment complete! Application is running on port 80."
echo "Supabase Studio is running on port 8000 (Kong)."
echo "Backups are scheduled daily and saved to ./volumes/backups"
echo "=================================================="
