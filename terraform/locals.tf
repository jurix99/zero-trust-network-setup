locals {
    final_volume_path = var.volume_path == "" ? path.cwd : var.volume_path
}