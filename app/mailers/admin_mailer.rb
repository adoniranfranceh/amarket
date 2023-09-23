class AdminMailer < ApplicationMailer
  def welcome_email(admin)
    @admin = admin
    mail(to: @admin.email, subject: 'Bem-vindo ao Amarket')
  end

  def send_birthday_greeting(customer)
    @customer = customer
    mail(to: @customer.email, subject: 'Feliz Aniversário!')
  end
end