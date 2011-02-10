class InscricaoObserver < ActiveRecord::Observer
  def after_save(inscricao)
    inscricao.consumos.each do |consumo|
      preco_produto = consumo.produto.get_preco(inscricao)
      #inscricao.desconto_inscricaos.each do |desconto_insc|
      #    desconto = desconto_insc.desconto
      #    if(desconto.todos_produtos)
      #        if(desconto.absoluto > 0)
      #            preco_produto = preco_produto-(desconto.absoluto)
      #        end
      #        if(desconto.percentagem > 0)
      #            preco_produto =  preco_produto - preco_produto.to_f*(desconto.percentagem/100).to_f
      #        end
      #    else
      #        if(desconto.produto_id != nil && desconto.produto_id > 0)
      #            if(consumo.produto_id == desconto.produto_id)
      #                if(desconto.absoluto > 0)
      #                  preco_produto = preco_produto.to_f-(desconto.absoluto.to_f)
      #                end
      #                if(desconto.percentagem > 0)
      #                    preco_produto = preco_produto.to_f-preco_produto.to_f*(desconto.percentagem/100).to_f
      #                end 
      #            end
      #        end
      #    end
      #end
      consumo.preco = preco_produto
      consumo.save
    end
  end
end

