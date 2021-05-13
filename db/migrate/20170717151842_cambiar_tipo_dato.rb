class CambiarTipoDato < ActiveRecord::Migration[5.0]
  def up
    change_table :people do |p|
      p.change :identification_document, :string
    end

    change_table :employees do |e|
      e.change :identification_document, :string
    end

    change_table :provider_providers do |pp|
      pp.change :identification_document, :string
    end
  end

  def down
    change_table :people do |p|
      p.change :identification_document, :integer
    end

    change_table :employees do |e|
      e.change :identification_document, :integer
    end

    change_table :provider_providers do |pp|
      pp.change :identification_document, :integer
    end
  end

end