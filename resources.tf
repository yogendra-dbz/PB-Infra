resource "aws_key_pair" "default"{
  key_name = "${var.key_name}" 
  public_key = "${file("${var.key_path}")}"
}

resource "aws_instance" "master" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.default.id}"
  user_data = "${file("${var.bootstrap_path}")}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  tags {
    Name  = "master"
  }
  
  provisioner "local-exec" {
    command = "sleep 120"
  }
  
}


data "aws_eip" "master_ip" {
  public_ip = "${var.master_public_ip}"
}

resource "aws_eip_association" "master_eip" {
  instance_id   = "${aws_instance.master.id}"
  allocation_id = "${data.aws_eip.master_ip.id}"
}


resource "aws_instance" "worker1" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.default.id}"
  user_data = "${file("${var.bootstrap_path}")}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  tags {
    Name  = "worker 1"
  }
  
  depends_on = ["aws_instance.master"]
  
  provisioner "local-exec" {
    command = "sleep 120"
  }
}

data "aws_eip" "worker1_ip" {
  public_ip = "${var.worker1_public_ip}"
}

resource "aws_eip_association" "worker1_eip" {
  instance_id   = "${aws_instance.worker1.id}"
  allocation_id = "${data.aws_eip.worker1_ip.id}"
}


resource "aws_instance" "worker2" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.default.id}"
  user_data = "${file("${var.bootstrap_path}")}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  tags {
    Name  = "worker 2"
  }
  
  depends_on = ["aws_instance.master","aws_instance.worker1"]
  
  provisioner "local-exec" {
    command = "sleep 120"
  }
  
}

data "aws_eip" "worker2_ip" {
  public_ip = "${var.worker2_public_ip}"
}

resource "aws_eip_association" "worker2_eip" {
  instance_id   = "${aws_instance.worker2.id}"
  allocation_id = "${data.aws_eip.worker2_ip.id}"
}

output "Mip" {
  value = ["${aws_instance.master.*.public_dns}"]
}

output "W1ip" {
  value = ["${aws_instance.worker1.*.public_dns}"]
}

output "W2ip" {
  value = ["${aws_instance.worker2.*.public_dns}"]
}

resource "null_resource" "ansible" {
  depends_on = ["aws_instance.worker2"]
  
  provisioner "local-exec" {
    command = "sleep 10 && chmod +x AddRemoveSSHKey.sh &&  ./AddRemoveSSHKey.sh "
  }
}
