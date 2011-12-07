require 'spec_helper'

describe InfoRequest do
  it { should validate_presence_of(:email)    }
end
