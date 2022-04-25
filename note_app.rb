# frozen_string_literal: true

require 'sinatra/base'
require_relative 'models/note'

class NoteApp < Sinatra::Base
  enable :logging, :method_override
  use Rack::Session::Pool, expire_after: 1.day
  use Rack::Protection::RemoteToken
  use Rack::Protection::SessionHijacking

  helpers do
    def page_title
      @page_title
    end

    def render_message
      message = session.delete(:message)
      return if message.nil? || message.empty?

      "<article><aside>#{message}</aside></article>"
    end

    def h(text)
      Rack::Utils.escape_html(text)
    end
  end

  # action: edit
  get '/:id/edit' do
    note = Note.find(params[:id])
    render_edit(note)
  end

  # action: new
  get '/new' do
    render_new(Note.new)
  end

  # action: show
  get '/:id' do
    note = Note.find(params[:id])
    @page_title = note.title

    erb :show, locals: { note: note }
  end

  # action: destroy
  delete '/:id' do
    note = Note.find(params[:id])
    note.destroy

    redirect_root('削除しました')
  end

  # action: update
  patch '/:id' do
    note = Note.find(params[:id])

    if note.update(slice_params)
      redirect_root('更新しました')
    else
      render_edit(note)
    end
  end

  # action: create
  post '/' do
    note = Note.new(slice_params)

    if note.save
      redirect_root('登録しました')
    else
      render_new(note)
    end
  end

  # action: index
  get '/' do
    @page_title = 'Notes'

    erb :index, locals: { notes: Note.all }
  end

  error 404 do
    'Not Found'
  end

  private

  def slice_params
    params.slice(:title, :content)
  end

  def render_new(note)
    @page_title = 'New Note'
    erb :new, locals: { note: note }
  end

  def render_edit(note)
    @page_title = 'Edit Note'
    erb :edit, locals: { note: note }
  end

  def redirect_root(message)
    session[:message] = message

    redirect to('/'), 303
  end
end
