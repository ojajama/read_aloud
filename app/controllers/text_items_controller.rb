require 'openai'

class TextItemsController < ApplicationController
  def new
    @text_item = TextItem.new
  end

  def create
    @text_item = TextItem.new(text_item_params)

    if @text_item.valid? && @text_item.text_file.attached?
      begin
        @text_item.save!
        text = @text_item.text_file.download.force_encoding("UTF-8")
      rescue
        flash.now[:alert] = "テキストファイルの読み込みに失敗しました。UTF-8形式のファイルをアップロードしてください。"
        @text_item.destroy
      end
    end

    if text.present?
      client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
      audio_binary = client.audio.speech(
        parameters: {
          model: "tts-1",
          voice: "alloy",
          input: text,
          response_format: "mp3"
        }
      )

      @text_item.audio_file.attach(
        io: StringIO.new(audio_binary),
        filename: "speech.mp3",
        content_type: "audio/mpeg"
      )

      @text_item.save!

      redirect_to @text_item
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @text_item = TextItem.find(params[:id])
  end

  private
  def text_item_params
    params.require(:text_item).permit(:text_file)
  end
end
