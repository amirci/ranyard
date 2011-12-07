require 'spec_helper'

describe Assignment do
  it { should belong_to(:speaker) }
  it { should belong_to(:session) }
end
