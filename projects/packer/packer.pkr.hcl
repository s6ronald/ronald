packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ubuntu-20.04-s6ronald"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "ubuntu-20.04-s6ronald"
  sources = ["source.amazon-ebs.ubuntu"]
  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apt-utils",
      "sudo apt-get install snapd",
      "sudo apt-get update",
      "sudo snap install kubectl --classic",
      "sudo curl -LO https://github.com/ahmetb/kubectx/releases/download/v0.9.4/kubectx",
      "sudo mv kubectx /usr/local/bin/",
      "sudo chmod +x /usr/local/bin/kubectx",
      "sudo ln -s /usr/local/bin/kubectx /usr/local/bin/kctx",
      "sudo curl -fsSL https://baltocdn.com/helm/signing.asc | sudo gpg --dearmor -o /usr/share/keyrings/helm-archive-keyring.gpg",
      "sudo echo \"deb [signed-by=/usr/share/keyrings/helm-archive-keyring.gpg] https://baltocdn.com/helm/stable/debian/ all main\" | sudo tee /etc/apt/sources.list.d/helm-stable.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y helm",
      "sudo apt-get install -y awscli",
      "sudo apt-get install -y docker-compose",
      "sudo apt-get update",
      "sudo apt-get install -y mysql-server",
      "sudo service mysql start",
      # Optional: Enable MySQL to start on boot
      # "sudo systemctl enable mysql",
      # Optional: Secure MySQL installation
      # "sudo mysql_secure_installation",
      # Verify MySQL installation
      "mysql --version",
      "sudo apt-get install -y postgresql",
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "sudo echo \"deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
       # Optional: Add your user to the docker group
    # "sudo usermod -aG docker $USER",
    # Optional: Start Docker on boot
      # "sudo systemctl enable docker",
      # Verify Docker installation
      "docker --version",
      "sudo apt-get install -y openjdk-11-jdk",
      "sudo apt-get install -y openjdk-11-jre",
      "sudo apt-get install -y python3",
      "sudo apt-get install -y python3-pip",
      "sudo apt-get install -y git",
      "sudo apt-get install -y nodejs",
      "sudo apt-get install -y npm",
      "sudo apt-get install -y maven",
      "sudo apt-get install -y wget",
      "sudo apt-get install -y ansible",
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "sudo curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg",
      "sudo sh -c 'echo \"deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main\" > /etc/apt/sources.list.d/hashicorp.list'",
      "sudo apt-get update",
      "sudo apt-get install -y terraform",
      "sudo apt-get install -y htop",
      "sudo apt-get install -y vim",
      "sudo apt-get install -y watch",
      "sudo apt-get install -y build-essential",
      "sudo apt-get install -y openssh-server"
    ]
  }
}
 

