pid_file = "./vault-agent/agent.pid"

vault {
  address = "https://vault-test.big.netlobo.com:8200"
}

auto_auth {
  method "approle" {
    config = {
      role_id_file_path = "./approle/role_id_file"
      secret_id_file_path = "./approle/secret_id_file"

      # Better to remove secret_id_file after reading in production
      # Default is true, for testing purposes I'm setting this to false
      remove_secret_id_file_after_reading = false
    }
  }

  sink {
    type = "file"
    config = {
      path = "./secret/sink_token"
    }
  }
}

cache {
  use_auto_auth_token = true
}

listener "tcp" {
  address = "127.0.0.1:8100"
  tls_disable = true
}

template {
  source      = "./templates/db.ctmpl"
  destination = "./rendered/db"
}

template {
  source      = "./templates/tls_cert7.ctmpl"
  destination = "./rendered/tls_cert7"
}

#env_template "DBPASS" {
#   contents             = "{{ with secret \"kv/1234/dev/db\" }}{{ .Data.data.db }}{{ end }}"
#   error_on_missing_key = true
#}
