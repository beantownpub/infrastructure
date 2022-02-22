# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

data "terraform_remote_state" "tfc" {
  backend = "remote"
  config = {
    organization = "beantown"
    workspaces = {
      name = "tfc"
    }
  }
}
