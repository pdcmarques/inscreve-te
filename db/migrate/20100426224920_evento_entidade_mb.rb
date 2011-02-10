class EventoEntidadeMb < ActiveRecord::Migration
  def self.up
    add_column  :eventos,  :entidade_mb,  :integer
  end

  def self.down
    remove_column  :eventos,  :entidade_mb
  end
end
