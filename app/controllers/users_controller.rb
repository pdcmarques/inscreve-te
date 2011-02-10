class UsersController < ApplicationController
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  # before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]  
  # protect_from_forgery :only => [:create, :update, :destroy]
  
 
  # render new.rhtml
  def new
    @entidade = Entidade.find_by_sigla(params[:entidade])
  end

  def create
    cookies.delete :auth_token
    @entidade = Entidade.find_by_sigla(params[:entidade])
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.login = @user.email
    @user.entidade = @entidade
    @user.register! if @user.valid?
    
    
    #@errors = {}
    if @user.errors.empty?
      self.current_user = User.authenticate(@user.login, @user.password, @entidade)
      if logged_in?
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
    end
    
    if(request.xhr? || params[:callback] != nil)
      render :template=>"users/create.xml.erb", :layout=>false
      return
    else 
      if @user.errors.empty?
        #self.current_user = @user
        redirect_back_or_default('/'+@entidade.sigla)
        flash[:notice] = "Consulte o seu e-mail '"+@user.email+"' para confirmar o registo e finalizar o processo."
      else
        render :action => 'new'
      end
    end
    
  end

  def activate
    @entidade = Entidade.find_by_sigla(params[:entidade])
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = "Processo de registo completo. Pode fazer já a sua primeira inscrição"
    end
    
    @entidade = @current_user.entidade
    if(@entidade.eventos.count == 1)
      redirect_back_or_default('/'+@entidade.sigla+'/'+@entidade.eventos[0].codigo+'/inscricoes/nova')
    else
      redirect_back_or_default('/'+@entidade.sigla)
    end
  end

  def suspend
    @entidade = Entidade.find_by_sigla(params[:entidade])
    @user.suspend! 
    redirect_back_or_default('/'+@entidade.sigla)
  end

  def unsuspend
    @entidade = Entidade.find_by_sigla(params[:entidade])
    @user.unsuspend!
    redirect_back_or_default('/'+@entidade.sigla)
  end

  def destroy
    @entidade = Entidade.find_by_sigla(params[:entidade])
    @user.delete!
    redirect_back_or_default('/'+@entidade.sigla)
  end

  def purge
    @entidade = Entidade.find_by_sigla(params[:entidade])
    @user.destroy
    redirect_back_or_default('/'+@entidade.sigla)
  end
  
  def reset_password
    @entidade = Entidade.find_by_sigla(params[:entidade])
    @errors = []
    if(params[:user] != nil)
        user = User.find_by_login(params[:user], :conditions=>"entidade_id = "+@entidade.id.to_s)
      if(user == nil)
        user = User.find_by_email(params[:user], :conditions=>"entidade_id = "+@entidade.id.to_s)
      end
      if(user == nil)
        if(request.xhr? || params[:callback] != nil)
          @errors[0][0] = 'user'
          @errors[0][1] = "Password não enviada, porque o Email é desconhecido. Crie uma nova conta no sistema"
          render :template=>"users/reset_password.xml.erb", :layout=>false
        else
          flash[:notice] = '<b><font color="red">ATENÇÃO: Password não enviada, porque o Username ou Email são desconhecidos. Crie uma nova conta no sistema</font></b>'
          redirect_to :controller=>"sessions", :action=>"new", :entidade=>@entidade.sigla
        end
      else
        user.update_attribute :password, random_password
        UserMailer.deliver_access_reminder(user)
        if(request.xhr? || params[:callback] != nil)
          render :template=>"users/reset_password.xml.erb", :layout=>false
        else
          flash[:notice] = "Nova password enviada por e-mail para <b>'"+user.email+"'</b>. Consulte o seu e-mail e faça login com as informações enviadas"
          redirect_to :controller=>"sessions", :action=>"new", :entidade=>@entidade.sigla
        end
      end
    end
  end

protected
  def find_user
    @user = User.find(params[:id])
  end
  
  def random_password(size = 8)
    chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
    (1..size).collect{|a| chars[rand(chars.size)] }.join
  end

end
