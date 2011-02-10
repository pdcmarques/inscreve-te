# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110116111157) do

  create_table "campo_produtos", :force => true do |t|
    t.integer  "campo_id"
    t.integer  "produto_id"
    t.string   "comparison_operand"
    t.string   "comparison_operator"
    t.string   "ruby_literal_exp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campos", :force => true do |t|
    t.string   "nome"
    t.integer  "grupo_campos_id"
    t.string   "label"
    t.string   "tipo"
    t.integer  "tamanho"
    t.string   "nota",                         :limit => 2550
    t.boolean  "mostra_tabela"
    t.boolean  "mostra_inserir"
    t.boolean  "mostra_detalhe"
    t.boolean  "mostra_update"
    t.integer  "lista_valores_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "long_description"
    t.boolean  "is_assinatura_recomendacao"
    t.boolean  "required"
    t.integer  "min_value",                    :limit => 10,   :precision => 10, :scale => 0
    t.integer  "max_value",                    :limit => 10,   :precision => 10, :scale => 0
    t.string   "regexp"
    t.boolean  "is_nome"
    t.boolean  "is_email"
    t.boolean  "is_data_nascimento"
    t.boolean  "is_igreja"
    t.boolean  "is_grupo_inscricoes"
    t.boolean  "is_grupo_inscricoes_relation"
    t.boolean  "is_morada"
    t.boolean  "is_codigo_postal"
    t.boolean  "is_localidade"
    t.boolean  "is_telemovel"
    t.integer  "order"
    t.boolean  "is_estatuto"
    t.string   "maskRe"
    t.integer  "tamanho_min"
    t.string   "regex_text"
    t.string   "default_value"
    t.string   "setup_value"
    t.string   "mailchimp_tag"
    t.boolean  "is_codigo_desconto"
  end

  create_table "codigo_descontos", :force => true do |t|
    t.string   "codigo"
    t.integer  "stock"
    t.integer  "qtd_consumida"
    t.integer  "user_id"
    t.integer  "desconto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "entidade_id"
    t.integer  "evento_id"
  end

  create_table "comunicacaos", :force => true do |t|
    t.string   "assunto"
    t.text     "corpo"
    t.integer  "user_id"
    t.datetime "data"
    t.text     "anexo"
    t.string   "nome_anexo"
    t.string   "tipo"
    t.integer  "comunicacao_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consumos", :force => true do |t|
    t.integer  "produto_id"
    t.datetime "data"
    t.decimal  "preco",        :precision => 10, :scale => 2
    t.string   "observacoes"
    t.integer  "inscricao_id"
    t.integer  "recibo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "consumos", ["inscricao_id"], :name => "inscricao_id"

  create_table "desconto_estatutos", :force => true do |t|
    t.integer  "desconto_id"
    t.integer  "estatuto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "desconto_facturas", :force => true do |t|
    t.integer  "desconto_id"
    t.integer  "recibo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "desconto_inscricaos", :force => true do |t|
    t.integer  "desconto_id"
    t.integer  "inscricao_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "descontos", :force => true do |t|
    t.string   "descricao"
    t.integer  "percentagem",    :limit => 10, :precision => 10, :scale => 0
    t.integer  "absoluto",       :limit => 10, :precision => 10, :scale => 0
    t.integer  "produto_id"
    t.boolean  "todos_produtos"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "evento_id"
    t.integer  "entidade_id"
    t.integer  "idade_min"
    t.integer  "idade_max"
  end

  create_table "documentos", :force => true do |t|
    t.string   "nome_documento"
    t.string   "descricao_documento"
    t.boolean  "is_imagem"
    t.boolean  "is_excel"
    t.boolean  "is_word"
    t.boolean  "is_pdf"
    t.string   "url"
    t.boolean  "is_instrucoes_formulario"
    t.boolean  "is_precario"
    t.boolean  "is_event_banner"
    t.boolean  "is_event_poster"
    t.boolean  "is_event_icon"
    t.integer  "evento_id"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_informacoes_alojamento"
  end

  create_table "dormidas", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "empresafacides", :force => true do |t|
    t.string   "nome"
    t.string   "nif"
    t.string   "morada"
    t.string   "localidade"
    t.string   "telefone"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entidades", :force => true do |t|
    t.string   "nome"
    t.string   "nome_curto"
    t.string   "sigla"
    t.string   "contacto"
    t.string   "morada"
    t.string   "email"
    t.string   "telefone"
    t.string   "fax"
    t.string   "observacoes"
    t.string   "logotipo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "support_email"
    t.string   "contacts_email"
    t.string   "nif"
    t.string   "mailchimp_users_list_id"
    t.string   "mailchimp_api_key"
  end

  create_table "estado_reservas", :force => true do |t|
    t.string   "nome"
    t.string   "descricao"
    t.string   "icon"
    t.boolean  "final_state"
    t.boolean  "send_email_state"
    t.text     "email_message"
    t.boolean  "warning_state"
    t.integer  "reserva_inscricao_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "estatutos", :force => true do |t|
    t.string   "nome"
    t.boolean  "protected"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "eventos", :force => true do |t|
    t.string   "nome"
    t.string   "nome_curto"
    t.text     "descricao"
    t.integer  "entidade_id"
    t.string   "responsavel"
    t.string   "email_responsavel"
    t.string   "telefone_responsavel"
    t.string   "fax_responsavel"
    t.datetime "data_inicio"
    t.datetime "data_fim"
    t.boolean  "inscricoes_abertas"
    t.boolean  "activo"
    t.boolean  "publico"
    t.string   "codigo"
    t.string   "imagem"
    t.integer  "preco_base",                                :limit => 10, :precision => 10, :scale => 0
    t.boolean  "preco_fixo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "taxa_inscricao",                            :limit => 10, :precision => 10, :scale => 0
    t.integer  "multa",                                     :limit => 10, :precision => 10, :scale => 0
    t.integer  "n_dias_multa"
    t.float    "bonificacao"
    t.boolean  "precisa_recomendacao"
    t.integer  "limite_inscricoes_aviso"
    t.integer  "limite_inscricoes_maximo"
    t.boolean  "preco_consumos"
    t.integer  "dias_para_pagamento_taxa"
    t.integer  "dias_para_pagamento_total"
    t.boolean  "group_based"
    t.integer  "desconto_pagamento_antecipado"
    t.integer  "limite_pagamentos_para_desconto"
    t.integer  "limite_montante_para_desconto",             :limit => 10, :precision => 10, :scale => 0
    t.integer  "referencia_mb_min"
    t.integer  "referencia_mb_max"
    t.integer  "prefixo_ref_mb"
    t.boolean  "taxa_insc_is_percentagem"
    t.integer  "taxa_inscricao_min",                        :limit => 10, :precision => 10, :scale => 0
    t.integer  "taxa_inscricao_max",                        :limit => 10, :precision => 10, :scale => 0
    t.string   "urlPrefix"
    t.integer  "desconto_antecipacao"
    t.datetime "data_limite_desconto_antecipacao"
    t.datetime "data_limite_desconto_pagamento_antecipado"
    t.datetime "data_limite_pagamento_total"
    t.datetime "data_limite_pagamento_taxa"
    t.text     "pre_html"
    t.text     "pos_html"
    t.integer  "entidade_mb"
    t.text     "mensagem"
    t.decimal  "custo",                                                   :precision => 10, :scale => 2
    t.string   "mailchimp_api_key"
    t.string   "mailchimp_list_id"
    t.string   "default_locale"
    t.string   "moeda"
  end

  create_table "eventos_grupos_campos", :force => true do |t|
    t.integer  "evento_id"
    t.integer  "grupo_campos_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order"
  end

  create_table "grupo_campos", :force => true do |t|
    t.string   "nome"
    t.integer  "order"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grupo_inscricoes", :force => true do |t|
    t.integer  "inscricao_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "i18n_locales", :force => true do |t|
    t.string   "codigo_local"
    t.string   "nome"
    t.string   "pais"
    t.string   "iso_pais"
    t.string   "lingua"
    t.string   "iso_moeda"
    t.string   "simbolo_moeda"
    t.string   "nbr_format"
    t.string   "short_date_format"
    t.string   "long_date_format"
    t.string   "time_format"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "igrejamgs", :force => true do |t|
    t.string   "nome"
    t.string   "morada"
    t.string   "codigo_postal"
    t.string   "localidade"
    t.string   "telefone"
    t.string   "fax"
    t.string   "email"
    t.string   "nr_membros"
    t.string   "nr_simpatizantes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "igrejas", :force => true do |t|
    t.string   "nome"
    t.string   "localidade"
    t.string   "email"
    t.string   "telefone"
    t.string   "responsavel"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "morada"
    t.string   "codigo_postal"
    t.string   "full_name"
  end

  create_table "igrejasummits", :force => true do |t|
    t.string   "nome"
    t.string   "morada"
    t.string   "codigo_postal"
    t.string   "localidade"
    t.string   "telefone"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inscricao_reservas", :force => true do |t|
    t.integer  "inscricao_id"
    t.integer  "reserva_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "consumo_id"
  end

  create_table "inscricaos", :force => true do |t|
    t.string   "nome"
    t.datetime "data_nascimento"
    t.integer  "igreja_id"
    t.string   "email"
    t.string   "telefone"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "idade"
    t.integer  "estatuto_id"
    t.integer  "evento_id"
    t.integer  "numero"
    t.integer  "grupo_inscricoes_id"
    t.string   "grupo_responsible_relation"
    t.string   "morada"
    t.string   "codigo_postal"
    t.string   "localidade"
    t.string   "telemovel"
    t.decimal  "preco_manual",               :precision => 10, :scale => 2
  end

  create_table "inscricaos_campos", :force => true do |t|
    t.integer  "inscricao_id"
    t.integer  "campo_id"
    t.string   "string_value"
    t.integer  "int_value"
    t.integer  "decimal_value", :limit => 10, :precision => 10, :scale => 0
    t.datetime "date_value"
    t.integer  "lov_value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "text_value"
  end

  add_index "inscricaos_campos", ["inscricao_id"], :name => "inscricao_id"

  create_table "ip_ranges", :force => true do |t|
    t.string   "start_ip"
    t.string   "end_ip"
    t.integer  "start_nbr"
    t.integer  "end_nbr"
    t.string   "country_code"
    t.string   "country_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lista_valores", :force => true do |t|
    t.string   "nome"
    t.boolean  "activa"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "class_name"
    t.string   "value_field"
    t.string   "text_field"
    t.string   "condition"
    t.boolean  "editavel"
    t.string   "condition_runtime_vars"
  end

  create_table "pacote_ignore_produtos", :force => true do |t|
    t.integer "pacote_id"
    t.integer "produto_id"
  end

  create_table "pacote_produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "produto_id"
    t.integer  "pacote_id"
  end

  create_table "pacotes", :force => true do |t|
    t.string   "nome"
    t.string   "descricao"
    t.integer  "produto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "prioridade"
  end

  create_table "pagamento_mbs", :force => true do |t|
    t.string   "referencia"
    t.datetime "data"
    t.decimal  "valor",        :precision => 8, :scale => 2
    t.string   "terminal"
    t.decimal  "tarifa",       :precision => 8, :scale => 2
    t.decimal  "valorliquido", :precision => 8, :scale => 2
    t.integer  "pagamento_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pagamentos", :force => true do |t|
    t.datetime "data"
    t.decimal  "valor",             :precision => 8, :scale => 2
    t.integer  "recibo_id"
    t.string   "observacoes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inscricao_id"
    t.integer  "tipo_pagamento_id"
  end

  create_table "precos", :force => true do |t|
    t.integer  "produto_id"
    t.decimal  "preco",          :precision => 10, :scale => 2
    t.integer  "idade_min"
    t.integer  "idade_max"
    t.datetime "data_min"
    t.datetime "data_max"
    t.boolean  "data_inscricao"
    t.boolean  "data_pagamento"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "precos", ["produto_id"], :name => "produto_id"

  create_table "produtos", :force => true do |t|
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_taxa_inscricao"
    t.integer  "evento_id"
    t.integer  "entidade_id"
  end

  create_table "recibos", :force => true do |t|
    t.integer  "igreja_id"
    t.string   "nome"
    t.datetime "data"
    t.boolean  "pago"
    t.string   "meio_pagamento"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inscricao_id"
    t.integer  "evento_id"
    t.integer  "referencia_mb"
    t.boolean  "fechado"
    t.string   "nif"
    t.datetime "data_ultimo_aviso"
    t.integer  "dias_que_faltam_para_taxa"
    t.integer  "dias_que_faltam_para_total"
    t.string   "morada1"
    t.string   "morada2"
    t.string   "codigo_postal"
    t.string   "localidade"
  end

  create_table "recomendacaos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "inscricao_id"
    t.string   "assinatura"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "refeicao_servidas", :force => true do |t|
    t.integer  "inscricao_id"
    t.integer  "refeicao_id"
    t.datetime "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "refeicaos", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tipo_refeicao"
    t.integer  "numero"
    t.integer  "reserva_id"
  end

  create_table "reserva_estados", :force => true do |t|
    t.integer  "estado_reserva_id"
    t.datetime "data_inicio"
    t.datetime "data_fim"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inscricao_reserva_id"
  end

  create_table "reserva_produtos", :force => true do |t|
    t.integer  "reserva_id"
    t.integer  "produto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "campo_id"
    t.string   "comparison_operator"
    t.string   "comparison_operand"
  end

  create_table "reservas", :force => true do |t|
    t.string   "nome"
    t.string   "nome_curto"
    t.datetime "data_consumo"
    t.integer  "tipo_reserva_id"
    t.integer  "stock"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "cost",            :precision => 10, :scale => 2
    t.string   "ementa"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_pagamentos", :force => true do |t|
    t.string   "nome"
    t.string   "nome_curto"
    t.string   "codigo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icone"
  end

  create_table "tipo_reservas", :force => true do |t|
    t.string   "nome"
    t.string   "descricao"
    t.string   "icone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "translations", :force => true do |t|
    t.string   "string_code"
    t.string   "string_value"
    t.string   "codigo_locale"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                   :default => "passive"
    t.datetime "deleted_at"
    t.string   "profile"
    t.integer  "igreja_id"
    t.integer  "evento_id"
    t.integer  "entidade_id"
  end

  create_table "valors", :force => true do |t|
    t.string   "valor"
    t.string   "descricao"
    t.integer  "ordem"
    t.boolean  "only_master_admin"
    t.boolean  "only_event_admin"
    t.integer  "lista_valores_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activo"
  end

  add_index "valors", ["lista_valores_id"], :name => "lista_valores_id"

end
