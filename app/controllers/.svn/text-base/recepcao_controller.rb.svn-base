class RecepcaoController < ApplicationController
  before_filter :authorize_admin
  
  def index
    redirect_to :action=>"lista_inscricoes"
  end
  
  def lista_inscricoes
    @event = Evento.find_by_codigo(params[:event])
    @inscricoes = @event.inscricaos
    
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "repcepcao-"+@event.nome, 
               :template => "/recepcao/lista_inscricoes.html.erb", 
               :stylesheets => [@entidade.sigla+"/default","niceforms-default","tabs","print"],
               :layout => "recepcao.html.erb"
      end
    end
  end
  
  def detalhe
    if(params[:id] != nil)
      @inscricao = Inscricao.find_by_id(params[:id])
      @inscricao.presente = true
      @inscricao.save
    else
      codigo = params[:codigo]
      if(codigo != nil)
        id_insc = codigo[8,3]
        @inscricao = Inscricao.find_by_id(id_insc)
        @inscricao.presente = true
        @inscricao.save
      end
    end
    @inscricao
  end
  
  def liquidar_recibo
    recibo = Recibo.find_by_id(params[:recibo_id])
    total_a_receber = recibo.total_recibo - recibo.total_pago
    
    if total_a_receber > 0
      pagamento = Pagamento.new
      pagamento.valor = total_a_receber
      pagamento.observacoes = "Pagamento no acto de inscrição"
      pagamento.data = Time.now
      pagamento.recibo_id = recibo.id
      pagamento.save
    end
    if total_a_receber < 0
      pagamento = Pagamento.new
      pagamento.valor = total_a_receber
      pagamento.observacoes = "Devolução no acto de inscrição"
      pagamento.data = Time.now
      pagamento.recibo_id = recibo.id
      pagamento.save
    end
    
    redirect_to :action=>"detalhe", :id=>params[:id]
  end
  
  def alterar_refeicoes
    @inscricao = Inscricao.find_by_id(params[:id])
    refeicoes_antigas = []
    refeicoes_antigas[1] = @inscricao.refeicao1_id
    refeicoes_antigas[2] = @inscricao.refeicao2_id
    refeicoes_antigas[3] = @inscricao.refeicao3_id
    refeicoes_antigas[4] = @inscricao.refeicao4_id
    refeicoes_antigas[5] = @inscricao.refeicao5_id
    
    @inscricao.update_attributes(params[:inscricao])
    
    reciboPessoal = Recibo.find_or_create_by_inscricao_id(@inscricao.id)
    if(reciboPessoal.nome == nil)
      reciboPessoal.nome = @inscricao.nome
      reciboPessoal.save
    end
    reciboIgreja = Recibo.find_or_create_by_igreja_id(@inscricao.igreja.id)
    if(reciboIgreja.nome == nil)
      reciboIgreja.nome = @inscricao.igreja.full_name
      reciboIgreja.save
    end
    
    if(@inscricao.idade > 10)
      produtoRefeicao = Produto.find_by_id(1)
    else
      produtoRefeicao = Produto.find_by_id(6)
    end
    
    if(refeicoes_antigas[1] != 1 && @inscricao.refeicao1_id == 1)
      consumo = Consumo.find(:first, :conditions => "observacoes = 'Almoço de 2/Abril' AND inscricao_id = "+ @inscricao.id.to_s)
      consumo1_igreja = consumo.recibo.igreja != nil
      consumo1_pessoal = consumo.recibo.inscricao != nil
      if(consumo != nil)
        Consumo.destroy(consumo.id)
      end
    end
    if(refeicoes_antigas[2] != 1 && @inscricao.refeicao2_id == 1)
      consumo = Consumo.find(:first, :conditions => "observacoes = 'Jantar de 2/Abril' AND inscricao_id = "+ @inscricao.id.to_s)
      consumo2_igreja = consumo.recibo.igreja != nil
      consumo2_pessoal = consumo.recibo.inscricao != nil
      if(consumo != nil)
        Consumo.destroy(consumo.id)
      end
    end
    if(refeicoes_antigas[3] != 1 && @inscricao.refeicao3_id == 1)
      consumo = Consumo.find_all(:first, :conditions => "observacoes = 'Almoço de 3/Abril' AND inscricao_id = "+ @inscricao.id.to_s)
      consumo3_igreja = consumo.recibo.igreja != nil
      consumo3_pessoal = consumo.recibo.inscricao != nil
      if(consumo != nil)
        Consumo.destroy(consumo.id)
      end
    end
    if(refeicoes_antigas[4] != 1 && @inscricao.refeicao4_id == 1)
      consumo = Consumo.find(:first, :conditions => "observacoes = 'Jantar de 3/Abril' AND inscricao_id = "+ @inscricao.id.to_s)
      consumo4_igreja = consumo.recibo.igreja != nil
      consumo4_pessoal = consumo.recibo.inscricao != nil
      if(consumo != nil)
        Consumo.destroy(consumo.id)
      end
    end
    if(refeicoes_antigas[5] != 1 && @inscricao.refeicao5_id == 1)
      consumo = Consumo.find(:first, :conditions => "observacoes = 'Almoço de 4/Abril' AND inscricao_id = "+ @inscricao.id.to_s)
      consumo5_igreja = consumo.recibo.igreja != nil
      consumo5_pessoal = consumo.recibo.inscricao != nil
      if(consumo != nil)
        Consumo.destroy(consumo.id)
      end
    end
    
    
    if(refeicoes_antigas[1] == 1 && @inscricao.refeicao1_id != 1)
      refeicao1Consumo = Consumo.new()
      refeicao1Consumo.produto_id = produtoRefeicao.id
      refeicao1Consumo.preco = produtoRefeicao.preco      
      refeicao1Consumo.data = "20090402"
      refeicao1Consumo.observacoes = "Almoço de 2/Abril"
      refeicao1Consumo.save
      @inscricao.consumos << refeicao1Consumo
      if(consumo1_igreja)
        reciboIgreja.consumos << refeicao1Consumo
      else
        reciboPessoal.consumos << refeicao1Consumo
      end
      
    end
    if(refeicoes_antigas[2] == 1 && @inscricao.refeicao2_id != 1)
      refeicao2Consumo = Consumo.new()
      refeicao2Consumo.produto_id = produtoRefeicao.id
      refeicao2Consumo.preco = produtoRefeicao.preco
      refeicao2Consumo.data = "20090402"
      refeicao2Consumo.observacoes = "Jantar de 2/Abril"
      refeicao2Consumo.save
      @inscricao.consumos << refeicao2Consumo
      if(consumo2_igreja)
        reciboIgreja.consumos << refeicao2Consumo
      else
        reciboPessoal.consumos << refeicao2Consumo
      end
    end
    if(refeicoes_antigas[3] == 1 && @inscricao.refeicao3_id != 1)
      refeicao3Consumo = Consumo.new()
      refeicao3Consumo.produto_id = produtoRefeicao.id
      refeicao3Consumo.preco = produtoRefeicao.preco      
      refeicao3Consumo.data = "20090403"
      refeicao3Consumo.observacoes = "Almoço de 3/Abril"
      refeicao3Consumo.save
      @inscricao.consumos << refeicao3Consumo
      if(consumo3_igreja)
        reciboIgreja.consumos << refeicao3Consumo
      else
        reciboPessoal.consumos << refeicao3Consumo
      end
    end
    if(refeicoes_antigas[4] == 1 && @inscricao.refeicao4_id != 1)
      refeicao4Consumo = Consumo.new()
      refeicao4Consumo.produto_id = produtoRefeicao.id
      refeicao4Consumo.preco = produtoRefeicao.preco
      refeicao4Consumo.data = "20090403"
      refeicao4Consumo.observacoes = "Jantar de 3/Abril"
      refeicao4Consumo.save
      @inscricao.consumos << refeicao4Consumo
      if(consumo4_igreja)
        reciboIgreja.consumos << refeicao4Consumo
      else
        reciboPessoal.consumos << refeicao4Consumo
      end
    end
    if(refeicoes_antigas[5] == 1 && @inscricao.refeicao5_id != 1)
      refeicao5Consumo = Consumo.new()
      refeicao5Consumo.produto_id = produtoRefeicao.id
      refeicao5Consumo.preco = produtoRefeicao.preco
      refeicao5Consumo.data = "20090404"
      refeicao5Consumo.observacoes = "Almoço de 4/Abril"
      refeicao5Consumo.save
      @inscricao.consumos << refeicao5Consumo
      if(consumo5_igreja)
        reciboIgreja.consumos << refeicao5Consumo
      else
        reciboPessoal.consumos << refeicao5Consumo
      end
    end

  
    redirect_to :action=>"detalhe", :id=>@inscricao.id
  end
  
  def authorize_admin
    if !self.logged_in?
      #flash[:notice] = "Identifique-se para aceder a esta funcionalidade"
      redirect_to :controller=>"sessions", :action=>"new"
      return
    end
    if(self.current_user.profile != "ADMIN")
      flash[:erro_titulo] = "Não autorizado"
      flash[:erro_mensagem] = "Não tem privilégios para aceder ao painel de administração."
      redirect_to :controller=>"error"
    end    
  end
  
end
