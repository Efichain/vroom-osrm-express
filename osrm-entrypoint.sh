#!/bin/bash

set -e
cd /data

PBF=malaysia-singapore-brunei-latest.osm.pbf
OSRM=malaysia-singapore-brunei-latest.osrm

# Step 1: Download PBF if missing
if [ ! -f "$PBF" ]; then
  echo "📦 Downloading PBF..."
  curl -O http://download.geofabrik.de/asia/$PBF
fi

# Step 2: Extract if not already done
if [ ! -f "$OSRM" ]; then
  echo "🛠 Extracting..."
  osrm-extract -p /opt/car.lua "$PBF"
fi

# Step 3: Partition
if [ ! -f "$OSRM.partition" ]; then
  echo "🧩 Partitioning..."
  osrm-partition "$OSRM"
fi

# Step 4: Customize
if [ ! -f "$OSRM.cells" ]; then
  echo "📦 Customizing..."
  osrm-customize "$OSRM"
fi
