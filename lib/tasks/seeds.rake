# encoding: utf-8

namespace 'db:seeds' do


    def self.action;     Category.find_by_name('action');      end
  def self.puzzle;     Category.find_by_name('puzzle');      end
  def self.simulation; Category.find_by_name('simulation');  end
  def self.shooter;    Category.find_by_name('shooter');     end
  def self.strategy;   Category.find_by_name('strategy');    end
  def self.other;      Category.find_by_name('other');       end

  desc 'Создать дефолтные категории'
  task :categories => :environment do
    I18n.locale = :en
    Category.find_or_create_by_name(:name => 'action', :title => 'Action')
    Category.find_or_create_by_name(:name => 'puzzle', :title => 'Puzzle')
    Category.find_or_create_by_name(:name => 'simulation', :title => 'Simulation')
    Category.find_or_create_by_name(:name => 'shooter', :title => 'Shooter')
    Category.find_or_create_by_name(:name => 'strategy', :title => 'Strategy')
    Category.find_or_create_by_name(:name => 'other', :title => 'Other')
  end
end