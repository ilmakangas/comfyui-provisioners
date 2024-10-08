# aidock-provisioners

My modular Stable Diffusion UI (ComfyUI, InvokeAI...) provisioning scripts for [https://github.com/ai-dock](https://github.com/ai-dock) images to be used on RunPod. The actual provisioning script is stored encrypted in the Git repository using [SOPS](https://github.com/getsops/sops).

## Prerequisites
* Install [SOPS](https://github.com/getsops/sops) tool on local computer
* Install [age](https://github.com/FiloSottile/age) tool on local computer

## Usage
1. Fork the repo
2. Create an age keypair
    ```
    $ age-keygen -o sops.agekey
    Public key: age15w79kqntstu6evq29z43t7tt4a8dpre4uwn6jsy9l78t57g5vdqqgx8vzu
    ```
3. Add the created public key to `.sops.yaml`
    * This key is used by SOPS to encrypt the provisioning script
4. Create a provisioning script
    * Example file in the repo
        * `examples/target-comfyui.sh` 
    * Store the script in `targets/` folder
    * Make sure the filename has the word `secret` in it
5. Encrypt the provisioning script before committing to the repository
    ```
    $ sops encrypt --in-place my-target.secret.sh
    ```
6. Create a RunPod template (next section has an example)
    * You can get the `LOADER_SOPSKEY` from the generated age key file
        * The private key is used to decrypt the provisioning script on the RunPod Pod

## Example RunPod template
![Screenshot](/screenshot.png?raw=true)
### Volume mount path on template
A RunPod network volume should be mounted to /workspace/modelstorage. All the models are thus downloaded only once and persist on that volume even if you destroy your Pod and create a new one. When a new Pod is started, the required models are downloaded (if they do not already exist) and then copied from the network volume to the local pod filesystem for enhanced performance in ComfyUI.
### Environment variables for template
| Key name |  Explanation
|:-------  | :----------- 
| HF_TOKEN | HuggingFace API token for downloading models
| CIVITAI_TOKEN | CivitAI API token for downloading models
| PROVISIONING_SCRIPT | URL to the `loader.sh` script in the repo
| LOADER_TARGET | URL to an actual provisioning script in the repo (e.g. flux.secret.sh or sdxl.secret.sh)
| LOADER_SOPSKEY | AGE private key used to decrypt the provisioning script (e.g. AGE-SECRET-KEY-xxxxxxxxxxxxxxxxxxxxxxxxx...)