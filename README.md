# Surya OCR - Docker

Dockerized setup for [Surya](https://github.com/datalab-to/surya) — OCR, layout detection, reading order, and table recognition in 90+ languages.

## Build

```bash
# CPU
docker build -t surya-ocr:cpu .

# GPU (requires nvidia-container-toolkit on the host)
docker build -f Dockerfile.gpu -t surya-ocr:gpu .
```

## Usage

Place your input files in a `data/` directory, then run:

```bash
# CPU
docker run --rm -v $(pwd)/data:/data -v surya-models:/root/.cache/huggingface surya-ocr:cpu surya_ocr /data/input.pdf

# GPU
docker run --rm --gpus all -v $(pwd)/data:/data -v surya-models:/root/.cache/huggingface surya-ocr:gpu surya_ocr /data/input.pdf
```

Model weights are downloaded automatically on first run and cached in the `surya-models` Docker volume so subsequent runs start instantly.

### Available Commands

| Command | Description |
|---------|-------------|
| `surya_ocr` | Full OCR (detection + recognition) |
| `surya_detect` | Text detection |
| `surya_layout` | Layout analysis |
| `surya_table` | Table recognition |
| `surya_latex` | LaTeX OCR |

Example:

```bash
docker run --rm -v $(pwd)/data:/data -v surya-models:/root/.cache/huggingface surya-ocr:cpu surya_detect /data/input.pdf
```

## GPU Prerequisites

1. NVIDIA drivers installed on the host
2. [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) installed:

   ```bash
   sudo apt-get install -y nvidia-container-toolkit
   sudo nvidia-ctk runtime configure --runtime=docker
   sudo systemctl restart docker
   ```

3. Verify with:

   ```bash
   docker run --rm --gpus all nvidia/cuda:12.1.0-runtime-ubuntu22.04 nvidia-smi
   ```

## GPU Selection

```bash
# All GPUs
docker run --rm --gpus all ...

# Specific GPU count
docker run --rm --gpus 2 ...

# Specific devices
docker run --rm --gpus '"device=0,1"' ...
```

## Pre-caching Models

To bake model weights into the image (larger image, no download at runtime), uncomment the pre-cache line in the respective Dockerfile before building.
# surya-ocr
