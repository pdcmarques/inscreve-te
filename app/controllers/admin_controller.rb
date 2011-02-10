class AdminController < ApplicationController
  
  before_filter :authorize_admin, :only=>[:pagamentos_mb, :load_pagamentos_mb, :envia_email_generico, :processa_recibo_reminder]
  before_filter :authorize_admin_evento_leitura, :only=>[:lista_inscricoes, :index, :set_evento, :lista_igrejas]
  before_filter :authorize_admin_evento_escrita, :only=>[:elimina_inscricao, :marcarpresente, :marcarausente, :marcarcancelado, :marcardescancelado, :lista_igrejas, :regista_ou_actualiza_recomendacao, :elimina_recomendacao]
  before_filter :authorize_admin_evento_facturacao_leitura, :only=>[:lista_recibos, :descontos_inscricao, :consumos_inscricao, :recibos_inscricao]
  before_filter :authorize_admin_evento_facturacao_escrita, :only=>[:elimina_recibo, :regista_ou_actualiza_pagamento, :elimina_pagamento, :elimina_consumo]
  
  def index
    @event = Evento.find_by_codigo(params[:event])
    @entidade = Entidade.find_by_sigla(params[:entidade])
    redirect_to :event=>@event.codigo, :action=>"lista_inscricoes"
  end
  
  def set_evento
    event = Evento.find_by_id(params[:evento_id])
    entidade = Entidade.find_by_sigla(params[:entidade])
    redirect_to :event=>event.codigo, :action=>"index", :entidade=>entidade.sigla
  end
  
  def lista_inscricoes
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    if(params[:sort] == nil)
      params[:sort] = ''
    end
    @campo = Campo.find_by_nome(params[:sort])
    @inscricoes = []
    if(params[:start] == nil)
        params[:start] = 0
    end
    
    @valor = params[:query]
    if(@valor == nil || @valor == "")
      @valor = "%"
    end
    
    if(@valor.upcase.starts_with?("I-") || @valor.upcase.starts_with?("I\'") || @valor.upcase.starts_with?("Iº"))
      @inscricoes = Inscricao.find_all_by_id(@valor[-4..-1])
      @totalCount = @inscricoes.size
      respond_to do |format|
        format.html
        format.xml
        format.pdf do
          render :pdf => "inscricoes", 
                 :template => "admin/lista_inscricoes.html.erb", 
                 :stylesheets => ["default","niceforms-default","tabs","print"],
                 :layout => "admin.html.erb"
        end
        format.xls  { render :template => "admin/lista_inscricoes.xls.rxls", :layout => false }
      end
      return
    end
    
    if(@valor.starts_with?("R-") || @valor.starts_with?("R\'"))
      @inscricoes = []
      recibo = Recibo.find_by_id(@valor[-4..-1])
      if(recibo != nil)
        recibo.consumos.each do |consumo|
          if(!@inscricoes.include?(consumo.inscricao))
            @inscricoes << consumo.inscricao
          end
        end
      end
      @totalCount = @inscricoes.size
      respond_to do |format|
        format.html
        format.xml
        format.pdf do
          render :pdf => "inscricoes", 
                 :template => "admin/lista_inscricoes.html.erb", 
                 :stylesheets => ["default","niceforms-default","tabs","print"],
                 :layout => "admin.html.erb"
        end
        format.xls  { render :template => "admin/lista_inscricoes.xls.rxls", :layout => false }
      end
      return
    end
    
    if(params[:sort].upcase == "NUMERO")
      @inscricoes = Inscricao.com_numero(-9999999,999999,params[:start], params[:limit], params[:dir],@event.id)
    end
    if(params[:sort].upcase == "IDADECALCULATED")
      @inscricoes = Inscricao.com_idade(-9999999,999999,params[:start], params[:limit], params[:dir],@event.id)
    end
    if(params[:sort].upcase == "CREATED_AT")
      @inscricoes = Inscricao.created_at_filter("2000-01-01","9999-12-31",params[:start], params[:limit], params[:dir],@event.id)
    end
    if(params[:sort].upcase == "USER")
      @inscricoes = Inscricao.com_user("%",params[:start], params[:limit], params[:dir],@event.id)
    end
    
    if(@campo != nil)
      puts "CAMPO: "+@campo.id.to_s+" - "+@campo.nome+" - "+@campo.tipo.upcase
      if(@campo.tipo.upcase == "STRING")
        @inscricoes = Inscricao.com_valor_string(@campo.id,@valor,params[:start], params[:limit], params[:dir],@event.id)
      end
      if(@campo.tipo.upcase == "DATE")
        @inscricoes = Inscricao.com_valor_data(@campo.id,"2000-01-01","9999-12-31",params[:start], params[:limit], params[:dir],@event.id)
      end
      if(@campo.tipo.upcase == "LOV")
        if(@campo.lista_valores.class_name != nil && @campo.lista_valores.class_name != '')
          @inscricoes = Inscricao.com_valor_lov_tabela(@campo.id,@valor,@campo.lista_valores.class_name,@campo.lista_valores.value_field,@campo.lista_valores.text_field,params[:start], params[:limit], params[:dir],@event.id)
        else
          @inscricoes = Inscricao.com_valor_lov(@campo.id,@valor,params[:start], params[:limit], params[:dir],@event.id)
        end
      end
      if(@campo.tipo.upcase == "TEXT")
        @inscricoes = Inscricao.com_valor_string(@campo.id,@valor,params[:start], params[:limit], params[:dir],@event.id)
      end
     if(@campo.tipo.upcase == "INT")
        @inscricoes = Inscricao.com_valor_int(@campo.id,-9999999,999999,params[:start], params[:limit], params[:dir],@event.id)
      end
      if(@campo.tipo.upcase == "DECIMAL")
        @inscricoes = Inscricao.com_valor_decimal(@campo.id,-9999999,999999,params[:start], params[:limit], params[:dir],@event.id)
      end
    end
    
    @totalCount = @event.inscricaos.count
    
    #if(request.xhr?)
    #  if(params[:start] == nil or params[:start] == '')
    #    params[:start] = 0
    #  end
    #  if (params[:limit] != nil && params[:limit] != nil)
    #    @inscricoes = Inscricao.find_by_sql("select * from inscricaos where evento_id = "+@event.id.to_s+" limit "+params[:start].to_s+", "+params[:limit].to_s)
    #  else
    #   @inscricoes = Inscricao.find_by_sql("select * from inscricaos where evento_id = "+@event.id.to_s)
    #  end
    #  @totalCount = @event.inscricaos.count
    #else
    #  if (params[:sort] != nil && params[:dir] != nil)
    #    @inscricoes = Inscricao.find_by_sql("select * from inscricaos where evento_id = "+@event.id.to_s+" ORDER BY "+params[:sort]+" "+params[:dir])
    # else
    #    @inscricoes = Inscricao.find_by_sql("select * from inscricaos where evento_id = "+@event.id.to_s)
    #  end
    #end
    
    respond_to do |format|
      format.html
      format.xml
      format.pdf do
        render :pdf => "inscricoes", 
               :template => "admin/lista_inscricoes.html.erb", 
               :stylesheets => ["default","niceforms-default","tabs","print"],
               :layout => "admin.html.erb"
      end
      format.xls  { render :template => "admin/lista_inscricoes.xls.rxls", :layout => false }
    end
  end
  
  
  
  def search_inscricoes
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    query = params[:query]
    
    @inscricoes = Inscricao.find_all_by_evento_id(@event.id, :conditions => "nome like '"+query+"%'", :offset=>params[:start], :limit=>params[:limit])
  
    respond_to do |format|
      format.xml do
        render :template => 'admin/lista_inscricoes.xml.erb', :layout => false
      end
    end

  end
  
  def send_sms
    text = params[:text]
    recipient = params[:to]
    
    ActiveSms::Base.establish_connection(
      :adapter  => "bulk_sms",
      :subscriber_id => "pdcmarques",
      :subscriber_password => "pdm49731" 
    )
    
    adapter = ActiveSms::ConnectionAdapters::BulkSmsAdapter.new(logger, { :region => :international, :username=> "pdcmarques", :password => "pdm49731" })
    
    sms = ActiveSms::Sms.new
    sms.from = 'inscrevete'
    sms.recipients = [recipient]
    sms.body = text
    
    adapter.deliver(sms)
  end
  
  
  def reporting_recepcao
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    letra = params[:letra]
    
    @inscricoes = Inscricao.find_all_by_evento_id(@event.id, :conditions => ["nome like '"+letra+"%%'"], :order => 'nome')
    @totalCount = @inscricoes.size
    
    respond_to do |format|
      format.xml { render :template => "admin/lista_inscricoes.xml.erb", :layout => false }
    end
    
  end
  
  def reporting_inscricoes
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    @inscricoes = []
    if(params[:ids] == 'all')
      logger.error "ALL"
      @inscricoes = @event.inscricaos
      logger.error "N: "+@inscricoes.size.to_s
    else
      if(params[:ids].include?(','))
        logger.error "id in ("+(params[:ids].split(',').map {|s| s.to_s}).to_s+")"
        @inscricoes = Inscricao.find_all_by_evento_id(@event.id, :conditions => ["id IN (?)", (params[:ids].split(',').map {|s| s.to_s+","}).to_s])
        logger.error "N: "+@inscricoes.size.to_s
      else
        if(params[:ids].include?('-'))
          logger.error "id >= ("+(params[:ids].split('-')[0].to_s) +" and <= "+(params[:ids].split('-')[1].to_s) +")"
          @inscricoes = Inscricao.find_all_by_evento_id(@event.id, :conditions => ["id >= (?) and id <= (?)", (params[:ids].split('-')[0].to_s), (params[:ids].split('-')[1].to_s)])
          logger.error "N: "+@inscricoes.size.to_s
        else
          logger.error "id = "+params[:ids].to_s
          @inscricoes = Inscricao.find_all_by_id(params[:ids], :conditions => "evento_id = "+@event.id.to_s)
          logger.error "N: "+@inscricoes.size.to_s
        end
      end
    end
    
    @totalCount = @inscricoes.size
    
    respond_to do |format|
      format.xml { render :template => "admin/lista_inscricoes.xml.erb", :layout => false }
    end
  end
  
  
  
  def reporting_facturas
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    @recibos = @event.recibos
    respond_to do |format|
      format.xml { render :template => "admin/lista_recibos.xml.erb", :layout => false }
    end
  end
  
  
  def contagem_reservas
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    id_reserva = params[:id_reserva]
    
    if(id_reserva != nil && id_reserva != 0)
    
    else
      
      
      
    end
    
    
    respond_to do |format|
      format.xml
    end
    
  end
  
  
  def elimina_inscricao
    @entidade = Entidade.find_by_sigla(params[:entidade])
    Inscricao.destroy(params[:id])
    flash[:notice] = "Inscrição eliminada"
    if(request.xhr?)
      render :text => "OK"
    else
      redirect_to :action=>"lista_inscricoes"
    end
  end
  
  def marcarpresente
    @entidade = Entidade.find_by_sigla(params[:entidade])
    insc = Inscricao.find_by_id(params[:id])
    insc.presente = true
    insc.cancelado = false
    insc.save
    redirect_to :action=>"lista_inscricoes"
  end
  
  def marcarausente
    @entidade = Entidade.find_by_sigla(params[:entidade])
    insc = Inscricao.find_by_id(params[:id])
    insc.presente = false
    insc.save
    redirect_to :action=>"lista_inscricoes"
  end
  
  def marcarcancelado
    @entidade = Entidade.find_by_sigla(params[:entidade])
    insc = Inscricao.find_by_id(params[:id])
    insc.cancelado = true
    insc.presente = false
    insc.save
    redirect_to :action=>"lista_inscricoes"
  end
  
  def marcardescancelado
    @entidade = Entidade.find_by_sigla(params[:entidade])
    insc = Inscricao.find_by_id(params[:id])
    insc.cancelado = false
    insc.save
    redirect_to :action=>"lista_inscricoes"
  end
  
  def lista_recibos
    @entidade = Entidade.find_by_sigla(params[:entidade])
    @event = Evento.find_by_codigo(params[:event])
    
    if(params[:query] != nil && params[:query] != "")
      @recibos = Recibo.find_all_by_evento_id(@event.id, :conditions => ['nome LIKE ? ', params[:query]])
    else
      @recibos = Recibo.find_all_by_evento_id(@event.id)
    end
    
    
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
  
   def lista_reservas
    @entidade = Entidade.find_by_sigla(params[:entidade])
    @event = Evento.find_by_codigo(params[:event])
    
    reserva_ids = nil
    if(params[:reserva_ids] != nil && params[:reserva_ids] != '')
      reserva_ids = params[:reserva_ids].split(',')
    end
    @ja_consumida = false
    @estado_anterior = nil
    @reservas = []
    if(params[:inscricao] == nil)
      @event.inscricaos.each do |inscricao|
        insc_reservas = inscricao.inscricao_reservas.sort do |a,b|
          bkey = (b.reserva.data_consumo != nil ? b.reserva.data_consumo : DateTime.now)
          akey = (a.reserva.data_consumo != nil ? a.reserva.data_consumo : DateTime.now)
          akey <=> bkey
        end
        insc_reservas.each do |reserva|
          if(reserva_ids != nil)
            reserva_ids.each do |id|
              if(reserva.reserva_id.to_i == id.to_i)
                @reservas << reserva
              end
            end
          else
            @reservas << reserva
          end
        end
      end
    else
      @inscricao = Inscricao.find_by_id(params[:inscricao])
      if(@inscricao != nil)
        insc_reservas = @inscricao.inscricao_reservas.sort do |a,b|
          bkey = (b.reserva.data_consumo != nil ? b.reserva.data_consumo : DateTime.now)
          akey = (a.reserva.data_consumo != nil ? a.reserva.data_consumo : DateTime.now)
          akey <=> bkey
        end
        insc_reservas.each do |reserva|
          if(reserva_ids != nil)
            reserva_ids.each do |id|
              if(reserva.reserva_id.to_i == id.to_i)
                @reservas << reserva
                if(params[:consumir_reserva] == "1")
                  @ja_consumida = false
                  @estado_anterior = nil
                  reserva.reserva_estados.each do |reserva_estado|
                    if(reserva_estado.estado_reserva_id == 5)
                      @ja_consumida = true
                    end
                    if(reserva_estado.data_fim == nil)
                      @estado_anterior = reserva_estado
                    end
                  end
                  if(!@ja_consumida)
                    if(@estado_anterior != nil)
                      @estado_anterior.data_fim = DateTime.now
                      @estado_anterior.save
                    end
                    
                    estado_reserva = ReservaEstado.new
                    estado_reserva.estado_reserva_id = 5
                    estado_reserva.inscricao_reserva_id = reserva.id
                    estado_reserva.data_inicio = DateTime.now
                    estado_reserva.save
                  else
                  end
                end
              end
            end
          else
            @reservas << reserva
          end
        end
      end
    end
    
    @totalCount = @reservas.size
    if(@totalCount == 0)
      if(reserva_ids != nil)
        @reserva = Reserva.find_by_id(reserva_ids[0])
      end
    end
  
    
    respond_to do |format|
      format.xml
    end
    
  end
   
   
  def lista_tipo_reservas
    @entidade = Entidade.find_by_sigla(params[:entidade])
    @event = Evento.find_by_codigo(params[:event])
    
    reservas = []
    @tipos_reservas = []
    
    @event.grupo_camposs.each do |grupo_campos|
      grupo_campos.campos.each do |campo|
        campo.campo_produtos.each do |campo_produto|
          campo_produto.produto.reserva_produtos.each do |reserva_produto|
            reservas << reserva_produto.reserva
          end
        end
      end
    end
    
    reservas.each do |reserva|
      ids = reserva.id.to_s
      add = true;
      @tipos_reservas.each do |tipo_reserva|
        if(tipo_reserva.nome == reserva.nome)
          add = false;
        end
      end
      if(!add)
        next;
      end
      reservas.each do |reserva_2|
        if(reserva.nome == reserva_2.nome && reserva.id != reserva_2.id)
          ids += ","+reserva_2.id.to_s
        end
      end
      tipoReserva = TipoReserva.new
      tipoReserva.nome = reserva.nome
      tipoReserva.ids = ids
      tipoReserva.icon = reserva.tipo_reserva.icone
      @tipos_reservas << tipoReserva
    end
    
    respond_to do |format|
      format.xml
    end
    
  end
  
  class TipoReserva
      def nome
        @nome
      end  
      def nome=(nome)  
        @nome = nome
      end
      
      def ids
        @ids
      end  
      def ids=(ids)  
        @ids = ids
      end
      
      def icon
        @icon
      end
      def icon=(icon)
        @icon = icon
      end
  end
  
  def elimina_recibo
    @entidade = Entidade.find_by_sigla(params[:entidade])
    
    @errors = []
    recibo = Recibo.find_by_id(params[:reciboId])
    if(recibo.consumos.count == 0)
      if(recibo.pagamentos.count > 0)
        @errors << ["pagamentos","Recibo contém pagamentos. Não pode ser apagago"]
      else
        Recibo.destroy(params[:reciboId])
      end
    else
      @errors << ["consumos","Recibo contém consumos. Não pode ser apagago"]
    end
    
    render :template=>"admin/resposta_xhr.xml", :layout=>false
    
  end
  
  def regista_ou_actualiza_pagamento
    pagamento_data = params[:pagamentoData]
    pagamento_valor = params[:pagamentoValor]
    pagamento_observacoes = params[:pagamentoObs]
    pagamento_inscricao_id = params[:pagamentoInscricao]
    pagamento_recibo_id = params[:pagamentoRecibo]
    pagamento_tipo = params[:pagamentoTipo]
    
    enviar_email = params[:sendEmail] == "1"
    
    if(params[:pagamentoId].starts_with? 'ext' or params[:pagamentoId] == nil or params[:pagamentoId] == '')
      pagamento = Pagamento.new()
      pagamento.data = pagamento_data
      pagamento.valor = pagamento_valor
      pagamento.observacoes = pagamento_observacoes
      if(pagamento_tipo != nil && pagamento_tipo.to_i > 0)
        pagamento.tipo_pagamento_id = pagamento_tipo
      end
      if(pagamento_inscricao_id != nil && pagamento_inscricao_id.to_i > 0)
        pagamento.inscricao_id = pagamento_inscricao_id
      end
      if(pagamento_recibo_id != nil && pagamento_recibo_id.to_i > 0)
        pagamento.recibo_id = pagamento_recibo_id
      end
      pagamento.save
      if(pagamento.inscricao != nil)
        pagamento.inscricao.atribui_numero();
      end
      if(pagamento.inscricao != nil && (pagamento.inscricao.user.profile == nil || (pagamento.inscricao.user.profile != nil && pagamento.inscricao.user.profile.upcase != "ADMIN")))
        if(enviar_email)
          envia_email_pagamento(pagamento.inscricao_id, pagamento)
        end
      end
      if(pagamento.recibo != nil)
        if(enviar_email)
          envia_email_pagamento_recibo(pagamento.recibo_id, pagamento)
        end
        #ENVIAR EMAIL PAGAMENTO DO RECIBO
        if(pagamento.recibo.total_pago >= pagamento.recibo.taxa_inscricao)
          pagamento.recibo.fechado = true
        end
        pagamento.recibo.save
      end
    else
      pagamento = Pagamento.find_by_id(params[:pagamentoId])
      pagamento.data = pagamento_data
      pagamento.valor = pagamento_valor
      pagamento.observacoes = pagamento_observacoes
      if(pagamento_tipo != nil && pagamento_tipo.to_i > 0)
        pagamento.tipo_pagamento_id = pagamento_tipo
      end
      if(pagamento_inscricao_id != nil && pagamento_inscricao_id.to_i > 0)
        pagamento.inscricao_id = pagamento_inscricao_id
      end
      if(pagamento_recibo_id != nil && pagamento_recibo_id.to_i > 0)
        pagamento.recibo_id = pagamento_recibo_id
      end
      pagamento.save
      if(pagamento.inscricao != nil)
        pagamento.inscricao.atribui_numero();
      end
      if(pagamento.recibo != nil)
        #ENVIAR EMAIL PAGAMENTO DO RECIBO
        if(enviar_email)
          envia_email_pagamento_recibo(pagamento.recibo_id, pagamento)
        end
        #TESTAR SE TAXA FOI TOTALMENTE PAGA E FECHAR O RECIBO
        if(pagamento.recibo.total_pago >= pagamento.recibo.taxa_inscricao)
          pagamento.recibo.fechado = true
        end
        pagamento.recibo.save
      end
      
    end
    
    if(request.xhr?)
      render :text=>"OK"
    end
  end
  
  def elimina_pagamento
    if(!params[:id].starts_with? 'ext')
      pagamento = Pagamento.find_by_id(params[:id])
      recibo = pagamento.recibo
      Pagamento.destroy(params[:id])
      flash[:notice] = "Pagamento eliminado"
      pagamento.recibo.save
      if(request.xhr?)
        render :text=>"OK"
      else
        redirect_to :controller=>"recibos", :action=>"detalhe", :id=>recibo.id
      end
    end
    
  end
  
  
  
  def regista_ou_actualiza_recomendacao
    recomendacao_id = params[:recomendacaoId]
    recomendacao_assinatura = params[:recomendacaoAssinatura]
    recomendacao_inscricao_id = params[:recomendacaoInscricao]
    
    if(params[:recomendacaoId].starts_with? 'ext' or params[:recomendacaoId] == nil or params[:recomendacaoId] == '')
      recomendacao = Recomendacao.new()
      recomendacao.assinatura = recomendacao_assinatura
      recomendacao.inscricao_id = recomendacao_inscricao_id
      recomendacao.user_id = @current_user.id
      recomendacao.save
    else
      recomendacao = Recomendacao.find_by_id(params[:recomendacaoId])
      recomendacao.assinatura = recomendacao_assinatura
      recomendacao.inscricao_id = recomendacao_inscricao_id
      recomendacao.save
    end
    
    insc = Inscricao.find_by_id(recomendacao_inscricao_id)
    insc.evento.grupo_camposs.each do |grupocampos|
      grupocampos.campos.each do |campo|
        if(campo.is_assinatura_recomendacao)
          campoInscricao = InscricaosCampos.new()
          campoInscricao.inscricao_id = recomendacao_inscricao_id
          campoInscricao.campo_id = campo.id
          campoInscricao.string_value = recomendacao_assinatura
          campoInscricao.save
        end
      end
    end
    
    if(request.xhr?)
      render :text=>"OK"
    end
  end
  
  def elimina_recomendacao
    if(!params[:id].starts_with? 'ext')
      rec = Recomendacao.find_by_id(params[:id])
      inscricao = Inscricao.find_by_id(rec.inscricao_id)
      
      campo_id = nil
      inscricao.evento.grupo_camposs.each do |grupocampos|
        grupocampos.campos.each do |campo|
          if(campo.is_assinatura_recomendacao)
            campo_id = campo.id
            break
          end
        end
      end
      if(campo_id != nil)
        ic = InscricaosCampos.find_by_campo_id(campo_id, :conditions=>"inscricao_id = "+inscricao.id.to_s)
        if(ic)
          InscricaosCampos.destroy(ic.id)
        end
      end
      
      Recomendacao.destroy(params[:id])
      
      flash[:notice] = "Recomendacao eliminada"
      if(request.xhr?)
        render :text=>"OK"
      else
        redirect_to :controller=>"inscricoes", :action=>"lista"
      end
    end
    
  end
  
  
  def sincroniza_recomendacoes
    entidade = Entidade.find_by_sigla(params[:entidade])
    
    entidade.eventos.each do |evento|
      if (evento.id >= 18 && evento.id <= 29)
        campo_id = nil
        evento.grupo_camposs.each do |grupocampos|
          grupocampos.campos.each do |campo|
            if(campo.is_assinatura_recomendacao)
              campo_id = campo.id
              break
            end
          end
        end
        
        if(campo_id)
          evento.inscricaos.each do |inscricao|
            ic = InscricaosCampos.find_by_campo_id(campo_id, :conditions=>"inscricao_id = "+inscricao.id.to_s)
            if(ic == nil)
              if(inscricao.recomendacaos.count > 0)
                assinatura = inscricao.recomendacaos[0].assinatura
                campoInscricao = InscricaosCampos.new()
                campoInscricao.inscricao_id = inscricao.id
                campoInscricao.campo_id = campo_id
                campoInscricao.string_value = assinatura
                campoInscricao.save
              end
            end
          end
        end
      end
    end
  end
  
  
  def elimina_consumo
    Consumo.destroy(params[:id])
  end
  
  def muda_consumo_de_factura
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    consumo = Consumo.find_by_id(params[:consumoId])
    facturaDestino = Recibo.find_by_id(params[:facturaId])
    
    if(consumo.recibo.evento_id == facturaDestino.evento_id)
      consumo.recibo_id = params[:facturaId].to_i
      consumo.save
    end
    
    @errors = []
    render :template=>"admin/resposta_xhr.xml", :layout=>false
  end
  
  
  def junta_facturas
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    facturaOrigem = Consumo.find_by_id(params[:facturaOrigemId])
    facturaDestino = Recibo.find_by_id(params[:facturaDestinoId])
    
    if(facturaOrigem.evento_id == facturaDestino.evento_id)
      facturaOrigem.consumos.each do |consumo|
        consumo.recibo_id = params[:facturaDestinoId].to_i
        consumo.save
      end
    end
    
    @errors = []
    render :template=>"admin/resposta_xhr.xml", :layout=>false
  end
  
  
  def create_or_update_recibo
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    if(params[:reciboId] != nil && params[:reciboId] != '')
      @recibo = Recibo.find_by_id(params[:reciboId])
    else
      @recibo = Recibo.new
    end
      
    @recibo.nome = params[:reciboNome]
    @recibo.data = params[:reciboData]
    @recibo.nif = params[:reciboNif]
    @recibo.evento_id = @event.id
    #if(@recibo.user == nil)
    #  @recibo.user_id = @current_user.id
    #end
    if(@recibo.referencia_mb == nil or @recibo.referencia_mb == '')
      @recibo.calcula_id_multibanco
    end
    @recibo.save
    
    @errors = []
    render :template=>"admin/resposta_xhr.xml", :layout=>false
  end
  
  
  def consumos_inscricao
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    @inscricao = Inscricao.find_by_id(params[:id])
    @consumos = []
    if(@inscricao.consumos.count > 0)
      @consumos = @inscricao.consumos
    end
  end
  
  
  def descontos_inscricao
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    @inscricao = Inscricao.find_by_id(params[:id])
    @descontos = @inscricao.desconto_inscricaos
  end
  
  
  def recibos_inscricao
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    @inscricao = Inscricao.find_by_id(params[:id])
    @recibos = []
    
    @inscricao.consumos.each do |consumo|
      if(!@recibos.include?(consumo.recibo))
        @recibos << consumo.recibo
      end
    end
  end
  
  
  def pagamentos_recibo
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    
    @recibo = Recibo.find_by_id(params[:id])
    @pagamentos = @recibo.pagamentos
  end
  
  
  
  def fixa_preco_manual
    inscricao_id = params[:inscricao]
    if(params[:id] != nil)
      inscricao_id = params[:id]
    end
    novo_preco = params[:preco].to_d
    
    inscricao = Inscricao.find_by_id(inscricao_id)
    inscricao.preco_manual = novo_preco
    inscricao.save
    
    if(request.xhr?)
      @errors = []
      render :template=>"admin/resposta_xhr.xml.erb"
    end
  end
  
  
  
  def elimina_preco_manual
    inscricao_id = params[:inscricao]
    if(params[:id] != nil)
      inscricao_id = params[:id]
    end
    inscricao = Inscricao.find_by_id(inscricao_id)
    
    inscricao.preco_manual = nil
    inscricao.save
    
    if(request.xhr?)
      render :text=>"OK"
    end
  end
  
  def acerta_voluntarios
    @entidade = Entidade.find_by_sigla(params[:entidade])
    @event = Evento.find_by_codigo(params[:event])
    
    inscricoes = Inscricao.find_all_by_evento_id(@event.id)
    inscricoes.each do |inscricao|
      localidade = inscricao.valor_campo_string(230)
      if(localidade == "Voluntário" || localidade == "Orador" || localidade.upcase == "Crianças" || localidade.upcase == "Conselheiro" || localidade.upcase == "Acompanhante")
        has_desconto = false
        inscricao.desconto_inscricaos.each do |desconto_insc|
          if(desconto_insc.desconto_id == 23)
            has_desconto = true
          end
        end
        if(!has_desconto)
          desconto = DescontoInscricao.new
          desconto.inscricao_id = inscricao.id
          desconto.desconto_id = 23
          desconto.save
        end
      end
    end
    
  end
  
  def acerta_passagem_ano
    @entidade = Entidade.find_by_sigla(params[:entidade])
    @event = Evento.find_by_codigo(params[:event])
    
    inscricoes = Inscricao.find_all_by_evento_id(@event.id)
    inscricoes.each do |inscricao|
      has_jantar = false
      consumo_jantar = nil
      has_presenca = false
      consumo_presenca = nil
      inscricao.consumos.each do |consumo|
        if(consumo.produto_id == 79)
          has_presenca = true
          consumo_presenca = consumo
        end
        if(consumo.produto_id == 72)
          has_jantar = true
          consumo_jantar = consumo
        end
      end
      if(has_presenca)
        consumo = Consumo.new
        consumo.produto_id = 125
        consumo.preco = Produto.find_by_id(125).get_preco(inscricao)
        consumo.inscricao_id = inscricao.id
        consumo.recibo_id = consumo_presenca.recibo_id
        consumo.save
        
        #Consumo.destroy(consumo_presenca.id)
        if(has_jantar)
          #Consumo.destroy(consumo_jantar.id)
        end
      end
    end
    
  end
   
  def processa_recibo_reminder
    @entidade = Entidade.find_by_sigla(params[:entidade])
    eventos = Evento.find_all_by_entidade_id(@entidade.id)
    
    send_emails = false
    if(params[:send_emails] == nil || params[:send_emails] == 'true')
      send_emails = true
    end
    
    eventos.each do |evento|
      if(evento.activo)
        recibos = Recibo.find_all_by_evento_id(evento.id)  
        recibos.each do |recibo|
          if(recibo.inscricao != nil)
            
            data_limite_pagamento_taxa = nil
            if(evento.dias_para_pagamento_taxa != nil && evento.dias_para_pagamento_taxa > 0)
              data_limite_pagamento_taxa = recibo.data+evento.dias_para_pagamento_taxa.days  
            end
            if(evento.data_limite_pagamento_taxa != nil)
              data_limite_pagamento_taxa = evento.data_limite_pagamento_taxa
            end
            
            data_limite_pagamento_total = nil
            if(evento.dias_para_pagamento_total != nil && evento.dias_para_pagamento_total > 0)
              data_limite_pagamento_total = recibo.data+evento.dias_para_pagamento_total.days
            end
            if(evento.data_limite_pagamento_total != nil)
              data_limite_pagamento_total = evento.data_limite_pagamento_total
            end
            
            if(data_limite_pagamento_taxa != nil)
              dias_que_faltam_para_taxa = ((data_limite_pagamento_taxa.to_date-Date.today.to_date)).round
            end
            if(data_limite_pagamento_total != nil)
              dias_que_faltam_para_total = ((data_limite_pagamento_total.to_date-Date.today.to_date)).round
            end
            
            recibo.dias_que_faltam_para_taxa = dias_que_faltam_para_taxa
            recibo.dias_que_faltam_para_total = dias_que_faltam_para_total
            recibo.save
        
            if(send_emails)
              if(recibo.inscricao.user.profile != 'ADMIN' || (recibo.data_ultimo_aviso == nil || recibo.data_ultimo_aviso <= 1.day.ago))
                if(data_limite_pagamento_taxa != nil && (dias_que_faltam_para_taxa <= 2 && dias_que_faltam_para_taxa >= -1) && (dias_que_faltam_para_total == nil || dias_que_faltam_para_total > 2) && recibo.taxa_inscricao > 0 && recibo.taxa_inscricao > recibo.total_pago)
                  @data_vencimento = data_limite_pagamento_taxa
                  if(dias_que_faltam_para_taxa > 1)
                    @expressao_temporal = 'dentro de '+dias_que_faltam_para_taxa.to_s+' dias'
                  end
                  if(dias_que_faltam_para_taxa == 1)
                    @expressao_temporal = 'amanhã'
                  end
                  if(dias_que_faltam_para_taxa == 0)
                    @expressao_temporal = 'hoje'
                  end
                  if(dias_que_faltam_para_taxa == -1)
                    @expressao_temporal = 'venceu ontem'
                  end
                  if(dias_que_faltam_para_taxa < -1)
                    @expressao_temporal = 'venceu há '+(0-dias_que_faltam_para_taxa).to_s+' dias'
                  end
                  
                  
                  @recibo = recibo
                  #@linhas_recibo = @recibo.linhas_recibo
                  #pdf = make_pdf :template => "recibos/detalhe.html.erb", :stylesheets => ["default","niceforms-default","print"], :layout => "recibos.html.erb"
                  begin
                    UserMailer.deliver_recibo_reminder(@recibo, @recibo.inscricao.user.email, @data_vencimento, @expressao_temporal, @recibo.to_pdf)
                  rescue
                    puts 'Erro a enviar o email para o recibo '+recibo.id
                    next
                  else 
                    recibo.data_ultimo_aviso = DateTime.now
                    recibo.save
                  end
                end
                
                if(data_limite_pagamento_total != nil && dias_que_faltam_para_total <= 2 && dias_que_faltam_para_total >= -1 && recibo.total_recibo-recibo.valor_desconto_antecipado > recibo.total_pago)
                  @data_vencimento = data_limite_pagamento_total
                  if(dias_que_faltam_para_total > 1)
                    @expressao_temporal = 'dentro de '+dias_que_faltam_para_total.to_s+' dias'
                  end
                  if(dias_que_faltam_para_total == 1)
                    @expressao_temporal = 'amanhã'
                  end
                  if(dias_que_faltam_para_total == 0)
                    @expressao_temporal = 'hoje'
                  end
                  if(dias_que_faltam_para_total == -1)
                    @expressao_temporal = 'venceu ontem'
                  end
                  if(dias_que_faltam_para_total < -1)
                    @expressao_temporal = 'venceu há '+(0-dias_que_faltam_para_total).to_s+' dias'
                  end
                  
                  @recibo = recibo
                  #@linhas_recibo = @recibo.linhas_recibo
                  #pdf = make_pdf :template => "recibos/detalhe.html.erb", :stylesheets => ["default","niceforms-default","print"], :layout => "recibos.html.erb"
                  begin
                    UserMailer.deliver_recibo_reminder(@recibo, @recibo.inscricao.user.email, @data_vencimento, @expressao_temporal, @recibo.to_pdf)
                  rescue
                    puts 'Erro a enviar o email para o recibo '+recibo.id
                    next
                  else 
                    recibo.data_ultimo_aviso = DateTime.now
                    recibo.save
                  end
                end
              end
            end
          end
        end
      end
    end
    redirect_to :action=>"lista_inscricoes"
  end
  
  
  def lista_igrejas
    @igrejas = Igreja.find(:all)
  end
  
  
  def envia_email_generico
    @event = Evento.find_by_codigo(params[:event])
    if(params[:texto] != nil && params[:texto] != '' && params[:assunto] != nil && params[:assunto] != '')
      soParaEsteEvento = params[:soEvento]
      if(soParaEsteEvento)
        envia_email_generico_inscricoes(params[:event], params[:assunto], params[:texto], params[:email])
      else
        envia_email_generico_users(params[:event], params[:assunto], params[:texto], params[:email])
      end
    end
  end
  
  
  def envia_email_generico_users(codigo_event, assunto, texto, email)
    @emails = []
    @event = Evento.find_by_codigo(codigo_event)
    if(params[:texto] != nil || params[:assunto] != nil)
      if(email != nil && email != '')
        UserMailer.deliver_generic_email(texto, assunto, email)
        @emails << email
      else
        users = User.find(:all)
        users.each do |user|
          UserMailer.deliver_generic_email(texto, assunto, user.email)
          @emails << user.email
        end
      end
      render :template=>"admin/email_enviado"
      return
    end
    render :template=>"admin/envia_email_generico"
  end
  
  
   def envia_email_generico_inscricoes(codigo_event, assunto, texto, email)
    @emails = []
    @event = Evento.find_by_codigo(codigo_event)
    if(texto != nil || assunto != nil)
      if(email != nil && email != '')
        begin
          UserMailer.deliver_generic_email(texto, assunto, email)
        rescue Exception => ex
          @emails << email+" --> "+ex.message
        end
        @emails << email
      else
        inscricoes = Inscricao.find_all_by_evento_id(@event.id)
        inscricoes.each do |inscricao|
          begin
            UserMailer.deliver_generic_email_inscricao(texto, assunto, inscricao, inscricao.email)
          rescue Exception => ex
            @emails << inscricao.email+" [" +inscricao.nome+ "] "+" --> "+ex.message
            next
          end
          @emails << inscricao.email+" [" +inscricao.nome+ "] "
          if(inscricao.email != inscricao.user.email)
            begin
              UserMailer.deliver_generic_email_inscricao(texto, assunto, inscricao, inscricao.user.email)
            rescue Exception => ex
              @emails << inscricao.user.email+" [" +inscricao.nome+ "] "+" --> "+ex.message
              next
            end
            @emails << inscricao.user.email+" [" +inscricao.nome+ "] "
          end
        end
      end
        
      render :template=>"admin/email_enviado"
      return
    end
    render :template=>"admin/envia_email_generico"
  end
  
  
  def envia_email_maquina_sonhos
    @event = Evento.find_by_id(30)
    @event.recibos.each do |recibo|
      if(recibo != nil && recibo.inscricao != nil && recibo.inscricao.user != nil && (recibo.inscricao.user.profile == nil || recibo.inscricao.user.profile != "ADMIN"))
        if((recibo.total_recibo - recibo.valor_desconto_antecipado - recibo.total_pago) > 0)
          @assunto = " Factura "+recibo.id.to_s+" a pagamento"
          @texto=""      
          #@recibo.inscricao.user.email
          UserMailer.deliver_maquina_sonhos_email(@texto, @assunto, recibo, recibo.inscricao.user.email, recibo.to_pdf)
        end
      end
    end
    
  end
  
  
  require 'net/ftp'
  require 'net/http'
  require 'csv'
  require 'fastercsv'
  require 'open-uri'
  require 'zip/zipfilesystem'
  
  def load_geo_ip_data
    url = URI.parse('http://geolite.maxmind.com/download/geoip/database/GeoIPCountryCSV.zip')
    Net::HTTP.start("geolite.maxmind.com") do |http|
      resp = http.get("/download/geoip/database/GeoIPCountryCSV.zip")
      open("public/GeoIPCountryCSV.zip", "wb") do |file|
        file.write(resp.body)
        file.close
      end
    end
    
    Zip::ZipFile.open("public/GeoIPCountryCSV.zip")  do |zip_file|
      
      file = zip_file.read("GeoIPCountryWhois.csv")
      file.each_line do |line|
        FasterCSV.parse(line) do |row|
          # row[0] = start_ip
          # row[1] = end_ip
          # row[2] = start_nbr
          # row[3] = end_nbr
          # row[4] = country_code
          # row[5] = country_name
          
          ipRange = IpRange.new
          ipRange.start_ip = row[0]
          ipRange.end_ip = row[1]
          ipRange.start_nbr = row[2]
          ipRange.end_nbr = row[3]
          ipRange.country_code = row[4]
          ipRange.country_name = row[5]
          
          ipRange.save
          
        end
      end
      
    end
    
    
  end
  
  
  
  def load_pagamentos_mb
    puts 'A Carregar Pagamentos MB'
    @pagamentos = []
    
    logins = [[10559853, 41558], [10559771, 48531], [11202159, 564215]]
    
    logins.each do |login|
      ftp = Net::FTP.new('ftp.ifthensoftware.com')
      #puts "LOGIN: "+login[0].to_s+", "+login[1].to_s
      ftp.login(user = login[0].to_s, passwd = login[1].to_s)
      @files = ftp.nlst('*.xml')
      @files.each do |file|
        filedate = File.basename(file).split('$')[0].to_datetime
        puts File.basename(file)
        if(filedate >= 30.days.ago)
          puts "  "+filedate.to_s+"  OK"
          ftp.gettextfile file, "public/MB-FILE-"+File.basename(file)
          xml = File.read("public/MB-FILE-"+File.basename(file)) 
          doc, pagamentos = REXML::Document.new(xml), []
          doc.elements.each('ficheiropagamentosMB/pagamentoMB') do |p|
            pag = {}
            %w[DATA_HORA TERMINAL REFERENCIA VALOR TARIFA VALORLIQUIDO].each do |a|
              pag[a.intern] = p.elements[a].text
            end
            @pagamentos << pag
          end
        end
      end
      ftp.quit()  
      @pagamentos.each do |pagamentoAuto|
        #if(pagamentoAuto[:REFERENCIA][3..6].to_i >= 1000 && pagamentoAuto[:REFERENCIA][3..6].to_i <= 1250 )
          referencia_recibo = pagamentoAuto[:REFERENCIA][3..6].to_i
          subentidade = pagamentoAuto[:REFERENCIA][0..2].to_i
        #else
        #  inscricao_id = pagamentoAuto[:REFERENCIA][4..6].to_i
        #end 
        
        eventos_validos = Evento.find_all_by_prefixo_ref_mb(subentidade)
        recibos = Recibo.find_all_by_evento_id(eventos_validos, :conditions=>"referencia_mb = "+referencia_recibo.to_s, :order=>"data DESC")
        recibo = recibos[0]
        pagsMB = PagamentoMb.find_all_by_referencia(pagamentoAuto[:REFERENCIA], :order=>"data DESC")
        if(pagsMB.length == 0 || pagsMB[0].data <= 180.days.ago)
          novoPagamentoMB = PagamentoMb.new()
          novoPagamentoMB.referencia = pagamentoAuto[:REFERENCIA]
          novoPagamentoMB.valor = pagamentoAuto[:VALOR].to_d
          novoPagamentoMB.tarifa = pagamentoAuto[:TARIFA].to_d
          novoPagamentoMB.valorliquido = pagamentoAuto[:VALORLIQUIDO].to_d
          novoPagamentoMB.terminal = pagamentoAuto[:TERMINAL]
          novoPagamentoMB.data = pagamentoAuto[:DATA_HORA]
          
          if(recibo != nil)
            pags = Pagamento.find_all_by_observacoes("MB "+pagamentoAuto[:REFERENCIA], :order=>"data DESC")
            if(pags.length == 0 || pags[0].data <= 180.days.ago || pags[0].recibo_id != recibo.id)
              pagamento = Pagamento.new()
              pagamento.recibo_id = recibo.id
              pagamento.valor = pagamentoAuto[:VALOR]
              pagamento.data = Date.parse(pagamentoAuto[:DATA_HORA])
              pagamento.observacoes = "MB "+pagamentoAuto[:REFERENCIA]
              pagamento.tipo_pagamento_id = 1
              pagamento.save
              #pagamento.inscricao.atribui_numero();
              pagamento.recibo.fechado = true;
              pagamento.recibo.save
              envia_email_pagamento_recibo(pagamento.recibo_id, pagamento)
              
              novoPagamentoMB.pagamento_id = pagamento.id;
            else
              novoPagamentoMB.pagamento_id = pags[0].id;
            end
            novoPagamentoMB.save
          end
        else
          if(pagsMB.length > 0 && pagsMB[0].pagamento == nil)
            pags = Pagamento.find_all_by_observacoes("MB "+pagamentoAuto[:REFERENCIA], :order=>"data DESC")
            if(pags.length == 0  || pags[0].data <= 180.days.ago || pags[0].recibo_id != recibo.id)
              pagamento = Pagamento.new()
              pagamento.recibo_id = recibo.id
              pagamento.valor = pagamentoAuto[:VALOR]
              pagamento.data = Date.parse(pagamentoAuto[:DATA_HORA])
              pagamento.observacoes = "MB "+pagamentoAuto[:REFERENCIA]
              pagamento.tipo_pagamento_id = 1
              pagamento.save
              envia_email_pagamento_recibo(pagamento.recibo_id, pagamento)
              if(pagamento.recibo != nil)
                pagamento.recibo.fechado = true;
                pagamento.recibo.save
              #  pagamento.inscricao.atribui_numero();
                pagsMB[0].pagamento_id = pagamento.id;
              end
            else
              pagsMB[0].pagamento_id = pags[0].id;
            end
            pagsMB[0].save
          end
        end
      end
    end
    redirect_to :action=>"pagamentos_mb"
  end
  
  def pagamentos_mb
    @pagamentos = PagamentoMb.find(:all)
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
  end
  

  def report_data
    @event = Evento.find_by_codigo(params[:event])
    @inscricoes = @event.inscricaos
    @totalCount = @event.inscricaos.count
    
    render :template=>"/admin/lista_inscricoes"
  end
  
  def save_inscricoes
    inscricoes = Inscricao.find(:all)
    inscricoes.each do |inscricao|
      inscricao.save
    end
  end
  
  
  
  def evolucao_inscricoes
    mode = params[:mode]
    @event = Evento.find_by_codigo(params[:event])
    @entidade = @event.entidade
    inscricoes = Inscricao.find_all_by_evento_id(@event.id, :order=>"created_at ASC")
    
    data_inicio = inscricoes[0].created_at
    data_fim = inscricoes[inscricoes.length-1].created_at
    
    puts "DATA_INICIO: "+data_inicio.strftime("%Y-%m-%d") 
    puts "DATA_FIM: "+data_fim.strftime("%Y-%m-%d") 
    
    dias = {}
    @data = []
    
    if(mode=="normal")
      date = data_inicio
      while date <= data_fim  do
          inscritosStat = InscritosStat.new
          inscritosStat.dia = date.strftime("%Y-%m-%d") 
          inscritosStat.inscritos = Inscricao.count(:all, :conditions=>"evento_id = "+@event.id.to_s+" AND created_at >= '"+date.strftime("%Y-%m-%d") +"' AND created_at < '"+(date+1.day).strftime("%Y-%m-%d")+"'")
          inscritosStat.tipo = "Quantidade de Inscritos"
          @data << inscritosStat
          
          date = date+1.day
        end
    end
    if(mode=="backwards")
    end
    if(mode=="percentage")
    end
    
    #@data.sort! { |a,b| a.dia <=> b.dia }
    
    total = 0
    @data.each do |data|
      total = total+data.inscritos
      data.totalizador = total
    end
    
  end
  
  
  class InscritosStat
      def dia  
        @dia
      end  
      def dia=(dia)  
        @dia = dia
      end
      
      def inscritos
        @inscritos
      end  
      def inscritos=(inscritos)  
        @inscritos = inscritos
      end
      
      def totalizador
        @totalizador
      end  
      def totalizador=(totalizador)  
        @totalizador = totalizador
      end
      
      def tipo
        @tipo
      end  
      def tipo=(tipo)  
        @tipo = tipo
      end 
  end
    
  def report_facturas
    event = Evento.find_by_codigo(params[:event])
    
    output_format = "PDF"
    report_unit = "/Reports/inscrevete/FacturasFM32010"
    report_params = { :logotipoUrlString => "http://www.inscreve-te.com.pt/images/"+event.entidade.sigla+"/factura_logo.jpg",
                      :NomeEvento => event.nome,
                      :XML_URL =>  "http://www.inscreve-te.com.pt/"+event.entidade.sigla+"/"+event.codigo+"/admin/reporting_facturas.xml",
                      :REPORT_LOCALE =>  "pt_PT",
                      :XML_DATE_PATTERN => "dd-MM-yyyy"
                    } # this should be a Hash!

    client = JasperServer::Client.new("http://www.inscreve-te.com.pt:8888/jasperserver/services/repository",
                                      "pdcmarques", "pdm49731")
    request = JasperServer::ReportRequest.new(report_unit, output_format, report_params)
    pdf_data = client.request_report(request)

    filename = "facturas_"+event.codigo+".pdf"#params[:action]+" on "+Time.now.iso8601+"."+format.downcase
    send_data(pdf_data, :type => Mime::Type.lookup_by_extension(output_format.downcase), 
              :disposition => 'attachment', :filename => filename)
  end
  
  
  def report_recepcao
    event = Evento.find_by_codigo(params[:event])
    report_unit= "/Reports/inscrevete/Recepcao"
    output_format = "PDF"
    
    letra = params[:letra]
    
    report_params = { :NomeEvento => event.nome,
                      :Letra => letra,
                      :XML_URL =>  "http://www.inscreve-te.com.pt/"+event.entidade.sigla+"/"+event.codigo+"/admin/reporting_recepcao.xml?letra="+params[:letra],
                      :REPORT_LOCALE =>  "pt_PT",
                      :XML_DATE_PATTERN => "dd-MM-yyyy"
                    } # this should be a Hash!
    
    
    client = JasperServer::Client.new("http://www.inscreve-te.com.pt:8888/jasperserver/services/repository",
                                      "pdcmarques", "pdm49731")
    request = JasperServer::ReportRequest.new(report_unit, output_format, report_params)
    pdf_data = client.request_report(request)

    filename = "recepcao_"+event.codigo+"_"+letra+".pdf"#params[:action]+" on "+Time.now.iso8601+"."+format.downcase
    send_data(pdf_data, :type => Mime::Type.lookup_by_extension(output_format.downcase), 
              :disposition => 'attachment', :filename => filename)
  end
  
  
  def report_reservas
    event = Evento.find_by_codigo(params[:event])
    
    format = params[:format]
    is_a4 = false
    if(format != nil && format == 'a4')
      is_a4 = true
    end
    
    if(is_a4)
      report_unit = "/Reports/inscrevete/ReservasA4"
    else
      report_unit = "/Reports/inscrevete/reservas"
    end
    
    
    output_format = "PDF"
    report_params = { :NomeEvento => event.nome,
                      :XML_URL =>  "http://www.inscreve-te.com.pt/"+event.entidade.sigla+"/"+event.codigo+"/admin/reporting_inscricoes.xml?ids="+params[:ids],
                      :REPORT_LOCALE =>  "pt_PT",
                      :XML_DATE_PATTERN => "dd-MM-yyyy"
                    } # this should be a Hash!

    client = JasperServer::Client.new("http://www.inscreve-te.com.pt:8888/jasperserver/services/repository",
                                      "pdcmarques", "pdm49731")
    request = JasperServer::ReportRequest.new(report_unit, output_format, report_params)
    pdf_data = client.request_report(request)

    filename = "reservas_"+event.codigo+".pdf"#params[:action]+" on "+Time.now.iso8601+"."+format.downcase
    send_data(pdf_data, :type => Mime::Type.lookup_by_extension(output_format.downcase), 
              :disposition => 'attachment', :filename => filename)
  end
  
  
  
  
  
  def mailchimp_sync
    
    
    eventos = Evento.find(:all)
    eventos.each do |evento|
      api_key = evento.mailchimp_api_key
      if(api_key != nil)

        list_id = evento.mailchimp_list_id
        h = Hominid::Base.new({:api_key => api_key})
        
        grouping_name = "inscreve-te "+evento.data_inicio.year.to_s
        grouping_id  = 0
        groupings = h.groupings(list_id)
        puts "GROUPINGS: "+groupings.size.to_s
        groupings.each do |grouping|
          puts "     NOME DO GROUPING: "+ grouping["name"]
          if(grouping["name"] == grouping_name)
            puts "     ENCONTRADO: "+ grouping["id"].to_s
            grouping_id = grouping["id"].to_i
          end
        end
        
        nome_group = ActiveSupport::Inflector.transliterate(evento.nome_curto)+" ("+evento.data_inicio.year.to_s+")"
        
        if(grouping_id == nil || grouping_id == 0)
          begin
            grouping_id = h.create_grouping(list_id, grouping_name, "checkboxes", [""+nome_group])
          rescue => e
            puts "*******************************************"
            puts "ERRO A FAZER GROUPING: "+"inscreve-te "+evento.data_inicio.year.to_s
            puts e
            puts "*******************************************"
          end
        else
          begin
            this_event_interest_id = h.create_group(list_id, ""+nome_group, grouping_id.to_s)
          rescue => e
            puts "*******************************************"
            puts "ERRO A FAZER GROUP: "+nome_group +" ("+grouping_id.to_s+")"
            puts e
            puts "*******************************************"
          end
        end
          
        inscricaos = Inscricao.find_all_by_evento_id(evento.id, :order => "idade ASC")
        #inscricaos = []
        inscricaos.each do |inscricao|
          if(inscricao != nil && inscricao.email != nil)
            #nomes_campos = []
            #valores_campos = []
            hash_merge_vars = {}
            
            evento.grupo_camposs.each do |grupo_campo|
              grupo_campo.campos.each do |campo|
                if(campo.mailchimp_tag != nil && campo.mailchimp_tag != "")
                  valor_campo = inscricao.valor_campo_string(campo.id)
                  if(campo.tipo.downcase == "lov")
                    valor_campo = inscricao.resolve_lov(campo.id)
                  end
                  if(valor_campo != nil || valor_campo != "" )
                    hash_merge_vars[campo.mailchimp_tag] = valor_campo
                  end
                end
              end
            end
            
            hash_merge_vars[:INTERESTS] = ""+nome_group
          
            begin
              member_info = h.member_info(list_id, inscricao.email)
              if(member_info != nil)
                if(member_info["status"].to_s == "subscribed")
                  h.subscribe(list_id, inscricao.email, hash_merge_vars, {:send_welcome => false, :double_opt_in => false, :update_existing => true, :replace_interests => false})
                end
              else
                h.subscribe(list_id, inscricao.email, hash_merge_vars, {:send_welcome => false, :double_opt_in => false, :update_existing => true, :replace_interests => false})
              end
            rescue => e
              puts "*******************************************"
              puts "ERRO A FAZER SUBSCRIBE: "+inscricao.email
              puts e
              puts "*******************************************"
              next
            end
          end
        end
      end
    end
    
    entidades = Entidade.find(:all)
    entidades.each do |entidade|
      
      api_key = entidade.mailchimp_api_key
      list_id = entidade.mailchimp_users_list_id
      if(api_key != nil && api_key != "" && list_id != nil && list_id != "")
        
        h = Hominid::Base.new({:api_key => api_key})
        
        begin
          grouping_id = h.create_grouping(list_id, "Users", "checkboxes", ["USER"])
        rescue => e
          puts "*******************************************"
          puts "ERRO A FAZER GROUPING: Users"
          puts e
          puts "*******************************************"
        end
        
        users = User.find_all_by_entidade_id(entidade.id)
        
        users.each do |user|
          if(user != nil && user.email != nil)
            begin
              h.subscribe(list_id, user.email, {:INTERESTS => "USER"}, {:send_welcome => false, :double_opt_in => false, :update_existing => true, :replace_interests => false})
            rescue
              puts "*******************************************"
              puts "ERRO A FAZER SUBSCRIBE: "+user.email
              puts e
              puts "*******************************************"
              next
            end
          end
          
        end
      end
      
    end
  end

  
  
  protected
  
  def envia_email_pagamento(inscricao_id, pagamento)
    @inscricao = Inscricao.find_by_id(inscricao_id)
    if(@inscricao != nil)
      @event = @inscricao.evento
      @entidade = @event.entidade
    
      if(@inscricao.user != nil && (@inscricao.user.profile == nil || @inscricao.user.profile != "ADMIN"))
        pdf = make_pdf :template => "inscricoes/detalhe.html.erb", :stylesheets => [@entidade.sigla+"/default","niceforms-default","tabs","print"], :layout => "inscricoes.erb"
        
        UserMailer.deliver_pagamento_notification(pagamento, @inscricao, @inscricao.user.email, pdf)
        if(@inscricao.email != @inscricao.user.email)
          UserMailer.deliver_pagamento_notification(pagamento, @inscricao, @inscricao.user.email, pdf)
        end
      end
    end
  end
  
  
  def envia_email_pagamento_recibo(recibo_id, pagamento)
    @recibo = Recibo.find_by_id(recibo_id)
    if(@recibo != nil)
      #@event = @recibo.evento
      #@entidade = @event.entidade
      #@linhas_recibo = @recibo.linhas_recibo
    
      if(@recibo.inscricao != nil && @recibo.inscricao.user != nil && (@recibo.inscricao.user.profile == nil || @recibo.inscricao.user.profile != "ADMIN"))
        #pdf = make_pdf :template => "recibos/detalhe.html.erb", :stylesheets => [@entidade.sigla+"/default","niceforms-default","tabs","print"], :layout => "recibos.erb"
        UserMailer.deliver_pagamento_recibo_notification(pagamento, @recibo, @recibo.inscricao.user.email, @recibo.to_pdf)
      end
    end
  end
  
  
  def authorize_admin
    if !self.logged_in?
      if(request.xhr?)
        render :text => "NOT LOGGED IN", :layout => false
      else
        redirect_to :controller=>"sessions", :action=>"new"
      end
      return
    end
    if(self.current_user.profile != "ADMIN")
      if(request.xhr?)
        render :text => "NOT AUTHORIZED", :layout => false
      else
        flash[:erro_titulo] = "Não autorizado"
        flash[:erro_mensagem] = "Não tem privilégios para aceder ao painel de administração."
        redirect_to :controller=>"error"
      end
    end
    
  end
  
  
  
  
  def authorize_admin_evento_leitura
    if !self.logged_in?
      if(request.xhr?)
        render :text => "NOT LOGGED IN", :layout => false
      else
        redirect_to :controller=>"sessions", :action=>"new"
      end
      return
    end
    if(self.current_user.profile != "ADMIN")
      if(params[:event] != nil)
        event = Evento.find_by_codigo(params[:event])
      else
        event = Evento.find_by_id(params[:evento_id])
      end
      if(!((self.current_user.profile == "EVENTO_LEITURA" || self.current_user.profile == "EVENTO_ESCRITA" || self.current_user.profile == "EVENTO_FACTURACAO_LEITURA" || self.current_user.profile == "EVENTO_FACTURACAO_ESCRITA")  && event != nil && event.id == self.current_user.evento_id))
        if(request.xhr?)
          render :text => "NOT AUTHORIZED", :layout => false
        else
          flash[:erro_titulo] = "Não autorizado"
          flash[:erro_mensagem] = "Não tem privilégios para aceder ao painel de administração."
          redirect_to :controller=>"error"
        end
      end
    end
    
  end
  
  def authorize_admin_evento_escrita
    if !self.logged_in?
      if(request.xhr?)
        render :text => "NOT LOGGED IN", :layout => false
      else
        redirect_to :controller=>"sessions", :action=>"new"
      end
      return
    end
    if(self.current_user.profile != "ADMIN")
      if(params[:event] != nil)
        event = Evento.find_by_codigo(params[:event])
      else
        event = Evento.find_by_id(params[:evento_id])
      end
      if(!((self.current_user.profile == "EVENTO_ESCRITA" || self.current_user.profile == "EVENTO_FACTURACAO_LEITURA" || self.current_user.profile == "EVENTO_FACTURACAO_ESCRITA")  && event != nil && event.id == self.current_user.evento_id))
        if(request.xhr?)
          render :text => "NOT AUTHORIZED", :layout => false
        else
          flash[:erro_titulo] = "Não autorizado"
          flash[:erro_mensagem] = "Não tem privilégios para aceder ao painel de administração."
          redirect_to :controller=>"error"
        end
      end
    end
  end
  
  
  
  def authorize_admin_evento_facturacao_leitura
    if !self.logged_in?
      if(request.xhr?)
        render :text => "NOT LOGGED IN", :layout => false
      else
        redirect_to :controller=>"sessions", :action=>"new"
      end
      return
    end
    if(self.current_user.profile != "ADMIN")
      if(params[:event] != nil)
        event = Evento.find_by_codigo(params[:event])
      else
        event = Evento.find_by_id(params[:evento_id])
      end
      if(!((self.current_user.profile == "EVENTO_FACTURACAO_LEITURA" || self.current_user.profile == "EVENTO_FACTURACAO_ESCRITA")  && event != nil && event.id == self.current_user.evento_id))
        if(request.xhr?)
          render :text => "NOT AUTHORIZED", :layout => false
        else
          flash[:erro_titulo] = "Não autorizado"
          flash[:erro_mensagem] = "Não tem privilégios para aceder ao painel de administração."
          redirect_to :controller=>"error"
        end
      end
    end  
  end
  
  
  def authorize_admin_evento_facturacao_escrita
    if !self.logged_in?
      if(request.xhr?)
        render :text => "NOT LOGGED IN", :layout => false
      else
        redirect_to :controller=>"sessions", :action=>"new"
      end
      return
    end
    if(self.current_user.profile != "ADMIN")
      if(params[:event] != nil)
        event = Evento.find_by_codigo(params[:event])
      else
        event = Evento.find_by_id(params[:evento_id])
      end
      if(!((self.current_user.profile == "EVENTO_FACTURACAO_ESCRITA")  && event != nil && event.id == self.current_user.evento_id))
        if(request.xhr?)
          render :text => "NOT AUTHORIZED", :layout => false
        else
          flash[:erro_titulo] = "Não autorizado"
          flash[:erro_mensagem] = "Não tem privilégios para aceder ao painel de administração."
          redirect_to :controller=>"error"
        end
      end
    end
  end
  
  
  
end