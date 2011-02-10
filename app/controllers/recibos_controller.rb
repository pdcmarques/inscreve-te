class RecibosController < ApplicationController
  before_filter :authorize, :only=> [:lista]
  before_filter :authorize_detalhe, :only=> [:detalhe, :regista_pagamento]
    
  def detalhe
    @recibo = Recibo.find_by_id(params[:id])
    @entidade = @recibo.evento.entidade
    @linhas_recibo = @recibo.linhas_recibo
     
    respond_to do |format|
      format.html
      format.pdf do
        id_factura = params[:id]
        filename = "factura_"+id_factura+".pdf"
        send_data(@recibo.to_pdf, :type => Mime::Type.lookup_by_extension("pdf"), :disposition => 'attachment', :filename => filename)
      end
    end
  end
  
  def detalhe_xml
    @recibo = Recibo.find_by_id(params[:id])
    @entidade = @recibo.evento.entidade
    @linhas_recibo = @recibo.linhas_recibo

    respond_to do |format|
      format.xml
    end
    
  end
  
  
  def report_factura
      id_factura = params[:id]
      factura = Recibo.find_by_id(id_factura)
      
      filename = "factura_"+id_factura+"."+output_format.downcase
      send_data(factura.to_pdf, :type => Mime::Type.lookup_by_extension(output_format.downcase), :disposition => 'attachment', :filename => filename)
  end  
  
  
  def lista
    @recibos = Recibo.find_all_by_inscricao_id(self.current_user.inscricaos)
    @entidade = Entidade.find_by_sigla(params[:entidade])
  end
  
  
  def regista_pagamento
    @recibo = Recibo.find_by_id(params[:id])
    @entidade = @recibo.evento.entidade
    
    total_pago_antes = @recibo.total_pago
    n_pagamentos_antes = @recibo.pagamentos.count
    
    @pagamento = Pagamento.new(params[:pagamento])
    @pagamento.recibo_id = params[:id]
    @pagamento.save
    
    if(total_pago_antes <= @recibo.evento.limite_montante_para_desconto) && (n_pagamentos_antes <= @recibo.evento.limite_pagamentos_para_desconto)
      desconto = Desconto.find_by_id(@recibo.evento.desconto_pagamento_antecipado)
      desconto_recibo = DescontoRecibo.new
      desconto_recibo.recibo_id = @recibo.id
      desconto_recibo.desconto_id = desconto.id
      desconto_recibo.save
    end
    
    @linhas_recibo = @recibo.linhas_recibo
    pdf = make_pdf :template => "recibos/detalhe.html.erb", :stylesheets => ["default","niceforms-default","tabs","print"], :layout => "recibos.html.erb"
    
    if(@recibo.inscricao != nil)
      UserMailer.deliver_pagamento_notification(@pagamento, @recibo, @recibo.inscricao.user.email, pdf)
    else
      users = User.find_all_by_igreja_id(@recibo.igreja)
      for user in users
	UserMailer.deliver_pagamento_notification(@pagamento, @recibo, user.email, pdf)
      end
    end
    redirect_to :action=>"detalhe", :id=>params[:id]
  end
  
  protected
  
  def authorize_detalhe
    if !self.logged_in?
      #flash[:notice] = "Identifique-se para aceder a esta funcionalidade"
      redirect_to :controller=>"sessions", :action=>"new"
    end
    recibo = Recibo.find_by_id(params[:id])
    if recibo != nil && self.current_user != nil && self.current_user != false && !(self.current_user.profile == "ADMIN" || ((self.current_user.profile == "EVENTO_FACTURACAO_LEITURA" || self.current_user.profile == "EVENTO_FACTURACAO_ESCRITA")  && self.current_user.evento_id == recibo.evento_id)) && !self.current_user.inscricaos.collect(&:id).include?(recibo.inscricao_id)
      if self.current_user.profile == "IGREJA" && recibo.igreja_id == self.current_user.igreja_id
	return
      end
      flash[:erro_titulo] = "Não autorizado"
      flash[:erro_mensagem] = "Não está autorizado a ver o detalhe deste recibo"
      flash[:erro_back_url] = "/recibos/lista"
      redirect_to :controller=>"error"
    end
  end
end
