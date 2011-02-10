class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Active a sua conta'
    @body[:url]  = "http://www.inscreve-te.com.pt/#{user.entidade.sigla}/activate/#{user.activation_code}"
    
    comunicacao = Comunicacao.new()
    comunicacao.user_id = user.id
    comunicacao.assunto = @subject
    comunicacao.data = Time.now
    comunicacao.tipo = "email"
    comunicacao.corpo = render_message("signup_notification", :user => user, :email => user.email, :url => "http://www.inscreve-te.com.pt/#{user.entidade.sigla}/activate/#{user.activation_code}")
    comunicacao.save
  end
  
  def access_reminder(user)
    setup_email(user)
    @subject    += 'Dados da sua conta'
    @body[:url]  = "http://www.inscreve-te.com.pt/#{user.entidade.sigla}/activate/#{user.activation_code}"
    
    comunicacao = Comunicacao.new()
    comunicacao.user_id = user.id
    comunicacao.assunto = @subject
    comunicacao.data = Time.now
    comunicacao.tipo = "email"
    comunicacao.corpo = render_message("access_reminder", :user => user, :email => user.email, :url => "http://www.inscreve-te.com.pt/#{user.entidade.sigla}/activate/#{user.activation_code}")
    comunicacao.save
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'A sua conta foi activada.'
    @body[:url]  = "http://www.inscreve-te.com.pt/#{user.entidade.sigla}"
    @content_type = "text/html"
    
    comunicacao = Comunicacao.new()
    comunicacao.user_id = user.id
    comunicacao.assunto = @subject
    comunicacao.data = Time.now
    comunicacao.tipo = "email"
    comunicacao.corpo = render_message("activation", :user => user, :email => user.email, :url => "http://www.inscreve-te.com.pt/#{user.entidade.sigla}")
    comunicacao.save
  end


  def inscricao_notification(inscricao, email, pdf)
    inscricao.reload
    @subject  = "["+inscricao.evento.entidade.sigla+" - Inscrições] Inscrição Registada"
    @recipients  = "#{email}"
    @from        = "#{inscricao.evento.entidade.nome} <#{inscricao.evento.entidade.contacts_email}>"
    @sent_on     = Time.now
   
    part :content_type => "text/html", :body => 
      render_message("inscricao_notification", :inscricao => inscricao, :evento => inscricao.evento, :email => email, :url => "http://www.inscreve-te.com.pt/#{inscricao.evento.entidade.sigla}/#{inscricao.evento.codigo}/inscricoes/detalhe/#{inscricao.id}") 
    
    attachment "application/pdf" do |a|
      a.body = pdf
      a.filename = "inscricao.pdf"
    end
    
    user = User.find_by_email(email)
    if(user != nil)
      comunicacao = Comunicacao.new()
      comunicacao.user_id = user.id
      comunicacao.assunto = @subject
      comunicacao.data = Time.now
      comunicacao.tipo = "email"
      comunicacao.corpo = render_message("inscricao_notification", :inscricao => inscricao, :evento => inscricao.evento, :email => email, :url => "http://www.inscreve-te.com.pt/#{inscricao.evento.entidade.sigla}/#{inscricao.evento.codigo}/inscricoes/detalhe/#{inscricao.id}")
      comunicacao.nome_anexo = "iscricao.pdf"
      comunicacao.anexo = pdf
      comunicacao.save
    end
  end
  
  
  def inscricao_notification_sem_precos(inscricao, email, pdf)
    inscricao.reload
    @subject  = "["+inscricao.evento.entidade.sigla+" - Inscrições] Inscrição Registada"
    @recipients  = "#{email}"
    @from        = "#{inscricao.evento.entidade.nome} <#{inscricao.evento.entidade.contacts_email}>"
    @sent_on     = Time.now
   
    part :content_type => "text/html", :body => 
      render_message("inscricao_notification_sem_precos", :inscricao => inscricao, :evento => inscricao.evento, :email => email, :url => "http://www.inscreve-te.com.pt/#{inscricao.evento.entidade.sigla}/#{inscricao.evento.codigo}/inscricoes/detalhe/#{inscricao.id}") 
    
    attachment "application/pdf" do |a|
      a.body = pdf
      a.filename = "inscricao.pdf"
    end
    
    user = User.find_by_email(email)
    if(user != nil)
      comunicacao = Comunicacao.new()
      comunicacao.user_id = user.id
      comunicacao.assunto = @subject
      comunicacao.data = Time.now
      comunicacao.tipo = "email"
      comunicacao.corpo = render_message("inscricao_notification_sem_precos", :inscricao => inscricao, :evento => inscricao.evento, :email => email, :url => "http://www.inscreve-te.com.pt/#{inscricao.evento.entidade.sigla}/#{inscricao.evento.codigo}/inscricoes/detalhe/#{inscricao.id}")
      comunicacao.nome_anexo = "iscricao.pdf"
      comunicacao.anexo = pdf
      comunicacao.save
    end
  end
  
  
  
  def precisa_recomendacao_notification(inscricao, email, pdf)
    inscricao.reload
    @subject  = "["+inscricao.evento.entidade.sigla+" - Inscrições] Pedido de Recomendação"
    @recipients  = "#{email}"
    @from        = "#{inscricao.evento.entidade.nome} <#{inscricao.evento.entidade.contacts_email}>"
    @sent_on     = Time.now
    
    
   part :content_type => "text/html", :body => 
      render_message("precisa_recomendacao_notification", :inscricao => inscricao, :evento => inscricao.evento, :email => email, :url => "http://www.inscreve-te.com.pt/#{inscricao.evento.entidade.sigla}/#{inscricao.evento.codigo}/inscricoes/recomendar/#{inscricao.id}") 
   
   attachment "application/pdf" do |a|
      a.body = pdf
      a.filename = "inscricao.pdf"
   end
   
   user = User.find_by_email(email)
    if(user != nil)
      comunicacao = Comunicacao.new()
      comunicacao.user_id = user.id
      comunicacao.assunto = @subject
      comunicacao.data = Time.now
      comunicacao.tipo = "email"
      comunicacao.corpo = render_message("precisa_recomendacao_notification", :inscricao => inscricao, :evento => inscricao.evento, :email => email, :url => "http://www.inscreve-te.com.pt/#{inscricao.evento.entidade.sigla}/#{inscricao.evento.codigo}/inscricoes/recomendar/#{inscricao.id}") 
      comunicacao.nome_anexo = "iscricao.pdf"
      comunicacao.anexo = pdf
      comunicacao.save
    end
  end
  
  
  def pagamento_notification(pagamento, inscricao, email, pdf)
    pagamento.reload
    inscricao.reload
    @subject  = "[AB - Inscrições] Pagamento Recebido"
    @recipients  = "#{email}"
    @from        = "#{inscricao.evento.entidade.nome} <#{inscricao.evento.entidade.contacts_email}>"
    @sent_on     = Time.now
    
    part :content_type => "text/html", :body => 
      render_message("pagamento_notification", :inscricao => inscricao, :pagamento => pagamento, :email => email, :url => "http://www.inscreve-te.com.pt/#{inscricao.evento.entidade.sigla}/#{inscricao.evento.codigo}/inscricoes/detalhe/#{inscricao.id}") 
    
    attachment "application/pdf" do |a|
      a.body = pdf
      a.filename = "inscricao.pdf"
    end
    
    user = User.find_by_email(email)
    if(user != nil)
      comunicacao = Comunicacao.new()
      comunicacao.user_id = user.id
      comunicacao.assunto = @subject
      comunicacao.data = Time.now
      comunicacao.tipo = "email"
      comunicacao.corpo = render_message("pagamento_notification", :inscricao => inscricao, :pagamento => pagamento, :email => email, :url => "http://www.inscreve-te.com.pt/#{inscricao.evento.entidade.sigla}/#{inscricao.evento.codigo}/inscricoes/detalhe/#{inscricao.id}") 
      comunicacao.nome_anexo = "inscricao.pdf"
      comunicacao.anexo = pdf
      comunicacao.save
    end
    
  end
  
  
  def pagamento_recibo_notification(pagamento, recibo, email, pdf)
    pagamento.reload
    recibo.reload
    @subject  = "["+recibo.evento.entidade.sigla+" - Inscrições] Pagamento Recebido"
    @recipients  = "#{email}"
    @from        = "#{recibo.evento.entidade.nome} <#{recibo.evento.entidade.contacts_email}>"
    @sent_on     = Time.now

    part :content_type => "text/html", :body => 
      render_message("pagamento_recibo_notification", :recibo => recibo, :pagamento => pagamento, :email => email, :url => "http://www.inscreve-te.com.pt/#{recibo.evento.entidade.sigla}/recibos/detalhe/#{recibo.id}") 
    
    attachment "application/pdf" do |a|
      a.body = pdf
      a.filename = "recibo.pdf"
    end
    
    user = User.find_by_email(email)
    if(user != nil)
      comunicacao = Comunicacao.new()
      comunicacao.user_id = user.id
      comunicacao.assunto = @subject
      comunicacao.data = Time.now
      comunicacao.tipo = "email"
      comunicacao.corpo = render_message("pagamento_recibo_notification", :recibo => recibo, :pagamento => pagamento, :email => email, :url => "http://www.inscreve-te.com.pt/#{recibo.evento.entidade.sigla}/recibos/detalhe/#{recibo.id}") 
      comunicacao.nome_anexo = "recibo.pdf"
      comunicacao.anexo = pdf
      comunicacao.save
    end
    
  end
  
  
  
  def novo_recibo_notification(recibo, email, pdf)
    recibo.reload
    @subject  = "["+recibo.evento.entidade.sigla+" - Inscrições] Aviso de Recebimento emitido em nome de "+recibo.nome
    @recipients  = "#{email}"
    @from        = "#{recibo.evento.entidade.nome} <#{recibo.evento.entidade.contacts_email}>"
    @sent_on     = Time.now

    part :content_type => "text/html", :body => 
      render_message("novo_recibo_notification", :recibo => recibo, :email => email, :url => "http://www.inscreve-te.com.pt/#{recibo.evento.entidade.sigla}/recibos/detalhe/#{recibo.id}") 
    
    attachment "application/pdf" do |a|
      a.body = pdf
      a.filename = "aviso-recebimento.pdf"
    end
    
    user = User.find_by_email(email)
    if(user != nil)
      comunicacao = Comunicacao.new()
      comunicacao.user_id = user.id
      comunicacao.assunto = @subject
      comunicacao.data = Time.now
      comunicacao.tipo = "email"
      comunicacao.corpo = render_message("novo_recibo_notification", :recibo => recibo, :email => email, :url => "http://www.inscreve-te.com.pt/#{recibo.evento.entidade.sigla}/recibos/detalhe/#{recibo.id}") 
      comunicacao.nome_anexo = "recibo.pdf"
      comunicacao.anexo = pdf
      comunicacao.save
    end
  end
  
  
  def recibo_alterado_notification(recibo, email, pdf)
    recibo.reload
    @subject  = "["+recibo.evento.entidade.sigla+" - Inscrições] Aviso de Recebimento Alterado "
    @recipients  = "#{email}"
    @from        = "#{recibo.evento.entidade.nome} <#{recibo.evento.entidade.contacts_email}>"
    @sent_on     = Time.now
    
    part :content_type => "text/html", :body => 
      render_message("recibo_alterado_notification", :recibo => recibo, :email => email, :url => "http://www.inscreve-te.com.pt/#{recibo.evento.entidade.sigla}/recibos/detalhe/#{recibo.id}") 
    
    attachment "application/pdf" do |a|
      a.body = pdf
      a.filename = "aviso-recebimento.pdf"
    end
    
    user = User.find_by_email(email)
    if(user != nil)
      comunicacao = Comunicacao.new()
      comunicacao.user_id = user.id
      comunicacao.assunto = @subject
      comunicacao.data = Time.now
      comunicacao.tipo = "email"
      comunicacao.corpo = render_message("recibo_alterado_notification", :recibo => recibo, :email => email, :url => "http://www.inscreve-te.com.pt/#{recibo.evento.entidade.sigla}/recibos/detalhe/#{recibo.id}") 
      comunicacao.nome_anexo = "recibo.pdf"
      comunicacao.anexo = pdf
      comunicacao.save
    end
    
  end
  
  def recibo_reminder(recibo, email, data_vencimento, expressao_temporal, pdf)
    recibo.reload
    @subject  = "["+recibo.evento.entidade.sigla+" - Inscrições] Aviso para pagamento de factura"
    @recipients  = "#{email}"
    @from        = "#{recibo.evento.entidade.nome} <#{recibo.evento.entidade.contacts_email}>"
    @sent_on     = Time.now
    
    @data_vencimento = data_vencimento
    @expressao_temporal = expressao_temporal
    
    part :content_type => "text/html", :body => 
      render_message("recibo_reminder", :recibo => recibo, :email => email, :data_vencimento => data_vencimento, :expressao_temporal => expressao_temporal, :url => "http://www.inscreve-te.com.pt/#{recibo.evento.entidade.sigla}/recibos/detalhe/#{recibo.id}") 
    
    attachment "application/pdf" do |a|
      a.body = pdf
      a.filename = "aviso-recebimento.pdf"
    end
    
    user = User.find_by_email(email)
    if(user != nil)
      comunicacao = Comunicacao.new()
      comunicacao.user_id = user.id
      comunicacao.assunto = @subject
      comunicacao.data = Time.now
      comunicacao.tipo = "email"
      comunicacao.corpo = render_message("recibo_reminder", :recibo => recibo, :email => email, :data_vencimento => data_vencimento, :expressao_temporal => expressao_temporal, :url => "http://www.inscreve-te.com.pt/#{recibo.evento.entidade.sigla}/recibos/detalhe/#{recibo.id}") 
      comunicacao.nome_anexo = "recibo.pdf"
      comunicacao.anexo = pdf
      comunicacao.save
    end
    
  end
  
  def generic_email(texto, assunto, email)
    @subject  = 'assunto'
    @recipients  = "#{email}"
    @from        = "INSCREVE-TE.COM.PT <geral@inscreve-te.com.pt>"
    @sent_on     = Time.now
    @body[:url]  = "http://www.inscreve-te.com.pt/"
    @body[:texto]= texto
    @body[:assunto] = assunto
    @body[:email] = email
    @content_type = "text/html"
    
    user = User.find_by_email(email)
    if(user != nil)
      comunicacao = Comunicacao.new()
      comunicacao.user_id = user.id
      comunicacao.assunto = @subject
      comunicacao.data = Time.now
      comunicacao.tipo = "email"
      comunicacao.corpo = render_message("generic_email", :texto => texto, :assunto=>assunto, :email => email, :url => "http://www.inscreve-te.com.pt") 
      comunicacao.save
    end
  end
  
  
  def maquina_sonhos_email(texto, assunto, recibo, email, pdf)
    @subject  = "["+recibo.evento.entidade.sigla+" - Inscrições] " + assunto
    @recipients  = "#{email}"
    @from        = "#{recibo.evento.entidade.nome} <#{recibo.evento.entidade.contacts_email}>"
    @sent_on     = Time.now
    @body[:url]  = "http://www.inscreve-te.com.pt/#{recibo.evento.entidade.sigla}"
    @body[:texto]= texto
    @body[:assunto] = assunto
    @body[:email] = email
    @body[:recibo] = recibo
    @content_type = "text/html"
    
    part :content_type => "text/html", :body => 
      render_message("maquina_sonhos_email",:recibo=>recibo, :texto => texto, :assunto=>assunto, :email => email, :url => "http://www.inscreve-te.com.pt/#{recibo.evento.entidade.sigla}")
    
    attachment "application/pdf" do |a|
      a.body = pdf
      a.filename = "factura_"+recibo.id.to_s+".pdf"
    end
    
    user = User.find_by_email(email)
    if(user != nil)
      comunicacao = Comunicacao.new()
      comunicacao.user_id = user.id
      comunicacao.assunto = @subject
      comunicacao.data = Time.now
      comunicacao.tipo = "email"
      comunicacao.corpo = render_message("maquina_sonhos_email",:recibo=>recibo, :texto => texto, :assunto=>assunto, :email => email, :url => "http://www.inscreve-te.com.pt/#{recibo.evento.entidade.sigla}")
      comunicacao.anexo = pdf
      comunicacao.save
    end
  end
  
  
  def generic_email_inscricao(texto, assunto, inscricao, email)
    @subject  = "["+inscricao.evento.entidade.sigla+" - Inscrições] + assunto"
    @recipients  = "#{email}"
    @from        = "#{inscricao.evento.entidade.nome} <#{inscricao.evento.entidade.contacts_email}>"
    @sent_on     = Time.now
    @body[:url]  = "http://www.inscreve-te.com.pt/#{inscricao.evento.entidade.sigla}"
    @body[:texto]= texto
    @body[:assunto] = assunto
    @body[:email] = email
    @body[:inscricao] = inscricao
    @content_type = "text/html"
    
    user = User.find_by_email(email)
    if(user != nil)
      comunicacao = Comunicacao.new()
      comunicacao.user_id = user.id
      comunicacao.assunto = @subject
      comunicacao.data = Time.now
      comunicacao.tipo = "email"
      comunicacao.corpo = render_message("generic_email_inscricao",:inscricao=>inscricao, :texto => texto, :assunto=>assunto, :email => email, :url => "http://www.inscreve-te.com.pt/#{inscricao.evento.entidade.sigla}") 
      comunicacao.save
    end
  end
  
  protected
    def setup_email(user)
      user.reload
      @subject  = '['+user.entidade.sigla+' - Inscrições] '
      @recipients  = "#{user.email}"
      @from        = user.entidade.nome+" <"+user.entidade.contacts_email+">"
      @sent_on     = Time.now
      @body[:user]  = user
      @content_type = "text/html"
    end
end
