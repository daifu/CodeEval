class SortedArray < Array
  def initialize(*args, &sort_by)
    @sort_by = sort_by
    super(*args)
    sort! &sort_by
  end

  def insert(i, v)
    insert_before = index(find {|x| @sort_by.call(x, v) == 1})
    super(insert_before ? insert_before : -1, v)
  end

  def <<(v)
    insert(0, v)
  end

end
