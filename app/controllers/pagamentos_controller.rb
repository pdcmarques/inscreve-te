class PagamentosController < ApplicationController
  before_filter :authorize_admin_evento_leitura, :only=>[:tipos_pagamento]
  before_filter :authorize_admin_evento_facturacao_leitura, :only=>[:lista]
  before_filter :authorize_admin_evento_facturacao_escrita, :only=>[]
  
  
  def lista
    @event = Evento.find_by_codigo(params[:event])
    @entidade = Entidade.find_by_sigla(params[:entidade])
    
    @pagamentos = Pagamento.find(:all, :conditions => { :recibo_id => @event.recibos})
    
    respond_to do |format|
        format.xml
    end
  end
  
  def report_totais_por_semana
    event = Evento.find_by_codigo(params[:event])
    
    output_format = "PDF"
    report_unit = "/Reports/inscrevete/totais_por_semana"
    report_params = { :logotipoUrlString => "http://www.inscreve-te.com.pt/images/"+event.entidade.sigla+"/factura_logo.jpg",
                      :NomeEvento => event.nome,
                      :XML_URL =>  "http://www.inscreve-te.com.pt/"+event.entidade.sigla+"/"+event.codigo+"/pagamentos/totais_por_semana.xml",
                      :REPORT_LOCALE =>  "pt_PT",
                      :XML_DATE_PATTERN => "dd-MM-yyyy"
                    } # this should be a Hash!

    client = JasperServer::Client.new("http://www.inscreve-te.com.pt:8888/jasperserver/services/repository",
                                      "pdcmarques", "pdm49731")
    request = JasperServer::ReportRequest.new(report_unit, output_format, report_params)
    pdf_data = client.request_report(request)

    filename = "pagamentos_semanais_"+event.codigo+".pdf"#params[:action]+" on "+Time.now.iso8601+"."+format.downcase
    send_data(pdf_data, :type => Mime::Type.lookup_by_extension(output_format.downcase), 
              :disposition => 'attachment', :filename => filename)
  end
  
  
  def totais_por_semana
    @event = Evento.find_by_codigo(params[:event])
    @entidade = Entidade.find_by_sigla(params[:entidade])
    
    @pagamentos = Pagamento.find(:all, :conditions => { :recibo_id => @event.recibos }, :order => :data)
    
    if(@pagamentos.size > 0)
      start_date = @pagamentos[0].data - @pagamentos[0].data.wday.days
      end_date = @pagamentos[@pagamentos.size-1].data + (6-@pagamentos[@pagamentos.size-1].data.wday).days
      
      puts @pagamentos[0].data.to_s+ " - "+ @pagamentos[0].data.wday.to_s + " = "+ start_date.to_s
      puts @pagamentos[@pagamentos.size-1].data.to_s+ " + "+ (6-@pagamentos[@pagamentos.size-1].data.wday).to_s + " = "+ end_date.to_s
      
      nsemanas = ((end_date.to_f - start_date.to_f)/60/60/24/7).ceil
      
      @totais = []
      @totais_no_evento = Totais.new
      @totais_no_evento.total_pagamentos = 0
      @totais_no_evento.data_inicio = @event.data_inicio
      @totais_no_evento.data_fim = @event.data_fim
      @totais_no_evento.totais_por_tipo = []
      time = start_date
      i = 0
      nsemanas.times do |semana|
        i = i+1
        puts i.to_s + ": " + time.to_s + " até " + (time+6.days).to_s
        
        pagamentos_semana = Pagamento.find(:all, :conditions => { :recibo_id => @event.recibos, :data => time..(time+6.days) }, :order => :data)
        totais_semana = Totais.new
        totais_por_tipo = []
        totais_semana.total_pagamentos = 0
        totais_semana.totais_por_tipo = totais_por_tipo
        totais_semana.data_inicio = time
        totais_semana.data_fim = time+6.days
        @totais << totais_semana
        pagamentos_semana.each do |pagamento|
          totais_semana.total_pagamentos = totais_semana.total_pagamentos + pagamento.valor
          if(pagamento.tipo_pagamento_id != nil && pagamento.tipo_pagamento_id > 0)
            if(totais_por_tipo[pagamento.tipo_pagamento_id] == nil)
              totais_por_tipo[pagamento.tipo_pagamento_id] = TotalPorTipo.new
              totais_por_tipo[pagamento.tipo_pagamento_id].tipo_pagamento_id = pagamento.tipo_pagamento_id
              totais_por_tipo[pagamento.tipo_pagamento_id].total = pagamento.valor
            else
              totais_por_tipo[pagamento.tipo_pagamento_id].total = totais_por_tipo[pagamento.tipo_pagamento_id].total + pagamento.valor
            end
          end
          if(pagamento.data >= @event.data_inicio && pagamento.data <= @event.data_fim)
            @totais_no_evento.total_pagamentos = @totais_no_evento.total_pagamentos + pagamento.valor
            if(pagamento.tipo_pagamento_id != nil && pagamento.tipo_pagamento_id > 0)
              if(@totais_no_evento.totais_por_tipo[pagamento.tipo_pagamento_id] == nil)
                  @totais_no_evento.totais_por_tipo[pagamento.tipo_pagamento_id] = TotalPorTipo.new
                  @totais_no_evento.totais_por_tipo[pagamento.tipo_pagamento_id].tipo_pagamento_id = pagamento.tipo_pagamento_id
                  @totais_no_evento.totais_por_tipo[pagamento.tipo_pagamento_id].total = pagamento.valor
              else
                  @totais_no_evento.totais_por_tipo[pagamento.tipo_pagamento_id].total = @totais_no_evento.totais_por_tipo[pagamento.tipo_pagamento_id].total + pagamento.valor
              end
            end
          end
        end
        time = time+7.days
      end
    end
    respond_to do |format|
        format.xml
    end
  end
  
  
  def tipos_pagamento
    @event = Evento.find_by_codigo(params[:event])
    @entidade = Entidade.find_by_sigla(params[:entidade])
    
    @tipos_pagamento = TipoPagamento.find(:all)
    
    respond_to do |format|
        format.xml
    end
  end
  
  
  
  
  
  
  
  class Totais
      def data_inicio  
        @data_inicio
      end  
      def data_inicio=(data_inicio)  
        @data_inicio = data_inicio
      end
      
      def data_fim
        @data_fim
      end  
      def data_fim=(data_fim)  
        @data_fim = data_fim
      end
      
      def total_pagamentos
        @total_pagamentos
      end
      def total_pagamentos=(total_pagamentos)
        @total_pagamentos = total_pagamentos
      end
      
      def totais_por_tipo
        @totais_por_tipo
      end
      def totais_por_tipo=(totais_por_tipo)
        @totais_por_tipo = totais_por_tipo
      end
  end
  
  
  class TotalPorTipo
    def tipo_pagamento_id  
        @tipo_pagamento_id
    end  
    def tipo_pagamento_id=(tipo_pagamento_id)  
      @tipo_pagamento_id = tipo_pagamento_id
      tp = TipoPagamento.find_by_id(tipo_pagamento_id)
      if(tp != nil)
        @tipo_pagamento_nome = TipoPagamento.find_by_id(tipo_pagamento_id).nome
      end
    end
    def tipo_pagamento_nome
        @tipo_pagamento_nome
    end
    def total
      @total
    end
    def total=(total)  
      @total = total
    end
  end
  
  
  
  protected
  
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
