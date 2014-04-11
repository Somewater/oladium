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
    @results = []

      # array of SearchResult
    @games = Game.search(@query, load: true, :per_page => 10, :page => @page).results

    if(@games.size == 0)
      flash.now[:notice] = I18n.t('search.empty_result')
    end
  end
end
