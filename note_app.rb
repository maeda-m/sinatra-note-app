# frozen_string_literal: true

require 'sinatra/base'
require_relative 'note_helper'
require_relative 'models/note'

# Application
class NoteApp < Sinatra::Base
  enable :logging, :method_override
  use Rack::Session::Pool, expire_after: 1.day
  use Rack::Protection::RemoteToken
  use Rack::Protection::SessionHijacking
  helpers NoteHelper

  # action: edit
  get '/:id/edit' do
    @page_title = 'Edit Note'
    note = Note.find(params[:id])

    erb :edit, locals: { note: }
  end

  # action: new
  get '/new' do
    @page_title = 'New Note'
    note = Note.new

    erb :new, locals: { note: }
  end

  # action: show
  get '/:id' do
    note = Note.find(params[:id])
    @page_title = note.title

    erb :show, locals: { note: }
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

    note.update(slice_params)
    redirect_root('更新しました')
  end

  # action: create
  post '/' do
    note = Note.new(slice_params)

    note.save
    redirect_root('登録しました')
  end

  # action: index
  get '/' do
    @page_title = 'Notes'

    notes = Note.where(session_id:)
    erb :index, locals: { notes: }
  end

  error ActiveHash::RecordNotFound do
    render_not_found
  end

  not_found do
    render_not_found
  end

  private

  def session_id
    session.id.to_s
  end

  def slice_params
    params.slice(:title, :content).merge(session_id:)
  end

  def redirect_root(message)
    session[:message] = message

    redirect to('/'), 303
  end

  def render_not_found
    @page_title = 'Not Found'

    status(404)
    erb :not_found
  end
end
