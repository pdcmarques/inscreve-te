class Pacote < ActiveRecord::Base
  has_many     :pacote_produtoss
  belongs_to   :produto
  
  def is_complete(consumos)
    complete = true
    pacote_produtoss.each do |pacote_produtos|
      produto = pacote_produtos.produto
      found = false
      consumos.each do |consumo|
        if(consumo.produto_id == produto.id)
          found = true
        end
      end
      if(!found)
        complete = false
      end
    end
    complete
  end
  
  
end
