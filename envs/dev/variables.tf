variable "region" { 
  type = string 
}

variable "name"   { 
  type = string 
}

variable "tags"   { 
  type = map(string) 
}

variable "repos"  { 
  type = list(string) 
}