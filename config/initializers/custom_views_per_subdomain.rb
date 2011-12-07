# from: http://www.axehomeyg.com/2009/06/10/view-path-manipulation-for-rails-with-aop/

# Place these in a bootstrap-only file, like a config/initializers script.
ActionController::Base.class_eval do
  # Assumes a per-application/request view prioritization, not per-controller
  cattr_accessor :application_view_path

  self.view_paths = %w(app/views
                       app/views/west).map do |path| Rails.root.join(path).to_s end
end
 
ActionView::PathSet.class_eval do
  def each_with_application_view_path(&block)
    application_view_path = ActionController::Base.application_view_path
    re_ends_with = Regexp.new("#{application_view_path}$")

    if application_view_path
      # remove and prepend the view path in question to the array BEFORE proceeding with the 'each' operation
      (select do |item|
        re_ends_with.match(item.to_s)
      end + reject do |item|
        re_ends_with.match(item.to_s)
      end).each(&block)
    else
      each_without_application_view_path(&block)
    end
  end
 
  # as usual, lets play nice with anything else in the call chain.
  alias_method_chain :each, :application_view_path
end
