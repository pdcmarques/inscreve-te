class ErrorController < ApplicationController
  
  def index
    @current_user = self.current_user
    @entidade = Entidade.find_by_sigla(params[:entidade])
    @erro_titulo = flash[:erro_titulo]
    @erro_mensagem = flash[:erro_mensagem]
    @erro_back_url = flash[:erro_back_url]
  end
  
end
