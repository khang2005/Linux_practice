#!/usr/bin/env python3
import psutil, time, matplotlib.pyplot as plt
from datetime import datetime

#configuration
Alert_Threshold= 80 # % CPU/memory/disk usage to trigger alerts
Log_File = "network_health.log"

def log_event(message):
  """Log events to a file with timestamps."""
  with open(Log_File, "a") as f:
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
  plt.figure(figsize= (10, 6))
  plt.plot(timestamps, cpu, label="CPU %")
  plt.plot(timestamps, mem, label="Memory %")
  plt.plot(timestamps, disk, label="Disk %")
  plt.xlabel("Time")
  plt.ylabel("Usage %")
  plt.title("System Resource Usage Over Time")
  plt.legend()
  plt.savefig("resoure_usage.png")
  print("Saved plot to resource_usage.png")

def main():
  print("starting network health monitor (Ctrl+C to stop)...")
  stats_history = []
  try:
    while True:
      cpu, mem, disk, sent, recv = check_resources()
      stats_history.append((time.time(), cpu, mem, disk))
      
      if cpu > Alert_Threshold:
        log_event(f"High CPU Usage: {cpu}%")
      if mem > Alert_Threshold:
        log_event(f"High Memory Usage: {mem}%")
      
      print(f"CPU: {cpu}% | Mem: {mem}% | Disk: {disk}% | Net: {sent/1e6:.2f}MB")
      time.sleep(5)
  except KeyboardInterrupt:
    visualize(stats_history)
    print(f"Logs saved to {Log_File}")
if __name__ == "__main__":
  main()
