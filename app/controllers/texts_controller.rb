class TextsController < ApplicationController
  def new
    @text_item = TextItem.new
  end

  def create
    @text_item = TextItem.new

    @text_item.text_file.attach(params[:text_item][:text_file])

    text = @text_item.text_file.download.force_encoding("UTF-8")

    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

    audio = client.audio.speech(
      model: "gpt-4o-mini-tts",
      voice: "alloy",
      input: text,
      format: "mp3"
    )

    @text_item.auto_file.attach(
      io: StringIO.new(audio),
      filename: "speech.mp3",
      content_type: "audio/mpeg"
    )

    @text_item.save!
    redirect_to @text_item
  end

  def show
    @text_item = TextItem.find(params[:id])
  end
end
