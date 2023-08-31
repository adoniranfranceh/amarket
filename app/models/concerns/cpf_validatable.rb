require 'cpf_cnpj'

module CpfValidatable
  extend ActiveSupport::Concern

  included do
    validate :valid_cpf_format
  end

  private

  def valid_cpf_format
    return unless cpf.present?

    cpf_clean = CPF.new(cpf).stripped

    unless CPF.valid?(cpf_clean)
      errors.add(:cpf, 'inválido')
    end
  end
end
