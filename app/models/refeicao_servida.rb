class RefeicaoServida < ActiveRecord::Base
  belongs_to :refeicao
  belongs_to :inscricao
end
