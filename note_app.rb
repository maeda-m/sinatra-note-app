# frozen_string_literal: true

require 'sinatra/base'

class NoteApp < Sinatra::Base
  enable :logging, :method_override

  helpers do
    def page_title
      @page_title
    end
  end

  # action: edit
  get '/:id/edit' do
    @page_title = 'Edit Note'

    erb :edit
  end

  # action: new
  get '/new' do
    @page_title = 'New Note'

    erb :new
  end

  # action: show
  get '/:id' do
    @page_title = 'TODO'

    erb :show
  end

  # action: destroy
  delete '/:id' do
    redirect to('/'), 303
  end

  # action: update
  patch '/:id' do
    @page_title = 'Edit Note'

    redirect to('/'), 303
  end

  # action: create
  post '/' do
    @page_title = 'New Note'

    redirect to('/'), 303
  end

  # action: index
  get '/' do
    @page_title = 'Notes'

    erb :index, locals: { notes: [] }
  end

  error 404 do
    'Not Found'
  end
end
