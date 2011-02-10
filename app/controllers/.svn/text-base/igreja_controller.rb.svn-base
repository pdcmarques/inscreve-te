class IgrejaController < ApplicationController
  before_filter :authorize_detalhe, :only => [:index]
  
  def index
    if(params[:id] != nil)
      @igreja = Igreja.find_by_id(params[:id])
    else
      @igreja = self.current_user.igreja  
    end
    @entidade = Entidade.find_by_sigla(params[:entidade])
    @inscricoes = Inscricao.find_all_by_igreja_id(@igreja.id, :order=>"created_at DESC")
  end
  
  
  def igrejas
    if(params[:query] != nil)
      @igrejas = Igreja.find_by_sql("select * from igrejas where nome like '"+params[:query]+"%' order by nome ASC")
    else
      @igrejas = Igreja.find(:all, :order=>"nome ASC")
    end
    @entidade = Entidade.find_by_sigla(params[:entidade])
  end
  
  protected
  
  def authorize_detalhe
    if !self.logged_in?
      #flash[:notice] = "Identifique-se para aceder a esta funcionalidade"
      redirect_to :controller=>"sessions", :action=>"new"
      return
    end
    if(self.current_user.profile != "IGREJA" && self.current_user.profile != "PASTOR" && self.current_user.profile != "ADMIN")
      flash[:erro_titulo] = "Não autorizado"
      flash[:erro_mensagem] = "Não tem privilégios para ver o detalhe de igreja"
      redirect_to :controller=>"error"
    end
    if((self.current_user.profile == "IGREJA" || self.current_user.profile == "PASTOR") && params[:id] != nil && params[:id] != self.current_user.igreja_id)
      flash[:erro_titulo] = "Não autorizado"
      flash[:erro_mensagem] = "Não tem privilégios para ver o detalhe desta igreja"
      redirect_to :controller=>"error"
    end
  end
  
end
