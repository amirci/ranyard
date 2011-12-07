Then /^the response should be a collection of "(.+)" with:$/ do |root, table|
  table.hashes.map {|row| parse_row(row)}.each do |row|
    
    path = "#{root}/#{row['id'] - 1}"
    json = row.to_json

    Then(%Q{the JSON at "#{path}" should be #{json}})
  end
end

Then /^the response should be a "([^"]+)" with:$/ do |root, table|
  row = table.hashes.map {|row| parse_row(row)}.first

  Then(%Q{the JSON at "#{root}" should be #{row.to_json}})
end

