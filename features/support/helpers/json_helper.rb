module JsonHelper
  def parse_row(row)
    row.update(row) { |key,val| parse_cell_value(val) }
  end

  def parse_cell_value(value)
    return value[1..-2].split(',').collect { |s| parse_cell_value(s) } if value =~ /\[.*\]/ 
    return value.to_i if value =~ /^\d+$/
    return nil if value == 'null'
    value
  end

end

World(JsonHelper)