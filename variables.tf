


variable "apim_name" {
  type          = string  
  description   = "Name for the API management"  
  default       = "ewapim"
}    


variable "resource_group_name" {
  type          = string  
  description   = "api management resource_group_name"
  default       = "ewapim-rg"
}    

variable "location" {
  type          = string  
  description   = "api management location"  
  default       = "westeurope"
}    

variable "vnet_address_space" {
    type        = list
    description = "Address space for Virtual Network"
    default = ["10.0.0.0/16"]
}


variable "sku_name" {
  type          = string  
  description   = "api management sku"  
  default       = "Developer_1"
}    

variable "publisher_name" {
  type          = string  
  description   = "api management publisher neam" 
  default       = "EuroWings" 
}    

variable "publisher_email" {
  type          = string  
  description   = "api management publisher email"  
  default       = "bakoni@eurowings.com"
}    

/*variable "apim_user_assigned_identity" {
  type          = string  
  description   = "api management apim_user_assigned_identity"  
  #default       = "dev-portal.nonprod.eurowings.com"
}*/

variable "virtual_network_type" {
  type          = string  
  description   = "api management virtual network type"  
  default       = "Internal"
} 

variable "apim_default_policy_path" {
  type = string
  description = "(optional) api management default policy path, if any policy needed to be apply"
  default = ""
}

variable "tags" {
  description   = "api management resource tags"  

  default       = { 
        "Data_Classification" = "Standard"
    }
}