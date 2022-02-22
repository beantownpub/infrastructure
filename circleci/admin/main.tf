# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

resource "circleci_project" "beantownpub_admin" {
  name = "admin"
  env_vars = {
    GOOGLE_API_KEY = var.google_api_key
  }
}
