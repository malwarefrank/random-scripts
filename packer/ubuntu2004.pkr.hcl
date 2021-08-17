
variable "memory" {
  type    = number
  default = 8192
}

variable "cpus" {
  type    = number
  default = 4
}

variable "sudo_user" {
  type    = string
  default = "admin"
}

variable "sudo_password" {
  type      = string
  default   = "admin"
  sensitive = true
}

packer {
  required_plugins {
    virtualbox = {
      version = ">=0.0.1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "virtualbox-iso" "focal-server" {
  boot_command         = ["<enter><enter><f6><esc><wait> ", "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/", "<enter>"]
  boot_wait            = "5s"
  disk_size            = 65536
  guest_additions_path = "VBoxGuestAdditions_{{.Version}}.iso"
  guest_os_type        = "Ubuntu_64"
  http_directory       = "http"
  iso_checksum         = "sha256:d1f2bf834bbe9bb43faf16f9be992a6f3935e65be0edece1dee2aa6eb1767423"
  iso_url              = "http://releases.ubuntu.com/20.04/ubuntu-20.04.2-live-server-amd64.iso"
  shutdown_command     = "echo '${var.sudo_password}'|sudo -S shutdown -hP now"
  ssh_port             = 22
  ssh_username         = "${var.sudo_user}"
  ssh_password         = "${var.sudo_password}"
  ssh_handshake_attempts = 1000
  ssh_wait_timeout     = "10000s"
  vboxmanage           = [["modifyvm", "{{.Name}}", "--memory", "${var.memory}"], ["modifyvm", "{{.Name}}", "--cpus", "${var.cpus}"]]
  format               = "ova"
}


build {
  sources = ["source.virtualbox-iso.focal-server"]
  provisioner "shell" {
    execute_command = "echo '${var.sudo_password}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    scripts = [
      "scripts/init.sh",
      "scripts/cleanup.sh"
    ]
  }
}
