class ListavaloresController < ApplicationController
  before_filter :authorize, :only=>[:my_group_seeders]
  
  def index
  end
  
  def add_valor
    @campo = Campo.find_by_id(params[:id])
    lista_valores = @campo.lista_valores
    @columns = eval(lista_valores.class_name+".columns")
  end
  
  def regista_valor
    @campo = Campo.find_by_id(params[:id])
    @lista_valores = @campo.lista_valores
    @columns = eval(@lista_valores.class_name+".columns")
    
    @objecto = eval(@lista_valores.class_name+".new")
    params[:campo].each do |campo|
      eval("@objecto."+campo[0]+" = '"+campo[1]+"'")
    end
    
    @objecto.save
    
    @values = []
    @values[@campo.id] = @objecto.id
    
    if(request.xhr? || params[:callback] != nil)
      render :template=>"listavalores/regista_valor.xml.erb"
    else
      if(@objecto.errors.count > 0)
        render :template=>"listavalores/regista_valor_error"
      end
    end
    
  end
  
  def valores
    @evento = Evento.find_by_codigo(params[:event])
    @campo = Campo.find_by_id(params[:id])
    @lista_valores = @campo.lista_valores
    
    if(@campo.is_grupo_inscricoes)
      @valores = []
      authorize()
      if(@current_user != nil)
        @columns = ['grupo_inscricoes_id','nome']
      else
        @valores = []
        return
      end
    end
    if(@lista_valores.class_name != nil)
      @columns = eval(@lista_valores.class_name+".columns")
      if(@lista_valores.condition != nil)
        condition = @lista_valores.condition
        if(@lista_valores.condition_runtime_vars != nil)
          runtime_vars = @lista_valores.condition_runtime_vars.gsub(", ",",").gsub(" ,",",").split(",")
          i = 1
          runtime_vars.each do |runtime_var|
            condition = condition.gsub("@"+i.to_s, eval(runtime_var).to_s)
            i = i + 1
          end
        end
        if(params[:query] != nil)
          @valores = eval(@lista_valores.class_name+".find_by_sql(\"select * from "+@lista_valores.class_name.downcase+"s where "+@lista_valores.text_field+" like '"+params[:query]+"%' AND "+condition+" order by "+@lista_valores.text_field+" ASC\")")
        else
          @valores = eval(@lista_valores.class_name+".find(:all, :conditions=>\""+condition+"\", :order=>\""+@lista_valores.text_field+" ASC\")")
        end
      else
        if(params[:query] != nil)
          @valores = eval(@lista_valores.class_name+".find_by_sql(\"select * from "+@lista_valores.class_name.downcase+"s where "+@lista_valores.text_field+" like '"+params[:query]+"%' order by "+@lista_valores.text_field+" ASC\")")
        else
          @valores = eval(@lista_valores.class_name+".find(:all, :order=>\""+@lista_valores.text_field+" ASC\")")
        end
      end
    else
      @columns = ['valor', 'descricao']
      if(params[:query] != nil)
        @valores = Valor.find_all_by_lista_valores_id(@lista_valores.id, :conditions=>"descricao like '"+params[:query]+"%' AND activo = 1", :order=>"ordem")
      else
        @valores = @campo.lista_valores.valors
      end
    end
    
    if(@valores == nil)
      @valores = []
    end
  end
  
  
  def my_group_seeders
    evento = Evento.find_by_codigo(params[:evento])
    Inscricoes.find(:all, conditions=>"user_id = #{@current_user.id} and grupo_responsible_relation = '-1' and evento_id = #{@current_user.id}")
  end
  
end


