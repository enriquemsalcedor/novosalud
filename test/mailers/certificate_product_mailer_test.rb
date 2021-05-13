require 'test_helper'

class CertificateProductMailerTest < ActionMailer::TestCase
  test "enviar_certificado" do
    mail = CertificateProductMailer.enviar_certificado
    assert_equal "Enviar certificado", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
