require 'cpf_cnpj'

module CnpjValidatable
  extend ActiveSupport::Concern

  included do
    validate :valid_cnpj_format
  end

  private

  def valid_cnpj_format
    return unless cnpj.present?

    cnpj_clean = CNPJ.new(cnpj).stripped

    unless CNPJ.valid?(cnpj_clean)
      errors.add(:cnpj, 'inválido')
    end
  end
end
