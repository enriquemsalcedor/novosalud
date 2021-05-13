# app/mailers/devise_custom_mailer.rb
class DeviseCustomMailer < Devise::Mailer

  before_filter :add_inline_attachment!

  def confirmation_instructions(record,token, opts={})
    super
  end

  def reset_password_instructions(record,token, opts={})
    super
  end

  def password_change(record)
    super
  end

  def unlock_instructions(record,token, opts={})
    super
  end

  private
  def add_inline_attachment!
    attachments.inline["novo_enlinea.png"] = File.read("#{Rails.root}/app/assets/images/novo_enlinea.png")
  end
end