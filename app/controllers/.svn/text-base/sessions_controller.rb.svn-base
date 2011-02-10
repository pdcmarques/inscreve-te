# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # render new.rhtml
  def new
    @entidade = Entidade.find_by_sigla(params[:entidade])
    if(params[:error] != nil)
      flash[:error] = params[:error]
      params[:error] = nil
    end
    if(flash[:notice] != nil)
      flash[:notice] = flash[:notice]
    end
  end

  def user_in_session
    @user = nil
    if(logged_in?)
      if(params[:entidade] != nil)
        @entidade = Entidade.find_by_sigla(params[:entidade])
        if(@current_user.entidade_id != @entidade.id)
          self.current_user.forget_me if logged_in?
          cookies.delete :auth_token
          reset_session
          @user = nil
        else
          @user = @current_user
          @recibos = []
          if(@user.inscricaos.count < 25)
            @recibos = Recibo.find_all_by_inscricao_id(@user.inscricaos)
          end
        end
      end
    end
    render  :template=>"sessions/user_in_session.xml.erb", :layout=>false
  end

  def create
    @entidade = Entidade.find_by_sigla(params[:entidade])
    self.current_user = User.authenticate(params[:login], params[:password],@entidade)
    @errors = {}
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      if(request.xhr? || params[:callback] != nil)
        render :template=>"/sessions/create.xml.erb", :layout=>false
      else
        @entidade = @current_user.entidade
        redirect_back_or_default('/'+@entidade.sigla+'/')
        flash[:notice] = "Sessão Iniciada com sucesso"
      end
    else
      if(request.xhr? || params[:callback] != nil)
        @errors["login"] = "<b>Falhou a autenticação.</b><br/><br/>Possíveis causas:<br/><br/><b>USERNAME OU PASSWORD ERRADAS:</b><br/>Rectifique, voltando a tentar<br/><br/><b>JÁ CONFIRMOU O SEU ENDEREÇO DE E-MAIL?</b><br/>Caso não o tenha feito, foi agora mesmo enviado um e-mail para si, com as instruções necessárias para o fazer."
        render :template=>"/sessions/create.xml.erb", :layout=>false
      else
        redirect_to :action => 'new', :error=>"<b>FALHOU A AUTENTICAÇÃO. POSSÍVEIS CAUSAS:</b><br/><br/><b>1. CONTA INEXISTENTE:</b><br/>Crie uma nova conta <a href='/"+@entidade.sigla+"/signup'>aqui</a><br/><br/><b>2. USERNAME OU PASSWORD ERRADAS:</b><br/>Rectifique, voltando a tentar<br/><br/><b>3. JÁ CONFIRMOU O SEU ENDEREÇO DE E-MAIL?</b><br/>Caso não o tenha feito, foi agora mesmo enviado um e-mail para si, com as instruções necessárias para o fazer."
      end
    end
  end

  def destroy
    @entidade = Entidade.find_by_sigla(params[:entidade])
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    if(request.xhr?  || params[:callback] != nil)
      if(params[:callback] != nil)
        render :text=> params[:callback].to_s + "('<message success=\"true\"><errors></errors></message>');", :layout => false
      else 
        render :text=>'<message success="true"><errors></errors></message>', :layout => false
      end
    else 
      flash[:notice] = "Desligou a sua sessão"
      redirect_back_or_default('/'+@entidade.sigla+'/')
    end
  end
end
