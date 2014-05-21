# encoding: utf-8

class  Admin::GamesController <  Admin::AdminBaseController
  def index
    if request.xhr?

    end
  end

  def show
    redirect_to action: :edit
  end

  def edit
    @game = Game.find_by_slug_or_id(params[:id])
  end

  def update
    @game = Game.find_by_slug_or_id(params[:id])
    case params[:act].to_s.to_sym
      when :upload_image then
        new_name = if @game.image.present?
                     GameUtils.filepath_to_next_version_filename(@game.image, File.extname(params[:game][:image].original_filename))
                   else
                     GameUtils.filepath_to_next_version_filename('thumb' + File.extname(params[:game][:image].original_filename))
                   end
        resized_file = Paperclip::Thumbnail.make(params[:game][:image], {geometry: "100x100>"})
        File.open(File.join(@game.local_directory, new_name), 'wb'){|f| f.write(resized_file.read) }
        @game.local_image_path = File.join(@game.local_directory, new_name)
      when :upload_file then
        file_name = params[:file_name]
        File.open(File.join(@game.local_directory, file_name), 'wb'){|f| f.write(params[:game][:upload_file].read) }
      when :new_file then
        new_name = params[:game][:new_file].original_filename
        File.open(File.join(@game.local_directory, new_name), 'wb'){|f| f.write(params[:game][:new_file].read) }
        check_file(@game, new_name) if params[:new_version]
      when :check_file then
        check_file(@game, params[:file_name])
      when :unlink_file then
        FileUtils.rm File.join(@game.local_directory, params[:file_name])
      else
        raise "Undefined act #{params[:act]}"
    end
    @game.save
    if request.xhr?
      head :ok
    else
      redirect_to action: :edit
    end
  end

  private
  def check_file(game, filename)
    game.local_path = File.join(game.local_directory, filename)
  end
end