require 'spec_helper'

describe Room do
  it { should have_db_column(:name).of_type(:string)  }  
  it { should have_many(:events) }
  it { should belong_to(:conference) }
end
