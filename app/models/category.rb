class Category < ActiveRecord::Base

  attr_accessible :name, :title

  has_many :games

  def self.action;     Category.find_by_name('action');      end
  def self.puzzle;     Category.find_by_name('puzzle');      end
  def self.simulation; Category.find_by_name('simulation');  end
  def self.shooter;    Category.find_by_name('shooter');     end
  def self.strategy;   Category.find_by_name('strategy');    end
  def self.other;      Category.find_by_name('other');       end

  def self.default;    self.other                            end
end
