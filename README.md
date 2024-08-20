# NGINX Image Processing with Lua

This project sets up an NGINX server with Lua scripting to handle dynamic image processing.
It uses LuaJIT's FFI (Foreign Function Interface) for file system operations and ImageMagick for image manipulation.
The setup is containerized using Docker.

## Directory Layout

```
nginx-docker-lua/
├── Dockerfile                # Dockerfile to build the Docker image
├── nginx.conf                # NGINX configuration file
├── lua/                      # Directory containing Lua scripts
│   ├── config.lua            # Configuration settings (e.g., root directories, allowed dimensions)
│   ├── utils.lua             # Utility functions (e.g., file checks, directory creation)
│   ├── ffi_helpers.lua       # FFI-based implementations for file operations
│   ├── image_processor.lua   # Main Lua script handling the image processing logic
├── html/                     # Public directory to serve static files (if needed)
│   ├── index.html            # Example static file
│   ├── thumb/                # Evergrowing cache folder, yup, no cleanup done yet ; your local folder needs chown 33:33 thumb
├── private/                  # Private directory for source files not accessible from the web
│   ├── images/               # Image source files
│   ├── replacement_images/   # see image_processor how to serve a default fallback / 404 image
├── docker-compose.yml        # Docker Compose file (optional, for orchestration)
└── README.md                 # This README file
```

## URL Structure

The application allows dynamic image processing through URLs with the following structure:

```
/thumb/<width>x<height>/<filename>.<ext>?quality=<quality>
```

### Example URL Call

To generate a thumbnail of an image:

```
http://localhost:82/thumb/300x200/example.jpg?quality=85
```

- **width**: Width of the thumbnail (e.g., 300).
- **height**: Height of the thumbnail (e.g., 200).
- **filename**: Name of the original image file without the extension (e.g., `example`).
- **ext**: Extension of the image file (e.g., `jpg`).
- **quality** (optional): Image quality percentage (e.g., 85).

### URL Call Description

- **Thumbnail Generation**: When you make a URL call, the server checks if a thumbnail with the specified dimensions and quality already exists. If it does, the existing image is served. If not, a new thumbnail is generated, cached, and then served.
Except it is not. Well, quality is ignored completly in cache checking. One could add the quality int to the caches filename though.
- 
## How to Use This Docker Setup

### Prerequisites

- **Docker**: Make sure Docker is installed on your machine.
- **Docker Compose** (optional): Useful for orchestrating the Docker containers.

### Build and Run the Docker Container

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd nginx-docker-lua
   ```

2. **Build the Docker Image**:
   ```bash
   docker build -t nginx-lua .
   ```

3. **Run the Docker Container**:
   ```bash
    docker run -p 82:80 \
    -v $(pwd)/html:/usr/local/openresty/nginx/html \
    -v $(pwd)/private:/usr/local/openresty/nginx/private nginx-lua

   ```

   If you're using Docker Compose, you can start the service with:
   ```bash
   docker-compose up --build
   ```

4. **Access the Service**:
   Open your web browser and go to `http://localhost:82`. You can then make requests to generate and retrieve image thumbnails.

### Configuration and Customization

- **NGINX Configuration**: Modify the `nginx.conf` file to customize the server behavior, such as the routing and handling of different URLs.
- **Lua Scripts**: The Lua scripts in the `lua/` directory handle various aspects of image processing and file management. You can modify these to change how images are processed, stored, or served.
- **Static Files**: If you want to serve static files, place them in the `html/` directory. These will be accessible via the root URL (`http://localhost:82/`).

