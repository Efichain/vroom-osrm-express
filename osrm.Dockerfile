FROM osrm/osrm-backend as builder

WORKDIR /data

# Fix broken apt sources in old Stretch
RUN sed -i '/stretch-updates/d' /etc/apt/sources.list && \
    sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until && \
    apt-get update && apt-get install -y curl

# Download PBF
RUN curl -O http://download.geofabrik.de/asia/malaysia-singapore-brunei-latest.osm.pbf

# Pre-process for MLD
RUN osrm-extract -p /opt/car.lua malaysia-singapore-brunei-latest.osm.pbf && \
    osrm-partition malaysia-singapore-brunei-latest.osrm && \
    osrm-customize malaysia-singapore-brunei-latest.osrm

# Final image
FROM osrm/osrm-backend
COPY --from=builder /data /data

EXPOSE 5000
CMD ["osrm-routed", "--algorithm", "mld", "/data/malaysia-singapore-brunei-latest.osrm"]
