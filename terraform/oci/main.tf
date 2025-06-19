terraform {
  required_providers {
    oci ={
        source = "oracle/oci"
        version = "~> 5.0"
    } 
  }
}

provider "oci" {
    tenancy_ocid = var.tenancy_ocid
    user_ocid = var.user_ocid
    fingerprint = var.fingerprint
    private_key_path = var.private_key_path
    region = var.region
}

resource "oci_core_vcn" "main_vcn" {
    compartment_id = var.compartment_ocid
    cidr_block = "10.0.0.0/16"
    display_name = "main_vcn"
  
}

resource "oci_core_subnet" "public_subnet" {
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.main_vcn
    cidr_block = "10.0.1.0/24"
    display_name = "public_subnet"
    availability_domain = var.availability_domain  
    prohibit_public_ip_on_vnic = false
}

resource "oci_core_instance" "web_instance" {
    availability_domain = var.availability_domain  
    compartment_id = var.compartment_ocid
    shape  = "VM.Standard.E2.1.Micro" 
    display_name = "oci_web"
    source_details {
        source_type = "image"
        source_id = var.image_ocid
    }

    create_vnic_details {
      subnet_id = oci_core_subnet.public_subnet
      assign_public_ip = true
    }

    metadata = {
        user_data = base64encode(file("setup.sh"))
    }
}