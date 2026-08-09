# Hyprland Hybrid GPU Setup (AMD iGPU + NVIDIA dGPU)

## System Configuration

**GPU Setup:**
- **Primary (Hyprland):** AMD Raphael iGPU at `10:00.0` (monitor connected here)
- **Secondary (Apps):** NVIDIA GeForce RTX 5070 at `01:00.0` (available for offloading)

**Driver Version:** 580.126.09

## Current Setup (Updated: 2026-01-28)

### 1. GPU Priority Configuration
✅ `WLR_DRM_DEVICES` set to prioritize AMD iGPU: `/dev/dri/by-path/pci-0000:10:00.0-card:/dev/dri/by-path/pci-0000:01:00.0-card`
✅ Hyprland compositor runs on AMD iGPU (where monitor is connected)
✅ NVIDIA dGPU available for on-demand application rendering

### 2. Environment Variables
✅ Using AMD/Mesa drivers by default: `LIBVA_DRIVER_NAME=radeonsi`, `GBM_BACKEND=amdgpu`
✅ Wayland support enabled for all applications
✅ NVIDIA environment variables removed from global scope

### 3. NVIDIA GPU Offloading
To run applications on the NVIDIA dGPU, use one of these methods:

**Method 1: Using the nvidia-run helper script**
```bash
nvidia-run <application>
```

Examples:
```bash
nvidia-run blender
nvidia-run steam
nvidia-run obs
nvidia-run glxgears  # for testing
```

**Method 2: Manual environment variables**
```bash
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only <application>
```

**Method 3: Per-application window rules in Hyprland**
Add to `hyprland.conf` to automatically run specific apps on NVIDIA:
```conf
env = STEAM_FORCE_DESKTOPUI_SCALING,1.5
windowrulev2 = env __NV_PRIME_RENDER_OFFLOAD 1,class:^(steam)$
windowrulev2 = env __GLX_VENDOR_LIBRARY_NAME nvidia,class:^(steam)$
windowrulev2 = env __VK_LAYER_NV_optimus NVIDIA_only,class:^(steam)$
```

### 4. Rendering Settings
✅ Direct scanout enabled for better performance
✅ VRR disabled for iGPU (can be enabled per-monitor if needed)

## Verification

After restarting Hyprland, verify the setup:

**1. Check Hyprland is using AMD iGPU:**
```bash
hyprctl systeminfo | grep "GPU"
```

**2. Check default OpenGL renderer:**
```bash
glxinfo | grep "OpenGL renderer"
# Should show: AMD Radeon Graphics (or similar)
```

**3. Test NVIDIA offloading:**
```bash
nvidia-run glxinfo | grep "OpenGL renderer"
# Should show: NVIDIA GeForce RTX 5070
```

**4. Monitor GPU usage:**
```bash
# AMD GPU
radeontop

# NVIDIA GPU  
nvidia-smi
```

## Benefits of This Setup

1. **Lower power consumption:** Compositor runs on efficient iGPU
2. **Cooler & quieter system:** NVIDIA GPU only spins up when needed
3. **Longer GPU lifespan:** NVIDIA GPU idles when not rendering 3D apps
4. **Flexibility:** Can still use NVIDIA for demanding applications

## Troubleshooting

**If Hyprland still uses NVIDIA:**
- Verify `WLR_DRM_DEVICES` is set correctly: `echo $WLR_DRM_DEVICES`
- Ensure no NVIDIA env vars are set in `~/.profile`, `~/.bashrc`, or systemd user environment
- Check: `systemctl --user show-environment | grep -i nvidia`

**If apps don't use NVIDIA when requested:**
- Verify NVIDIA driver is loaded: `lsmod | grep nvidia`
- Check NVIDIA GPU is visible: `nvidia-smi`
- Try running with verbose output: `nvidia-run __GL_SHOW_GRAPHICS_OSD=1 glxgears`

**If cursor is invisible on AMD iGPU:**
- Add: `env = WLR_NO_HARDWARE_CURSORS,1` (uncommon for AMD, but possible)

## Package Requirements

Ensure you have these packages installed:
```bash
sudo pacman -S nvidia-dkms nvidia-utils nvidia-settings lib32-nvidia-utils \
               mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon \
               libva-mesa-driver mesa-vdpau
```

## Kernel Parameters

Ensure these are in your bootloader config:
```
nvidia_drm.modeset=1 nvidia_drm.fbdev=1
```

For CachyOS with GRUB, edit `/etc/default/grub`:
```bash
sudo nano /etc/default/grub
```
Add to `GRUB_CMDLINE_LINUX_DEFAULT`, then run:
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## Backup Location

Configuration backup created at: `~/.config/hypr/backups/20260128_182512/`

## References
- [Hyprland Nvidia Wiki](https://wiki.hyprland.org/Nvidia/)
- [PRIME Render Offload (Arch Wiki)](https://wiki.archlinux.org/title/PRIME)
- [CachyOS Wiki](https://wiki.cachyos.org/)

