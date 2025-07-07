FROM node:20

# Install OS-level dependencies
RUN apt update && apt install -y \
  git build-essential cmake g++ pkg-config libprotobuf-dev protobuf-compiler \
  libosmpbf-dev libstxxl-dev libstxxl-doc libxml2-dev libzip-dev \
  libboost-all-dev lua5.2 liblua5.2-dev libasio-dev libssl-dev curl unzip

# Build VROOM binary
RUN git clone https://github.com/VROOM-Project/vroom.git && \
    cd vroom && git checkout v1.14.0 && git submodule update --init --recursive && \
    make -C src && cp bin/vroom /usr/local/bin

# Setup VROOM-EXPRESS API
WORKDIR /vroom-express
COPY package.json .
RUN npm install
COPY . .

EXPOSE 3000
CMD ["node", "src/index.js"]
