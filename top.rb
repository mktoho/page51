PER_PAGE = 100
SORT_MAP = {n: 'last_comment_time', v: 'view_counter', f: 'start_time', m: 'mylist_counter', r: 'comment_counter', l: 'length_seconds'}
ORDER_MAP = {a: 'asc', d: 'desc'}

    @q = params['q']
    @page = params['page'].to_i || 1
    @sort = params['sort']
    @sort = 'nd' unless %w{nd vd fd md na va rd ra ma fa ld la}.include?(@sort)
    sort_by = SORT_MAP[@sort[0]]
    order = ORDER_MAP[@sort[1]]
    @prev = @page - 1
    @next = @page + 1
    unless @q.nil?
      nico = NicoSearchSnapshot.new('page51')
      @results = nico.search(@q, size: PER_PAGE, from: ((@page - 1) * PER_PAGE, sort_by: sort_by, order: order))
    end
