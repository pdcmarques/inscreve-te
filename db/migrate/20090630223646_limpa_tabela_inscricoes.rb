class LimpaTabelaInscricoes < ActiveRecord::Migration
  def self.up
    remove_column :inscricaos,  :morada
    remove_column :inscricaos,  :codigo_postal
    remove_column :inscricaos,  :localidade
    remove_column :inscricaos,  :tipo_alojamento
    remove_column :inscricaos,  :local_alojamento
    remove_column :inscricaos,  :presente
    remove_column :inscricaos,  :cancelado
    remove_column :inscricaos,  :pago
    remove_column :inscricaos,  :observacoes
    remove_column :inscricaos,  :refeicao1_id
    remove_column :inscricaos,  :refeicao2_id
    remove_column :inscricaos,  :refeicao3_id
    remove_column :inscricaos,  :refeicao4_id
    remove_column :inscricaos,  :refeicao5_id
    remove_column :inscricaos,  :noite1_id
    remove_column :inscricaos,  :noite2_id
    remove_column :inscricaos,  :nome_cracha
    remove_column :inscricaos,  :n_camas_extra
  end

  def self.down
  end
end
