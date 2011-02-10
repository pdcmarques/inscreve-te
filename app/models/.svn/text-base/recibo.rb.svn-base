class Recibo < ActiveRecord::Base
    has_many    :consumos
    belongs_to  :igreja
    belongs_to  :inscricao
    belongs_to  :evento
    has_many    :pagamentos, :dependent => :delete_all
    has_many    :desconto_facturas, :dependent => :delete_all
    
    
    def total_recibo
      total = 0.to_f
      for consumo in consumos do
        preco_produto = consumo.preco.to_f
        if(consumo.inscricao != nil)
	    consumo.inscricao.desconto_inscricaos.each do |desconto_insc|
		desconto = desconto_insc.desconto
			if(self.evento.desconto_antecipacao != desconto.id)
				    if(desconto.todos_produtos)
					    if(desconto.absoluto > 0)
						    preco_produto = preco_produto.to_f-(desconto.absoluto).to_f
					    end
					    if(desconto.percentagem > 0)
						    preco_produto = preco_produto.to_f - preco_produto.to_f*((desconto.percentagem.to_f/100.to_f).to_f)
					    end
				    else
					    if(desconto.produto_id != nil && desconto.produto_id > 0)
						    if(consumo.produto_id == desconto.produto_id)
							    if(desconto.absoluto > 0)
								    preco_produto = preco_produto.to_f-(desconto.absoluto.to_f)
							    end
							    if(desconto.percentagem > 0)
								    preco_produto = preco_produto.to_f - preco_produto.to_f*((desconto.percentagem.to_f/100.to_f).to_f)
							    end 
						    end
					    end
				    end
			    end
	    end
        end
        total += preco_produto.to_f
      end
      self.desconto_facturas.each do |desconto|
          if(desconto.todos_produtos)
                  if(desconto.absoluto > 0)
                      total = total.to_f-(desconto.absoluto).to_f
                  end
                  if(deconto.percentagem > 0)
                      total = total.to_f - total.to_f*((desconto.percentagem.to_f/100.to_f).to_f)
                  end
          end
          
      end
      total
    end
    
    
    def calcula_total_recibo_data(data_pagamento)
	total = 0.to_f
	consumos.each do |consumo|
	    if(consumo.inscricao != nil)
		preco_produto = consumo.produto.get_preco(consumo.inscricao, consumo.inscricao.created_at, data_pagamento).to_f
		consumo.inscricao.desconto_inscricaos.each do |desconto_insc|
		    desconto = desconto_insc.desconto
		    if(self.evento.desconto_antecipacao != desconto.id)
				if(desconto.todos_produtos)
					if(desconto.absoluto > 0)
						preco_produto = preco_produto.to_f-(desconto.absoluto).to_f
					end
					if(desconto.percentagem > 0)
						preco_produto = preco_produto.to_f - preco_produto.to_f*((desconto.percentagem.to_f/100.to_f).to_f)
					end
				else
					if(desconto.produto_id != nil && desconto.produto_id > 0)
						if(consumo.produto_id == desconto.produto_id)
							if(desconto.absoluto > 0)
								preco_produto = preco_produto.to_f-(desconto.absoluto.to_f)
							end
							if(desconto.percentagem > 0)
								preco_produto = preco_produto.to_f - preco_produto.to_f*((desconto.percentagem.to_f/100.to_f).to_f)
							end 
						end
					end
				end
			end
		end
	    else
		preco_produto = consumo.produto.get_preco(nil, created_at, data_pagamento).to_f
	    end
	  total += preco_produto.to_f
	end
	self.desconto_facturas.each do |desconto|
	    if(desconto.todos_produtos)
		    if(desconto.absoluto > 0)
			total = total.to_f-(desconto.absoluto).to_f
		    end
		    if(deconto.percentagem > 0)
			total = total.to_f - total.to_f*((desconto.percentagem.to_f/100.to_f).to_f)
		    end
	    end
	    
	end
	total
    end
    
    
    
    def datas_mudanca_preco
	datas = []
	datas << data
	if(evento.desconto_antecipacao != nil)
	    datas << data+(evento.dias_para_pagamento_taxa+1).days    
	end
	self.consumos.each do |consumo|
	    idade_inscricao = consumo.inscricao != nil ? consumo.inscricao : 0
	    consumo.produto.precos.each do |preco|
		if (preco.data_pagamento && preco.data_min > evento.created_at && preco.idade_min <= consumo.inscricao.idade && preco.idade_max >= consumo.inscricao.idade)
		    if(preco.data_min > data)
			datas << preco.data_min
		    end
		end
	    end
	end
	datas.sort
    end
    
    
    def mudancas_preco
	precos = []
	ultimo_preco = 0
	ultimo_desconto = 0
	ultima_mudanca = nil
	datas_mudanca_preco.each do |data|
	    preco = calcula_total_recibo_data(data)
	    desconto = valor_desconto_antecipado(data)
	    #puts "DATA: "+data.to_s+" / VALOR: "+preco.to_s+" / DESCONTO: "+desconto.to_s
	    if(preco != ultimo_preco || desconto != ultimo_desconto)
		if(ultima_mudanca)
		    ultima_mudanca.proxima_data = data-1.day
		end
		mudancaPreco = MudancaPreco.new
		mudancaPreco.data = data
		mudancaPreco.valor = preco
		mudancaPreco.desconto = desconto
		precos << mudancaPreco
		ultimo_preco = preco
		ultimo_desconto = desconto
		ultima_mudanca = mudancaPreco
	    end
	end
	precos
    end
    
    
    def total_pago
      total = 0
      for pagamento in pagamentos do
        total += pagamento.valor
      end
      total
    end
    
    def pago
      return (total_pago >= (total_recibo-valor_desconto_antecipado))
    end
    
    
    def referencia_multibanco
        if(merece_desconto_antecipado)
            valor = ((total_recibo.to_f-valor_desconto_antecipado.to_f-total_pago.to_f).to_f*100).to_i
        else
            valor = ((total_recibo-total_pago).to_f*100).to_i
        end
        
      stringRef = evento.entidade_mb.to_s+evento.prefixo_ref_mb.to_s+referencia_mb.to_s.rjust(4, '0') + valor.to_s.rjust(8, '0')
      
      multiplicadores = [3, 30, 9, 90, 27, 76, 81, 34, 49, 5, 50, 15, 53, 45, 62, 38, 89, 17, 73, 51]
      check = 0 
      i=0;
      for multiplicador in multiplicadores
        digito = stringRef[19-i,1].to_i
        check += (digito % 10)*multiplicador
        i = i + 1
      end
      check = 98 - (check % 97)
      
      stringMB = evento.prefixo_ref_mb.to_s + referencia_mb.to_s.rjust(4, '0') + check.to_s.rjust(2, '0')
      stringMB[0..2]+" "+stringMB[3..5]+" "+stringMB[6..8]
    end
    
    
    def referencia_multibanco_taxa_inscricao
       
      valor = ((taxa_inscricao).to_f*100).to_i
        
      stringRef = evento.entidade_mb.to_s+evento.prefixo_ref_mb.to_s+referencia_mb.to_s.rjust(4, '0') + valor.to_s.rjust(8, '0')
      
      multiplicadores = [3, 30, 9, 90, 27, 76, 81, 34, 49, 5, 50, 15, 53, 45, 62, 38, 89, 17, 73, 51]
      check = 0 
      i=0;
      for multiplicador in multiplicadores
        digito = stringRef[19-i,1].to_i
        check += (digito % 10)*multiplicador
        i = i + 1
      end
      check = 98 - (check % 97)
      
      stringMB = evento.prefixo_ref_mb.to_s + referencia_mb.to_s.rjust(4, '0') + check.to_s.rjust(2, '0')
      stringMB[0..2]+" "+stringMB[3..5]+" "+stringMB[6..8]
    end
    
    
    def calcula_id_multibanco
        ultima_ref = Recibo.maximum(:referencia_mb, :conditions=>"evento_id = "+self.evento_id.to_s)
        if(ultima_ref == nil || ultima_ref == 0)
            self.referencia_mb = evento.referencia_mb_min
        else
            self.referencia_mb = ultima_ref+1
        end
    end
    
    
    
    def data_desconto
	data_tx = nil
	if(self.evento.dias_para_pagamento_taxa > 0)
	    data_tx = self.data+self.evento.dias_para_pagamento_taxa.days
	end
	if((self.evento.data_limite_desconto_antecipacao != nil) && (data_tx == nil || data_tx > (self.evento.data_limite_desconto_antecipacao)))
	    data_tx = self.evento.data_limite_desconto_antecipacao
	end
	
	if(self.evento.dias_para_pagamento_total != nil)
	    data_total = self.data + self.evento.dias_para_pagamento_total.days
	else
	    data_total = data_tx
	end
	
	if(data_tx != nil)
            if(data_tx > (data_total))
              data_desconto = data_total
            else
              data_desconto = data_tx
            end
	else
            data_desconto = self.data
        end
        
	data_desconto
    end
    
    
        
    def linhas_recibo
      @recibo_itens = []
      
      for consumo in consumos do
	inscricao_id = consumo.inscricao != nil ? consumo.inscricao_id : 0
	if(@recibo_itens[inscricao_id] == nil)
	    @recibo_itens[inscricao_id] = LinhaReciboParent.new
	    @recibo_itens[inscricao_id].inscricao_id = inscricao_id
	    @recibo_itens[inscricao_id].linhas_recibo = []
	    @recibo_itens[inscricao_id].linhas_recibo_desconto = []
	    if(consumo.inscricao != nil)
		consumo.inscricao.desconto_inscricaos.each do |desconto_insc|
		    #puts "*********************** DESCONTO INSCRICAO ***********************"
		    if(self.evento.desconto_antecipacao != desconto_insc.desconto_id || (self.evento.desconto_antecipacao == desconto_insc.desconto_id && merece_desconto_antecipado))
			desconto = desconto_insc.desconto
			if(@recibo_itens[consumo.inscricao_id].linhas_recibo_desconto[desconto.id] == nil)
			    @recibo_itens[consumo.inscricao_id].linhas_recibo_desconto[desconto.id] = LinhaReciboDesconto.new
			    if(self.evento.desconto_antecipacao == desconto_insc.desconto_id)
			        @recibo_itens[consumo.inscricao_id].linhas_recibo_desconto[desconto.id].descricao = desconto.descricao+'<br/><font size="-1"><i>(se pago integralmente até '+data_desconto.strftime("%d/%m/%Y")+')</i></font>'
			    else
			        @recibo_itens[consumo.inscricao_id].linhas_recibo_desconto[desconto.id].descricao = desconto.descricao
			    end
			    @recibo_itens[consumo.inscricao_id].linhas_recibo_desconto[desconto.id].valor = desconto_insc.valor.to_f
			end
		    end
		end
	    end
	end
	
        if(@recibo_itens[inscricao_id].linhas_recibo[consumo.produto_id] == nil)
          @recibo_itens[inscricao_id].linhas_recibo[consumo.produto_id] = LinhaRecibo.new()
          @recibo_itens[inscricao_id].linhas_recibo[consumo.produto_id].descricao = consumo.produto.descricao
          @recibo_itens[inscricao_id].linhas_recibo[consumo.produto_id].preco = consumo.preco
        end
        if @recibo_itens[inscricao_id].linhas_recibo[consumo.produto_id].quantidade == nil
          @recibo_itens[inscricao_id].linhas_recibo[consumo.produto_id].quantidade = 0
        end
        preco = consumo.preco.to_f
        if(preco > 0)
          @recibo_itens[inscricao_id].linhas_recibo[consumo.produto_id].quantidade += 1
          if @recibo_itens[inscricao_id].linhas_recibo[consumo.produto_id].subtotal == nil
            @recibo_itens[inscricao_id].linhas_recibo[consumo.produto_id].subtotal = 0.to_f
          end
          @recibo_itens[inscricao_id].linhas_recibo[consumo.produto_id].subtotal += preco.to_f
        end
      end
      
      @recibo_itens
    end
    
    
    def merece_desconto_antecipado(data_calculo = Date.today)
        n_dias_desconto_antecipado = evento.dias_para_pagamento_taxa
        n_pagamentos_para_desconto = evento.limite_pagamentos_para_desconto
        montante_max_para_desconto = evento.limite_montante_para_desconto
        dias_que_ja_passaram = data_calculo.to_date - data.to_date
        
        if(data_calculo >= Date.today)
	    #puts "PgAntesDe: "+(data+n_dias_desconto_antecipado).to_s+", "+(calcula_total_recibo_data(self.data+n_dias_desconto_antecipado.days).to_f-valor_deconto_antecipado_inner.to_f).to_s
	    #+(data+n_dias_desconto_antecipado.days).to_s+", "+(calcula_total_recibo_data(self.data+n_dias_desconto_antecipado.days).to_f-valor_deconto_antecipado_inner.to_f)).to_s
	    if(pago_antes_de(data_desconto, (calcula_total_recibo_data(self.data).to_f)-valor_deconto_antecipado_inner.to_f))
		#puts "--->PAGO_ANTES_DE OK"
		return true
	    end
        end
        if(evento.data_limite_desconto_pagamento_antecipado != nil && self.data >= evento.data_limite_desconto_pagamento_antecipado)
	    #puts "--->DATA_LIMITE_DESCONTO NOK"
            return false
        end
        if(evento.data_limite_desconto_antecipacao != nil && self.data >= evento.data_limite_desconto_antecipacao)
	    #puts "--->DATA_LIMITE_DESCONTO NOK"
            return false
        end
        if(evento.desconto_pagamento_antecipado == 0 && evento.desconto_antecipacao == 0)
	    #puts "--->SEM QQ DESCONTO NOK"
            return false
        end
        if(dias_que_ja_passaram > n_dias_desconto_antecipado)
	    #puts "--->DIAS Q JA PASSARAM NOK"
            return false
        end
        if(data_calculo == Date.today)
	    if(pagamentos.count > n_pagamentos_para_desconto)
		#puts "--->N PAGAMENTOS NOK"
		return false
	    end
	    if(total_pago > montante_max_para_desconto)
		#puts "--->MONTANTE MAX P DESCONTO NOK"
		return false
	    end
        end
        
        puts "--->TUDO OK"
        return true
    end
    
    def pago_antes_de(data, montante)
        montante_pago_antes = 0.to_f;
        pagamentos.each do |pagamento|
            if(pagamento.data <= data)
                montante_pago_antes = montante_pago_antes.to_f+pagamento.valor.to_f
            end
        end
        montante_pago_antes.to_f >= montante.to_f
    end
    
    def desconto_de_pagamento_antecipado
        desconto = Desconto.find_by_id(evento.desconto_pagamento_antecipado)
    end
    
    
    def valor_desconto_antecipado(data_calculo = Date.today)
	#puts "A CALCULAR DESCONTO PARA A DATA "+data_calculo.to_s
        valor = 0.to_f
        if(merece_desconto_antecipado(data_calculo))
	    #puts "MERECE DESCONTO"
            valor = valor_deconto_antecipado_inner
            #puts "VALOR DO DESCONTO: "+valor.to_s
        else
	    #puts "***Não Merece Desconto***"
            valor = 0
        end
        
        valor.to_f
    end
    
    def valor_deconto_antecipado_inner
        valor = 0.to_f
        desconto = desconto_de_pagamento_antecipado
        if(desconto != nil)
            if(desconto.percentagem != nil && desconto.percentagem > 0)
                valor = total_recibo.to_f * ((desconto.percentagem.to_f/100.to_f).to_f)
            end
            if(desconto.absoluto != nil && desconto.absoluto > 0)
                valor = valor.to_f + desconto.absoluto.to_f
            end
        end
		
	if(self.evento.desconto_antecipacao != 0 && self.evento.desconto_antecipacao != nil)
	    for consumo in consumos do
		preco_produto = consumo.preco.to_f
		if(consumo.inscricao != nil)
		    consumo.inscricao.desconto_inscricaos.each do |desconto_insc|
			#puts "--->DESCONTO: "+desconto_insc.desconto.descricao
			desconto = desconto_insc.desconto
			if(self.evento.desconto_antecipacao == desconto.id)
			    #puts "--->DESCONTO ANTEC: OK!"
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
		    end
		end
	    end
	end


        valor.to_f
    end


    def taxa_inscricao
        valor_taxa = 0.to_f
        if(evento.taxa_insc_is_percentagem)
            valor_taxa = (total_recibo-valor_deconto_antecipado_inner).to_f*(evento.taxa_inscricao.to_f/100).to_f
        else
            valor_taxa = evento.taxa_inscricao.to_f
        end

		for consumo in consumos do
				if consumo.produto.is_taxa_inscricao
					valor_taxa += consumo.preco
				end
		end	  
        		
        valor_taxa = valor_taxa.round
		
        if((total_recibo-valor_deconto_antecipado_inner) < evento.taxa_inscricao_min)
            valor_taxa = 0
        end
        if(evento.taxa_inscricao_max > 0 && valor_taxa > evento.taxa_inscricao_max)
            valor_taxa = evento.taxa_inscricao_max
        end
        valor_taxa
    end
    
    
    def nivel_alerta
	nivel = 0
	if(self.dias_que_faltam_para_taxa != nil && self.dias_que_faltam_para_taxa <= 2)
	    if(taxa_inscricao > 0 && total_pago < taxa_inscricao)
		if(self.dias_que_faltam_para_taxa > 0 && self.dias_que_faltam_para_taxa <= 2)
		    nivel = 1
		end
		if(self.dias_que_faltam_para_taxa == 0)
		    nivel = 2
		end
		if(self.dias_que_faltam_para_taxa < 0)
		    nivel = 3
		end
	    end
	end
	if(self.dias_que_faltam_para_total != nil && self.dias_que_faltam_para_total <= 2 && nivel == 0)
	    if(total_recibo-valor_desconto_antecipado > total_pago)
		if(self.dias_que_faltam_para_total > 0 && self.dias_que_faltam_para_total <= 2)
		    nivel = 1
		end
		if(self.dias_que_faltam_para_total == 0)
		    nivel = 2
		end
		if(self.dias_que_faltam_para_total < 0)
		    nivel = 3
		end
	    end
	end
	nivel
    end
    
    
    def to_pdf
      id_factura = self.id
      factura = self
      
      event = factura.evento
      output_format = "PDF"
      report_unit = "/Reports/inscrevete/Factura"
      report_params = { :logotipoUrlString => "http://www.inscreve-te.com.pt/images/"+event.entidade.sigla+"/factura_logo.jpg",
                        :NomeEvento => event.nome,
                        :XML_URL =>  "http://www.inscreve-te.com.pt/"+event.entidade.sigla+"/recibos/detalhe_xml/"+id_factura.to_s+".xml",
                        :REPORT_LOCALE =>  "pt_PT",
                        :XML_DATE_PATTERN => "dd-MM-yyyy",
                        :TipoInscricao => "Inscri\u00B8\u223Co"
                      } # this should be a Hash!
  
      client = JasperServer::Client.new("http://www.inscreve-te.com.pt:8888/jasperserver/services/repository",
                                        "pdcmarques", "pdm49731")
      request = JasperServer::ReportRequest.new(report_unit, output_format, report_params)
      pdf_data = client.request_report(request)
      return pdf_data
    end
    
    
    
    class LinhaReciboParent
      def inscricao_id
          @inscricao_id
      end
      def inscricao_id=(inscricao_id)
          @inscricao_id = inscricao_id
      end
      
      def inscricao
	  if(@inscricao_id != 0)
	      Inscricao.find_by_id(@inscricao_id)
	  else
	      nil
	  end
      end
      
      def linhas_recibo
          @linhas_recibo
      end
      def linhas_recibo=(linhasrecibo)
          @linhas_recibo = linhasrecibo
      end
      
      def linhas_recibo_desconto
          @linhas_recibo_desconto
      end
      def linhas_recibo_desconto=(linhasrecibodeconto)
          @linhas_recibo_desconto = linhasrecibodeconto
      end
      
    end
    
    class LinhaRecibo
      def descricao  
        @descricao  
      end  
      def descricao=(descricao)  
        @descricao = descricao
      end  

      def quantidade
        @quantidade
      end  
      def quantidade=(quantidade)  
        @quantidade = quantidade
      end  
      
      def preco
        @preco.to_f
      end  
      def preco=(preco)  
        @preco = preco.to_f
      end
      
      def subtotal
        @subtotal.to_f
      end  
      def subtotal=(subtotal)  
        @subtotal = subtotal.to_f
      end 
    end
    
    
    class LinhaReciboDesconto
      def descricao  
        @descricao  
      end  
      def descricao=(descricao)  
        @descricao = descricao
      end
      
      def valor
        @valor.to_f
      end  
      def valor=(valor)  
        @valor = valor.to_f
      end 
    end
    
    
    
    class MudancaPreco
      def data  
        @data
      end  
      def data=(data)  
        @data = data
      end
      
      
      def proxima_data  
        @proxima_data
      end  
      def proxima_data=(proxima_data)  
        @proxima_data = proxima_data
      end
      
      
      def valor
        @valor.to_f
      end  
      def valor=(valor)  
        @valor = valor.to_f
      end
      
      
      def desconto
	  @desconto.to_f
      end
      def desconto=(desconto)
	  @desconto = desconto.to_f
      end
    end
    
end
