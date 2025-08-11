# Docker Concepts (Interview Notes)

## What is Docker?
Docker is a tool that lets you package your app + dependencies into a portable unit called a container.

## Image vs Container
- Image = blueprint
- Container = running instance

## Why use Docker?
- Same behavior in dev, test, and prod
- Starts faster than a VM
- Easier to scale

## Commands
```bash
docker build -t app:1.0 .
docker run -p 5000:5000 app:1.0
docker ps
docker stop <id>