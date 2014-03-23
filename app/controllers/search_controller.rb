class SearchController < ApplicationController

  class SearchResult
    attr_reader :model

    def initialize(model, controller)
      @model = model
      @controller = controller
    end

    def title
      unless @title
        @title =  case(@model)
                    when Game
                      @model.title
                    else
                      @model.title
                  end
      end
      @title
    end

    def description
      unless @description
        @description =  case(@model)
                          when Game
                            @model.description
                          else
                            @model.description
                        end
      end
      @description
    end

    def path
      unless @path
        @path = case(@model)
                  when Game
                    @controller.game_path(@model)
                  else
                    '/'
                end
      end
      @path
    end
  end

  def search_words
    @query = params['words'] || params['wordsline']
    assign_page()
    @query = @query.to_s.strip
    @words = @query.split.select{|w| w.size > 2}.map(&:strip)
    @results = []
    if !@query || @query.size < 3 && @words.size == 0
      flash.now[:alert] = I18n.t('search.empty_request')
    elsif @words.size > 5
      flash.now[:alert] = I18n.t('search.more_word_request')
    else
      # array of SearchResult
      @results = []
      @games = []
      #Product::Translation.where(['CONCAT(description,title) ILIKE ("%?%")', word])

      translations = []
      translated_fields = ['title','description','tags']
      model_class = Game
      @words.each do |word|
        result = model_class.where(["CONCAT(#{translated_fields.map{|m| "COALESCE(#{m},'')" }.join(',')}) ILIKE (?)", '%' + word.to_s + '%']).limit(50)
        translations << result.to_a if result && result.size > 0
      end

      translations_uniq = []
      translations.flatten.each{|t|translations_uniq << t unless translations_uniq.index(t)}

      if(translations_uniq.size == 0)
        flash.now[:notice] = I18n.t('search.empty_result')
      elsif translations_uniq.size > 50
        flash.now[:notice] = I18n.t('search.empty_result')
      else
        # всё хорошо
        translations_uniq.slice(0,20).each do |translation|
          #@results << SearchResult.new(translation, self)
          @games << translation
        end
      end
    end
  end
end
