# frozen_string_literal: true

require 'sinatra/base'

class NoteApp < Sinatra::Base
  enable :logging

  helpers do
    def page_title
      'TODO'
    end
  end

  # action: new
  get '/:id/new' do
    erb :new
  end

  # action: edit
  get '/:id/edit' do
    erb :edit
  end

  # action: show
  get '/:id' do
    erb :show
  end

  # action: destroy
  delete '/:id' do
    redirect to('/'), 303
  end

  # action: update
  patch '/:id' do
    redirect to('/'), 303
  end

  # action: create
  post '/' do
    redirect to('/'), 303
  end

  # action: index
  get '/' do
    erb :index
  end

  error 404 do
    'Not Found'
  end
end
