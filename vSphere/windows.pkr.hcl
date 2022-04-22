source "vsphere-iso" "Windows_Server_2012" {
  vcenter_sever = ""
  host = ""
  username =
  password =
  cluster = "Test_Cluster"
  datacenter = "Test_DC"
  datastore = "Test_ONEFS"
  insecure_connection = true

  vm_name = "Golden_VM"
  winrm_password = ""
  winrm_username = ""
  CPUs = 3
  RAM = 8192
  RAM_reserve_all = true
  communicator = "winrm"
  disk_controller_type = ["lsilogic-sas"]
  firmware = "BIOS"
  floppy_files = ["setup.ps1"]
  iso_paths = ["[Test_ONEFS] ISO/Windows_Server_2012/Windows_Server_2012_x64_en-us.iso"]
  network_adaptors{
    network = "VM Network"
    network_card = "vmxnet3"
  }
  storage{
    disk_size = "4096"
    disk_thin_provisioned = true
  }
  convert_to_template = true
}

provisioner "powershell" {
  elevated_password = ""
  elevated_user     = ""
  inline            = ["Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"]
}

provisioner "windows-update" {
  filters         = ["exclude:$_.Title -like '*Preview*'", "include:$_.AutoSelectOnWebSites"]
  search_criteria = "IsInstalled=0"
}

provisioner "windows-restart" {
  restart_timeout = "30m"
}

provisioner "shell-local" {
  command = "sleep 30"
}

provisioner "powershell" {
  elevated_password = "${var.User_Password}"
  elevated_user     = "${var.User_Name}"
  inline            = ["choco upgrade chocolatey"]
}


provisioner "shell-local" {
  command = "sleep 30"
}


provisioner "powershell" {
  inline = ["choco install -y git.install"]
}

provisioner "windows-update" {
  filters         = ["exclude:$_.Title -like '*Preview*'", "include:$_.AutoSelectOnWebSites"]
  search_criteria = "IsInstalled=0"
}

build {
  sources = ["source.vsphere-iso.Windows_Server_2012"]
}

