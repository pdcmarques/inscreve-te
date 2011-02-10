class RefeicoesController < ApplicationController
  before_filter :authorize_admin
  
  
  def index
    @entidade = Entidade.find_by_sigla(params[:entidade])
    @event = Evento.find_by_codigo(params[:event])
    redirect_to :action=>"detalhe"
  end
  
  def processar
    @entidade = Entidade.find_by_sigla(params[:entidade])
    @event = Evento.find_by_codigo(params[:event])
    
    codigo = params[:codigo]
    id_insc = codigo[-4..-1]
    
    refeicoes = [[4,0],[5,6],[7,8],[9,0],[12,13],[14,15],[16,0],[17,18]]
    
    
    if(params[:num_ref] != nil)
      numRefeicao = params[:num_ref].to_i
    else
      numRefeicao = getNumRefeicao
    end
    
    estaRefeicao = nil
    insc = Inscricao.find_by_id(id_insc)
    if(insc != nil)
      insc.inscricao_reservas.each do |insc_reserva|
          refeicao = Refeicao.find_by_reserva_id(insc_reserva.reserva_id)
          if(refeicao != nil)
            if(refeicao.numero == numRefeicao)
              estaRefeicao = refeicao
            end
          end
      end
    end
    
    if(estaRefeicao != nil)
      n = RefeicaoServida.count(:conditions => "refeicao_id = "+estaRefeicao.id.to_s+" and inscricao_id = "+id_insc.to_s)
      if (n == 0)
        refeicaoServida = RefeicaoServida.new()
        refeicaoServida.inscricao_id = id_insc
        refeicaoServida.data = Time.now
        refeicaoServida.refeicao_id = estaRefeicao.id
        refeicaoServida.save
      end
    end
    
    redirect_to :action=>"detalhe", :id=>id_insc.to_i, :num_ref=>numRefeicao
  end
  
  def detalhe
    @entidade = Entidade.find_by_sigla(params[:entidade])
    @event = Evento.find_by_codigo(params[:event])
    
    @inscricao = Inscricao.find_by_id(params[:id])
    if(params[:num_ref] != nil)
      @refeicao_num = params[:num_ref].to_i
    else
      @refeicao_num = getNumRefeicao
    end
    
    @ementas = Refeicao.find_all_by_numero(@refeicao_num)
    
    @refeicoes_ui = []
    8.times do |i|
      #puts (i+1).to_s
      @refeicoes_ui[i+1] = []
      2.times do |j|
        #puts "  "+(j+1).to_s
        @refeicoes_ui[i+1][j+1] = "-"
      end
    end
    
    if(@inscricao != nil)
      @inscricao.inscricao_reservas.each do |insc_reserva|
          refeicao = Refeicao.find_by_reserva_id(insc_reserva.reserva_id)
          if(refeicao != nil)
            @refeicoes_ui[refeicao.numero][1] = refeicao.tipo_refeicao
            @refeicoes_ui[refeicao.numero][2] = refeicao.nome
          end
      end
    end
    
  end
  
  private

  def getNumRefeicao
    
    dia1 = Date.new(2009,10,9)
    dia2 = Date.new(2009,10,10)
    dia3 = Date.new(2009,10,11)
    
    @data = Time.now
    @data_day = Date.today
    
    @refeicao_num = 0
    if(@data_day == dia1)
      if(@data.hour < 11)
        @refeicao_num = 1
      else
        if @data.hour < 17
          @refeicao_num = 2
        else
          @refeicao_num = 3
        end
      end
    end
    if(@data_day == dia2)
      if(@data.hour < 11)
        @refeicao_num = 4
      else
        if @data.hour < 17
          @refeicao_num = 5
        else
          @refeicao_num = 6
        end
      end
    end
    if(@data_day == dia3)
      if(@data.hour < 11)
        @refeicao_num = 7
      else
        if @data.hour < 17
          @refeicao_num = 8
        end
      end
    end
    @refeicao_num
  end

  def authorize_admin
    if !self.logged_in?
      #flash[:notice] = "Identifique-se para aceder a esta funcionalidade"
      redirect_to :controller=>"sessions", :action=>"new"
      return
    end
    if(self.current_user.profile != "ADMIN")
      flash[:erro_titulo] = "N‹o autorizado"
      flash[:erro_mensagem] = "N‹o tem privilŽgios para aceder ao painel de administra‹o."
      redirect_to :controller=>"error"
    end    
  end

end
