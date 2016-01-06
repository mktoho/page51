# coding: utf-8

require 'sinatra'
require 'sinatra/base'
require "sinatra/reloader" if development?
require 'slim'
require 'nico_search_snapshot'

PER_PAGE = 100
SORT_MAP = {n: 'last_comment_time', v: 'view_counter', f: 'start_time', m: 'mylist_counter', r: 'comment_counter', l: 'length_seconds'}
ORDER_MAP = {a: 'asc', d: 'desc'}
SEARCH_MAP = {
  tg: [:tags_exact],
  zk: [:title, :description, :tags],
  tt: [:title],
  td: [:title, :description]
}

class MainApp < Sinatra::Base
  get '/' do
    @q = params['q']
    @page = params['page'].to_i
    @page = 1 if @page < 1
    @search = params['search']
    @search = 'tg' unless %w{tg zk tt td}.include?(@search)
    @sort = params['sort'] || 'nd'
    @sort = 'nd' unless %w{nd vd fd md na va rd ra ma fa ld la}.include?(@sort)
    sort_by = SORT_MAP[@sort[0].to_sym]
    order = ORDER_MAP[@sort[1].to_sym]
    search = SEARCH_MAP[@search.to_sym]
    @prev = @page - 1
    @next = @page + 1
    from = (@page - 1) * PER_PAGE
    from = 0 if from < 0
    @results = []
    unless @q.nil?
      nico = NicoSearchSnapshot.new('page51')
      begin
        @results = nico.search(@q, search: search, size: PER_PAGE, from: from, sort_by: sort_by, order: order)
      rescue
        halt slim(:error)
      end
    end
    slim :index
  end
end
