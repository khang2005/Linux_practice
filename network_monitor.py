#!/usr/bin/env python3
import psutil, time, matplotlib.pyplot as plt
from email.message import EmailMessage
import os
import smtplib
from dotenv import load_dotenv
from datetime import datetime

# Configuration
ALERT_THRESHOLD = 80  # % CPU/Memory/Disk usage to trigger alerts
LOG_FILE = "network_health.log"

def log_event(message):
    """Log events to a file with timestamps."""
    with open(LOG_FILE, "a") as f:
        f.write(f"[{datetime.now()}] {message}\n")

def check_resources():
    """Monitor system resources and return stats."""
    cpu = psutil.cpu_percent(interval=1)
    mem = psutil.virtual_memory().percent
    disk = psutil.disk_usage('/').percent
    net_io = psutil.net_io_counters()
    return cpu, mem, disk, net_io.bytes_sent, net_io.bytes_recv

def visualize(data):
    """Plot CPU/Memory/Disk usage over time."""
    timestamps, cpu, mem, disk = zip(*data)
    plt.figure(figsize=(10, 6))
    plt.plot(timestamps, cpu, label="CPU %")
    plt.plot(timestamps, mem, label="Memory %")
    plt.plot(timestamps, disk, label="Disk %")
    plt.xlabel("Time")
    plt.ylabel("Usage %")
    plt.title("System Resource Usage Over Time")
    plt.legend()
    plt.savefig("resource_usage.png")
    print("Saved plot to resource_usage.png")
# load environment variabeles
load_dotenv()

def send_email_alert(subject, body):
    msg = EmailMessage()
    msg.set_content(body)
    msg["Subject"]=subject
    msg["From"] = os.getenv("GMAIL_ADDRESS") 
    msg["To"] = os.getenv("GMAIL_ADDRESS")

    with smtplib.SMTP("smtp.gmailcom", 587) as server:
        server.startls()
        server.login(
            os.getenv("GMAIL_ADDRESS"),
            os.getenv("GMAIL_PASSWORD")
        )
        server.send_message(msg)

def main():
    print("Starting Network Health Monitor (Ctrl+C to stop)...")
    stats_history = []
    try:
        while True:
            cpu, mem, disk, sent, recv = check_resources()
            stats_history.append((time.time(), cpu, mem, disk))
            
            # Log alerts
            if cpu > ALERT_THRESHOLD:
                log_event(f"High CPU Usage: {cpu}%")
            if mem > ALERT_THRESHOLD:
                log_event(f"High Memory Usage: {mem}%")
            
            print(f"CPU: {cpu}% | Mem: {mem}% | Disk: {disk}% | Net: ↑{sent/1e6:.2f}MB ↓{recv/1e6:.2f}MB")
            time.sleep(5)
    except KeyboardInterrupt:
        visualize(stats_history)
        print(f"Logs saved to {LOG_FILE}")

if __name__ == "__main__":
    main()
