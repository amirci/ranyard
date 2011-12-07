require Rails.root.join("features/page_objects/base_page.rb")

mod = Module.new do
  Dir[Rails.root.join("features/page_objects/*.rb")].
    map { |f| File.basename(f).gsub("_page.rb", "") }.
    reject { |f| f == 'base' }.
    each do |f|
      define_method(f + "_po") do
        (f.camelize + "Page").constantize.new
      end
  end
end

World(mod)
