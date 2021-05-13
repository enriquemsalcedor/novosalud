require 'test_helper'

class ActivacionProductoMailerTest < ActionMailer::TestCase
  test "notificarActivacion" do
    mail = ActivacionProductoMailer.notificarActivacion
    assert_equal "Notificaractivacion", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
