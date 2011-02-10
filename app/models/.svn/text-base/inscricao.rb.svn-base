class Inscricao < ActiveRecord::Base
    has_many    :consumos, :dependent => :delete_all
    has_many    :refeicao_servidas, :dependent => :delete_all
    belongs_to  :user
    belongs_to  :igreja
    belongs_to  :evento
    belongs_to  :grupo_inscricoes
    has_many    :recibos
    has_many    :pagamentos
    has_many    :inscricaos_camposs, :dependent => :delete_all
    has_many    :campos, :through => :inscricaos_campos
    has_many    :recomendacaos, :dependent => :delete_all
    has_many    :desconto_inscricaos, :dependent => :delete_all
    has_one     :estatuto
    has_many    :inscricao_reservas, :dependent => :delete_all
    
    named_scope :com_valor_string, lambda { |id_campo,valor,start,limit,dir,event|
        {
            :joins=>"INNER JOIN inscricaos_campos ON inscricaos_campos.inscricao_id = inscricaos.id ",
            :conditions => ["inscricaos_campos.campo_id = ? AND inscricaos_campos.string_value like ? AND inscricaos.evento_id = ?", id_campo, valor,event],
            :order=>"inscricaos_campos.string_value "+dir,
            :limit=>limit,
            :offset=>start
        }
    }
    
    
    named_scope :com_valor_text, lambda { |id_campo,valor,start,limit,dir,event|
        {
            :joins=>"INNER JOIN inscricaos_campos ON inscricaos_campos.inscricao_id = inscricaos.id ",
            :conditions => ["inscricaos_campos.campo_id = ? AND inscricaos_campos.text_value like ? AND inscricaos.evento_id = ?", id_campo, valor,event],
            :order=>"inscricaos_campos.text_value "+dir,
            :limit=>limit,
            :offset=>start
        }
    }
    
    named_scope :com_valor_data, lambda { |id_campo,valor_inf,valor_sup,start,limit,dir,event|
        {
            :joins=>"INNER JOIN inscricaos_campos ON inscricaos_campos.inscricao_id = inscricaos.id ",
            :conditions => ["inscricaos_campos.campo_id = ? AND inscricaos_campos.date_value <= ? and inscricaos_campos.date_value >= ? AND inscricaos.evento_id = ?", id_campo, valor_sup, valor_inf,event],
            :order=>"inscricaos_campos.date_value "+dir,
            :limit=>limit,
            :offset=>start
        }
    }
    
    named_scope :com_valor_int, lambda { |id_campo,valor_inf,valor_sup,start,limit,dir,event|
        {
            :joins=>"INNER JOIN inscricaos_campos ON inscricaos_campos.inscricao_id = inscricaos.id ",
            :conditions => ["inscricaos_campos.campo_id = ? AND inscricaos_campos.int_value <= ? and inscricaos_campos.int_value >= ? AND inscricaos.evento_id = ?", id_campo, valor_sup, valor_inf,event],
            :order=>"inscricaos_campos.int_value "+dir,
            :limit=>limit,
            :offset=>start
        }
    }
    
    named_scope :com_valor_decimal, lambda { |id_campo,valor_inf,valor_sup,start,limit,dir,event|
        {
            :joins=>"INNER JOIN inscricaos_campos ON inscricaos_campos.inscricao_id = inscricaos.id ",
            :conditions => ["inscricaos_campos.campo_id = ? AND inscricaos_campos.decimal_value <= ? and inscricaos_campos.decimal_value >= ? AND inscricaos.evento_id = ?", id_campo, valor_sup, valor_inf,event],
            :order=>"inscricaos_campos.decimal_value "+dir,
            :limit=>limit,
            :offset=>start
        }
    }
    
    named_scope :com_valor_lov, lambda { |id_campo,valor,start,limit,dir,event|
        {
            :joins=>"INNER JOIN inscricaos_campos ON inscricaos_campos.inscricao_id = inscricaos.id INNER JOIN campos on inscricaos_campos.campo_id = campos.id INNER JOIN valors on (valors.lista_valores_id = campos.lista_valores_id and valor = inscricaos_campos.lov_value)",
            :conditions => ["inscricaos_campos.campo_id = ? AND valors.descricao like ? AND inscricaos.evento_id = ?", id_campo, valor,event],
            :order=>"valors.descricao "+dir,
            :limit=>limit,
            :offset=>start
        }
    }
    
    named_scope :com_valor_lov_tabela, lambda { |id_campo,valor,tabela,campo_valor,campo_descricao,start,limit,dir,event|
        {
            :joins=>"INNER JOIN inscricaos_campos ON inscricaos_campos.inscricao_id = inscricaos.id INNER JOIN campos on inscricaos_campos.campo_id = campos.id INNER JOIN "+tabela.downcase+"s on ("+tabela.downcase+"s."+campo_valor+" = inscricaos_campos.lov_value)",
            :conditions => ["inscricaos_campos.campo_id = ? AND "+tabela.downcase+"s."+campo_descricao+" like ? AND inscricaos.evento_id = ?", id_campo, valor,event],
            :order=>tabela.downcase+"s."+campo_descricao+" "+dir,
            :limit=>limit,
            :offset=>start
        }
    }
    
    named_scope :com_numero, lambda { |valor_inf,valor_sup,start,limit,dir,event|
        {
            :conditions => ["((inscricaos.numero >= ? AND inscricaos.numero <= ?) OR inscricaos.numero is null) AND inscricaos.evento_id = ?", valor_inf, valor_sup,event],
            :order=>"inscricaos.numero "+dir,
            :limit=>limit,
            :offset=>start
        }
    }
    
    named_scope :com_idade, lambda { |valor_inf,valor_sup,start,limit,dir,event|
        {
            :conditions => ["inscricaos.idade >= ? AND inscricaos.idade <= ? AND inscricaos.evento_id = ?", valor_inf, valor_sup,event],
            :order=>"inscricaos.idade "+dir,
            :limit=>limit,
            :offset=>start
        }
    }
    
    named_scope :created_at_filter, lambda { |valor_inf,valor_sup,start,limit,dir,event|
        {
            :conditions => ["inscricaos.created_at >= ? AND inscricaos.created_at <= ? AND inscricaos.evento_id = ?", valor_inf, valor_sup,event],
            :order=>"inscricaos.created_at "+dir,
            :limit=>limit,
            :offset=>start
        }
    }
    
    
    named_scope :com_user, lambda { |valor,start,limit,dir,event|
        {
            :joins => "INNER JOIN users on users.id = inscricaos.user_id",
            :conditions => ["users.login like ? AND inscricaos.evento_id = ?", valor,event],
            :order=>"users.login "+dir,
            :limit=>limit,
            :offset=>start
        }
    }


    def preco      
      preco = 0
      if(evento.preco_consumos)
        consumos.each do |consumo|
            preco_produto = consumo.preco.to_f
            preco = preco + preco_produto
        end
      else
        if(preco_manual != nil && preco_manual >= 0)
            preco = preco_manual
        else
            if(idade != nil && evento_id != nil)
              if(idade >= 6 and idade <= 12 && evento_id != 3 && evento_id != 4)
                preco_base = 85
              else
                preco_base = evento.preco_base
              end
              
              data_limite_preco_base = evento.data_inicio-evento.n_dias_multa.days
              data_limite_preco_bonificado = created_at+8.days
              
              total_pago_agora = total_pago
              
              if(created_at > data_limite_preco_base)
                preco = preco_base+evento.multa
              end
              if((Date.today > data_limite_preco_bonificado.to_date) && (created_at <= data_limite_preco_base))
                preco = preco_base
              end
              if((Date.today <= data_limite_preco_bonificado.to_date) && (created_at <= data_limite_preco_base) && (total_pago_agora == 0))
                preco = preco_base-evento.bonificacao
              end
              if((created_at <= data_limite_preco_base) && (total_pago_agora > 0))
                preco = preco_base
              end
              if((created_at <= data_limite_preco_base) && (total_pago_agora > 0) && (pago_antes_de(data_limite_preco_bonificado, preco_base-evento.bonificacao)))
                preco = preco_base-evento.bonificacao
              end
              if((Date.today > data_limite_preco_base.to_date) && (total_pago_agora < evento.taxa_inscricao))
                preco = preco_base+evento.multa
              end
              
              
              if(idade >= 0 and idade <= 2)
                preco = 25
              end
              if(idade >= 3 and idade <= 5)
                preco = 50
              end
          end
        end
      end
      preco
    end
    
    def taxa_inscricao
      taxa = 0
      if(evento.preco_consumos)
        consumos.each do |consumo|
          if(consumo.produto.is_taxa_inscricao)
            taxa = taxa + consumo.preco
          end
        end
      else
        taxa = evento.taxa_inscricao
      end
      taxa
    end
    
    def pago_antes_de(data, valor)
      pago = false
      total_pago_ate_data = 0
      pagamentos.each do |pagamento|
        if(pagamento.data <= data)
          total_pago_ate_data = total_pago_ate_data + pagamento.valor
        end
      end
      if(total_pago_ate_data == valor)
        pago = true
      end
      pago
    end
    
    def efectiva
      efectiva = false
      if(total_pago >= taxa_inscricao)
        if(evento.precisa_recomendacao && recomendacaos.count > 0)
          efectiva = true
        else
          if(!evento.precisa_recomendacao)
            efectiva = true
          else
            efectiva = false
          end
        end
      else
        efectiva = false
      end
      efectiva
    end
    
    def total_consumos
      total = 0;
      for consumo in consumos
        total = total+consumo.preco
      end
      total
    end
    
    
    def total_descontos
        total = 0
        for desconto_insc in desconto_inscricaos
            total += desconto_insc.valor
        end
        total
    end
    
    def total_pago
      total = 0;
      if(evento.preco_consumos)
          for consumo in consumos
              if(consumo.recibo.pago)
                  if(consumo.preco == nil)
                      consumo.preco = consumo.produto.get_preco(self)
                      consumo.save
                  end
                  total += consumo.preco
              end
          end
      else
        for pagamento in pagamentos
            total += pagamento.valor
        end
      end
      
      total
    end
    
    
    def atribui_numero
      if(total_pago >= evento.taxa_inscricao && numero == nil)
        result = Inscricao.maximum(:numero, :conditions=>"evento_id = "+self.evento_id.to_s)
        if(result != nil)
          self.numero = result+1
        else
          self.numero = 1
        end
        self.save
      end
    end
    
    def muda_numero(novo_num)
      Inscricao.update_all 'numero = numero+1', 'numero >'+novo_num+' and evento_id = '+self.evento_id.to_s
      self.numero = novo_num
      self.save
    end
    
    def instancia_campo(campo_id)
      campo = InscricaosCampos.find_by_campo_id(campo_id, :conditions=>"inscricao_id = "+self.id.to_s)
    end
    
    def valor_campo(campo_id)
      result = ""
      
      meta_campo = Campo.find_by_id(campo_id)
      if(self.id != nil)
          campo = InscricaosCampos.find_by_campo_id(campo_id, :conditions=>"inscricao_id = "+self.id.to_s, :order=>"created_at DESC")
      else
          self.inscricaos_camposs.each do |insccampo|
              if(insccampo.campo_id == campo_id)
                  campo = insccampo
              end
          end
      end
      
      if(meta_campo.tipo.upcase == "STRING")
        if(campo != nil)
          result = campo.string_value
        end
      end
      if(meta_campo.tipo.upcase == "TEXT")
        if(campo != nil)
          result = campo.text_value
        end
      end
      if(meta_campo.tipo.upcase == "INT")
        if(campo != nil)
          result = campo.int_value
        end
      end
      if(meta_campo.tipo.upcase == "DATE")
        if(campo != nil)
          result = campo.date_value
        end
      end
      if(meta_campo.tipo.upcase == "DECIMAL")
        if(campo != nil)
          result = campo.decimal_value
        end
      end
      if(meta_campo.tipo.upcase == "LOV")
        if(campo != nil)
          result = campo.lov_value
        end
      end
      result
    end
    
    def valor_campo_string(campo_id)
      result = ""
      
      meta_campo = Campo.find_by_id(campo_id)
      if(self.id != nil)
          campo = InscricaosCampos.find_by_campo_id(campo_id, :conditions=>"inscricao_id = "+self.id.to_s, :order=>"created_at DESC")
      else
          self.inscricaos_camposs.each do |insccampo|
              if(insccampo.campo_id == campo_id)
                  campo = insccampo
              end
          end
      end
      
      if(meta_campo.tipo.upcase == "STRING")
        if(campo != nil && campo.string_value != nil)
          result = campo.string_value
        end
      end
      if(meta_campo.tipo.upcase == "TEXT")
        if(campo != nil && campo.text_value != nil)
          result = campo.text_value
        end
      end
      if(meta_campo.tipo.upcase == "INT")
        if(campo != nil &&  campo.int_value != nil)
          result = campo.int_value.to_s
        end
      end
      if(meta_campo.tipo.upcase == "DATE")
        if(campo != nil &&  campo.date_value != nil)
          result = campo.date_value.strftime("%d-%m-%Y")
        end
      end
      if(meta_campo.tipo.upcase == "DECIMAL")
        if(campo != nil &&  campo.decimal_value != nil)
          result = campo.decimal_value.to_s
        end
      end
      if(meta_campo.tipo.upcase == "LOV")
        if(campo != nil && campo.lov_value != nil)
          result = campo.lov_value.to_s
        end
      end
      result
    end
    
    def resolve_lov(campo_id)
      result = ""
      
      meta_campo = Campo.find_by_id(campo_id)
      campo = InscricaosCampos.find_by_campo_id(campo_id, :conditions=>"inscricao_id = "+self.id.to_s, :order=>"created_at DESC")
      
      if(meta_campo.tipo.upcase == "LOV")
        if(campo != nil && campo.lov_value != nil && meta_campo.lista_valores.class_name != nil)
          result = eval(meta_campo.lista_valores.class_name+".find_by_"+meta_campo.lista_valores.value_field+"("+campo.lov_value.to_s+")."+meta_campo.lista_valores.text_field)
        end
        if(campo != nil && campo.lov_value != nil && meta_campo.lista_valores.class_name == nil)
            result = (Valor.find_by_lista_valores_id(meta_campo.lista_valores_id, :conditions=>"valor="+campo.lov_value.to_s)).descricao
        end
      end
      result
    end
    
    
    def referencia_multibanco
      if(id >= 1000 and id <= 1250 )
        stringRef = "853"+ id.to_s.rjust(4, '0') + ((preco-total_pago).to_i*100).to_s.rjust(8, '0')
      else
        stringRef = "853"+ evento_id.to_s+id.to_s.rjust(3, '0') + ((preco-total_pago).to_i*100).to_s.rjust(8, '0')
      end
      
      multiplicadores = [3, 30, 9, 90, 27, 76, 81, 34, 49, 5, 50, 15, 53, 45, 62]
      check = 923 
      i=0;
      for multiplicador in multiplicadores
        digito = stringRef[14-i,1].to_i
        check += digito*multiplicador
        i = i + 1
      end
      check = 98 - (check % 97)
      
      if(id >= 1000 and id <= 1250 )
          stringMB = "853"+ id.to_s.rjust(4, '0') + check.to_s.rjust(2, '0')
      else
          stringMB = "853"+ evento_id.to_s+id.to_s.rjust(3, '0') + check.to_s.rjust(2, '0')
      end
      
      stringMB[0..2]+" "+stringMB[3..5]+" "+stringMB[6..8]
    end
    
    
    def referencia_multibanco_taxa_insc
      if(id >= 1000 and id <= 1250 )
        stringRef = "853"+ id.to_s.rjust(4, '0') + ((evento.taxa_inscricao).to_i*100).to_s.rjust(8, '0')
      else
        stringRef = "853"+ evento_id.to_s+id.to_s.rjust(3, '0') + ((evento.taxa_inscricao).to_i*100).to_s.rjust(8, '0')
      end
      
      multiplicadores = [3, 30, 9, 90, 27, 76, 81, 34, 49, 5, 50, 15, 53, 45, 62]
      check = 923 
      i=0;
      for multiplicador in multiplicadores
        digito = stringRef[14-i,1].to_i
        check += digito*multiplicador
        i = i + 1
      end
      check = 98 - (check % 97)
      
      if(id >= 1000 and id <= 1250 )
          stringMB = "853"+ id.to_s.rjust(4, '0') + check.to_s.rjust(2, '0')
      else
          stringMB = "853"+ evento_id.to_s+id.to_s.rjust(3, '0') + check.to_s.rjust(2, '0')
      end
      
      stringMB[0..2]+" "+stringMB[3..5]+" "+stringMB[6..8]
    end
  

  
  def calcula_idade
    data = evento.data_inicio
    # how many years?
    # has their birthday occured this year yet?
    # subtract 1 if so, 0 if not
    age = data.year - data_nascimento.year - (data_nascimento.to_time.change(:year => data.year) > data ? 1 : 0)
  end
  
  
  def get_recibo_activo
      result = nil
      recibos.each do |recibo|
          if(!recibo.fechado)
              result = recibo
          end
      end
      result
  end
  
  def name_badge_printing_string
    string = "badgeprint://?nome="+nome_abreviado.upcase+"&codigobarras=I-"+id.to_s.rjust(4,"0")
    string += "&ref1="+ref1.to_s
    string += "&ref2="+ref2.to_s
    string += "&ref3="+ref3.to_s
    string += "&ref4="+ref4.to_s
    string += "&ref5="+ref5.to_s
    string += "&ref6="+ref6.to_s
    string += "&ref7="+ref7.to_s
    string += "&ref8="+ref8.to_s
  end
  
  def badge_printing_string

    nome_abreviado = valor_campo_string(98)

    ref1 = "-"
    ref2 = "-"
    ref3 = "-"
    ref4 = "-"
    ref5 = "-"
    ref6 = "-"
    ref7 = "-"
    ref8 = "-"
  
    inscricao_reservas.each do |insc_reserva|
        if(insc_reserva.reserva_id == 26)
            ref1 = "PEIXE"
        end
        if(insc_reserva.reserva_id == 27)
            ref1 = "CARNE"
        end
        if(insc_reserva.reserva_id == 28)
            ref2 = "PEIXE"
        end
        if(insc_reserva.reserva_id == 29)
            ref2 = "CARNE"
        end
        if(insc_reserva.reserva_id == 30)
            ref3 = "PEIXE"
        end
        if(insc_reserva.reserva_id == 31)
            ref3 = "CARNE"
        end
        if(insc_reserva.reserva_id == 32)
            ref4 = "CARNE"
        end
        if(insc_reserva.reserva_id == 33)
            ref4 = "LEITAO"
        end
    end
    
    igreja = Igreja.find_by_id(valor_campo(106))
    estatuto = resolve_lov(107)
    alojamento = resolve_lov(113)
    if(alojamento == "Quero alojamento oferecido pela igreja")
        alojamento = "SIM"
    else
        alojamento = resolve_lov(114)
        if(alojamento == "Quero alojamento oferecido pela igreja")
            alojamento = "SIM"
        else
            alojamento = "-"
        end
    end

    string = "badgeprint://?nome="+nome_abreviado.upcase+"&codigobarras=I-"+id.to_s.rjust(4,"0")
    string += "&ref1="+ref1.to_s
    string += "&ref2="+ref2.to_s
    string += "&ref3="+ref3.to_s
    string += "&ref4="+ref4.to_s
    string += "&ref5="+ref5.to_s
    string += "&ref6="+ref6.to_s
    string += "&ref7="+ref7.to_s
    string += "&ref8="+ref8.to_s
	
	
	#if(igreja != nil && igreja.full_name != nil)
	#	string += "&igreja="+igreja.full_name.upcase
	#end
	#if(alojamento != nil)
	#	string += "&alojamento="+alojamento.upcase
	#end
	#if(estatuto != nil)
	#	string += "&estatuto="+estatuto.upcase
	#end
  end
  
end
