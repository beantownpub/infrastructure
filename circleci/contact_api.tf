# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

resource "circleci_environment_variable" "test_email_recipient" {
  name    = "TEST_EMAIL_RECIPIENT"
  value   = var.test_email_recipient
  project = "contact_api"
}
