class HomeController < ApplicationController
  
  
  def index
    @current_user = self.current_user
    
    if(params[:entidade] != nil && params[:entidade] != '')
      @entidade = Entidade.find_by_sigla(params[:entidade])
    end
    
    if(@entidade != nil)
      @eventos = Evento.find(:all, :conditions=>"activo = 1 and publico = 1 and entidade_id = "+@entidade.id.to_s, :order=>"data_inicio ASC")  
    else
      @inscricoes_count = Inscricao.count(:all)+200
      @entidades_count = Entidade.count(:all)
      @eventos_count = Evento.count(:all)+1
      render :template=>"home/index.html.erb", :layout=>false
      return
    end
    
  end
  
  
  protected
  def find_user
    @user = User.find(params[:id])
  end
end
