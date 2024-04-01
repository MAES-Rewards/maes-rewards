# frozen_string_literal: true

class DocsController < ApplicationController
  def index
    render('docs/index')
  end
end
