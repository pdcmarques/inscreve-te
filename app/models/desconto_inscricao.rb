class DescontoInscricao < ActiveRecord::Base
  belongs_to :inscricao
  belongs_to :desconto
  
  
  def valor
    valor = 0.to_f
    inscricao.consumos.each do |consumo|
      preco_produto = consumo.preco.to_f
      if(desconto.todos_produtos)
          if(desconto.absoluto > 0)
              valor += desconto.absoluto.to_f
          end
          if(desconto.percentagem > 0)
              valor += preco_produto.to_f*((desconto.percentagem.to_f/100.to_f).to_f)
          end
      else
        if(desconto.produto_id != nil && desconto.produto_id > 0)
          if(consumo.produto_id == desconto.produto_id)
            if(desconto.absoluto > 0)
                valor += desconto.absoluto.to_f
            end
            if(desconto.percentagem > 0)
                valor += preco_produto.to_f*((desconto.percentagem.to_f/100.to_f).to_f)
            end 
          end
        end
      end
    end
    valor.to_f  
  end
end
