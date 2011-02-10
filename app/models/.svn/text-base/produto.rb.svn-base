class Produto < ActiveRecord::Base
    has_many    :consumos
    has_many    :pacote_produtoss
    has_many    :precos
    has_many    :reserva_produtos
    belongs_to  :evento
    belongs_to  :entidade
    has_one     :pacote
    
    
    def get_preco(inscricao, data_criacao = nil, data_pagamento = nil)
	
      if(data_criacao == nil && data_pagamento == nil)
	    data_criacao = DateTime.now
	    data_pagamento = DateTime.now
	    
	    if(inscricao != nil && inscricao.created_at != nil)
		data_criacao = inscricao.created_at
	    end
		
	    
	    if(inscricao != nil && inscricao.id != nil && inscricao != 0)
		data_max_pagamento = nil
		data_pagamento = DateTime.now
	    
		consumo = nil
		consumos = Consumo.find_all_by_produto_id(self.id, :conditions=>"inscricao_id = "+inscricao.id.to_s)
		if(consumos.length> 0)
		    consumo = consumos[0]
		end
		
		if(consumo != nil)
		    tx_insc = consumo.recibo.taxa_inscricao
		    
		    pagamentos = Pagamento.find_all_by_recibo_id(consumo.recibo.id, :order=>"created_at ASC")
		    montante_pago = 0
		    if(tx_insc > 0)
			pagamentos.each do |pagamento|
			    montante_pago = montante_pago + pagamento.valor
			    if(data_max_pagamento == nil || data_max_pagamento < pagamento.data)
				data_max_pagamento = pagamento.data
			    end
			    if(montante_pago >= tx_insc)
				break
			    end
			end
		    else
			montante_total = consumo.recibo.total_recibo-consumo.recibo.valor_desconto_antecipado
			pagamentos.each do |pagamento|
			    montante_pago = montante_pago + pagamento.valor
			    if(data_max_pagamento == nil || data_max_pagamento < pagamento.data)
				data_max_pagamento = pagamento.data
			    end
			    if(montante_pago >= montante_total)
				break
			    end
			end
		    end
		end
	      
		if(data_max_pagamento != nil)
		    data_pagamento = data_max_pagamento
		else
		    data_pagamento = DateTime.now
		end
	    end
      end
      
      idade = inscricao != nil ? inscricao.idade : 0
      
      preco = Preco.find_by_produto_id(self.id, :conditions=>"idade_min <= #{idade} AND idade_max >= #{idade} AND ((data_inscricao = 1 AND data_min <= '#{data_criacao.strftime("%Y%m%d")}' AND data_max >= '#{data_criacao.strftime("%Y%m%d")}') OR (data_pagamento = 1 AND data_min <= '#{data_pagamento.strftime("%Y%m%d")}' AND data_max >= '#{data_pagamento.strftime("%Y%m%d")}'))")
      if(preco != nil)
        preco.preco.to_f
      else
        0
      end
      
    end
    
end
