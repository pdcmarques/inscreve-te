class CreateInscricaos < ActiveRecord::Migration
  def self.up
    create_table :inscricaos do |t|
      t.string    :nome
      t.datetime  :data_nascimento
      t.integer   :igreja_id
      t.string    :estatuto
      t.string    :morada
      t.string    :codigo_postal
      t.string    :localidade
      t.string    :email
      t.string    :telefone
      t.string    :tipo_alojamento
      t.boolean   :noite1
      t.boolean   :noite2
      t.string    :local_alojamento
      t.string    :refeicao1
      t.string    :refeicao2
      t.string    :refeicao3
      t.string    :refeicao4
      t.boolean   :presente
      t.boolean   :cancelado
      t.boolean   :pago
      t.text      :observacoes
      t.integer   :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :inscricaos
  end
end
