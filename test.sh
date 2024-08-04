#!/opt/homebrew/bin/bash

# This file will be sourced in init.sh

# https://raw.githubusercontent.com/ai-dock/comfyui/main/config/provisioning/sd3.sh

# Packages are installed after nodes so we can fix them...


PYTHON_PACKAGES=(
)

NODES=(
    "https://github.com/ltdrdata/ComfyUI-Manager"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack"
    "https://github.com/ltdrdata/ComfyUI-Inspire-Pack"
    "https://github.com/civitai/comfy-nodes"
    "https://github.com/Gourieff/comfyui-reactor-node"
    "https://github.com/Lerc/canvas_tab"
)

CHECKPOINT_MODELS=(
)

UNET_MODELS=(
)

CLIP_MODELS=(
)
LORA_MODELS=(
)

VAE_MODELS=(
)

ESRGAN_MODELS=(
    "https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth"
    "https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth"
    "https://huggingface.co/Akumetsu971/SD_Anime_Futuristic_Armor/resolve/main/4x_NMKD-Siax_200k.pth"
)

CONTROLNET_MODELS=(
    "https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models_XL/adapter-xl-canny.pth"
    "https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models_XL/adapter-xl-openpose.pth"
    "https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models_XL/adapter-xl-sketch.pth"
)

declare -A IPADAPTER_MODELS=(
    ["https://hugcivitaigingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter_sdxl_vit-h.safetensors"]="ip-adapter_sdxl_vit-h.safetensors"
    ["https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter-plus_sdxl_vit-h.safetensors"]="ip-adapter-plus_sdxl_vit-h.safetensors"
    ["https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter-plus-face_sdxl_vit-h.safetensors"]="ip-adapter-plus-face_sdxl_vit-h.safetensors"
    ["https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter_sdxl.safetensors"]="ip-adapter_sdxl.safetensors"
)

declare -A CLIP_VISION_MODELS=(
    ["https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors"]="CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    ["https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/image_encoder/model.safetensors"]="CLIP-ViT-bigG-14-laion2B-39B-b160k.safetensors"
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {

    provisioning_get_models_map \
        "${WORKSPACE}/storage/stable_diffusion/models/ipadapter" \
        IPADAPTER_MODELS
    provisioning_get_models_map \
        "${WORKSPACE}/storage/stable_diffusion/models/clip_vision" \
        CLIP_VISION_MODELS

    provisioning_print_end
}


function provisioning_get_models_map() {
    if [[ -z $2 ]]; then return 1; fi
    dir="$1"
    local -n arr=$2
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${!arr[@]}"; do
        fn="${arr[$url]}"
        printf "Downloading: %s as %s\n" "${url}" "${fn}"
        if [[ "${url}" == *"civitai"* ]]; then
            printf "civitai\n"
        else
            printf "hf\n"
        fi
        printf "\n"
    done
}
function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
    if [[ $DISK_GB_ALLOCATED -lt $DISK_GB_REQUIRED ]]; then
        printf "WARNING: Your allocated disk size (%sGB) is below the recommended %sGB - Some models will not be downloaded\n" "$DISK_GB_ALLOCATED" "$DISK_GB_REQUIRED"
    fi
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Web UI will start now\n\n"
}

provisioning_start