require 'fastercsv'

class InscricoesController < ApplicationController
  before_filter :authorize, :only => [:regista, :regista_consumos, :lista]  
  before_filter :authorize_detalhe, :only => [:detalhe, :distribuir_consumos, :consumos, :editar, :update, :recomendar, :grupo]
  
  def nova
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    if((!@event.inscricoes_abertas || !@event.activo) && (@current_user != nil && @current_user.profile != "ADMIN"))
      flash[:erro_titulo] = "Não se pode inscrever neste evento"
      flash[:erro_mensagem] = "O evento '"+@event.nome+"' já fechou as inscrições por falta de vagas. Se quiser ficar numa lista de espera, envie um e-mail para <a href='mailto:geral@acampamentobaptsita.com.pt'>geral@acampamentobaptsita.com.pt</a> com o numero de inscrições que pretende colocar na lista e o seu contacto."
      redirect_to :controller=>"error"
    end
    
    @values = []
    
    respond_to do |format|
      format.html {
        if(@event.pre_html != nil)
          render :layout=>false
        end
      }
      format.js
    end

  end
  
  
  def get_consumos_temp
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    @inscricao = Inscricao.new()
    @inscricao.evento_id = @event.id
    
    if(params[:campo] != nil && params[:campo].length > 0)
    
      params[:campo].each do |campo|
        metaCampo = Campo.find_by_id(campo[0])
        
        #@values[campo[0].to_i] = campo[1]
        
        campoInscricao = InscricaosCampos.new()
        campoInscricao.campo_id = metaCampo.id
        if(metaCampo.tipo.upcase == "STRING")
          campoInscricao.string_value = campo[1]
          if(metaCampo.nome.upcase == "NOME" || metaCampo.is_nome)
            @inscricao.nome = campo[1]
          end
          if(metaCampo.nome.upcase == "EMAIL" || metaCampo.is_email)
            @inscricao.email = campo[1]
          end
          if(metaCampo.is_morada)
            @inscricao.morada = campo[1]
          end
          if(metaCampo.is_codigo_postal)
            @inscricao.codigo_postal = campo[1]
          end
          if(metaCampo.is_localidade)
            @inscricao.localidade = campo[1]
          end
          if(metaCampo.is_telemovel)
            @inscricao.telemovel = campo[1]
          end
        end
        if(metaCampo.tipo.upcase == "TEXT")
          campoInscricao.text_value = campo[1]
          if(metaCampo.is_morada)
            @inscricao.morada = campo[1]
          end
          if(metaCampo.is_codigo_postal)
            @inscricao.codigo_postal = campo[1]
          end
          if(metaCampo.is_localidade)
            @inscricao.localidade = campo[1]
          end
        end
        if(metaCampo.tipo.upcase == "INT")
          campoInscricao.int_value = campo[1].to_i
        end
        if(metaCampo.tipo.upcase == "DECIMAL")
          campoInscricao.decimal_value = campo[1]
        end
        if(metaCampo.tipo.upcase == "DATE")
          campoInscricao.date_value = campo[1]
          if(metaCampo.nome.upcase == "DATANASCIMENTO" || metaCampo.is_data_nascimento)
            @inscricao.data_nascimento = campo[1]
            if(campo[1] != nil && campo[1] != '')
              @inscricao.idade = @inscricao.calcula_idade #@inscricao.calDate.today.year - campo[1].to_date.year
            end
          end
        end
        if(metaCampo.tipo.upcase == "LOV")
          campoInscricao.lov_value = campo[1]
          if(metaCampo.nome.upcase == "IGREJA" || metaCampo.is_igreja)
            @inscricao.igreja_id = campo[1]
          end
          if(metaCampo.is_grupo_inscricoes)
            @inscricao.grupo_inscricoes_id = campo[1]
          end
          if(metaCampo.is_grupo_inscricoes_relation)
            @inscricao.grupo_responsible_relation = campo[1]
          end
          if(metaCampo.is_estatuto)
            @inscricao.estatuto_id = campo[1]
          end
        end
        
        @inscricao.inscricaos_camposs << campoInscricao
  
      end
    end
    @consumos = calcula_consumos(@inscricao, nil, false)
    
    if (request.xhr? || params[:callback] != nil)
        render :template=>"/inscricoes/get_consumos_temp.xml.erb", :layout=>false
    end
    
  end
  
  def regista
    @values = []
    
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    edit_mode = false
    if(params[:id] != nil)
      @inscricao = Inscricao.find_by_id(params[:id])
      edit_mode = true
    else
      @inscricao = Inscricao.new()
      @inscricao.evento_id = @event.id
      @inscricao.user_id = @current_user.id
    end
  
    
    params[:campo].each do |campo|
      metaCampo = Campo.find_by_id(campo[0])
      
      @values[campo[0].to_i] = campo[1]
      
      error = false
      
      if((campo[1] == nil || campo[1] == "") && metaCampo.required && @current_user.profile == "ADMIN")
          campo[1] = metaCampo.default_value
      end
      
      if(metaCampo.required)
        if(campo[1] == nil || campo[1] == "")
          @inscricao.errors.add("campo["+metaCampo.id.to_s+"]","Tem que preencher o campo "+metaCampo.label.upcase)
          error = true;
        end
      end
      if(metaCampo.min_value != nil)
        if(campo[1].to_d < metaCampo.min_value)
          @inscricao.errors.add("campo["+metaCampo.id.to_s+"]","O campo "+metaCampo.label.upcase+" tem que ser preenchido com um valor superior a "+metaCampo.min_value.to_s)
          error = true;
        end
      end
      if(metaCampo.max_value != nil)
        if(campo[1].to_d > metaCampo.max_value)
          @inscricao.errors.add("campo["+metaCampo.id.to_s+"]","O campo "+metaCampo.label.upcase+" tem que ser preenchido com um valor inferior a "+metaCampo.max_value.to_s)
          error = true;
        end
      end
      
      if(!error)
        if(edit_mode)
          add_new_field = false
          campoInscricao = InscricaosCampos.find_by_inscricao_id(params[:id], :conditions=>"campo_id = "+metaCampo.id.to_s)
          if(campoInscricao == nil)
            campoInscricao = InscricaosCampos.new()
            campoInscricao.campo_id = metaCampo.id
            add_new_field = true
          end
        else
          campoInscricao = InscricaosCampos.new()
          campoInscricao.campo_id = metaCampo.id
        end
        
        
        if(metaCampo.tipo.upcase == "STRING")
          campoInscricao.string_value = campo[1]
          if(metaCampo.nome.upcase == "NOME" || metaCampo.is_nome)
            @inscricao.nome = campo[1]
          end
          if(metaCampo.nome.upcase == "EMAIL" || metaCampo.is_email)
            @inscricao.email = campo[1]
          end
          if(metaCampo.is_morada)
            @inscricao.morada = campo[1]
          end
          if(metaCampo.is_codigo_postal)
            @inscricao.codigo_postal = campo[1]
          end
          if(metaCampo.is_localidade)
            @inscricao.localidade = campo[1]
          end
          if(metaCampo.is_telemovel)
            @inscricao.telemovel = campo[1]
          end
        end
        if(metaCampo.tipo.upcase == "TEXT")
          campoInscricao.text_value = campo[1]
          if(metaCampo.is_morada)
            @inscricao.morada = campo[1]
          end
          if(metaCampo.is_codigo_postal)
            @inscricao.codigo_postal = campo[1]
          end
          if(metaCampo.is_localidade)
            @inscricao.localidade = campo[1]
          end
        end
        if(metaCampo.tipo.upcase == "INT")
          campoInscricao.int_value = campo[1].to_i
        end
        if(metaCampo.tipo.upcase == "DECIMAL")
          campoInscricao.decimal_value = campo[1]
        end
        if(metaCampo.tipo.upcase == "DATE")
          campoInscricao.date_value = campo[1]
          if(metaCampo.nome.upcase == "DATANASCIMENTO" || metaCampo.is_data_nascimento)
            @inscricao.data_nascimento = campo[1]
            @inscricao.idade = @inscricao.calcula_idade #@inscricao.calDate.today.year - campo[1].to_date.year
          end
        end
        if(metaCampo.tipo.upcase == "LOV")
          campoInscricao.lov_value = campo[1]
          if(metaCampo.nome.upcase == "IGREJA" || metaCampo.is_igreja)
            @inscricao.igreja_id = campo[1]
          end
          if(metaCampo.is_grupo_inscricoes)
            if(!edit_mode)
              @inscricao.grupo_inscricoes_id = campo[1]
            end
          end
          if(metaCampo.is_grupo_inscricoes_relation)
            @inscricao.grupo_responsible_relation = campo[1]
          end
          if(metaCampo.is_estatuto)
            @inscricao.estatuto_id = campo[1]
          end
        end
        
        if(edit_mode && !add_new_field)
          campoInscricao.save
        else
          @inscricao.inscricaos_camposs << campoInscricao
        end
      end
    end
    
    if(@inscricao.errors.count == 0)
      @inscricao.save
      
      if(params[:datainsc] != nil)
        @inscricao.created_at = params[:datainsc]
        @inscricao.save
      end
      
      recibo_anterior = nil
      if(edit_mode)
        if(@inscricao.consumos.count > 0)
          recibo_anterior = @inscricao.consumos[0].recibo
        end
        
        @inscricao.consumos.each do |consumo|
          Consumo.destroy(consumo.id)
        end
        @inscricao.desconto_inscricaos.each do |desconto|
          DescontoInscricao.destroy(desconto.id)
        end
        @inscricao.inscricao_reservas.each do |inscricao_reserva|
          InscricaoReserva.destroy(inscricao_reserva.id)
        end
      end
      
      recibo = recibo_anterior
      if(recibo == nil)
        if(@inscricao.evento.group_based && (@inscricao.grupo_inscricoes_id == nil || @inscricao.grupo_inscricoes_id == 0))
          grupo = GrupoInscricoes.new
          grupo.inscricao_id = @inscricao.id
          grupo.save
          @inscricao.grupo_inscricoes_id = grupo.id
          @inscricao.grupo_responsible_relation = "-1"
          @inscricao.save
          recibo = Recibo.new
          recibo.nome = @inscricao.nome
          recibo.evento_id = @inscricao.evento_id
          recibo.inscricao_id = @inscricao.id
          recibo.calcula_id_multibanco
          recibo.data = DateTime.now
          recibo.fechado = false
          recibo.save
          envia_email_criacao_recibo = true
        else
          if(@inscricao.evento.group_based)
            recibo = @inscricao.grupo_inscricoes.inscricao.get_recibo_activo
            if(recibo == nil)
              recibo = Recibo.new
              recibo.nome = @inscricao.grupo_inscricoes.inscricao.nome
              recibo.evento_id = @inscricao.evento_id
              recibo.inscricao_id = @inscricao.grupo_inscricoes.inscricao_id
              recibo.calcula_id_multibanco
              recibo.data = DateTime.now
              recibo.fechado = false
              recibo.save
              envia_email_criacao_recibo = true
            end
          end
        end
      end
      
      if(@inscricao.evento.preco_consumos)
        if(recibo == nil)
          recibo = Recibo.new
          recibo.nome = @inscricao.nome
          recibo.evento_id = @inscricao.evento_id
          recibo.inscricao_id = @inscricao.id
          recibo.calcula_id_multibanco
          recibo.data = DateTime.now
          recibo.fechado = false
          recibo.save
          envia_email_criacao_recibo = true
        else
          montante_anterior = recibo.total_recibo
        end
        calcula_consumos(@inscricao, recibo)
        calcula_descontos(@inscricao, recibo)
        @inscricao.save
      end
      
      if(!(@current_user != nil && ((@current_user.profile == "ADMIN") || ((@current_user.profile == "EVENTO_ESCRITA" || @current_user.profile == "EVENTO_FACTURACAO_LEITURA" || @current_user.profile == "EVENTO_FACTURACAO_ESCRITA") && @current_user.evento_id == @event.id))))
        #ENVIAR E-MAIL DE CONFIRMAÇÃO
        pdf = make_pdf :template => "inscricoes/detalhe.html.erb", :stylesheets => ["default","niceforms-default","tabs","print"], :layout => "inscricoes.erb"
        if(@inscricao.evento.preco_consumos)
          UserMailer.deliver_inscricao_notification_sem_precos(@inscricao, @inscricao.user.email, pdf)
        else
          UserMailer.deliver_inscricao_notification(@inscricao, @inscricao.user.email, pdf)
        end
        if(@inscricao.user.email != @inscricao.email && @inscricao.email != nil && @inscricao.email != "")
          if(@inscricao.evento.preco_consumos)
            UserMailer.deliver_inscricao_notification_sem_precos(@inscricao, @inscricao.email, pdf)
          else
            UserMailer.deliver_inscricao_notification(@inscricao, @inscricao.email, pdf)
          end
        end
        
        if(recibo != nil)
          if(envia_email_criacao_recibo)
            recibo.reload
            @recibo = recibo
            #@linhas_recibo = @recibo.linhas_recibo
            #pdf = make_pdf :template => "recibos/detalhe.html.erb", :stylesheets => [@entidade.sigla+"/default","niceforms-default","tabs","print"], :layout => "recibos.erb"
            UserMailer.deliver_novo_recibo_notification(@recibo, @recibo.inscricao.user.email, @recibo.to_pdf)          
          else
            recibo.reload
            if(montante_anterior != recibo.total_recibo)
              @recibo = recibo
              #@linhas_recibo = @recibo.linhas_recibo
              #pdf = make_pdf :template => "recibos/detalhe.html.erb", :stylesheets => [@entidade.sigla+"/default","niceforms-default","tabs","print"], :layout => "recibos.erb"
              UserMailer.deliver_recibo_alterado_notification(@recibo, @recibo.inscricao.user.email, @recibo.to_pdf)          
            end
          end
        end
        
        #ENVIAR E-MAIL A PEDIR ASSINATURA
        if(@inscricao.evento.precisa_recomendacao)
          users = User.find_all_by_igreja_id(@inscricao.igreja_id)
          users.each do |user|
            if(user.profile != nil && user.profile.upcase == "PASTOR")
              UserMailer.deliver_precisa_recomendacao_notification(@inscricao, user.email, pdf)
            end
          end
        end
      end
      
      
      ## MAILCHIMP
      #h = Hominid::Base.new({:api_key => '684c1fce9c987be99235575038b6dc62-us1'})
      #list = h.find_list_by_id('f5513616d0')
      #if(list != nil)
      #  h.subscribe('f5513616d0', @inscricao.email, {:FNAME => "Pedro", :LNAME => "Marques", :CODPOSTAL => "2725-374", :LOCALIDADE => "Mem Martins"}, {:email_type => 'html'})
      #end
      
      
      ## CLICKATELL
      #api = Clickatell::API.authenticate('3093282', 'pdcmarques', 'pdm49731')
      #api.send_message('351916730588', @inscricao.nome+', obrigado pela tua inscricao.', {:from=>'351916730588'})
      
    end
    
    if(@inscricao.errors.count == 0)
      if (request.xhr? || params[:callback] != nil)
        render :template=>"/inscricoes/regista.xml.erb", :layout=>false
      else 
        redirect_to :event=>@event.codigo, :action=>"detalhe", :id=>@inscricao.id
      end
    else
      if (request.xhr? || params[:callback] != nil)
        render :template=>"/inscricoes/regista.xml.erb", :layout=>false
      else 
        render :template=>"inscricoes/nova"
      end
    end
  end
  
   
  
  def calcula_consumos(inscricao, recibo, persist = true)
    evento = inscricao.evento
    
    consumos = []
    consumos_finais = []
    
    if(inscricao.idade == nil)
      if(!persist)
        return consumos_finais
      else
        return
      end
    end
    
    evento.grupo_camposs.each do |grupo|
      grupo.campos.each do |campo|
        campo.campo_produtos.each do |campo_produto|
          if(inscricao.valor_campo_string(campo.id) != "")
            inserir_consumo = false
            if(campo_produto.ruby_literal_exp != nil)
              inserir_consumo = eval("'"+campo_produto.ruby_literal_exp+"'")
            else
              if(campo_produto.comparison_operator == nil)
                inserir_consumo = true
              end
              if(campo_produto.comparison_operator == ">" || campo_produto.comparison_operator == "<" || campo_produto.comparison_operator == ">=" || campo_produto.comparison_operator == "<=")
                if(campo.tipo == "int" || campo.tipo == "decimal" || campo.tipo == "lov")
                  inserir_consumo = eval(inscricao.valor_campo_string(campo.id)+" "+campo_produto.comparison_operator+" "+campo_produto.comparison_operand)
                end
                if(campo.tipo == "date")
                  inserir_consumo = eval("Date.parse(\""+inscricao.valor_campo_string(campo.id)+"\") "+campo_produto.comparison_operator+" Date.parse(\""+campo_produto.comparison_operand+"\") ")
                end
              end
              if(campo_produto.comparison_operator == "=" || campo_produto.comparison_operator == "==")
                if(campo.tipo == "int" || campo.tipo == "decimal")
                  inserir_consumo = eval(inscricao.valor_campo_string(campo.id)+" == "+campo_produto.comparison_operand)
                end
                if(campo.tipo == "text" || campo.tipo == "lov")
                  inserir_consumo = eval("'"+inscricao.valor_campo_string(campo.id)+"'.upcase == '"+campo_produto.comparison_operand+"'.upcase")
                end
                if(campo.tipo == "date")
                  inserir_consumo = eval("Date.parse(\""+inscricao.valor_campo_string(campo.id)+"\") == Date.parse(\""+campo_produto.comparison_operand+"\") ")
                end
              end
              if(campo_produto.comparison_operator == "in")
                found = false
                itens = campo_produto.comparison_operand.gsub(", ",",").gsub(" ,",",").split(",")
                itens.each do |item|
                  if(campo.tipo == "int" || campo.tipo == "decimal" || campo.tipo == "lov")
                    found = eval(inscricao.valor_campo_string(campo.id)+" == "+item)  
                  end
                  if(campo.tipo == "text" || campo.tipo == "lov")
                    found = eval("'"+inscricao.valor_campo_string(campo.id)+"'.upcase == '"+item+"'.upcase")  
                  end
                  if(campo.tipo == "date")
                    found = eval("Date.parse(\""+inscricao.valor_campo_string(campo.id)+"\") == Date.parse(\""+item+"\") ")
                  end
                  if(found)
                    inserir_consumo = true
                    break
                  end
                end
              end
              if(campo_produto.comparison_operator == "not in")
                not_found = true
                found = false
                itens = campo_produto.comparison_operand.gsub(", ",",").gsub(" ,",",").split(",")
                itens.each do |item|
                  if(campo.tipo == "int" || campo.tipo == "decimal" || campo.tipo == "lov")
                    found = eval(inscricao.valor_campo_string(campo.id)+" == "+item)  
                  end
                  if(campo.tipo == "text" || campo.tipo == "lov")
                    found = eval("'"+inscricao.valor_campo_string(campo.id)+"'.upcase == '"+item+"'.upcase")  
                  end
                  if(campo.tipo == "date")
                    found = eval("Date.parse(\""+inscricao.valor_campo_string(campo.id)+"\") == Date.parse(\""+item+"\") ")
                  end
                  if(found)
                    not_found = false
                    break
                  end
                end
                if(not_found)
                  inserir_consumo = true
                end
              end
              
            end
            if(inserir_consumo)
              consumo = Consumo.new
              consumo.produto_id = campo_produto.produto_id
              consumo.preco = Produto.find_by_id(campo_produto.produto_id).get_preco(@inscricao)
              if(persist)
                consumo.inscricao_id = inscricao.id
              end
              consumos << consumo
            end
          end
        end
      end
    end
    
    pacotes_produtos = []
    consumos.each do |consumo|
      pacote_escolhido = nil
      prioridade = 999
      consumo.produto.pacote_produtoss.each do |pacote_produtos|
        if(pacote_produtos.pacote.prioridade < prioridade && pacote_produtos.pacote.is_complete(consumos))
          pacote_escolhido = pacote_produtos.pacote
          prioridade = pacote_escolhido.prioridade
        end
      end
      if(pacote_escolhido == nil)
        consumoForaPacote = Consumo.new
        consumoForaPacote.produto_id = consumo.produto_id
        consumoForaPacote.preco = consumo.produto.get_preco(inscricao)
        if(persist)
          consumoForaPacote.inscricao_id = inscricao.id
          consumoForaPacote.recibo_id = recibo.id
          consumoForaPacote.save
          consumoForaPacote.reload
          consumoForaPacote.produto.reserva_produtos.each do |reservaproduto|
            if(add_reserva(reservaproduto, inscricao))
              reserva = InscricaoReserva.new
              reserva.inscricao_id = inscricao.id
              reserva.reserva_id = reservaproduto.reserva_id
              reserva.consumo_id = consumoForaPacote.id
              reserva.save
              reserva.reload
              estado = ReservaEstado.new
              estado.inscricao_reserva_id = reserva.id
              estado.estado_reserva_id = 1
              estado.data_inicio = DateTime.now
              estado.save
            end
          end
        else
          consumos_finais << consumoForaPacote
        end
      else
        if(!pacotes_produtos.include?(pacote_escolhido.id))
          consumoPacote = Consumo.new
          consumoPacote.produto_id = pacote_escolhido.produto_id
          consumoPacote.preco = pacote_escolhido.produto.get_preco(inscricao)
          pacotes_produtos << pacote_escolhido.id
          if(persist)
            consumoPacote.inscricao_id = inscricao.id
            consumoPacote.recibo_id = recibo.id
            consumoPacote.save
            consumoPacote.reload
            pacote_escolhido.pacote_produtoss.each do |pacoteproduto|
              pacoteproduto.produto.reserva_produtos.each do |reservaproduto|
                if(add_reserva(reservaproduto, inscricao))
                  reserva = InscricaoReserva.new
                  reserva.inscricao_id = inscricao.id
                  reserva.reserva_id = reservaproduto.reserva_id
                  reserva.consumo_id = consumoPacote.id
                  reserva.save
                  reserva.reload
                  estado = ReservaEstado.new
                  estado.inscricao_reserva_id = reserva.id
                  estado.estado_reserva_id = 1
                  estado.data_inicio = DateTime.now
                  estado.save
                end
              end
            end
            
          else
            consumos_finais << consumoPacote
          end
        end
      end
    end
    
    pacotes_produtos.each do |pacote_id|
      pips = PacoteIgnoreProduto.find_all_by_pacote_id(pacote_id)
      pips.each do |pip|
         consumos_finais.delete_if {|consumo| consumo.produto_id == pip.produto_id }
         if(persist)
             Consumo.delete_all("inscricao_id = " + inscricao.id.to_s + " AND produto_id = " + pip.produto_id.to_s)
         end
      end
    end
    
    
    consumos_finais
  end
  

  def calcula_descontos(inscricao, recibo)
    codigo_desconto = nil
    add_desconto = false
    inscricao.inscricaos_camposs.each do |insc_campo|
      metaCampo = Campo.find_by_id(insc_campo.campo_id)
      if(metaCampo.is_codigo_desconto)
        valor_codigo = insc_campo.string_value        
        codigo_desconto = CodigoDesconto.find_by_codigo(valor_codigo)
        if(codigo_desconto != nil)
         if(codigo_desconto.user_id != nil && codigo_desconto.user_id == inscricao.user_id)
           add_desconto = true
         else
           if(codigo_desconto.user_id == nil)
             add_desconto = true
           end
         end
         
         if(add_desconto && codigo_desconto.evento_id != nil && codigo_desconto.evento_id == inscricao.evento_id)
           add_desconto = true
         else
          add_desconto = false
         end
         if(add_desconto && codigo_desconto.entidade_id != nil && codigo_desconto.entidade_id == inscricao.evento.entidade_id)
           add_desconto = true
         else
          add_desconto = false
         end
         if(add_desconto)
          qtd_consumida = DescontoInscricao.count_by_sql("select count(*) from desconto_inscricaos where desconto_id = "+codigo_desconto.desconto_id.to_s)
          if((codigo_desconto.stock-qtd_consumida) > 0)
            add_desconto = true
          else
           add_desconto = false
          end
         end
        end
      end
    end
    
    if(add_desconto && codigo_desconto != nil)
      desconto_inscricao = DescontoInscricao.new
      desconto_inscricao.inscricao_id = inscricao.id
      desconto_inscricao.desconto_id = codigo_desconto.desconto_id
      desconto_inscricao.save
      inscricao.desconto_inscricaos << desconto_inscricao
    end
    
    
    descontos = DescontoEstatuto.find_all_by_estatuto_id(inscricao.estatuto_id)
    if(descontos != nil)
      descontos.each do |desconto|
        desconto_inscricao = DescontoInscricao.new
        desconto_inscricao.inscricao_id = inscricao.id
        desconto_inscricao.desconto_id = desconto.id
        desconto_inscricao.save
        inscricao.desconto_inscricaos << desconto_inscricao
      end
    end
    if((inscricao.evento.desconto_antecipacao != nil) && (DateTime.now <= inscricao.evento.data_limite_desconto_antecipacao))
      desconto = Desconto.find_by_id(inscricao.evento.desconto_antecipacao)
      if(desconto != nil)
        if(inscricao.idade >= desconto.idade_min && inscricao.idade <= desconto.idade_max)
          desconto_inscricao = DescontoInscricao.new
          desconto_inscricao.inscricao_id = inscricao.id
          desconto_inscricao.desconto_id = desconto.id
          desconto_inscricao.save
          inscricao.desconto_inscricaos << desconto_inscricao
        end
      end
    end
  end

  
  def consumos
    @inscricao = Inscricao.find_by_id(params[:id])
    @evento = @incricao.evento
    @entidade = @evento.entidade
  end
  
  def distribuir_consumos
    @inscricao = Inscricao.find_by_id(params[:id])
    reciboProprio = Recibo.find_by_inscricao_id(@inscricao_id)
    if(reciboProprio != nil)
      session[:valor_recibo_proprio_antes] = reciboProprio.total_recibo
    end
    reciboIgreja = Recibo.find_by_igreja_id(@inscricao.igreja_id)
    if(reciboIgreja != nil)
      session[:valor_recibo_igreja_antes] = reciboIgreja.total_recibo
    end
  end
  
  def regista_consumos
    recibo_novo_igreja = false
    recibo_alterado_igreja = false
    recibo_novo_pessoal = false
    recibo_alterado_pessoal = false
    
    inscricao = Inscricao.find_by_id(params[:id])
    for recibo in params[:consumo] do
      consumo = Consumo.find_by_id(recibo[0])
      if(recibo[1] == "1")
        reciboIgreja = Recibo.find_or_create_by_igreja_id(inscricao.igreja_id)
        if(reciboIgreja.nome == nil)
          reciboIgreja.nome = inscricao.igreja.full_name
          reciboIgreja.save
          recibo_novo_igreja = true
          #puts "RECIBO NOVO IGREJA = TRUE"
        end
        consumo.recibo_id = reciboIgreja.id
        consumo.save
        recibo_alterado_igreja = true
      end
      if(recibo[1] == "2")
        reciboProprio = Recibo.find_or_create_by_inscricao_id(inscricao.id)
        if(reciboProprio.nome == nil)
          reciboProprio.nome = inscricao.nome
          reciboProprio.save
          recibo_novo_pessoal = true
        end
        consumo.recibo_id = reciboProprio.id
        consumo.save
        recibo_alterado_pessoal = true
      end
      if(recibo[1] == "3")
        reciboCBP = Recibo.find_by_id(31)
        consumo.recibo_id = reciboCBP.id
        consumo.save
      end
      if(recibo[1] == "4")
        reciboAB = Recibo.find_by_id(32)
        consumo.recibo_id = reciboAB.id
        consumo.save
      end
    end
    
    if(recibo_novo_igreja)
      @recibo = Recibo.find_by_id(reciboIgreja.id)
      #@linhas_recibo = @recibo.linhas_recibo
      #pdf = make_pdf :template => "recibos/detalhe.html.erb", :stylesheets => [@entidade.sigla+"/default","niceforms-default","tabs","print"], :layout => "recibos.html.erb"
      pdf = @recibo.to_pdf
      users = User.find_all_by_igreja_id(@recibo.igreja)
      for user in users
        UserMailer.deliver_novo_recibo_notification(@recibo, user.email, pdf)
      end
    end
    if(recibo_novo_pessoal)
      @recibo = Recibo.find_by_id(reciboProprio.id)
      #@linhas_recibo = @recibo.linhas_recibo
      #pdf = make_pdf :template => "recibos/detalhe.html.erb", :stylesheets => [@entidade.sigla+"/default","niceforms-default","tabs","print"], :layout => "recibos.html.erb"
      
      UserMailer.deliver_novo_recibo_notification(@recibo, @recibo.inscricao.user.email, @recibo.to_pdf)
    end
    
    if(reciboProprio != nil && reciboProprio.total_recibo != session[:valor_recibo_proprio_antes] && !recibo_novo_pessoal)
      @recibo = Recibo.find_by_id(reciboProprio.id)
      #@linhas_recibo = @recibo.linhas_recibo
      #pdf = make_pdf :template => "recibos/detalhe.html.erb", :stylesheets => [@entidade.sigla+"/default","niceforms-default","tabs","print"], :layout => "recibos.html.erb"
      UserMailer.deliver_recibo_alterado_notification(@recibo, @recibo.inscricao.user.email, @recibo.to_pdf)
    end
    
    if(reciboIgreja != nil && reciboIgreja.total_recibo != session[:valor_recibo_igreja_antes] && !recibo_novo_igreja)
      @recibo = Recibo.find_by_id(reciboIgreja.id)
      #@linhas_recibo = @recibo.linhas_recibo
      #pdf = make_pdf :template => "recibos/detalhe.html.erb", :stylesheets => [@entidade.sigla+"/default","niceforms-default","tabs","print"], :layout => "recibos.html.erb"
      pdf = @recibo.to_pdf
      users = User.find_all_by_igreja_id(@recibo.igreja)
      for user in users
        UserMailer.deliver_recibo_alterado_notification(@recibo, user.email, pdf)
      end
    end
    
    redirect_to :action=>"consumos", :id=>inscricao.id
  end
  
  def add_consumo_to_inscricao
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    consumoId = params[:consumoId]
    produtoId = params[:consumoProdutoId]
    inscricaoId = params[:pagamentoInscricao]
    
    inscricao = Inscricao.find_by_id(inscricaoId)
    produto = Produto.find_by_id(produtoId)
    
    enviar_email = params[:sendEmail] == "1"
    
    inscricao_consumos = Consumo.find_all_by_inscricao_id(inscricaoId)
    recibos = []
    inscricao_consumos.each do |consumo|
      if(!recibos.include?(consumo.recibo))
        if(!consumo.recibo.fechado)
          recibos << consumo.recibo
        end
      end
    end
    
    send_new_recibo_email = false
    if(recibos.size > 0)
      novo_recibo = false
      recibo = recibos[0]
      montante_anterior = recibo.total_recibo
    else
      novo_recibo = true
      recibo = Recibo.new
      recibo.inscricao_id = inscricaoId
      recibo.data = DateTime.now
      recibo.nome = inscricao.nome
      recibo.evento_id = @event.id
      recibo.calcula_id_multibanco
      recibo.fechado = false
      recibo.save
      send_new_recibo_email = enviar_email
    end
    
  
    if(recibo != nil)
      novo_consumo = Consumo.new
      novo_consumo.inscricao_id = inscricao.id
      novo_consumo.produto_id = produto.id
      novo_consumo.recibo_id = recibo.id
      novo_consumo.preco = produto.get_preco(inscricao)
      novo_consumo.save
      @success = true
    else
      @success = false
    end
    
    if(produto.pacote != nil)
      produto.pacote.pacote_produtoss.each do |pacoteproduto|
        pacoteproduto.produto.reserva_produtos.each do |reservaproduto|
          if(add_reserva(reservaproduto, inscricao))
            reserva = InscricaoReserva.new
            reserva.inscricao_id = inscricao.id
            reserva.reserva_id = reservaproduto.reserva_id
            reserva.consumo_id = novo_consumo.id
            reserva.save
            reserva.reload
            estado = ReservaEstado.new
            estado.inscricao_reserva_id = reserva.id
            estado.estado_reserva_id = 1
            estado.data_inicio = DateTime.now
            estado.save
          end
        end
      end
    else
      produto.reserva_produtos.each do |reservaproduto|
        if(add_reserva(reservaproduto, inscricao))
          reserva = InscricaoReserva.new
          reserva.inscricao_id = inscricao.id
          reserva.reserva_id = reservaproduto.reserva_id
          reserva.consumo_id = novo_consumo.id
          reserva.save
          reserva.reload
          estado = ReservaEstado.new
          estado.inscricao_reserva_id = reserva.id
          estado.estado_reserva_id = 1
          estado.data_inicio = DateTime.now
          estado.save
        end
      end
    end
    
    inscricao.save
    
    
    if(send_new_recibo_email && novo_recibo)
      recibo.reload
      @recibo = recibo
      #@linhas_recibo = @recibo.linhas_recibo
      #pdf = make_pdf :template => "recibos/detalhe.html.erb", :stylesheets => [@entidade.sigla+"/default","niceforms-default","tabs","print"], :layout => "recibos.html.erb"
      UserMailer.deliver_novo_recibo_notification(@recibo, @recibo.inscricao.user.email, @recibo.to_pdf)          
    else
      recibo.reload
      if(montante_anterior != recibo.total_recibo && enviar_email)
        @recibo = recibo
        #@linhas_recibo = @recibo.linhas_recibo
        #pdf = make_pdf :template => "recibos/detalhe.html.erb", :stylesheets => [@entidade.sigla+"/default","niceforms-default","tabs","print"], :layout => "recibos.html.erb"
        UserMailer.deliver_recibo_alterado_notification(@recibo, @recibo.inscricao.user.email, @recibo.to_pdf)          
      end  
    end
  end
  
  
  def add_desconto_to_inscricao
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    descontoId = params[:descontoDescontoId]
    inscricaoId = params[:descontoInscricao]
    enviar_email = params[:sendEmail] == "1"
    
    insc = Inscricao.find_by_id(inscricaoId)
    
    inscricao_consumos = Consumo.find_all_by_inscricao_id(inscricaoId)
    recibos = []
    inscricao_consumos.each do |consumo|
      if(!recibos.include?(consumo.recibo))
        if(!consumo.recibo.fechado)
          recibos << consumo.recibo
        end
      end
    end
    
    send_new_recibo_email = false
    if(recibos.size > 0)
      recibo = recibos[0]
      montante_anterior = recibo.total_recibo
    end
    
    desconto_insc = DescontoInscricao.new
    desconto_insc.desconto_id = descontoId
    desconto_insc.inscricao_id = inscricaoId
    desconto_insc.save
  
    insc.save
    
    recibo.reload
    if(montante_anterior != recibo.total_recibo && enviar_email)
      @recibo = recibo
      #@linhas_recibo = @recibo.linhas_recibo
      #pdf = make_pdf :template => "recibos/detalhe.html.erb", :stylesheets => [@entidade.sigla+"/default","niceforms-default","tabs","print"], :layout => "recibos.html.erb"
      UserMailer.deliver_recibo_alterado_notification(@recibo, @recibo.inscricao.user.email, @recibo.to_pdf)          
    end
    
  end
  
  
  def elimina_consumo
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    enviar_email = params[:sendEmail] == "1"
    consumoId = params[:consumoId]
    consumo = Consumo.find_by_id(consumoId)
    recibo = consumo.recibo
    
    reservas_to_destroy = []
    if(consumo.produto.pacote != nil)
      consumo.produto.pacote.pacote_produtoss.each do |pacote_produto|
        pacote_produto.produto.reserva_produtos.each do |reservaproduto|
          reservas = InscricaoReserva.find_all_by_reserva_id(reservaproduto.reserva_id, :conditions=>"inscricao_id = "+consumo.inscricao_id.to_s)
          reservas.each do |inscricaoReserva|
            reservas_to_destroy << inscricaoReserva.id
          end
        end
      end
    else
      consumo.produto.reserva_produtos.each do |reservaproduto|
        reservas = InscricaoReserva.find_all_by_reserva_id(reservaproduto.reserva_id, :conditions=>"inscricao_id = "+consumo.inscricao_id.to_s)
        reservas.each do |inscricaoReserva|
          reservas_to_destroy << inscricaoReserva.id
        end
      end
    end
    
    reservas_to_destroy.each do |inscricaoReservaId|
      InscricaoReserva.destroy(inscricaoReservaId)
    end
    
    Consumo.destroy(consumoId)
    
    if(enviar_email)
      @recibo = recibo
      #@linhas_recibo = @recibo.linhas_recibo
      #pdf = make_pdf :template => "recibos/detalhe.html.erb", :stylesheets => [@entidade.sigla+"/default","niceforms-default","tabs","print"], :layout => "recibos.html.erb"
      UserMailer.deliver_recibo_alterado_notification(@recibo, @recibo.inscricao.user.email, @recibo.to_pdf)          
    end
    @success = true
  end
  
  
  def elimina_desconto
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    enviar_email = params[:sendEmail] == "1"
    descontoId = params[:descontoId]
    desconto = DescontoInscricao.find_by_id(descontoId)
    
    inscricao = desconto.inscricao
    
    DescontoInscricao.destroy(descontoId)
    inscricao.save
    if(inscricao.consumos.count > 0)
      recibo = inscricao.consumos[0].recibo
      
      if(enviar_email)
        @recibo = recibo
        #@linhas_recibo = @recibo.linhas_recibo
        #pdf = make_pdf :template => "recibos/detalhe.html.erb", :stylesheets => [@entidade.sigla+"/default","niceforms-default","tabs","print"], :layout => "recibos.html.erb"
        UserMailer.deliver_recibo_alterado_notification(@recibo, @recibo.inscricao.user.email, @recibo.to_pdf)          
      end
    end
    @success = true
  end
  
  
  
  def recomendar
    @inscricao = Inscricao.find_by_id(params[:id])
    @event = Evento.find_by_id(@inscricao.evento_id)
    @entidade = @event.entidade
    
    if(@current_user != nil && ((current_user.profile.upcase == "PASTOR" || @current_user.profile == "ADMIN") || ((@current_user.profile == "EVENTO_ESCRITA" || @current_user.profile == "EVENTO_FACTURACAO_LEITURA" || @current_user.profile == "EVENTO_FACTURACAO_ESCRITA") && @current_user.evento_id == @event.id)))
      if(params[:recomendacao] != nil && params[:recomendacao] != "")
        recomendacao = Recomendacao.new()
        recomendacao.user_id = current_user.id;
        recomendacao.inscricao_id = @inscricao.id;
        recomendacao.assinatura = params[:recomendacao]
        recomendacao.save
  
        @event.grupo_camposs.each do |grupocampos|
          grupocampos.campos.each do |campo|
            if(campo.is_assinatura_recomendacao)
              campoInscricao = InscricaosCampos.new()
              campoInscricao.inscricao_id = @inscricao.id
              campoInscricao.campo_id = campo.id
              campoInscricao.string_value = params[:recomendacao]
              campoInscricao.save
            end
          end
        end
        
        ## Enviar e-mail de confirmação de assinatura.
        
      end
    end
  end

  
  def editar
    @inscricao = Inscricao.find_by_id(params[:id])
    @event = Evento.find_by_id(@inscricao.evento_id)
    @entidade = @event.entidade
    
    @values = []
    
    @event.grupo_camposs.each do |grupo_campos|
      grupo_campos.campos.each do |campo|
        @values[campo.id] = @inscricao.valor_campo(campo.id)
      end
    end
    
  end
  
  def regista_modificacoes
    @values = []
    
    @inscricao = Inscricao.find_by_id(params[:id])
    @event = Evento.find_by_id(@inscricao.evento_id)
    
    error = false
    params[:campo].each do |campo|
      metaCampo = Campo.find_by_id(campo[0])
      
      @values[campo[0].to_i] = campo[1]
      
      if(metaCampo.required)
        if(campo[1] == nil || campo[1] == "")
          @inscricao.errors.add(metaCampo.nome,"Tem que preencher o campo '"+metaCampo.label+"'")
          error = true;
        end
      end
      if(metaCampo.min_value != nil)
        if(campo[1].to_d < metaCampo.min_value)
          @inscricao.errors.add(metaCampo.nome,"O campo '"+metaCampo.label+"' tem que ser preenchido com um valor superior a "+metaCampo.min_value.to_s)
          error = true;
        end
      end
      if(metaCampo.max_value != nil)
        if(campo[1].to_d > metaCampo.max_value)
          @inscricao.errors.add(metaCampo.nome,"O campo '"+metaCampo.label+"' tem que ser preenchido com um valor inferior a "+metaCampo.max_value.to_s)
          error = true;
        end
      end
    end
      
    if(!error)
      params[:campo].each do |campo|
        metaCampo = Campo.find_by_id(campo[0])
      
        campoInscricao = InscricaosCampos.find_by_inscricao_id(@inscricao.id, :conditions=>"campo_id = "+metaCampo.id.to_s)
        if(campoInscricao == nil)
          campoInscricao = InscricaosCampos.new()
          campoInscricao.campo_id = metaCampo.id
        end
        if(metaCampo.tipo.upcase == "STRING")
          campoInscricao.string_value = campo[1]
          if(metaCampo.nome.upcase == "NOME" || metaCampo.is_nome)
            @inscricao.nome = campo[1]
          end
          if(metaCampo.nome.upcase == "EMAIL" || metaCampo.is_email)
            @inscricao.email = campo[1]
          end
        end
        if(metaCampo.tipo.upcase == "TEXT")
          campoInscricao.text_value = campo[1]
        end
        if(metaCampo.tipo.upcase == "INT")
          campoInscricao.int_value = campo[1].to_i
        end
        if(metaCampo.tipo.upcase == "DECIMAL")
          campoInscricao.decimal_value = campo[1]
        end
        if(metaCampo.tipo.upcase == "DATE")
          campoInscricao.date_value = campo[1]
          if(metaCampo.nome.upcase == "DATANASCIMENTO" || metaCampo.is_data_nascimento)
            @inscricao.idade = Date.today.year - campo[1].to_date.year
          end
        end
        if(metaCampo.tipo.upcase == "LOV")
          campoInscricao.lov_value = campo[1]
          if(metaCampo.nome.upcase == "IGREJA" || metaCampo.is_igreja)
            @inscricao.igreja_id = campo[1]
          end
        end
        
        @inscricao.inscricaos_camposs << campoInscricao
      end
    end
    
    if(@inscricao.errors.count == 0)
      @inscricao.save
      if (request.xhr? || params[:callback] != nil)
        render :template=>"/inscricoes/regista.xml.erb"
      else 
        redirect_to :event=>@event.codigo, :action=>"detalhe", :id=>@inscricao.id
      end
    else
      if (request.xhr? || params[:callback] != nil)
        render :template=>"/inscricoes/regista.xml.erb"
      else 
        render :template=>"inscricoes/nova"
      end
      
    end
      
  end
  
  
  
  
  def update
    @inscricao = Inscricao.find_by_id(params[:id])
    
    #@inscricao.inscricaos_camposs.each do |campo_insc|
    #  InscricaosCampos.destroy(campo_insc.id)
    #end
    
    params[:campo].each do |campo|
      metaCampo = Campo.find_by_id(campo[0])
      
      campoInscricao = InscricaosCampos.new()
      campoInscricao.campo_id = metaCampo.id
      if(metaCampo.tipo.upcase == "STRING")
        campoInscricao.string_value = campo[1]
      end
      if(metaCampo.tipo.upcase == "INT")
        campoInscricao.int_value = campo[1].to_i
      end
      if(metaCampo.tipo.upcase == "DECIMAL")
        campoInscricao.decimal_value = campo[1]
      end
      if(metaCampo.tipo.upcase == "DATE")
        campoInscricao.date_value = campo[1]
      end
      if(metaCampo.tipo.upcase == "LOV")
        campoInscricao.lov_value = campo[1]
      end
      
      campoInscricao.inscricao_id = @inscricao.id
      campoInscricao.save
      
    end
    
    @inscricao.save
    
    redirect_to :action=>"detalhe", :id=>@inscricao.id
  end
  
  def detalhe
    @inscricao = Inscricao.find_by_id(params[:id])
    @event = Evento.find_by_id(@inscricao.evento_id)
    @entidade = @event.entidade
    
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "inscricao-"+@inscricao.id.to_s, 
               :template => "/inscricoes/detalhe.html.erb", 
               :stylesheets => [@entidade.sigla+"/default","niceforms-default","tabs","print"],
               :layout => "inscricoes.erb"
      end
    end
  end
  
  
  def grupo
        @inscricao = Inscricao.find_by_id(params[:id])
        @event = Evento.find_by_id(@inscricao.evento_id)
        @entidade = @event.entidade
        
        responsavel_inscricao = InscricaosCampos.find_by_campo_id(15, :conditions=>"inscricao_id = "+params[:id]).string_value
        @inscricoes_grupo = Inscricao.com_valor_string(15, responsavel_inscricao, 0, 1000, "ASC", @inscricao.evento_id)
        
        respond_to do |format|
          format.html
          format.pdf do
            render :pdf => "grupo-"+@inscricao.id.to_s, 
                   :template => "/inscricoes/grupo.html.erb", 
                   :stylesheets => [@entidade.sigla+"/default","niceforms-default","tabs","print"],
                   :layout => "inscricoes.erb"
          end
        end
  end
  
  
  def lista
    @inscricoes = Inscricao.find_all_by_user_id(self.current_user.id);
    
    respond_to do |format|
      format.html
      format.xml
      format.pdf do
        render :pdf => "lista-inscricoes",
               :template => "/admin/lista_inscricoes.html.erb", 
               :stylesheets => [@entidade.sigla+"/default","niceforms-default","tabs","print"],
               :layout => "admin.html.erb"
      end
    end
  end
  
  def eliminar
    Inscricao.destroy(params[:id])
    redirect_to :action=>"lista"
  end


  def calcular_reservas_all
    inscricoes = Inscricao.find(:all)
    
    inscricoes.each do |inscricao|
      inscricao.consumos.each do |consumo|
        produto = consumo.produto
        if(produto.pacote != nil)
          produto.pacote.pacote_produtoss.each do |pacoteproduto|
            pacoteproduto.produto.reserva_produtos.each do |reservaproduto|
              if(add_reserva(reservaproduto, inscricao))
                reserva = InscricaoReserva.new
                reserva.inscricao_id = inscricao.id
                reserva.reserva_id = reservaproduto.reserva_id
                reserva.consumo_id = consumo.id
                reserva.save
                reserva.reload
                estado = ReservaEstado.new
                estado.inscricao_reserva_id = reserva.id
                estado.estado_reserva_id = 1
                estado.data_inicio = consumo.created_at
                estado.save
                if(consumo.recibo.total_pago >= consumo.recibo.taxa_inscricao)
                  estado.data_fim = DateTime.now
                  estado.save
                  estado2 = ReservaEstado.new
                  estado2.inscricao_reserva_id = reserva.id
                  estado2.estado_reserva_id = 2
                  estado2.data_inicio = DateTime.now
                  estado2.save
                end
              end
            end
          end
        else
          produto.reserva_produtos.each do |reservaproduto|
            if(add_reserva(reservaproduto, inscricao))
              reserva = InscricaoReserva.new
              reserva.inscricao_id = inscricao.id
              reserva.reserva_id = reservaproduto.reserva_id
              reserva.consumo_id = consumo.id
              reserva.save
              reserva.reload
              estado = ReservaEstado.new
              estado.inscricao_reserva_id = reserva.id
              estado.estado_reserva_id = 1
              estado.data_inicio = consumo.created_at
              estado.save
              if(consumo.recibo.total_pago >= consumo.recibo.taxa_inscricao)
                estado.data_fim = DateTime.now
                estado.save
                estado2 = ReservaEstado.new
                estado2.inscricao_reserva_id = reserva.id
                estado2.estado_reserva_id = 2
                estado2.data_inicio = DateTime.now
                estado2.save
              end
            end
          end
        end
      end
    end
  end
 
# example action to return the contents
  # of a table in CSV format
  def export_inscricoes
    inscricoes = Inscricao.find(:all)
    stream_csv do |csv|
      #csv << ["codigo","nome","igreja","estatuto","refeicao1","refeicao2","refeicao3","refeicao4","refeicao5"]
      inscricoes.each do |i|
        codigo = "I-AGCBP-"+i.id.to_s.rjust(3, '0')
        igreja = i.igreja.full_name
        estatuto = ""
        if i.estatuto.id == 2
          estatuto = "A"
        else
          estatuto = "D"
        end
        csv << [codigo,i.nome_cracha.upcase,igreja,estatuto,i.refeicao1.tipo_refeicao.to_s,i.refeicao2.tipo_refeicao.to_s,i.refeicao3.tipo_refeicao.to_s,i.refeicao4.tipo_refeicao.to_s,i.refeicao5.tipo_refeicao.to_s]
      end
    end
  end

  protected
  
  def authorize_detalhe
    if !self.logged_in?
      #flash[:notice] = "Identifique-se para aceder a esta funcionalidade"
      if(request.xhr? || params[:callback] != nil)
        render :text => "NOT LOGGED IN", :layout=>false
      else
        redirect_to :controller=>"sessions", :action=>"new"
      end
      return
    end
    inscricao = Inscricao.find_by_id(params[:id])
    if inscricao != nil && self.current_user.profile != "ADMIN" && !self.current_user.inscricaos.collect(&:id).include?(inscricao.id)
      if ((self.current_user.profile == "IGREJA" || self.current_user.profile == "PASTOR") && inscricao.igreja_id == self.current_user.igreja_id)
        return
      end
      if((self.current_user.profile == "EVENTO_LEITURA" || self.current_user.profile == "EVENTO_ESCRITA" || self.current_user.profile == "EVENTO_FACTURACAO_LEITURA" || self.current_user.profile == "EVENTO_FACTURACAO_ESCRITA") && self.current_user.evento_id == inscricao.evento.id)
        return
      end
      if(request.xhr? || params[:callback] != nil)
        render :text => "NOT AUTHORIZED", :layout=>false
      else
        flash[:erro_titulo] = "Não autorizado"
        flash[:erro_mensagem] = "Não está autorizado a ver o detalhe desta inscrição"
        redirect_to :controller=>"error"
      end
    end
  end

  private
    def stream_csv
       filename = params[:action] + ".csv"    
	
       #this is required if you want this to work with IE		
       if request.env['HTTP_USER_AGENT'] =~ /msie/i
         headers['Pragma'] = 'public'
         headers["Content-type"] = "text/plain"
         headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
         headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
         headers['Expires'] = "0"
       else
         headers["Content-Type"] ||= 'text/csv'
         headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
       end
 
      render :text => Proc.new { |response, output|
        csv = FasterCSV.new(output, :row_sep => "\r\n") 
        yield csv
      }
    end
end


def add_reserva(reserva_produto, inscricao)
  
  campo = reserva_produto.campo
  result = false
  
  inscricao_reserva = InscricaoReserva.find_by_inscricao_id(inscricao.id, :conditions=>"reserva_id ="+reserva_produto.reserva_id.to_s)
  if(inscricao_reserva != nil)
    return false
  end
  if(reserva_produto.comparison_operator == nil)
    result = true
  end
  if(reserva_produto.comparison_operator == ">" || reserva_produto.comparison_operator == "<" || reserva_produto.comparison_operator == ">=" || reserva_produto.comparison_operator == "<=")
    if(campo.tipo == "int" || campo.tipo == "decimal" || campo.tipo == "lov")
      result = eval(inscricao.valor_campo_string(campo.id)+" "+reserva_produto.comparison_operator+" "+reserva_produto.comparison_operand)
    end
    if(campo.tipo == "date")
      result = eval("Date.parse(\""+inscricao.valor_campo_string(campo.id)+"\") "+reserva_produto.comparison_operator+" Date.parse(\""+reserva_produto.comparison_operand+"\") ")
    end
  end
  if(reserva_produto.comparison_operator == "=" || reserva_produto.comparison_operator == "==")
    if(campo.tipo == "int" || campo.tipo == "decimal")
      result = eval(inscricao.valor_campo_string(campo.id)+" == "+reserva_produto.comparison_operand)
    end
    if(campo.tipo == "text" || campo.tipo == "lov")
      result = eval("'"+inscricao.valor_campo_string(campo.id)+"'.upcase == '"+reserva_produto.comparison_operand+"'.upcase")
    end
    if(campo.tipo == "date")
      result = eval("Date.parse(\""+inscricao.valor_campo_string(campo.id)+"\") == Date.parse(\""+reserva_produto.comparison_operand+"\") ")
    end
  end
  if(reserva_produto.comparison_operator == "in")
    found = false
    itens = reserva_produto.comparison_operand.gsub(", ",",").gsub(" ,",",").split(",")
    itens.each do |item|
      if(campo.tipo == "int" || campo.tipo == "decimal" || campo.tipo == "lov")
        found = eval(inscricao.valor_campo_string(campo.id)+" == "+item)  
      end
      if(campo.tipo == "text" || campo.tipo == "lov")
        found = eval("'"+inscricao.valor_campo_string(campo.id)+"'.upcase == '"+item+"'.upcase")  
      end
      if(campo.tipo == "date")
        found = eval("Date.parse(\""+inscricao.valor_campo_string(campo.id)+"\") == Date.parse(\""+item+"\") ")
      end
      if(found)
        result = true
        break
      end
    end
  end
  if(reserva_produto.comparison_operator == "not in")
    not_found = true
    found = false
    itens = reserva_produto.comparison_operand.gsub(", ",",").gsub(" ,",",").split(",")
    itens.each do |item|
      if(campo.tipo == "int" || campo.tipo == "decimal" || campo.tipo == "lov")
        found = eval(inscricao.valor_campo_string(campo.id)+" == "+item)  
      end
      if(campo.tipo == "text" || campo.tipo == "lov")
        found = eval("'"+inscricao.valor_campo_string(campo.id)+"'.upcase == '"+item+"'.upcase")  
      end
      if(campo.tipo == "date")
        found = eval("Date.parse(\""+inscricao.valor_campo_string(campo.id)+"\") == Date.parse(\""+item+"\") ")
      end
      if(found)
        not_found = false
        break
      end
    end
    if(not_found)
      result = true
    end
  end
  
  result
end

