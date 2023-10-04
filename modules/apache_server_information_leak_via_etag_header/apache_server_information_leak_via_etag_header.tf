resource "shoreline_notebook" "apache_server_information_leak_via_etag_header" {
  name       = "apache_server_information_leak_via_etag_header"
  data       = file("${path.module}/data/apache_server_information_leak_via_etag_header.json")
  depends_on = [shoreline_action.invoke_update_apache_version,shoreline_action.invoke_stop_edit_restart_apache]
}

resource "shoreline_file" "update_apache_version" {
  name             = "update_apache_version"
  input_file       = "${path.module}/data/update_apache_version.sh"
  md5              = filemd5("${path.module}/data/update_apache_version.sh")
  description      = "Update the Apache web server to the latest version and apply any patches that address the ETag header vulnerability."
  destination_path = "/agent/scripts/update_apache_version.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "stop_edit_restart_apache" {
  name             = "stop_edit_restart_apache"
  input_file       = "${path.module}/data/stop_edit_restart_apache.sh"
  md5              = filemd5("${path.module}/data/stop_edit_restart_apache.sh")
  description      = "Configure the ETag header to only include a secure hash value that does not reveal any sensitive information about the server or its configuration."
  destination_path = "/agent/scripts/stop_edit_restart_apache.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_apache_version" {
  name        = "invoke_update_apache_version"
  description = "Update the Apache web server to the latest version and apply any patches that address the ETag header vulnerability."
  command     = "`chmod +x /agent/scripts/update_apache_version.sh && /agent/scripts/update_apache_version.sh`"
  params      = []
  file_deps   = ["update_apache_version"]
  enabled     = true
  depends_on  = [shoreline_file.update_apache_version]
}

resource "shoreline_action" "invoke_stop_edit_restart_apache" {
  name        = "invoke_stop_edit_restart_apache"
  description = "Configure the ETag header to only include a secure hash value that does not reveal any sensitive information about the server or its configuration."
  command     = "`chmod +x /agent/scripts/stop_edit_restart_apache.sh && /agent/scripts/stop_edit_restart_apache.sh`"
  params      = ["PATH_TO_APACHE_CONFIG_FILE"]
  file_deps   = ["stop_edit_restart_apache"]
  enabled     = true
  depends_on  = [shoreline_file.stop_edit_restart_apache]
}

